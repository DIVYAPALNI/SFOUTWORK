//
//  OppViewCell.m
//  SampleSalesForce
//
//  Created by Apple on 10/28/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "OppViewCell.h"

@implementation OppViewCell
@synthesize titleLbl;
@synthesize dateLbl;
@synthesize companyLbl;
@synthesize statusMsgLbl;
@synthesize rupeesLbl;

// Products
@synthesize prodName;
@synthesize prodCode;
@synthesize prodFamily;
@synthesize prodActive;
@synthesize prodCreatedDate;
@synthesize checkBoxBtn;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
