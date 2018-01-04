//
//  TextViewCell.h
//  Ivuko
//
//  Created by Incresol on 31/01/16.
//  Copyright © 2016 org.palni. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskSubmitDelegate <NSObject>

@optional
-(void)submitTaskStatus;

@end
@interface TextViewCell : UITableViewCell<UITextViewDelegate>
@property (strong, nonatomic) id<TaskSubmitDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *textViewtitle;
@property (weak, nonatomic) IBOutlet UILabel *changeAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextview;

@property (weak, nonatomic) IBOutlet UITextField *classifiedDescpPlaceholder;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

-(IBAction)submitData:(id)sender;
-(void)drawBordersToView;
@end
