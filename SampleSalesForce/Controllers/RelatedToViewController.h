//
//  RelatedToViewController.h
//  SampleSalesForce
//
//  Created by Apple on 11/10/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesforceSDKManager.h"
#import <SalesforceSDKCore/SFRestRequest.h>
#import "SFDefaultUserManagementViewController.h"
#import "InitialViewController.h"
#import "Contacts.h"
#import "AppDelegate.h"
#import "SFIdentityData.h"
#import "SFUserAccountManager.h"
#import "SFRestAPI.h"
#import "SFLogger.h"
#import "SalesforceSDKManagerWithSmartStore.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "OppViewCell.h"
#import "OppDataDO.h"

@protocol RelatedSelectDelagate <NSObject>
-(void)selectedContact:(NSDictionary*)contact :(NSString *)typeIS;
-(void)selectedRelated:(NSDictionary*)customer :(NSString *)typeIS;
-(void)selectedProducts:(NSDictionary*)product :(NSString *)typeIS;

@end

//@protocol EventSelectDelagate <NSObject>
//-(void)selectedEventContact:(NSDictionary*)contact :(NSString *)typeIS;
//-(void)selectedEventRelated:(NSDictionary*)customer :(NSString *)typeIS;
//@end

@interface RelatedToViewController : UIViewController<SFRestDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UISearchResultsUpdating>{
    NSTimer *ateTimer;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    BOOL isSearching;
    UISegmentedControl *segmentControl;

}
@property (assign, nonatomic) BOOL isFilterApplied;
@property (nonatomic, strong) NSMutableArray *filteredContentList;
@property (strong, nonatomic) NSString* savedSearchTerm;
@property (nonatomic, strong) NSMutableArray *dataRows;
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSString *relatedTypeIs;
@property (nonatomic, strong) NSString *colorType;

@property (assign,nonatomic) id<RelatedSelectDelagate> delegate;
//@property (assign,nonatomic) id<EventSelectDelagate> eventdelegate;

@property (nonatomic, strong) NSString *selectedTypeFromCreate;
@property (strong, nonatomic) NSString *selectedSegmentType;

@end
