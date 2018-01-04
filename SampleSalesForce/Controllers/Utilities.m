//
//  utilities.m
//  Ivoko
//
//  Copyright (c) 2015 org.palni. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

//NSString * const APP_ROOT_URL = @"http://52.11.151.112:5005/";
//NSString * const APP_ROOT_URL = @"http://apidev.useguild.com/";


NSString * const APP_ROOT_URL = @"http://outworkapi.useguild.com/";


// DevServer url --- 07-06-17
//NSString * const APP_ROOT_URL = @"http://outworkapi.useguild.com:9000/";


//@"http://54.68.95.182:5005/"; //
//

////Divya
#define REGEX_FOR_NUMBERS   @"^([+-]?)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"
#define REGEX_FOR_INTEGERS  @"^([+-]?)(?:|0|[1-9]\\d*)?$"
#define IS_A_NUMBER(string) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_FOR_NUMBERS] evaluateWithObject:string]
#define IS_AN_INTEGER(string) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_FOR_INTEGERS] evaluateWithObject:string]

/** BOOL: Detect if device is an iPhone or iPod **/
#define IS_IPHONE ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )

//IS_IPHONE_6PLUS
#define IS_IPHONE_4S ( IS_IPHONE ? CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 960)) ? YES : NO : NO )

/** BOOL: Detect if device is an iPhone 5 **/
#define IS_IPHONE_5 ( IS_IPHONE ? CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136)) ? YES : NO : NO )

//IS_IPHONE_6
#define IS_IPHONE_6 ( IS_IPHONE ? CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(750, 1334)) ? YES : NO : NO )

//IS_IPHONE_6PLUS
#define IS_IPHONE_6PLUS ( IS_IPHONE ? CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(1242, 2208)) ? YES : NO : NO )

/** BOOL: IS_RETINA **/
#define IS_RETINA ( [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2 )

#define SCREEN_WIDTH (IOS_VERSION_LOWER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height) : [[UIScreen mainScreen] bounds].size.width)

#define SCREEN_HEIGHT (IOS_VERSION_LOWER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width) : [[UIScreen mainScreen] bounds].size.height)

#define IOS_VERSION_LOWER_THAN_8 (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)



////
- (NSString *)currentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

- (NSString *)validityDateFormatFromDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *convertDate = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:convertDate];
}

- (UIImage *)resizeImage:(CGSize)newSize image:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showAlert:(NSString *)message title:(NSString*)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (NSString *)shortDateTimeUnix:(NSString *)dateString {
    
    NSTimeInterval _interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSString *userVisibleDateTimeString;
    
    
    if (date != nil) {
        BOOL today = [[NSCalendar currentCalendar] isDateInToday:date];
        
        if(today) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
            userVisibleDateTimeString = [NSString stringWithFormat:@"%02ld : %02ld", (long)[components hour] , (long)[components minute] ];
            userVisibleDateTimeString=[NSString stringWithFormat:@"Today at %@",userVisibleDateTimeString];
            
        } else {
            NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMM d at HH:mm" options:0
                                                                      locale:[NSLocale currentLocale]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatString];
            userVisibleDateTimeString = [dateFormatter stringFromDate:date];
            
            userVisibleDateTimeString=[userVisibleDateTimeString stringByReplacingOccurrencesOfString:@"," withString:@" at"];
        }
        
    }
    return userVisibleDateTimeString;
}
- (NSString *)shortTaskDateTimeUnix:(NSString *)dateString {
    
    NSTimeInterval _interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSString *userVisibleDateTimeString;
    
    
    if (date != nil) {
        BOOL today = [[NSCalendar currentCalendar] isDateInToday:date];
        
        if(today) {
            userVisibleDateTimeString=[NSString stringWithFormat:@"Today"];
            
        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMM dd"];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            userVisibleDateTimeString = [dateFormatter stringFromDate:date];
        }
        
    }
    return userVisibleDateTimeString;
}


