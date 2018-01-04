//
//  SubmitButtonCell.m
//  Ivuko
//
//  Created by Incresol on 31/01/16.
//  Copyright © 2016 org.palni. All rights reserved.
//

#import "SubmitButtonCell.h"

@implementation SubmitButtonCell
@synthesize submitButton;
@synthesize delegate;
@synthesize submitLabel;
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)submit:(id)sender{
    [self.delegate submitData];
}
-(IBAction)submitStatus:(id)sender{
    UIButton *button=sender;
    [self.delegate submitStatus:button.tag];
}

@end
