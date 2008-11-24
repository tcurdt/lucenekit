#ifndef __LUCENE_CALENDAR_DATE__
#define __LUCENE_CALENDAR_DATE__

#include <Foundation/Foundation.h>

/** Define the resolution of data to be stored */
typedef enum _LCResolution {
	LCResolution_YEAR = 1,
	LCResolution_MONTH,
	LCResolution_DAY,
	LCResolution_HOUR,
	LCResolution_MINUTE,
	LCResolution_SECOND,
	LCResolution_MILLISECOND
} LCResolution;


@interface LCCalendarDate : NSDate {

}

+ (id)dateWithString:(NSString*)string calendarFormat:(NSString*)format;
+ (id)date:(NSDate*) date withCalendarFormat:(NSString *)formatString timeZone:(NSTimeZone *)timeZone;
+ (id)dateWithYear:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute second:(int)second timeZone:(NSTimeZone*)timeZone;

- (id)initWithYear:(int)year month:(unsigned)month day:(unsigned)day hour:(unsigned)hour minute:(unsigned)minute second:(unsigned)second timeZone:(NSTimeZone*)timeZone;

- (LCCalendarDate *) dateWithResolution: (LCResolution) resolution;

- (NSTimeInterval) timeIntervalSince1970WithResolution: (LCResolution) resolution;

- (NSString*)descriptionWithCalendarFormat:(NSString*)format;

- (void)setTimeZone:(NSTimeZone *)timeZone;

- (NSTimeZone*) timeZone;

- (int)yearOfCommonEra;
- (int)monthOfYear;
- (int)dayOfMonth;
- (int)dayOfWeek;
- (int)dayOfYear;
- (int)hourOfDay;
- (int)minuteOfHour;
- (int)secondOfMinute;


@end

#endif /* __LUCENE_CALENDAR_DATE__ */
