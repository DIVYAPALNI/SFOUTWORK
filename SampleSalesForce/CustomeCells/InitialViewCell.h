//
//  InitialViewCell.h
//  SampleSalesForce
//
//  Created by vamsee on 11/05/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactId;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *url;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITextField *headerLabelText;

@property (weak, nonatomic) IBOutlet UIImageView *employeePic;
@property (weak, nonatomic) IBOutlet UIButton *displayIcon;

@end
