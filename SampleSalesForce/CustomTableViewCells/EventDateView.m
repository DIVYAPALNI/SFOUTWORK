//
//  EventDateView.m


#import "EventDateView.h"

@implementation EventDateView
@synthesize delegate;
@synthesize eventDate;
@synthesize eventDateButton;
@synthesize index;
@synthesize headerlabel;
@synthesize segmentControl;

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)clickdatePicker:(id)sender{
    [self.delegate opendatepicker:index];
}
-(void)drawBordersToView{
    
    CGFloat borderWidth = 1.0f;
    self.eventDateButton.layer.borderColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f].CGColor;
    self.eventDateButton.layer.borderWidth = borderWidth;
    [self.eventDateButton.layer setCornerRadius:5.0f];
}
@end
