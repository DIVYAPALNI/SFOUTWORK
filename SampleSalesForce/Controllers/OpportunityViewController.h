//
//  OpportunityViewController.h
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
#import "AppDelegate.h"
#import "OppDataDO.h"
#import "SVProgressHUD.h"
#import "VCFloatingActionButton.h"

@interface OpportunityViewController : UIViewController <UIScrollViewDelegate,CAAnimationDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,SFRestDelegate,floatMenuDelegate>
{
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    BOOL isSearching;
    NSTimer *ateTimer;
    UISegmentedControl *segmentControl;
    
}
@property (nonatomic, strong) NSMutableArray *dataRows;
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (assign, nonatomic) BOOL isFilterApplied;
@property (strong, nonatomic) NSString *selectedSegmentType;
@property (nonatomic, strong) NSMutableArray *filteredContentList;
@property (strong, nonatomic) NSString* savedSearchTerm;
@property (nonatomic,strong)OppDataDO *opDataDO;
@property(nonatomic,strong) UIRefreshControl *refreshControl1;
@property (nonatomic, assign) NSInteger oldSegmentedIndex;

@end
