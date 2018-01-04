//
//  SlideMenuViewController.h
//  SampleSalesForce
//
//  Created by Apple on 10/26/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideMenuCell.h"
#import "RootViewController.h"
#import <SalesforceSDKCore/SFRestAPI.h>
#import "SalesforceSDKManager.h"
#import <SalesforceSDKCore/SFRestRequest.h>
#import "SFDefaultUserManagementViewController.h"
#import "InitialViewController.h"
#import "Contacts.h"
#import "AppDelegate.h"
#import "AddRecords.h"
#import "SFIdentityData.h"
#import "SFUserAccountManager.h"
#import "SFRestAPI.h"
#import "SFLogger.h"
#import "SalesforceSDKManagerWithSmartStore.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

@interface SlideMenuViewController : UIViewController<SFRestDelegate>{
    IBOutlet UIView *profileScrollView;
    //integer decalrations
    int drop;
    int dropTag;
    AppDelegate *appdelegate;

}
@property(nonatomic,strong)IBOutlet UITableView *tablview;
@property (nonatomic,weak)  SlideMenuViewController *profileVCObj;
@property (nonatomic, strong) NSArray *dataRows;

@end
