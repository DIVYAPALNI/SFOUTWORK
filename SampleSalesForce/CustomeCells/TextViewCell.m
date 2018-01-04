//
//  TextViewCell.m
//  Ivuko
//
//  Created by Incresol on 31/01/16.
//  Copyright © 2016 org.palni. All rights reserved.
//

#import "TextViewCell.h"

@implementation TextViewCell
@synthesize textview;
@synthesize classifiedDescpPlaceholder;
@synthesize delegate;
@synthesize remarkTextview;
@synthesize changeAddressLabel;
@synthesize descLbl;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawBordersToView{
    
    //CGFloat borderWidth = 1.0f;
    //self.textview.layer.borderColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f].CGColor;
   // self.textview.layer.borderWidth = borderWidth;
    //[self.textview.layer setCornerRadius:5.0f];
}
-(IBAction)submitData:(id)sende{
    [self.delegate submitTaskStatus];
}
@end
