//
//  OpportunityViewController.m
//  SampleSalesForce
//
//  Created by Apple on 10/27/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "OpportunityViewController.h"
#import "OppViewCell.h"
#import "OpportunityDetailsViewController.h"
#import "TaskListViewController.h"
#import "NotesViewController.h"

@interface OpportunityViewController ()<createdActivitiesDelagate>
@property (strong, nonatomic) VCFloatingActionButton *addButton;

@end

@implementation OpportunityViewController
@synthesize dataRows;
@synthesize savedSearchTerm;
@synthesize addButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Opportunities";
    self.dataRows = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    UIImage *buttonImage = [UIImage imageNamed:@"arrow_back.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    self.isFilterApplied=FALSE;
    self.selectedSegmentType = @"OPEN"; // StageName // Owner.Name,Id,
    [segmentControl setSelectedSegmentIndex:0];

    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT name,StageName,Probability,Owner.Name,Id, Account.Name, CloseDate, Amount,NextStep,CreatedDate,CreatedById FROM opportunity WHERE stagename NOT IN ('Closed Won', 'Closed Lost')"]; // LIMIT 20
//    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT name, Opportunity.Name, Account.Name, Type, CloseDate, Amount FROM opportunity WHERE stagename NOT IN ('Closed Won', 'Closed Lost')"]; // LIMIT 20
    [[SFRestAPI sharedInstance] send:request delegate:self];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor colorWithRed:255.0/255.0  green:94.0/255.0 blue:90.0/255.0 alpha:1];
    [refreshControl addTarget:self action:@selector(loadingRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl1 = refreshControl;
    [self.tableview addSubview:self.refreshControl1];
    ateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                target:self
                                              selector:@selector(rotateMove)
                                              userInfo:nil
                                               repeats:YES];

    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 20, [UIScreen mainScreen].bounds.size.height -40 - 60, 60, 60);
    addButton = [[VCFloatingActionButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"plus.png"] andPressedImage:[UIImage imageNamed:@"CloseTask.png"] withScrollview:self.tableview];
    addButton.imageArray = @[@"notes.png",@"calendarevent.png",@"task.png"];
    addButton.labelArray = @[@"Add Note",@"Add Event",@"Add Task"]; //
    addButton.hideWhileScrolling = YES;
    addButton.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.view addSubview:addButton];

}
-(void)loadingRefresh{
    if([self.selectedSegmentType isEqualToString:@"OPEN"]){
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT name,StageName,Probability,Owner.Name,Id, Account.Name, CloseDate, Amount,NextStep,CreatedDate,CreatedById FROM opportunity WHERE stagename NOT IN ('Closed Won', 'Closed Lost')"]; // LIMIT 20
        [[SFRestAPI sharedInstance] send:request delegate:self];

    }else{
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT name,StageName,Probability,Owner.Name,Id, Account.Name, CloseDate, Amount,NextStep,CreatedDate FROM opportunity WHERE stagename IN ('Closed Won', 'Closed Lost')"]; // LIMIT 20
        [[SFRestAPI sharedInstance] send:request delegate:self];
    }

}

