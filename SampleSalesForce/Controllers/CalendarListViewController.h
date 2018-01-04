//
//  CalendarListViewController.h
//  SampleSalesForce
//
//  Created by Apple on 10/27/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import <UIKit/UIKit.h>
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
#import "DIDatepicker.h"
#import "SVProgressHUD.h"
#import "VCFloatingActionButton.h"

@interface CalendarListViewController : UIViewController<SFRestDelegate,NSFetchedResultsControllerDelegate,UIScrollViewDelegate,CAAnimationDelegate,UISearchDisplayDelegate,UISearchBarDelegate,floatMenuDelegate,UITableViewDataSource,UITableViewDelegate,CAAnimationDelegate>{
    AppDelegate *appdelegate;
    NSString *typeIs;
    NSTimer *ateTimer;

}
@property (weak, nonatomic) IBOutlet DIDatepicker *datepicker;
@property (weak, nonatomic) IBOutlet UILabel *selectedDateLabel;

@property (nonatomic, strong) NSMutableArray *dataRows;
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tasksArray;
@property (nonatomic, strong) NSString  *statusType;
@property (nonatomic, strong) NSString *selectedDate;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *typeOfCal;
@property (nonatomic, strong) NSString *totalRecords;
@property (nonatomic, strong) NSString *eventTypeIS;
@property(nonatomic,strong) UIRefreshControl *refreshControl1;

@end