- (NSString *)eventDateConvert:(NSString *)startDate endDate:(NSString*)endDate{
     NSArray *monthsArray=[[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec", nil];
    NSString *userVisibleDateTimeString;
    NSTimeInterval _startInterval=[startDate doubleValue];
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:_startInterval];
    
    NSTimeInterval _endInterval=[endDate doubleValue];
    NSDate *enddate = [NSDate dateWithTimeIntervalSince1970:_endInterval];
    
    NSDateComponents *startComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:startdate];
    NSDateComponents *endComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute  fromDate:enddate];
    
    long startDay = [startComponents day];
    NSInteger startMonth = [startComponents month];
    NSInteger startYear = [startComponents year];
    
    long startHour=[startComponents hour];
    long startMinutes=[startComponents minute];
    
    long endDay = [endComponents day];
    NSInteger endMonth = [endComponents month];
    
    if (startMonth ==endMonth ) {
        if (startDay==endDay) {
            userVisibleDateTimeString=[[NSString alloc] initWithFormat:@"%@ %02ld, %li",[monthsArray objectAtIndex:startMonth-1],startDay,(long)startYear];
            
        }else{
            userVisibleDateTimeString=[[NSString alloc] initWithFormat:@"%@ %02ld - %02ld, %li",[monthsArray objectAtIndex:startMonth-1],startDay,endDay,(long)startYear];
        }
    }else{
        userVisibleDateTimeString=[[NSString alloc] initWithFormat:@"%@ %02ld - %@ %02ld, %li",[monthsArray objectAtIndex:startMonth-1],startDay,[monthsArray objectAtIndex:endMonth-1],endDay,(long)startYear];
    
    }
    userVisibleDateTimeString =[userVisibleDateTimeString stringByAppendingString:[NSString stringWithFormat:@"_%02ld:%02ld onwards",startHour,startMinutes]];
    return userVisibleDateTimeString;
}

- (NSString *)shortDateTime:(NSString *)dateString {
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy'T'HH':'mm':'ss a"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    
    //    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    
    NSString *userVisibleDateTimeString;
    
    
    if (date != nil) {
        BOOL today = [[NSCalendar currentCalendar] isDateInToday:date];
        
        if(today) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
            userVisibleDateTimeString = [NSString stringWithFormat:@"%02ld", (long)[components hour] ];
            
        } else {
            NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMM d at HH:mm" options:0
                                                                      locale:[NSLocale currentLocale]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatString];
            
            // Convert the date object to a user-visible date string.
            //NSDateFormatter *userVisibleDateFormatter = [[NSDateFormatter alloc] init];
            //assert(userVisibleDateFormatter != nil);
            
            // [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            
            userVisibleDateTimeString = [dateFormatter stringFromDate:date];
        }
        
    }
    return userVisibleDateTimeString;
}


- (NSString *)longDateTime:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy'/'MM'/'dd'T'HH':'mm':'ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    NSString *userVisibleDateTimeString;
    if (date != nil) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEE MMM d yyyy at HH:mm" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        
        
        
        // Convert the date object to a user-visible date string.
        //NSDateFormatter *userVisibleDateFormatter = [[NSDateFormatter alloc] init];
        //assert(userVisibleDateFormatter != nil);
        
        // [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

- (NSString *)ConvertDateForAttendance:(NSString *)date{
    NSTimeInterval _interval=[date doubleValue];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSString *userVisibleDateTimeString;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, dd-HH:mm"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
//    NSDate *dateFromString = [[NSDate alloc] init];
    
    userVisibleDateTimeString = [dateFormatter stringFromDate:date1];
    
//    if (date != nil) {
//        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEEE,dd HH:mm" options:0
//                                                                  locale:[NSLocale currentLocale]];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:formatString];
//        
//    }
    return userVisibleDateTimeString;
}


