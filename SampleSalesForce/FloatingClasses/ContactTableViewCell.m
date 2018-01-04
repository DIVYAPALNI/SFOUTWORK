//
//  ContactTableViewCell.m
//  SampleSalesForce
//
//  Created by Apple on 11/20/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell
@synthesize  imgView;
@synthesize contactNameLbl;
@synthesize accountNameLbl;
@synthesize arrowImg;
@synthesize accountTitleLbl;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//+ (NSString *)reuseIdentifier {
//    return @"CustomCellIdentifier";
//}

@end
