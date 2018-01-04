//
//  SideMenuCell.m
//  Ivuko
//
//  Created by Incresol on 08/01/16.
//  Copyright © 2016 org.palni. All rights reserved.
//

#import "SideMenuCell.h"

@implementation SideMenuCell
@synthesize menuTitle;
@synthesize menuIcon;
@synthesize menuDateandTime;

- (void)awakeFromNib {
    // Initialization code
    [menuIcon setContentMode:UIViewContentModeScaleToFill];
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
