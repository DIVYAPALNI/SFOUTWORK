//
//  ProceedCell.h
//  RimokonPatient
//
//  Created by Apple on 1/16/17.
//  Copyright © 2017 Palni. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProceedCellDelagate <NSObject>
@optional
-(void)proceedbuttonClicked;

-(void)tapHereClicked;
@end

@interface ProceedCell : UITableViewCell

@property (assign, nonatomic) id<ProceedCellDelagate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;

-(IBAction)proceed:(id)sender;

@end
