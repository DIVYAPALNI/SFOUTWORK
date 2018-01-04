//
//  CalTaskViewCell.m
//  SampleSalesForce
//
//  Created by vamsee on 05/01/18.
//  Copyright © 2018 SampleSalesForceOrganizationName. All rights reserved.
//

#import "CalTaskViewCell.h"

@implementation CalTaskViewCell
@synthesize todayLbl;
@synthesize dateLbl;
@synthesize dueMsgLbl;

@synthesize completeCheckImg;
@synthesize msgLabelText;

@synthesize nameLbl;
@synthesize timeLbl;
@synthesize timeSecLbl;
@synthesize statusOfEventLbl;
@synthesize statusUrl;

@synthesize phoneImg;
@synthesize refreshImg;
//
@synthesize startDateLbl;
@synthesize  endDateLbl;
@synthesize oppNameLbl;

@synthesize displayIcon;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
