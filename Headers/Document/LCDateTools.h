#ifndef __LUCENE_DOCUMENT_DATE_TOOLS__
#define __LUCENE_DOCUMENT_DATE_TOOLS__

#include <Foundation/Foundation.h>
#include "LCCalendarDate.h"


/** Convert between NSString and LCCalendarDate */
@interface NSString (LuceneKit_Document_Date)

/** Convert a LCCalendarDate to NSString in GMT with resolution */
+ (id) stringWithCalendarDate: (LCCalendarDate *) date
                   resolution: (LCResolution) resolution;

/** Convert a NSTimeInterval to NSString with resolution */
+ (id) stringWithTimeIntervalSince1970: (NSTimeInterval) time
                            resolution: (LCResolution) resolution;

/** Convert a NSString to NSTimeInterval */
- (NSTimeInterval) timeIntervalSince1970;

/** Convert a NSString in GMT to LCCalendarDate */
- (LCCalendarDate *) calendarDate;
@end

#endif /* __LUCENE_DOCUMENT_DATE_TOOLS__ */

