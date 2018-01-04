//
//  utilities.h
//  Ivoko
//
//  Copyright (c) 2015 org.palni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

- (void)showAlert:(NSString *)message;
- (void)showAlert:(NSString *)message title:(NSString*)title;

extern NSString * const APP_ROOT_URL;
- (UIImage *)resizeImage:(CGSize)newSize image:(UIImage *)image;
- (NSString *)shortDateTime:(NSString *)dateString;
- (NSString *)shortDateTimeUnix:(NSString *)dateString;
- (NSString *)longDateTime:(NSString *)dateString;
- (NSString *)longDateTimeUnix:(NSString *)dateString;
- (NSString *)eventDateConvert:(NSString *)startDate endDate:(NSString*)endDate;
+ (BOOL)objectIsNull:(id)value;
- (NSString *)dateTimeUnixForTask:(NSString *)dateString ;
-(NSString *)convertDateToMilliseconds :(NSString *)dateStr;
- (NSString *)shortTimeUnix:(NSString *)dateString;
- (NSString *)convertNsDateToMilliSeconds:(NSDate *)date;
- (NSString *)ConvertDateForAttendance:(NSString *)date;
- (NSDate *)NSTimeIntervalToNSDate:(NSString *)dateString;
- (NSString *)shortTaskDateTimeUnix:(NSString *)dateString ;
- (NSString *)longAttendenceDateTimeUnix:(NSString *)dateString ;
- (NSString *)dateTimeUnixForRecTaskDetails:(NSString *)dateString;
- (NSString *)NSTimeIntervalToNSDateForReschuduleDue:(NSString *)dateString ;

-(NSString *)todayDateIs ;
- (NSString *)dateTimeUnixForTaskList:(NSString *)dateString;
-(NSString *)todayFullDate: (NSString *)dateStr ;
-(NSString *)selectedFullDate: (NSString *)dateStr ;

- (NSString *)currentDate ;

- (NSString *)validityDateFormatFromDateString:(NSString *)dateString ;


@end
