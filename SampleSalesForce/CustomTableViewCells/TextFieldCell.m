//
//  TextFieldCell.m
//  Ivuko
//
//  Created by Incresol on 31/01/16.
//  Copyright © 2016 org.palni. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell
@synthesize textfield;
@synthesize delegate;
@synthesize textview;
@synthesize textfieldTitle;
@synthesize doneButton;
@synthesize addProductButton;
@synthesize customertTextfieldTitle;
@synthesize titleName;
@synthesize AccName;
@synthesize CreatedDate;
@synthesize ownedByName;
@synthesize displayIcon;

@synthesize amountLbl;
@synthesize stageLbl;
@synthesize probabilityLbl;
@synthesize closingDateLbl;
@synthesize commentCountLbl;
@synthesize commentsBtn;
@synthesize oppStatusLbl;
@synthesize commentTextView;

@synthesize amountTitleLbl;
@synthesize stageTitleLbl;
@synthesize probabilityTitleLbl;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.camerabutton.layer setCornerRadius:self.camerabutton.frame.size.height/2];
     [self.textfieldBG.layer setBorderColor:[[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f] CGColor]];
     [self.textfieldBG.layer setBorderWidth:1.0f];
    [self.textfieldBG.layer setCornerRadius:5.0f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)openImageOptions:(id)sender{
    [self.delegate openImageSelectOptions];
}
@end
