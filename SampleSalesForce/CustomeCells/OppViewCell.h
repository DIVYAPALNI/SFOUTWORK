//
//  OppViewCell.h
//  SampleSalesForce
//
//  Created by Apple on 10/28/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OppViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *companyLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusMsgLbl;
@property (weak, nonatomic) IBOutlet UILabel *rupeesLbl;


// Product List Objects

@property (weak, nonatomic) IBOutlet UILabel *prodName;
@property (weak, nonatomic) IBOutlet UILabel *prodCode;
@property (weak, nonatomic) IBOutlet UILabel *prodFamily;
@property (weak, nonatomic) IBOutlet UILabel *prodActive;
@property (weak, nonatomic) IBOutlet UILabel *prodCreatedDate;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;

@end
