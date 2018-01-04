/*
 Copyright (c) 2011-present, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <UIKit/UIKit.h>
#import <SalesforceSDKCore/SFRestAPI.h>
#import <CoreData/CoreData.h>
#import "SlideMenuViewController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
//#import "ContactTableViewCell.h"
#import "SFAuthenticationManager.h"

@class SlideMenuViewController;

@interface RootViewController : UITableViewController <SFRestDelegate,NSFetchedResultsControllerDelegate,UIScrollViewDelegate,CAAnimationDelegate,UISearchDisplayDelegate,UISearchBarDelegate> {
    
    //NSMutableArray *dataRows;
    IBOutlet UITableView *tableView;
    //integer decalrations
    int drop;
    int dropTag;
    IBOutlet UIView *profileScrollView;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    AppDelegate *appdelegate;
    BOOL isSearching;
    NSTimer *ateTimer;
    BOOL  flag;
    UISegmentedControl *segmentControl;

}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *contacts;

@property (nonatomic, strong) NSMutableArray *dataRows;
@property (nonatomic, strong) NSMutableDictionary *deleteRequests;
@property (nonatomic,weak)  SlideMenuViewController *profileVCObj;
//@property (nonatomic,strong) IBOutlet UIView *profileScrollView;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (assign, nonatomic) BOOL isFilterApplied;
@property (strong, nonatomic) NSString *selectedSegmentType;
@property (nonatomic, strong) NSMutableArray *filteredContentList;
@property (strong, nonatomic) NSString* savedSearchTerm;
@property(nonatomic,strong) UIRefreshControl *refreshControl1;
@property (strong, nonatomic) NSString* firstTimeLogin;
@property (strong, nonatomic) NSString* logedInUserId;
//@property (assign, nonatomic) IBOutlet ContactTableViewCell *customCell;

@end
