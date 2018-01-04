//
//  CalTaskViewCell.h
//  SampleSalesForce
//
//  Created by vamsee on 05/01/18.
//  Copyright © 2018 SampleSalesForceOrganizationName. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalTaskViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *todayLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *dueMsgLbl;

@property (weak, nonatomic) IBOutlet UIImageView *completeCheckImg;
@property (weak, nonatomic) IBOutlet UITextView *msgLabelText;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeSecLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusOfEventLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusUrl;
@property (weak, nonatomic) IBOutlet UILabel *eventTypeLbl;

@property (weak, nonatomic) IBOutlet UIImageView *phoneImg;
@property (weak, nonatomic) IBOutlet UIImageView *refreshImg;

@property (weak, nonatomic) IBOutlet UIButton *displayIcon;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet UILabel *startDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *endDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *oppNameLbl;

@end
