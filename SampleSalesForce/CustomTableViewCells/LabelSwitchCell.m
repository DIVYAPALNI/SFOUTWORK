//
//  ProfileEditCell.m
//  Ivuko
//
//  Created by Incresol on 17/12/15.
//  Copyright © 2015 org.palni. All rights reserved.
//

#import "LabelSwitchCell.h"

@implementation LabelSwitchCell

@synthesize fieldTitle;
@synthesize toggleButton;
@synthesize indexpath;
@synthesize fieldContent;


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)selectVisibility:(id)sender{
        if ([self.toggleButton isSelected]) {
            [self.toggleButton setSelected:FALSE];
            [self.delegate changeToggleState:FALSE index:self.indexpath];
        }else{
            [self.toggleButton setSelected:TRUE];
            [self.delegate changeToggleState:TRUE index:self.indexpath];
        }
    
}


- (BOOL) validateUrl: (NSString *) url {
    NSString *urlRegEx = @"^http(?:s)?://(?:w{3}\\.)?(?!w{3}\\.)(?:[\\p{L}a-zA-Z0-9\\-]+\\.){1,}(?:[\\p{L}a-zA-Z]{2,})/(?:\\S*)?$";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:url];
}

-(BOOL)validateContactNumber:(NSString *)number{
    NSString *phoneRegex = @"^[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:number];
}

@end
