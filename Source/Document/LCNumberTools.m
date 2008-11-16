#include "LCNumberTools.h"
#include <limits.h>

char _dig_vec[] =
"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

//long long MAX_LONG = (((unsigned long long)(-1)) / 2) - 1; // MAX of long

//#define STR_SIZE 13

@implementation NSString (LuceneKit_Document_Number)

+ (NSString *) stringWithLongLong: (long long) v
{
	char *buffer = malloc(sizeof(char)*(STR_SIZE+1));
	register char *p;
	long long new_val;
	long long val = (v < 0) ? (v + LLONG_MAX + 1) : v;
	
	bzero(buffer, (STR_SIZE+1));
	memset(buffer, '0', STR_SIZE);
	
	/*  The slightly contorted code which follows is due to the
		*  fact that few machines directly support unsigned long / and %.
		*  Certainly the VAX C compiler generates a subroutine call.  In
		*  the interests of efficiency (hollow laugh) I let this happen
		*  for the first digit only; after that "val" will be in range so
		*  that signed integer division will do.  Sorry 'bout that.
		*  CHECK THE CODE PRODUCED BY YOUR C COMPILER.  The first % and /
		*  should be unsigned, the second % and / signed, but C compilers
		*  tend to be extraordinarily sensitive to minor details of style.
		*  This works on a VAX, that's all I claim for it.
		**/
	p = buffer+STR_SIZE;
	new_val= val / RADIX;
	//  long long t = val-new_val*RADIX;
	*--p = _dig_vec[(unsigned char) (val-new_val* RADIX)];
	val = new_val;
	while (val != 0)
    {
		new_val=val/RADIX;
		*--p = _dig_vec[(unsigned char) (val-new_val*RADIX)];
		val= new_val;
    }
	NSString *s;
	if (v < 0)
		s = [NSString stringWithFormat: @"%@%s", NEGATIVE_PREFIX, buffer];
	else
		s = [NSString stringWithFormat: @"%@%s", POSITIVE_PREFIX, buffer];
	free(buffer);
	buffer = NULL;
	return s;
}

/**
* Converts a String that was returned by {@link #longToString} back to a
 * long.
 * 
 * @throws IllegalArgumentException
 *             if the input is null
 * @throws NumberFormatException
 *             if the input does not parse (it was not a String returned by
											*             longToString()).
 */
- (long long) longLongValue
{  
	char *p = (char *)[self cString];
	long long val, new_val = 0LL;
	int minus = 1;
	if (*p++ == '-')
    {
		minus = -1;
    }
	
	while((*p != 0))
    {
		if (*p < 'A') 
        {
			val = *p-'0';
        }
		else if (*p < 'a')
        {
			val = *p-'A'+10;
        }
		else
        {
			val = *p-'a'+10;
        }
		
		new_val = new_val*RADIX+val;
		p++;
    }
	
	if (minus == -1)
    {
		new_val = new_val - LLONG_MAX -1;
		return new_val;
    }
	else
		return new_val;
}

@end
