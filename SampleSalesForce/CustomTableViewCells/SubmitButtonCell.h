//
//  SubmitButtonCell.h
//  Ivuko
//
//  Created by Incresol on 31/01/16.
//  Copyright © 2016 org.palni. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubmitButtonDelegate <NSObject>
@optional

-(void)submitData;
-(void)submitStatus:(NSInteger)tag;


@end
@interface SubmitButtonCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *submitLabel;
@property (strong, nonatomic) id<SubmitButtonDelegate> delegate;
-(IBAction)submit:(id)sender;
-(IBAction)submitStatus:(id)sender;
@end