-(void)rotateMove{
    [SVProgressHUD dismiss];
}
#pragma Backbutton clicked
-(void)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment {
//    if (segmentControl.selectedSegmentIndex!=2) {
//        self.oldSegmentedIndex = segmentControl.selectedSegmentIndex;
//    }else{
//        self.oldSegmentedIndex = -1;
//    }
    switch (segment.selectedSegmentIndex) {
        case 0:{
            //action for the first button (Current)
            searchBar.text=@"";
            [segmentControl setSelectedSegmentIndex:0];
            self.selectedSegmentType = @"OPEN";
            [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
            SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT name,StageName,Probability,Owner.Name,Id,Account.Name, CloseDate, Amount,NextStep,CreatedDate,CreatedById FROM opportunity WHERE stagename NOT IN ('Closed Won', 'Closed Lost')"]; // LIMIT 20
            [[SFRestAPI sharedInstance] send:request delegate:self];
        }
        break;
        case 1:{
            //action for the first button (Current)
            searchBar.text=@"";
            self.selectedSegmentType = @"CLOSED";
            [segmentControl setSelectedSegmentIndex:1];

            [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
            SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT name,StageName,Probability,Owner.Name,Id, Account.Name, CloseDate, Amount,NextStep,CreatedDate FROM opportunity WHERE stagename IN ('Closed Won', 'Closed Lost')"]; // LIMIT 20
            // @"SELECT name, Account.Name, CloseDate, Amount FROM opportunity WHERE stagename NOT IN ('Closed Won', 'Closed Lost')"
            // select Id,lastname from contact where CreatedDate = Yesterday
            [[SFRestAPI sharedInstance] send:request delegate:self];
        }
        break;
        default:
            break;

    }
}
- (void)send:(SFRestRequest *)request delegate:(nullable id<SFRestDelegate>)delegate{
    // showDetailsVC
}

#pragma mark - SFRestDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    [self rotateMove];
    if(jsonResponse !=nil && ![jsonResponse isEqual:@""] && ![jsonResponse isEqual:@"<>"]){
        NSArray *records = jsonResponse[@"records"];
        NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
        if([self.selectedSegmentType isEqualToString:@"OPEN"]){
            self.dataRows = [records mutableCopy];
        }else{
            self.dataRows = [records mutableCopy];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"No data found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];

    }
//    if (segmentControl.selectedSegmentIndex==2) {
//        [segmentControl setSelectedSegmentIndex:self.oldSegmentedIndex];
//    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  /*  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OpportunityDetailsViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showDetailsVC"];
    [oppVC setEditMode:FALSE];
    oppVC.showEditButton = FALSE;
    oppVC.infoArray = [self.dataRows objectAtIndex:indexPath.row] ;
    oppVC.recordObjectId =[[self.dataRows objectAtIndex:indexPath.row] objectForKey:@"Id"];
    [self.navigationController pushViewController:oppVC animated:YES];*/
    
    if(self.isFilterApplied){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OpportunityDetailsViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showDetailsVC"];
        [oppVC setEditMode:FALSE];
        oppVC.showEditButton = FALSE;
        oppVC.infoArray = [self.filteredContentList objectAtIndex:indexPath.row] ;
        oppVC.recordObjectId =[[self.filteredContentList objectAtIndex:indexPath.row] objectForKey:@"Id"];
        oppVC.createdByIdIs = [[self.filteredContentList objectAtIndex:indexPath.row] objectForKey:@"CreatedById"];
        oppVC.ownerNameStr = [[[self.filteredContentList objectAtIndex:indexPath.row] objectForKey:@"Owner"] objectForKey:@"Name"];
        oppVC.accountNameStr = [[[self.dataRows objectAtIndex:indexPath.row] objectForKey:@"Owner"] objectForKey:@"Name"];
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:oppVC];
        [self presentViewController:navController animated:YES completion:nil];

    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OpportunityDetailsViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showDetailsVC"];
        [oppVC setEditMode:FALSE];
        oppVC.showEditButton = FALSE;
        oppVC.infoArray = [self.dataRows objectAtIndex:indexPath.row] ;
        oppVC.recordObjectId =[[self.dataRows objectAtIndex:indexPath.row] objectForKey:@"Id"];
        oppVC.createdByIdIs = [[self.dataRows objectAtIndex:indexPath.row] objectForKey:@"CreatedById"];
        oppVC.ownerNameStr = [[[self.dataRows objectAtIndex:indexPath.row] objectForKey:@"Owner"] objectForKey:@"Name"];
        oppVC.accountNameStr = [[[self.dataRows objectAtIndex:indexPath.row] objectForKey:@"Owner"] objectForKey:@"Name"];
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:oppVC];
        [self presentViewController:navController animated:YES completion:nil];

    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.dataRows count];
    if (self.isFilterApplied) {
        if(self.filteredContentList.count !=0 && ![self.filteredContentList isKindOfClass:[NSNull class]]){
            return [self.filteredContentList count];
        }else{
            return [self.filteredContentList count];
        }
    }
    else {
        return [self.dataRows count];
    }

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.refreshControl1 endRefreshing];

    if (self.isFilterApplied) {
        if(self.filteredContentList!=nil && [self.filteredContentList count]>0){
            OppViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"OppViewCellIdentifier"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            //NSDictionary *obj = self.dataRows[indexPath.row];
            
            NSString *createdDateStr = [self.filteredContentList[indexPath.row] objectForKey:@"CloseDate"];;
            if(createdDateStr !=nil && [createdDateStr length]>0){
                cell.dateLbl.text = [self headerDateIs:createdDateStr];
                
            }else{
                cell.dateLbl.text = @"NA";
            }
            //name, Account.Name
            
            NSString *namestr =  [self.filteredContentList[indexPath.row] objectForKey:@"Name"];
            if(namestr !=nil && [namestr length]>0){
                cell.titleLbl.text = namestr;
                
            }else{
                cell.titleLbl.text = @"Not available";
            }
            NSString *companyNamestr =  @"Salesforce.com";
            if(companyNamestr !=nil && [companyNamestr length]>0){
                cell.companyLbl.text = companyNamestr;
            }else{
                cell.companyLbl.text = @"Not available";
            }
            
            NSString *statusMsgStr = [[self.filteredContentList[indexPath.row] objectForKey:@"Account"] objectForKey:@"Name"] ;
            if(statusMsgStr !=nil && [statusMsgStr length]>0){
                cell.statusMsgLbl.text = statusMsgStr;
            }else{
                cell.statusMsgLbl.text = @"Not available";
            }
            NSNumber *amount =  [self.filteredContentList[indexPath.row] objectForKey:@"Amount"];
            NSString *rupee = [NSString stringWithFormat:@"%@",amount];
            if (rupee!=nil && ![rupee isEqual:@"<null>"] && ![rupee isKindOfClass:[NSNull class]]&& [rupee length]>0 ) {
                [cell.rupeesLbl setText:rupee];
            }else{
                [cell.rupeesLbl setText:@"NA"];
            }
            return cell;
        }else{
            
        }

    }else{
        if(self.dataRows!=nil && [self.dataRows count]>0){
            OppViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"OppViewCellIdentifier"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            //NSDictionary *obj = self.dataRows[indexPath.row];
            
            NSString *createdDateStr = [self.dataRows[indexPath.row] objectForKey:@"CloseDate"];;
            if(createdDateStr !=nil && [createdDateStr length]>0){
                cell.dateLbl.text = [self headerDateIs:createdDateStr];
                
            }else{
                cell.dateLbl.text = @"NA";
            }
            //name, Account.Name
            
            NSString *namestr =  [self.dataRows[indexPath.row] objectForKey:@"Name"];
            if(namestr !=nil && [namestr length]>0){
                cell.titleLbl.text = namestr;
                
            }else{
                cell.titleLbl.text = @"Not available";
            }
            NSString *companyNamestr =  @"Salesforce.com";
            if(companyNamestr !=nil && [companyNamestr length]>0){
                cell.companyLbl.text = companyNamestr;
            }else{
                cell.companyLbl.text = @"Not available";
            }
            
            NSString *statusMsgStr = [[self.dataRows[indexPath.row] objectForKey:@"Account"] objectForKey:@"Name"] ;
            if(statusMsgStr !=nil && [statusMsgStr length]>0){
                cell.statusMsgLbl.text = statusMsgStr;
            }else{
                cell.statusMsgLbl.text = @"Not available";
            }
            NSNumber *amount =  [self.dataRows[indexPath.row] objectForKey:@"Amount"];
            NSString *rupee = [NSString stringWithFormat:@"%@",amount];
            if (rupee!=nil && ![rupee isEqual:@"<null>"] && ![rupee isKindOfClass:[NSNull class]]&& [rupee length]>0 ) {
                [cell.rupeesLbl setText:rupee];
            }else{
                [cell.rupeesLbl setText:@"NA"];
            }
            return cell;
        }else{
            
        }

    }
    return nil;
    
}
- (NSString *)headerDateIs:(NSString *)dateString {
    NSString *userVisibleDateTimeString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //yyyy-MM-dd
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMM "];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

- (NSString *)fullDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    // [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss'Z'"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSString *userVisibleDateTimeString;
    if (date != nil) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEE, MMM dd, yyyy" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}
- (NSString *)onlyTime:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    // [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss'Z'"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSString *userVisibleDateTimeString;
    if (date != nil) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd MMM" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 100)] ;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.tableview.frame.size.width, 30)];
    //    [headerView addSubview:label];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:18.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [headerView setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:241.0/255.0f blue:241/255.0f alpha:1.0f]];
    //[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]
    
    segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"OPEN",@"CLOSED"]];
    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentControl.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 40);
    [segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    segmentControl.tintColor = [UIColor colorWithRed:74.0/255.0 green:138.0/255.0 blue:244.0/255.0 alpha:1];

    if([self.selectedSegmentType isEqualToString:@"OPEN"]){
        [segmentControl setSelectedSegmentIndex:0];
    }else if([self.selectedSegmentType isEqualToString:@"CLOSED"]){
        [segmentControl setSelectedSegmentIndex:1];
    }
    //[segmentControl setSelectedSegmentIndex:0];
    
    [headerView addSubview:segmentControl];
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
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    searchBar.text=@"";
    [self setSavedSearchTerm:nil];
    self.isFilterApplied =FALSE;
    [self.tableview reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText length]>0){
        [self handleSearchForTerm:searchText];
    }else{
        self.isFilterApplied = FALSE;
        [self.tableview reloadData];
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
    if([self.selectedSegmentType isEqualToString:@"OPEN"]){
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
    
    if([self.selectedSegmentType isEqualToString:@"OPEN"]){
        for (NSDictionary *t in self.dataRows){
            if ([[[t objectForKey:@"Name"] lowercaseString] rangeOfString:[searchTerm lowercaseString]].location!=NSNotFound){
                [temp addObject:t];
            }
        }
        self.filteredContentList=[[NSMutableArray alloc]initWithArray:[[NSMutableArray alloc] initWithArray:temp]];
        self.isFilterApplied = TRUE;
        if([self.filteredContentList count]>0){
            [self.tableview reloadData];
            
        }else{
            [self.tableview reloadData];
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
            [self.tableview reloadData];
            
        }else{
            [self.tableview reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) didSelectMenuOptionAtIndex:(NSInteger)row {
    NSLog(@"Floating action tapped index %tu",row);
    if(row == 0){
        // Notes
        UIStoryboard *card = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NotesViewController *notesListVC = [card instantiateViewControllerWithIdentifier:@"showNotesVC"];
        [notesListVC setEditMode:TRUE];
        //[self.navigationController pushViewController:notesListVC animated:YES];
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:notesListVC];
        [self presentViewController:navController animated:YES completion:nil];
    }else if(row == 1){
        // Event
        UIStoryboard *card = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TaskListViewController *taskListVC = [card instantiateViewControllerWithIdentifier:@"showAddTaskVC"];
        [taskListVC setEditMode:TRUE];
        taskListVC.create_Activites_delegate = self;
        
        //  taskListVC.showEditButton = FALSE;
        taskListVC.selectedTypeIs = @"Event";
        // [self.navigationController pushViewController:taskListVC animated:YES];
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:taskListVC];
        [self presentViewController:navController animated:YES completion:nil];
        
    }else{
        // task
        UIStoryboard *card = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TaskListViewController *taskListVC = [card instantiateViewControllerWithIdentifier:@"showAddTaskVC"];
        [taskListVC setEditMode:TRUE];
        taskListVC.create_Activites_delegate = self;
        taskListVC.selectedTypeIs = @"Task";
        //  [self.navigationController pushViewController:taskListVC animated:YES];
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:taskListVC];
        [self presentViewController:navController animated:YES completion:nil];
    }
}
// created task
-(void)CreatedTask:(NSString *)typeIS{
    if([typeIS isEqualToString:@"CreatedTask"]){
        // call sfdc soql query
        [self loadingRefresh];
    }
    
}
// created event
-(void)CreatedEvent:(NSString *)typeIS{
    if([typeIS isEqualToString:@"CreatedEvent"]){
        [self loadingRefresh];
    }
    
}

@end
