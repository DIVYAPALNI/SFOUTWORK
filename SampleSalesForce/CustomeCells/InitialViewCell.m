//
//  InitialViewCell.m
//  SampleSalesForce
//
//  Created by vamsee on 11/05/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "InitialViewCell.h"

@implementation InitialViewCell
@synthesize contactId;
@synthesize type;
@synthesize name;
@synthesize url;
@synthesize employeePic;
@synthesize headerLabelText;
@synthesize headerLabel;
@synthesize displayIcon;
@synthesize lastName;
@synthesize title;



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
