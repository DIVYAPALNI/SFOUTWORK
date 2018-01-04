//
//  ProceedCell.m
//  RimokonPatient
//
//  Created by Apple on 1/16/17.
//  Copyright © 2017 Palni. All rights reserved.
//

#import "ProceedCell.h"

@implementation ProceedCell
@synthesize delegate;
@synthesize proceedButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(IBAction)proceed:(id)sender{
    [self.delegate proceedbuttonClicked];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
