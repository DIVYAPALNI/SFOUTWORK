//
//  ContactTableViewCell.h
//  SampleSalesForce
//
//  Created by Apple on 11/20/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *accountTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;

@property (strong,nonatomic) UIView *overlay;
//+ (NSString *)reuseIdentifier;
@end
