//
//  Created by Dmitry Ivanenko on 15.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepickerDateView.h"


const CGFloat kDIDatepickerItemWidth = 46.;
const CGFloat kDIDatepickerSelectionLineWidth = 51.;


@interface DIDatepickerCell ()

@property (strong, nonatomic) UILabel *dateLabel;
@property (nonatomic, strong) UIView *selectionView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


@implementation DIDatepickerCell

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [self setSelected:NO];
    self.selectionView.alpha = 0.0f;
    //self.selectionView.alpha = 1.0f;

}

#pragma mark - Setters
-(NSString *)todayOnly:(NSString *)dateIS {
    
    //NSDate *todayDate = [NSDate date];
    //  2017 03 22
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateis = [dateFormatter dateFromString:dateIS];
    NSLog(@"%@",dateis);
    ///
    // NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    [df setDateFormat:@"d"];
    //    NSDate *date = [df dateFromString:str];
    //    NSLog(@"%@",date);
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"dd"];
    NSString *convertedDateStr = [df1 stringFromDate:dateis];
    return convertedDateStr;
}
-(NSString *)todayFullDate:(NSDate *)dateIS {
    
    //NSDate *todayDate = [NSDate date];
    //  2017 03 22
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSString *str = [dateFormatter stringFromDate:dateIS];
    NSLog(@"%@",str);
    ///
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *date = [df dateFromString:str];
    NSLog(@"%@",date);
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    NSString *convertedDateStr = [df1 stringFromDate:date];
    return convertedDateStr;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    NSDate *todayDate = [NSDate date];
    NSString *todayDateStr = [self todayFullDate:todayDate];
    NSString *dateStr = [self todayOnly:todayDateStr];
    

    [self.dateFormatter setDateFormat:@"dd"];
    NSString *dayFormattedString = [self.dateFormatter stringFromDate:date];
    
    [self.dateFormatter setDateFormat:@"EEE"];
    NSString *dayInWeekFormattedString = [self.dateFormatter stringFromDate:date];
    
    [self.dateFormatter setDateFormat:@"MMM"];
    // if date is Today
    NSString *monthFormattedString;
    if([dayFormattedString isEqualToString:dateStr]){
       // monthFormattedString = [@"Today" uppercaseString];
        monthFormattedString = [[self.dateFormatter stringFromDate:date] uppercaseString];

    }else{
        monthFormattedString = [[self.dateFormatter stringFromDate:date] uppercaseString];

    }
    
   /* NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@\n%@", dayFormattedString, [dayInWeekFormattedString uppercaseString], monthFormattedString]];*/
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@\n%@",monthFormattedString,dayFormattedString, [dayInWeekFormattedString uppercaseString]]];
  //Month
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:12],
                                NSForegroundColorAttributeName: [UIColor grayColor]
                                } range:NSMakeRange(0, monthFormattedString.length)];

    // DATE
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:20],
                                NSForegroundColorAttributeName: [UIColor blackColor]
                                } range:NSMakeRange(dayFormattedString.length + 1, dayInWeekFormattedString.length)];
    
    // WEEK DAY
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:12],
                                NSForegroundColorAttributeName: [UIColor grayColor]
                                } range:NSMakeRange(dateString.string.length - monthFormattedString.length, monthFormattedString.length)];
    
    if ([self isWeekday:date]) {
        [dateString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]
                           range:NSMakeRange(dayFormattedString.length + 5, dayInWeekFormattedString.length)];
    }
    
    self.dateLabel.attributedText = dateString;
}

- (void)setItemSelectionColor:(UIColor *)itemSelectionColor
{
    self.selectionView.backgroundColor = itemSelectionColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.selectionView.hidden = NO;
    if (highlighted) {
        self.selectionView.alpha = self.isSelected ? 1 : .5;
    } else {
        self.selectionView.alpha = self.isSelected ? 1 : 0;
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.selectionView.alpha = (selected)?1.0f:0.0f;
}

#pragma mark - Getters

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.numberOfLines = 3;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];
    }
    
    return _dateLabel;
}

- (UIView *)selectionView
{
    if (!_selectionView) {
        _selectionView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 51) / 2, CGRectGetHeight(self.frame) - 3, 51, 3)];
        _selectionView.alpha = 0.0f;
        _selectionView.backgroundColor = [UIColor colorWithRed:242./255. green:93./255. blue:28./255. alpha:1.];
        [self addSubview:_selectionView];
    }
    
    return _selectionView;
}

- (NSDateFormatter *)dateFormatter
{
    if(!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _dateFormatter;
}

#pragma mark - Helper Methods

- (BOOL)isWeekday:(NSDate *)date
{
    NSInteger day = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];
    
    const NSInteger kSunday = 1;
    const NSInteger kSaturday = 7;
    
    BOOL isWeekdayResult = day == kSunday || day == kSaturday;
    
    return isWeekdayResult;
}

@end
