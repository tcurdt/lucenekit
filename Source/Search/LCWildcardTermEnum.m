#include "LCWildcardTermEnum.h"
#include "LCIndexReader.h"
#include "GNUstep.h"
#ifdef USE_PCREParser
#include <PCREParser/PCREParser.h>
#else
#include <OgreKit/OgreKit.h>
#endif


static void replaceInString(NSMutableString* string, NSString* search, NSString* replace)
{
  NSRange       range;
  unsigned int  count = 0;
  unsigned int  newEnd;
  NSRange       searchRange;

  if (search == nil)
    {
      [NSException raise: NSInvalidArgumentException
                  format: @"replaceInString: nil search string"];
    }
  if (replace == nil)
    {
      [NSException raise: NSInvalidArgumentException
                  format: @"replaceInString: nil search string"];
    }

  searchRange = NSMakeRange(0, [string length]);
  range = [string rangeOfString: search options: 0 range: searchRange];

  if (range.length > 0)
    {
      unsigned  replaceLen = [replace length];

      do
        {
          count++;
          [string replaceCharactersInRange: range
                              withString: replace];

          newEnd = NSMaxRange(searchRange) + replaceLen - range.length;
          searchRange.location = range.location + replaceLen;
          searchRange.length = newEnd - searchRange.location;

          range = [string rangeOfString: search
                              options: 0
                                range: searchRange];
        }
      while (range.length > 0);
    }
}

@interface LCWildcardTermEnumerator (LCPrivate)
- (BOOL) wildcardEqualsTo: (NSString *) text;
@end

/**
 * Subclass of FilteredTermEnum for enumerating all terms that match the
 * specified wildcard filter term.
 * <p>
 * Term enumerations are always ordered by Term.compareTo().  Each term in
 * the enumeration is greater than all that precede it.
 *
 * @version $Id$
 */

/**
* Creates a new <code>WildcardTermEnum</code>.  Passing in a
 * {@link org.apache.lucene.index.Term Term} that does not contain a
 * <code>WILDCARD_CHAR</code> will cause an exception to be thrown.
 * <p>
 * After calling the constructor the enumeration is already pointing to the first 
 * valid term if such a term exists.
 */

@implementation LCWildcardTermEnumerator

- (id) initWithReader: (LCIndexReader *) reader term: (LCTerm *) term
{
	self = [self init];
	endEnum = NO;
	ASSIGNCOPY(searchTerm, term);
	ASSIGNCOPY(field, [searchTerm field]);
	ASSIGNCOPY(text, [searchTerm text]);
	
	/* Make '*' to be '.*', '?' to be '.?' for regular expression */
	NSMutableString *ms = [[NSMutableString alloc] initWithString: text];
        replaceInString(ms,@"*",@".*");
        replaceInString(ms,@"?",@".?");
	
#ifdef USE_PCREParser
        regexp=[[PCREPattern alloc] initWithPattern:[NSString stringWithFormat: @"^%@$", ms]
                                    options:0];
#else
	ASSIGN(regexp, ([OGRegularExpression regularExpressionWithString: [NSString stringWithFormat: @"^%@$", ms]]));
#endif
	DESTROY(ms);
	
	LCTerm *t = [[LCTerm alloc] initWithField: field text: @""];
	LCTermEnumerator *e = [reader termEnumeratorWithTerm: t];
	[self setEnumerator: e];
	AUTORELEASE(t);
	//AUTORELEASE(e);  // FIXME: cause segment fault
	return self;
}

- (void) dealloc
{
	DESTROY(searchTerm);
	DESTROY(field);
	DESTROY(text);
	DESTROY(regexp);
	[super dealloc];
}

- (BOOL) isEqualToTerm: (LCTerm *) term
{
	if ([field isEqualToString: [term field]])
	{
		return [self wildcardEqualsTo: [term text]];
	}
	endEnum = YES;
	return NO;
}

- (float) difference
{
	return 1.0f;
}

- (BOOL) endOfEnumerator
{
	return endEnum;
}

/* Use OgreKit to match wildcard */
- (BOOL) wildcardEqualsTo: (NSString *) t
{
#ifdef USE_PCREParser
  NSRange r=[t rangeOfPattern:regexp
               range:NSMakeRange(0,[t length])];
  return (r.length>0 ? YES : NO);
#else
	OGRegularExpressionMatch *match;
	if ((match = [regexp matchInString: t]))
        {
		return YES;
	}
	else
	{
		return NO;
	}
#endif
}

- (void) close
{
	[super close];
	DESTROY(searchTerm);
	DESTROY(field);
	DESTROY(text);
	DESTROY(regexp);
}

@end
