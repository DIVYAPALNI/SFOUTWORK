//
//  ProfileEditCell.h
//  Ivuko
//
//  Created by Incresol on 17/12/15.
//  Copyright © 2015 org.palni. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToggleSwitchDelegate <NSObject>
-(void)changeToggleState:(BOOL)state index:(NSIndexPath*)index;


@end
@interface LabelSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fieldTitle;
@property (weak, nonatomic) IBOutlet UILabel *fieldContent;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;
@property (strong, nonatomic) NSIndexPath *indexpath;
@property(nonatomic,strong) id<ToggleSwitchDelegate> delegate;
-(IBAction)selectVisibility:(id)sender;

@end
