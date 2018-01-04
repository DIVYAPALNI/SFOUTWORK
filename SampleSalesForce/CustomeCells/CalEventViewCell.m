//
//  CalEventViewCell.m
//  SampleSalesForce
//
//  Created by Apple on 10/27/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "CalEventViewCell.h"

@implementation CalEventViewCell
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
