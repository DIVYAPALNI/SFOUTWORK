//
//  SlideMenuViewController.m
//  SampleSalesForce
//
//  Created by Apple on 10/26/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "TaskListViewController.h"
#import "CalendarListViewController.h"
#import "OpportunityViewController.h"
#import "ProdListViewController.h"
#import "SyncViewController.h"

@interface SlideMenuViewController ()

@end

@implementation SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Task";
    appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    //self.view.alpha = 1;
    profileScrollView.layer.shadowColor = [UIColor blackColor].CGColor;
    //profileScrollView.layer.shadowOffset = CGSizeMake(-15, 20);
    profileScrollView.layer.shadowRadius = 10.0;
    profileScrollView.layer.shadowOpacity = 0.5;
    profileScrollView.layer.masksToBounds = NO;

//    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT AccountId, Account.Name, Subject, WhatId, What.Name, WhoId, Who.Name, CreatedDate  FROM Task LIMIT 20"]; // LIMIT 20
//    [[SFRestAPI sharedInstance] send:request delegate:self];

//    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
//    NSString *str = [NSString stringWithFormat:@"select user.id, user.Email,user.FirstName,user.LastName,user.profile.name,user.Username,user.IsActive,SmallPhotoUrl, FullPhotoUrl FROM user WHERE user.id = '%@'",appdelegate.loginUserId];
//    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:str];
//    [[SFRestAPI sharedInstance] send:request delegate:self];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftMenuBtnEvents:(UIButton *)sender {
    switch (sender.tag) {
     //Contacts
       case 101:{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"contactsSelected" forKey:@"SELECTEDCONTACT"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedContactBtnNotification" object:nil userInfo:userInfo];
        }
        break;
        //Calendar
        case 102:{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"calendarSelected" forKey:@"SELECTEDCALENDAR"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedCalBtnNotification" object:nil userInfo:userInfo];
            UIStoryboard *card = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CalendarListViewController *calVC = [card instantiateViewControllerWithIdentifier:@"calVC"];
            [self.navigationController pushViewController:calVC animated:YES];
        }
        break;
        // Opportunity
        case 103:{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"oppSelected" forKey:@"SELECTEDOPPORTUNITY"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedOppBtnNotification" object:nil userInfo:userInfo];
            UIStoryboard *card = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OpportunityViewController *feedBackVC = [card instantiateViewControllerWithIdentifier:@"oppVC"];
            [self.navigationController pushViewController:feedBackVC animated:YES];
        }
        break;
        // Products
        case 104:{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"productSelected" forKey:@"SELECTEDPRODUCT"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedProductBtnNotification" object:nil userInfo:userInfo];
            UIStoryboard *card = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ProdListViewController *prodListVC = [card instantiateViewControllerWithIdentifier:@"showProdListVC"];
            [self.navigationController pushViewController:prodListVC animated:YES];
        }
        break;
        // Sync
        case 105:{
           /* NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"SyncSelected" forKey:@"SELECTEDSYNCSELECT"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedSyncBtnNotification" object:nil userInfo:userInfo];
            // SyncViewController
            UIStoryboard *card = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SyncViewController *syncListVC = [card instantiateViewControllerWithIdentifier:@"showSyncVC"];
            [self.navigationController pushViewController:syncListVC animated:YES];*/
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"logoutSelected" forKey:@"SELECTEDLOGOUT"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedLogoutBtnNotification" object:nil userInfo:userInfo];
        }
        break;
        // Sync
        case 106:{
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"logoutSelected" forKey:@"SELECTEDLOGOUT"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedLogoutBtnNotification" object:nil userInfo:userInfo];
        }
        break;
        default:
        break;
    }
}
- (void)send:(SFRestRequest *)request delegate:(nullable id<SFRestDelegate>)delegate{
    
}

#pragma mark - SFRestDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSArray *records = jsonResponse[@"records"];
    NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
    //CreatedDate // what - Name
    self.dataRows = [records mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

- (void) perform {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.profileVCObj = [storyboard instantiateViewControllerWithIdentifier:@"profileVCID"];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480){   // iPhone Classic
            [self.profileVCObj.view setFrame:CGRectMake(380-self.view.frame.origin.x, 0,self.view.frame.size.width, self.view.frame.size.height)];
            [UIView animateWithDuration:0.7 animations:^{
                [self.profileVCObj.view setFrame:CGRectMake(80-self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
            }];
        }
        else if(result.height == 568){
            [self.profileVCObj.view setFrame:CGRectMake(380-self.view.frame.origin.x, 0,self.view.frame.size.width, self.view.frame.size.height)];
            [UIView animateWithDuration:0.7 animations:^{
                [self.profileVCObj.view setFrame:CGRectMake(80-self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
            }];
        }
        else if(result.height == 667){ // 390-self.view.frame.origin.x // 90-self.view.frame.origin.x
            [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-200, 0,self.view.frame.size.width, self.view.frame.size.height)];
            [UIView animateWithDuration:0.7 animations:^{
                [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-10, 0, self.view.frame.size.width, self.view.frame.size.height)];
            }];
        }
        else if(result.height == 736){
            [self.profileVCObj.view setFrame:CGRectMake(400-self.view.frame.origin.x, 0,self.view.frame.size.width-100, self.view.frame.size.height)];
            [UIView animateWithDuration:0.7 animations:^{
                [self.profileVCObj.view setFrame:CGRectMake(100-self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
            }];
        }else {
            [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-200, 0,self.view.frame.size.width, self.view.frame.size.height)];
            [UIView animateWithDuration:0.7 animations:^{
                [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-10, 0, self.view.frame.size.width, self.view.frame.size.height)];
            }];

        }
    }
    [self addChildViewController:self.profileVCObj];
    [self.view addSubview:self.profileVCObj.view];
    [self.profileVCObj didMoveToParentViewController:self];
}

@end
