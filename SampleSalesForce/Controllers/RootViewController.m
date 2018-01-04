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


@implementation RootViewController

@synthesize dataRows;
@synthesize savedSearchTerm;

#pragma mark Misc

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
    
}

- (void)dealloc
{
    self.dataRows = nil;
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.title = @"Mobile SDK Sample App";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
   // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:82.0/255.0 green:144.0/255.0 blue:245.0/255.0 alpha:1]];
   // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:62.0/255.0 green:122.0/255.0 blue:242.0/255.0 alpha:1]];
    // 41,128,185
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0/255.0 green:107.0/255.0 blue:241.0/255.0 alpha:1]];

    self.isFilterApplied=FALSE;
    
    self.filteredContentList = [[NSMutableArray alloc] init];
    appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
   /* if([appdelegate.loginUserId isEqualToString:@"Login"]){
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
        NSString *str = [NSString stringWithFormat:@"select user.id, user.Email,user.FirstName,user.LastName,user.profile.name,user.Username,user.IsActive,SmallPhotoUrl, FullPhotoUrl FROM user"];
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:str];
        [[SFRestAPI sharedInstance] send:request delegate:self];
        self.firstTimeLogin = @"YES";
    }else{
        
    }*/
    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
    // Fetch contacts
 //   SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,Title,LastName, Phone, Email, Id,Owner.Id,Account.Name FROM Contact Limit 5000"]; // LIMIT 20
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,Title,LastName, Phone, Email, Id,Owner.Id,Account.Name FROM Contact"]; // LIMIT 20
   //SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,Title,LastName,Phone, Email, Id FROM Contact where CreatedDate = Yesterday"]; //

    [[SFRestAPI sharedInstance] send:request delegate:self];
    self.title = @"Contacts";
    
    UIButton* customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
    customButton.frame =CGRectMake(0, 0, 30,30);
    [customButton setTitle:@"" forState:UIControlStateNormal];
    [customButton sizeToFit];
    [customButton addTarget:self action:@selector(leftMenuBtnEvents:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.leftBarButtonItem = customBarButtonItem; // or self.navigationItem.rightBarButtonItem
   
     flag = 1;
    //Contacts
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectContactBtnClicked:)
                                                 name:@"selectedContactBtnNotification"
                                               object:nil];
    self.selectedSegmentType = @"ALL";
    //Cal
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectCalendarBtnClicked:)
                                                 name:@"selectedCalBtnNotification"
                                               object:nil];
    
    // Opp
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectOppBtnClicked:)
                                                 name:@"selectedOppBtnNotification"
                                               object:nil];
    
    // Product list
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectProductsBtnClicked:)
                                                 name:@"selectedProductBtnNotification"
                                               object:nil];
    // Logout
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectLogoutBtnClicked:)
                                                 name:@"selectedLogoutBtnNotification"
                                               object:nil];
// sync
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectSyncBtnClicked:)
                                                 name:@"selectedSyncBtnNotification"
                                               object:nil];

    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor colorWithRed:255.0/255.0  green:94.0/255.0 blue:90.0/255.0 alpha:1];
    [refreshControl addTarget:self action:@selector(loadingRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl1 = refreshControl;
    [self.tableView addSubview:self.refreshControl1];
    ateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                target:self
                                              selector:@selector(rotateMove)
                                              userInfo:nil
                                               repeats:YES];
    
    
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ContactTableViewCell class])
//                                               bundle:nil]
//         forCellReuseIdentifier:NSStringFromClass([ContactTableViewCell class])];

    
}
-(void)rotateMove{
    [SVProgressHUD dismiss];
}
-(void)loadingRefresh{
    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
    // Fetch contacts
    //SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,Title,LastName, Phone, Email, Id FROM Contact"]; // LIMIT 20
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,Title,LastName, Phone, Email, Id,Owner.Id,Account.Name FROM Contact"]; // LIMIT 20
    [[SFRestAPI sharedInstance] send:request delegate:self];

}
- (void)selectSyncBtnClicked:(NSNotification *)notification{
    NSString *cancelStrIS = [notification.userInfo  objectForKey:@"SELECTEDSYNCSELECT"];
    if([cancelStrIS isEqualToString:@"SyncSelected"]){
        [self hideContentController:self.profileVCObj];
    }
}

