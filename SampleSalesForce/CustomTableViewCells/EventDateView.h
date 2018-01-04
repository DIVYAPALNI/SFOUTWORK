//
//  ProfilePhotoCell.h

#import <UIKit/UIKit.h>

@protocol EventDateViewDelegate <NSObject>

-(void)opendatepicker:(NSIndexPath*)index;
@end

@interface EventDateView : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerlabel;
@property (weak, nonatomic) IBOutlet UIButton *eventDateButton;
@property (weak, nonatomic) IBOutlet UITextField *eventDate;
@property (strong, nonatomic) NSIndexPath *index;

@property (strong, nonatomic) id<EventDateViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

-(IBAction)clickdatePicker:(id)sender;
-(void)drawBordersToView;
@end
