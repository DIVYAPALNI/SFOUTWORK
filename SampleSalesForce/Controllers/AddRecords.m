//
//  AddRecords.m
//  SampleSalesForce
//
//  Created by vamsee on 11/05/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "AddRecords.h"
#import "InitialViewCell.h"
#import "ProceedCell.h"
@interface AddRecords ()<UITextFieldDelegate,ProceedCellDelagate>
@property (nonatomic,weak) IBOutlet UITableView *tableView;

@end

@implementation AddRecords

- (void)viewDidLoad {
    self.title = @"Add Records";
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:185.0/255.0 blue:251.0/255.0 alpha:1]];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // Do any additional setup after loading the view.
}
-(IBAction)back:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 9;
    }else {
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        InitialViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InitialDetailViewCellIdentifier"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row==0) {
            [cell.headerLabelText setTag:1000];
            [cell.headerLabelText setKeyboardType:UIKeyboardTypeDefault];
            [cell.headerLabel setText:@"Firstname"];
            [cell.headerLabelText setDelegate:self];
            [cell.headerLabelText setText:@""];
        }else if (indexPath.row==1){
            [cell.headerLabelText setTag:1001];
            [cell.headerLabel setText:@"Lastname"];
            [cell.headerLabelText setKeyboardType:UIKeyboardTypeDefault];
            [cell.headerLabelText setDelegate:self];
            [cell.headerLabelText setText:@""];
        }else if (indexPath.row==2){
            [cell.headerLabelText setTag:1002];
            [cell.headerLabel setText:@"Alias"];
            [cell.headerLabelText setKeyboardType:UIKeyboardTypeDefault];
            [cell.headerLabelText setDelegate:self];
            [cell.headerLabelText setText:@""];
        }else if (indexPath.row==3){
            [cell.headerLabelText setTag:1003];
            [cell.headerLabel setText:@"Email"];
            [cell.headerLabelText setKeyboardType:UIKeyboardTypeDefault];
            [cell.headerLabelText setDelegate:self];
            [cell.headerLabelText setText:@""];
        } else if (indexPath.row==4){
            [cell.headerLabelText setTag:1004];
            [cell.headerLabel setText:@"Title"];
            [cell.headerLabelText setKeyboardType:UIKeyboardTypeDefault];
            [cell.headerLabelText setDelegate:self];
            [cell.headerLabelText setText:@""];
        } else if (indexPath.row==5){
            [cell.headerLabelText setTag:1005];
            [cell.headerLabel setText:@"Company"];
            [cell.headerLabelText setKeyboardType:UIKeyboardTypeDefault];
            [cell.headerLabelText setDelegate:self];
            [cell.headerLabelText setText:@""];
        }else if (indexPath.row==6){
            [cell.headerLabelText setTag:1006];
            [cell.headerLabel setText:@"DOB"];
            [cell.headerLabelText setDelegate:self];
            [cell.headerLabelText setKeyboardType:UIKeyboardTypeDefault];
            [cell.headerLabelText setText:@""];
        }
        else if (indexPath.row==7){
            [cell.headerLabelText setTag:1007];
            [cell.headerLabel setText:@"Contact Number"];
            [cell.headerLabelText setDelegate:self];
            [cell.headerLabelText setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.headerLabelText setText:@""];
        }
        else if (indexPath.row==8){
            [cell.headerLabelText setTag:1008];
            [cell.headerLabelText setDelegate:self];
            [cell.headerLabel setText:@"Gender"];
            [cell.headerLabelText setKeyboardType:UIKeyboardTypeDefault];
            [cell.headerLabelText setText:@""];
        }
        return cell;
    }else{
        ProceedCell *resultCell1 = [tableView dequeueReusableCellWithIdentifier:@"ProceedCellIdentifier" forIndexPath:indexPath];
        [resultCell1 setDelegate:self];
        [resultCell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        return resultCell1;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 90;
    }else{
        return 80;
    }
    
}
-(void)proceedbuttonClicked {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