//******* Logout Btn Tapped **********//
- (void)selectLogoutBtnClicked:(NSNotification *)notification{
    NSString *cancelStrIS = [notification.userInfo  objectForKey:@"SELECTEDLOGOUT"];
    if([cancelStrIS isEqualToString:@"logoutSelected"]){
        [self hideContentController:self.profileVCObj];
        [[SFAuthenticationManager sharedManager] logout];
    }
}

//******* Product Btn Tapped **********//
- (void)selectProductsBtnClicked:(NSNotification *)notification{
    NSString *cancelStrIS = [notification.userInfo  objectForKey:@"SELECTEDPRODUCT"];
    if([cancelStrIS isEqualToString:@"productSelected"]){
        [self hideContentController:self.profileVCObj];
        //[[NSNotificationCenter defaultCenter] removeObserver:self];
    }

}

//******* Contacts Btn Tapped **********//
- (void)selectContactBtnClicked:(NSNotification *)notification{
    NSString *cancelStrIS = [notification.userInfo  objectForKey:@"SELECTEDCONTACT"];
    if([cancelStrIS isEqualToString:@"contactsSelected"]){
        [self hideContentController:self.profileVCObj];
        //[[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

//******* Opportunity Btn Tapped **********//
- (void)selectOppBtnClicked:(NSNotification *)notification{
    NSString *cancelStrIS = [notification.userInfo  objectForKey:@"SELECTEDOPPORTUNITY"];
    if([cancelStrIS isEqualToString:@"oppSelected"]){
        [self hideContentController:self.profileVCObj];
        //[[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

//******* Calendar Btn Tapped **********//
- (void)selectCalendarBtnClicked:(NSNotification *)notification{
    NSString *cancelStrIS = [notification.userInfo  objectForKey:@"SELECTEDCALENDAR"];
    if([cancelStrIS isEqualToString:@"calendarSelected"]){
        [self hideContentController:self.profileVCObj];
      //  [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0:{
            //action for the first button (Current)
            searchBar.text=@"";
            self.selectedSegmentType = @"ALL";
            [segmentControl setSelectedSegmentIndex:0];
            [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
            SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,Title,LastName, Phone, Email, Id,Owner.Id,Account.Name FROM Contact"]; // LIMIT 20
            [[SFRestAPI sharedInstance] send:request delegate:self];
        }
        break;
        case 1:{
            //action for the first button (Current)
            searchBar.text=@"";
            [segmentControl setSelectedSegmentIndex:1];
            self.selectedSegmentType = @"RECENT/FAVORITES";
            [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
            SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,Title,LastName,Phone, Email, Id,Owner.Id,Account.Name FROM Contact"]; // LIMIT 20
            //SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,Title,LastName,Phone, Email, Id,Owner.Id,Account.Name FROM Contact where CreatedDate = Yesterday"]; // LIMIT 20
            // select Id,lastname from contact where CreatedDate = Yesterday
            [[SFRestAPI sharedInstance] send:request delegate:self];
        }
            break;
        default:
            break;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)leftMenuBtnEvents:(UIButton *)sender {
   // self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75];
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75];
       // self.tableView.alpha = 0.5;
         /*drop++;
            if(drop%2!=0){
                [self perform];
            }
            else{
                [self hideContentController:self.profileVCObj];
            }*/
    if (flag==1) {
        flag=0;
        [self perform];
    }
    else{
        flag=1;
        [self hideContentController:self.profileVCObj];
    }

}
- (void) perform {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.profileVCObj = [storyboard instantiateViewControllerWithIdentifier:@"profileVCID"];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480){   // iPhone Classic
            [self.profileVCObj.view setFrame:CGRectMake(380-self.view.frame.origin.x, 0,self.view.frame.size.width, self.view.frame.size.height+self.tableView.frame.size.height)];
            [UIView animateWithDuration:0.3 animations:^{
                [self.profileVCObj.view setFrame:CGRectMake(80-self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height+self.tableView.frame.size.height)];
            }];
        }
        else if(result.height == 568){
            [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-200, 0,self.view.frame.size.width, self.view.frame.size.height+self.tableView.frame.size.height)];
            [UIView animateWithDuration:0.3 animations:^{
                [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-10, 0, self.view.frame.size.width, self.view.frame.size.height+self.tableView.frame.size.height)];
            }];
        }
        else if(result.height == 667){ // 390-self.view.frame.origin.x // 90-self.view.frame.origin.x 6 an 7 
            [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-200, 0,self.view.frame.size.width, self.view.frame.size.height+self.tableView.frame.size.height)];
            [UIView animateWithDuration:0.3 animations:^{
                [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-10, 0, self.view.frame.size.width, self.view.frame.size.height+self.tableView.frame.size.height)];
            }];
        }
        else if(result.height == 736){ // 6pluse 7Pluse
            [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-200, 0,self.view.frame.size.width, self.view.frame.size.height+self.tableView.frame.size.height)];
            [UIView animateWithDuration:0.3 animations:^{
                [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-10, 0, self.view.frame.size.width, self.view.frame.size.height+self.tableView.frame.size.height)];
            }];
        }else{
            [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-200, 0,self.view.frame.size.width, self.view.frame.size.height)];
            [UIView animateWithDuration:0.7 animations:^{
                [self.profileVCObj.view setFrame:CGRectMake(self.view.frame.origin.x-10, 0, self.view.frame.size.width, self.view.frame.size.height)];
            }];

        }
    }
    [self addChildViewController:self.profileVCObj];
    [self.view addSubview:self.profileVCObj.view];
    [self.profileVCObj didMoveToParentViewController:self];
   // [self.tableView bringSubviewToFront:self.profileVCObj];
   // [self.view.superview bringSubviewToFront:self.profileVCObj.view];

}
- (void) hideContentController: (UIViewController*) content {
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.profileVCObj.view setFrame:CGRectMake(-375, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
    [self.profileVCObj willMoveToParentViewController:nil];
     flag=1;
   //[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        [self.profileVCObj.view setFrame:CGRectMake(375, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}
-(void)swipeLeftToRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    NSLog(@"swipeLeftToRight");
    CATransition *transition = nil;
    transition = [CATransition animation]; transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    transition.delegate = self;
    [self.profileVCObj.view.layer addAnimation:transition forKey:nil];
}



-(void)addRecords{
    
    [[SFAuthenticationManager sharedManager] logout];
    
}
- (void)resetViewState:(void (^)(void))postResetBlock
{
    if ((self.navigationController).presentedViewController) {
        [self.navigationController dismissViewControllerAnimated:NO completion:^{
            postResetBlock();
        }];
    } else {
        postResetBlock();
    }
}

- (void)send:(SFRestRequest *)request delegate:(nullable id<SFRestDelegate>)delegate{
    
}

#pragma mark - SFRestDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    if(jsonResponse !=nil && ![jsonResponse isEqual:@""] && ![jsonResponse isEqual:@"<>"] && ![jsonResponse isKindOfClass:[NSNull class]]){
        [self rotateMove];
            NSArray *records = jsonResponse[@"records"];
            NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
            if([self.selectedSegmentType isEqualToString:@"ALL"]){
                self.dataRows = [records mutableCopy];
            }else{
                self.dataRows = [records mutableCopy];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"No data found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    appdelegate.loginUserId = [[[self.dataRows objectAtIndex:0] objectForKey:@"Owner"] valueForKey:@"Id"];
}
/*- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSUInteger count = [dataRows count];
    if (row < count) {
       // return UITableViewCellEditingStyleDelete;
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleNone;
    }

}*/

/*- (void)tableView:(UITableView *)tView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger count = [dataRows count];
    
    if (row < count && editingStyle == UITableViewCellEditingStyleDelete)
    {
        //Remove from dictionary on server
        //Get the ID of the record from the row in dataRows
        //
        NSString *deletedId = [dataRows objectAtIndex:row];
        
        // Capture these values before sending the delete request:
        //    -- the associated REST response object
        //    -- the index path
        NSMutableArray *deletedItemInfo = [[NSMutableArray alloc] init];
        [deletedItemInfo addObject:[[dataRows objectAtIndex:row] valueForKey:@"Id"]];
       // [deletedItemInfo addObject:indexPath];
        
        // Create a new DELETE request
        SFRestRequest *request = [[SFRestAPI sharedInstance]
                                  requestForDeleteWithObjectType:@"Contact"
                                  objectId:deletedId];
        
        if (self.deleteRequests == nil)
        {
            self.deleteRequests = [[NSMutableDictionary alloc] init];
        }
        
        [self.deleteRequests setObject:deletedItemInfo
                                forKey:[NSValue valueWithNonretainedObject:request]];
        [dataRows removeObjectAtIndex:row];
        
        [tView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:TRUE];
        
        // Send the request
        [[SFRestAPI sharedInstance] send:request delegate:self];
    }
}*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isFilterApplied) {
        if([self.selectedSegmentType isEqualToString:@"ALL"]){
        if(self.filteredContentList.count !=0 && ![self.filteredContentList isKindOfClass:[NSNull class]]){
            return [self.filteredContentList count];
        }else{
            return 0;
        }
        }else{
            if(self.filteredContentList.count !=0 && ![self.filteredContentList isKindOfClass:[NSNull class]]){
                return [self.filteredContentList count];
            }else{
                return [self.filteredContentList count];
            }
        }
    }
    else {
        if([self.selectedSegmentType isEqualToString:@"ALL"]){
            return [self.dataRows count];
        }else { //  if([self.selectedSegmentType isEqualToString:@"RECENT/FAVORITES"]){
            // Recent/Fav
          //  return [self.customersListArray count];
            return [self.dataRows count];
        }
    }

   // return (self.dataRows).count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.refreshControl1 endRefreshing];

   /* static NSString *CellIdentifier = @"ContactTableViewCell";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = (ContactTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];*/

    
    static NSString *CellIdentifier = @"CellIdentifier";
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (self.isFilterApplied) {
        if([self.selectedSegmentType isEqualToString:@"ALL"]){
        UIImage *image = [UIImage imageNamed:@"ContactListicon.png"];
        cell.imageView.image = image;
        NSDictionary *obj = self.filteredContentList[indexPath.row];
        NSString *namestr= obj[@"Name"];
        if(namestr!=nil && ![namestr isEqual:@""] && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
            cell.textLabel.text = namestr;
        }else{
            cell.textLabel.text = @"NA";
        }
        // details
            NSString *titleNameStr= obj[@"Title"];
            if(titleNameStr!=nil && ![titleNameStr isEqual:@""] && ![titleNameStr isKindOfClass:[NSNull class]] &&![titleNameStr isEqualToString:@"<null>"]){
                cell.detailTextLabel.text = titleNameStr;
            }else{
                cell.detailTextLabel.text = @"NA";
            }
        //cell.detailTextLabel.text = [obj objectForKey:@"Title"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
        UIImage *image = [UIImage imageNamed:@"ContactListicon.png"];
        cell.imageView.image = image;
        NSDictionary *obj = self.filteredContentList[indexPath.row];
        NSString *namestr= obj[@"Name"];
            if(namestr!=nil && ![namestr isEqual:@""] && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
                cell.textLabel.text = namestr;
            }else{
                cell.textLabel.text = @"NA";
            }
            // details
            NSString *titleNameStr= obj[@"Title"];
            if(titleNameStr!=nil && ![titleNameStr isEqual:@""] && ![titleNameStr isKindOfClass:[NSNull class]] &&![titleNameStr isEqualToString:@"<null>"]){
                cell.detailTextLabel.text = titleNameStr;
            }else{
                cell.detailTextLabel.text = @"NA";
            }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else{
        if([self.selectedSegmentType isEqualToString:@"ALL"]){
            UIImage *image = [UIImage imageNamed:@"ContactListicon.png"];
            cell.imageView.image = image;
            NSDictionary *obj = dataRows[indexPath.row];
//            cell.textLabel.text =  obj[@"Name"];
//            cell.detailTextLabel.text = [obj objectForKey:@"Title"];
            NSString *namestr= obj[@"Name"];
            if(namestr!=nil && ![namestr isEqual:@""] && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
                cell.textLabel.text = namestr;
            }else{
                cell.textLabel.text = @"NA";
            }
            // details
            NSString *titleNameStr= obj[@"Title"];
            if(titleNameStr!=nil && ![titleNameStr isEqual:@""] && ![titleNameStr isKindOfClass:[NSNull class]] &&![titleNameStr isEqualToString:@"<null>"]){
                cell.detailTextLabel.text = titleNameStr;
            }else{
                cell.detailTextLabel.text = @"NA";
            }

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            UIImage *image = [UIImage imageNamed:@"ContactListicon.png"];
            cell.imageView.image = image;
            NSDictionary *obj = dataRows[indexPath.row];
            NSString *namestr= obj[@"Name"];
            if(namestr!=nil && ![namestr isEqual:@""] && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
                cell.textLabel.text = namestr;
            }else{
                cell.textLabel.text = @"NA";
            }
            // details
            NSString *titleNameStr= obj[@"Title"];
            if(titleNameStr!=nil && ![titleNameStr isEqual:@""] && ![titleNameStr isKindOfClass:[NSNull class]] &&![titleNameStr isEqualToString:@"<null>"]){
                cell.detailTextLabel.text = titleNameStr;
            }else{
                cell.detailTextLabel.text = @"NA";
            }

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
    
}
/*- (ContactTableViewCell *)loadMoreTableViewCellForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell =  (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *obj = dataRows[indexPath.row];
    cell.contactNameLbl.text =  obj[@"Name"];
    cell.accountNameLbl.text = [obj objectForKey:@"Title"];
    return cell;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.isFilterApplied){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:[NSBundle mainBundle]];
        InitialViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"InitialDetailView"];
        //myController.detailsArray = [self.dataRows objectAtIndex:indexPath.row];
        myController.detailsArray = self.filteredContentList[indexPath.row] ;
        [myController setEditMode:FALSE];
        myController.showEditButton = FALSE;
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:myController];
        navController.navigationBar.backgroundColor = [UIColor blackColor];
        [self presentViewController:navController animated:YES completion:nil];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:[NSBundle mainBundle]];
        InitialViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"InitialDetailView"];
        //myController.detailsArray = [self.dataRows objectAtIndex:indexPath.row];
        myController.detailsArray = self.dataRows[indexPath.row] ;
        [myController setEditMode:FALSE];
        myController.showEditButton = FALSE;
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:myController];
        navController.navigationBar.backgroundColor = [UIColor blackColor];
        [self presentViewController:navController animated:YES completion:nil];

    }


}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    searchBar.text=@"";
    [self setSavedSearchTerm:nil];
    self.isFilterApplied =FALSE;
    [self.tableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText length]>0){
        [self handleSearchForTerm:searchText];
    }else{
        self.isFilterApplied = FALSE;
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchTableList];
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchTableList {
    NSString *searchString = searchBar.text;
    if([self.selectedSegmentType isEqualToString:@"ALL"]){
        for (int i =0; i<[self.dataRows count]; i++){
            
            NSString *tempStr = [[self.dataRows objectAtIndex:i]valueForKey:@"Name"];
            NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
            
            if (result == NSOrderedSame) {
                [self.filteredContentList addObject:[self.dataRows objectAtIndex:i]];
                
            }
        }
    }else{
        for (int i =0; i<[self.dataRows count]; i++){
            
            NSString *tempStr = [[self.dataRows objectAtIndex:i]valueForKey:@"Name"];
            NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
            
            if (result == NSOrderedSame) {
                [self.filteredContentList addObject:[self.dataRows objectAtIndex:i]];
                
            }
        }
    }
}
- (void)handleSearchForTerm:(NSString *)searchTerm {
    [self setSavedSearchTerm:searchTerm];
    if([self filteredContentList] == nil) {
        self.filteredContentList = [NSMutableArray array];
    }
    [self.filteredContentList removeAllObjects];
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    
    if([self.selectedSegmentType isEqualToString:@"ALL"]){
        for (NSDictionary *t in self.dataRows){
            if ([[[t objectForKey:@"Name"] lowercaseString] rangeOfString:[searchTerm lowercaseString]].location!=NSNotFound){
                [temp addObject:t];
            }
        }
        self.filteredContentList=[[NSMutableArray alloc]initWithArray:[[NSMutableArray alloc] initWithArray:temp]];
        self.isFilterApplied = TRUE;
        if([self.filteredContentList count]>0){
            [self.tableView reloadData];
            
        }else{
            [self.tableView reloadData];
        }
    }else{
        for (NSDictionary *t in self.dataRows){
            if ([[[t objectForKey:@"Name"] lowercaseString] rangeOfString:[searchTerm lowercaseString]].location!=NSNotFound){
                [temp addObject:t];
            }
        }
        self.filteredContentList=[[NSMutableArray alloc]initWithArray:[[NSMutableArray alloc] initWithArray:temp]];
        self.isFilterApplied = TRUE;
        if([self.filteredContentList count]>0){
            [self.tableView reloadData];
            
        }else{
            [self.tableView reloadData];
        }
    }
}

- (void)reinstateDeletedRowWithRequest:(SFRestRequest *)request
{
        // Reinsert deleted rows if the operation is DELETE and the ID matches the deleted ID.
        // The trouble is, the NSError parameter doesn't give us that info, so we can't really
        // judge which row caused this error.
        NSNumber *val = [NSNumber numberWithUnsignedInteger:[request hash]];
        NSArray *rowValues = [self.deleteRequests objectForKey:val];
        
        // To avoid possible problems with using the original row number, insert the data object at
        // the beginning of the dataRows dictionary (index 0).
        if (rowValues)
        {
            [dataRows insertObject:rowValues[0] atIndex:0];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:rowValues[1]]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.deleteRequests removeObjectForKey:val];
        }
    
}
/////

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self reinstateDeletedRowWithRequest:request];
                       [self.tableView reloadData];
                       UIAlertController *alert = [UIAlertController
                                                   alertControllerWithTitle:@"Alert!!!"
                                                   message:[error.userInfo objectForKey:@"NSLocalizedDescription"]
                                                   preferredStyle:UIAlertControllerStyleAlert];
                       
                       UIAlertAction* cancel = [UIAlertAction
                                                actionWithTitle:@"Cancel"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                                }];
                       [alert addAction:cancel];
                       [self presentViewController:alert animated:YES completion:nil];
                   });
}
- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self reinstateDeletedRowWithRequest:request];
                       [self.tableView reloadData];
                       UIAlertController *alert = [UIAlertController
                                                   alertControllerWithTitle:@"Cannot delete item"
                                                   message:@"The server cancelled the load"
                                                   preferredStyle:UIAlertControllerStyleAlert];
                       
                       UIAlertAction* cancel = [UIAlertAction
                                                actionWithTitle:@"Cancel"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                                }];
                       [alert addAction:cancel];
                       [self presentViewController:alert animated:YES completion:nil];
                   });
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self reinstateDeletedRowWithRequest:request];
                       [self.tableView reloadData];
                       UIAlertController *alert = [UIAlertController
                                                   alertControllerWithTitle:@"Cannot delete item"
                                                   message:@"The server request timed out"
                                                   preferredStyle:UIAlertControllerStyleAlert];
                       
                       UIAlertAction* cancel = [UIAlertAction
                                                actionWithTitle:@"Cancel"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                                }];
                       [alert addAction:cancel];
                       [self presentViewController:alert animated:YES completion:nil];
                   });
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 110;
   // return 55;

}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 100)] ;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.tableView.frame.size.width, 30)];
//    [headerView addSubview:label];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:18.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [headerView setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:241.0/255.0f blue:241/255.0f alpha:1.0f]];
    //[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]
    
    segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"ALL",@"RECENT/FAVORITES"]];
    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentControl.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 40);
    [segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [segmentControl setSelectedSegmentIndex:0];
    [headerView addSubview:segmentControl];
    segmentControl.tintColor = [UIColor colorWithRed:74.0/255.0 green:138.0/255.0 blue:244.0/255.0 alpha:1];

    if([self.selectedSegmentType isEqualToString:@"ALL"]){
        [segmentControl setSelectedSegmentIndex:0];
    }else if([self.selectedSegmentType isEqualToString:@"RECENT/FAVORITES"]){
        [segmentControl setSelectedSegmentIndex:1];
    }

    // 65
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 44)];
    searchBar.delegate = self;
    //self.tableView.tableHeaderView = searchBar;
    //[self.tableView addSubview:searchBar];
    
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    searchController.delegate = self;
    [headerView addSubview:searchBar];

    //[label setText:@"Records List"];
    
    return headerView;
}
-(void)logoutofTheApp
{
    //[[[SFRestAPI sharedInstance] coordinator] revokeAuthentication];
   // [[[SFRestAPI sharedInstance] coordinator] authenticate];
}

@end