- (NSString *)longDateTimeUnix:(NSString *)dateString {
    
    NSTimeInterval _interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSString *userVisibleDateTimeString;
    
    
    if (date != nil) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEE MMM d yyyy at HH:mm" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

- (NSString *)longAttendenceDateTimeUnix:(NSString *)dateString {
    
    NSTimeInterval _interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSString *userVisibleDateTimeString;
    
    
    if (date != nil) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMM yyyy" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}
- (NSString *)shortTimeUnix:(NSString *)dateString {
    
    NSTimeInterval _interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSString *userVisibleDateTimeString;
    
    
    if (date != nil) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"HH:mm" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

- (NSString *)dateTimeUnixForTask:(NSString *)dateString {
    
    NSTimeInterval _interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSString *userVisibleDateTimeString;
    
    if (date != nil) {
//        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd/MM/yyyy hh:mm a" options:0
//                                                                  locale:[NSLocale currentLocale]];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
//        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}
- (NSString *)dateTimeUnixForTaskList:(NSString *)dateString {
    
    NSTimeInterval _interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSString *userVisibleDateTimeString;
    
    
    if (date != nil) {
        //        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd/MM/yyyy hh:mm a" options:0
        //                                                                  locale:[NSLocale currentLocale]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        
        //        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}


- (NSString *)dateTimeUnixForRecTaskDetails:(NSString *)dateString {
    
//    NSTimeInterval _interval=[dateString doubleValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateString];
//    
    NSString *userVisibleDateTimeString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //06/05/2017, 2:45 PM

   // NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd/MM/yyyy, hh:mm a" options:0
              
                                                              //locale:[NSLocale currentLocale]];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy, hh:mm a"];

   // [dateFormatter setDateFormat:formatString];

    NSDate *date = [dateFormatter dateFromString:dateString];

    
    if (date != nil) {
       // NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMM dd yyyy, hh:mm a" options:0
                                                                // locale:[NSLocale currentLocale]];
        

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       // [dateFormatter setDateFormat:formatString];
        [dateFormatter setDateFormat:@"MMM dd yyyy, hh:mm a"];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}
- (NSDate *)NSTimeIntervalToNSDate:(NSString *)dateString {
    
    NSTimeInterval _interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSString *userVisibleDateTimeString;
    
    
    if (date != nil) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd/MM/yyyy hh:mm a" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
        return [dateFormatter dateFromString:userVisibleDateTimeString];
    }
    return nil;
}
- (NSString *)NSTimeIntervalToNSDateForReschuduleDue:(NSString *)dateString {
    
    NSTimeInterval _interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSString *userVisibleDateTimeString;
    
    
    if (date != nil) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MM/dd/yyyy, hh:mm a" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
        //return [dateFormatter dateFromString:userVisibleDateTimeString];
        return userVisibleDateTimeString;
        
    }
    return nil;
}


-(NSString *)convertDateToMilliseconds :(NSString *)dateStr{
    //17/04/2017 12:02 PM";
    //NSString *dateString = @"21-04-2015 14:23";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateStr];
    NSTimeInterval timeInMiliseconds = [dateFromString timeIntervalSince1970];
    
    NSString *millisecondsStr = [NSString stringWithFormat:@"%.f",timeInMiliseconds];
    
    return millisecondsStr;
    
}
- (NSString *)convertNsDateToMilliSeconds:(NSDate *)date{
    NSTimeInterval timeInMiliseconds = [date timeIntervalSince1970];
    
    NSString *millisecondsStr = [NSString stringWithFormat:@"%.f",timeInMiliseconds];

    
    return millisecondsStr;
}
-(NSString *)todayDateIs {
    
    NSDate *todayDate = [NSDate date];
    //  2017 03 22
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSString *str = [dateFormatter stringFromDate:todayDate];
    NSLog(@"%@",str);
    ///
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *date = [df dateFromString:str];
    NSLog(@"%@",date);
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"MMM dd yyyy, hh:mm a"];
    NSString *convertedDateStr = [df1 stringFromDate:date];
    return convertedDateStr;
}
-(NSString *)todayFullDate: (NSString *)dateStr {
    
    NSDate *todayDate = [NSDate date];
    //  2017 03 22
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [dateFormatter stringFromDate:todayDate];
    NSLog(@"%@",str);
    ///
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:str];
    NSLog(@"%@",date);
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"EEE, dd MMM, yyyy"];
    NSString *convertedDateStr = [df1 stringFromDate:date];
    return convertedDateStr;
}
-(NSString *)selectedFullDate: (NSString *)dateStr {
    
   /* NSDate *todayDate = [NSDate date];
    //  2017 03 22
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [dateFormatter stringFromDate:todayDate];
    NSLog(@"%@",str);*/
    ///
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:dateStr];
    NSLog(@"%@",date);
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"EEE, dd MMM, yyyy"];
    NSString *convertedDateStr = [df1 stringFromDate:date];
    return convertedDateStr;
}

#pragma mark - Check NSNull condition

+ (BOOL)objectIsNull:(id)value {
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

@end
