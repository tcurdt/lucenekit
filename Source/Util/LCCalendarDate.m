#import "LCCalendarDate.h"


@implementation LCCalendarDate

+ (id)dateWithString:(NSString*)string calendarFormat:(NSString*)format
{
    return nil;
}

+(id)dateWithYear:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute second:(int)second timeZone:(NSTimeZone*)timeZone
{
    id newDate = [[LCCalendarDate alloc] initWithYear:year
                                                month:month
                                                  day:day
                                                 hour:hour
                                               minute:minute
                                               second:second
                                             timeZone:timeZone];
    return newDate;
}


+ (id)date:(NSDate*) date withCalendarFormat:(NSString *)formatString timeZone:(NSTimeZone *)timeZone
{
    id newDate = [[[LCCalendarDate alloc] initWithTimeIntervalSinceReferenceDate:[date timeIntervalSinceReferenceDate]] autorelease];

    [newDate setCalendarFormat:formatString];
    [newDate setTimeZone:timeZone];

    return newDate;
}


- (id)initWithYear:(int)year month:(unsigned)month day:(unsigned)day 
  hour:(unsigned)hour minute:(unsigned)minute second:(unsigned)second 
  timeZone:(NSTimeZone*)timeZone
{
    return nil;
}


- (void)setTimeZone:(NSTimeZone *)timeZone
{
}


- (NSTimeZone *)timeZone
{
    return nil;
}

- (NSString*)descriptionWithCalendarFormat:(NSString*)format
{
    /*
    return [LCCalendarDate descriptionForCalendarDate:self
                           withFormat:format
                           timeZoneDetail:self->timeZoneDetail
                           locale:nil];
    */
    return nil;
}


/**
* Limit a date's resolution. For example, the date <code>1095767411000</code>
 * (which represents 2004-09-21 13:50:11) will be changed to 
 * <code>1093989600000</code> (2004-09-01 00:00:00) when using
 * <code>Resolution.MONTH</code>.
 * 
 * @param resolution The desired resolution of the date to be returned
 * @return the date with all values more precise than <code>resolution</code>
 *  set to 0 or 1, expressed as milliseconds since January 1, 1970, 00:00:00 GMT
 */
- (NSTimeInterval) timeIntervalSince1970WithResolution: (LCResolution) res
{
	return [[self dateWithResolution: res] timeIntervalSince1970];
}


/**
* Limit a date's resolution. For example, the date <code>2004-09-21 13:50:11</code>
 * will be changed to <code>2004-09-01 00:00:00</code> when using
 * <code>Resolution.MONTH</code>. 
 * 
 * @param resolution The desired resolution of the date to be returned
 * @return the date with all values more precise than <code>resolution</code>
 *  set to 0 or 1
 */
- (LCCalendarDate *) dateWithResolution: (LCResolution) res
{
	switch(res)
	{
		case LCResolution_YEAR:
			return [LCCalendarDate dateWithYear: [self yearOfCommonEra]
										  month: 1
											day: 1
										   hour: 0
										 minute: 0
										 second: 0
									   timeZone: [self timeZone]];
		case LCResolution_MONTH:
			return [LCCalendarDate dateWithYear: [self yearOfCommonEra]
										  month: [self monthOfYear]
											day: 1
										   hour: 0
										 minute: 0
										 second: 0
									   timeZone: [self timeZone]];
		case LCResolution_DAY:
			return [LCCalendarDate dateWithYear: [self yearOfCommonEra]
										  month: [self monthOfYear]
											day: [self dayOfMonth]
										   hour: 0
										 minute: 0
										 second: 0
									   timeZone: [self timeZone]];
		case LCResolution_HOUR:
			return [LCCalendarDate dateWithYear: [self yearOfCommonEra]
										  month: [self monthOfYear]
											day: [self dayOfMonth]
										   hour: [self hourOfDay]
										 minute: 0
										 second: 0
									   timeZone: [self timeZone]];
		case LCResolution_MINUTE:
			return [LCCalendarDate dateWithYear: [self yearOfCommonEra]
										  month: [self monthOfYear]
											day: [self dayOfMonth]
										   hour: [self hourOfDay]
										 minute: [self minuteOfHour]
										 second: 0
									   timeZone: [self timeZone]];
		case LCResolution_SECOND: 
			return [LCCalendarDate dateWithYear: [self yearOfCommonEra]
										  month: [self monthOfYear]
											day: [self dayOfMonth]
										   hour: [self hourOfDay]
										 minute: [self minuteOfHour]
										 second: [self secondOfMinute]
									   timeZone: [self timeZone]];
		case LCResolution_MILLISECOND:
			return [[self copy] autorelease];
			// don't cut off anything
		default:
			return nil; // Error;
	}
}

- (int)yearOfCommonEra
{
    return 0;
}

- (int)monthOfYear
{
    return 0;
}

- (int)dayOfMonth
{
    return 0;
}

- (int)dayOfWeek
{
    return 0;
}

- (int)dayOfYear
{
    return 0;
}

- (int)hourOfDay
{
    return 0;
}

- (int)minuteOfHour
{
    return 0;
}

- (int)secondOfMinute
{
    return 0;
}


@end