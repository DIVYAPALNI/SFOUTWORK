//
//  SideMenuCell.h
//  Ivuko
//
//  Created by Incresol on 08/01/16.
//  Copyright © 2016 org.palni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *menuTitle;
@property (weak, nonatomic) IBOutlet UILabel *menuDateandTime;

@property (weak, nonatomic) IBOutlet UILabel *menuDesc;
@property (weak, nonatomic) IBOutlet UIButton *menuIcon;

@property (weak, nonatomic) IBOutlet UIImageView *menuIconImage;
@end
