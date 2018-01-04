//
//  RelatedToViewController.m
//  SampleSalesForce
//
//  Created by Apple on 11/10/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "RelatedToViewController.h"

@interface RelatedToViewController ()

@end

@implementation RelatedToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:3.0/255.0 green:35.0/255.0 blue:102.0/255.0 alpha:1]];
    if([self.colorType isEqualToString:@"Event"]){
      //  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:140.0/255.0 green:112.0/255.0 blue:201.0/255.0 alpha:1]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0/255.0 green:107.0/255.0 blue:241.0/255.0 alpha:1]];

    }
    else if([self.colorType isEqualToString:@"Task"]){
       // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:100.0/255.0 green:178.0/255.0 blue:71.0/255.0 alpha:1]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0/255.0 green:107.0/255.0 blue:241.0/255.0 alpha:1]];

    }
    // Do any additional setup after loading the view.
    self.isFilterApplied=FALSE;
    self.filteredContentList = [[NSMutableArray alloc] init];

    if([self.relatedTypeIs isEqualToString:@"RelatedTo"]){
        self.title = @"Opportunity";
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,StageName,Probability,Owner.Name,Id, Account.Name, CloseDate, Amount,NextStep,CreatedDate FROM opportunity WHERE stagename NOT IN ('Closed Won', 'Closed Lost')"]; // LIMIT 20
        [[SFRestAPI sharedInstance] send:request delegate:self];

    }else if([self.relatedTypeIs isEqualToString:@"Contact"]){
        self.title = @"Contacts";
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
//        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,LastName,FirstName, Account.Name,Id FROM Contact Limit 50"]; // LIMIT 20
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,Title,LastName, Phone, Email, Id,Owner.Id,Account.Name FROM Contact"]; // LIMIT 20

        [[SFRestAPI sharedInstance] send:request delegate:self];
    }else if([self.relatedTypeIs isEqualToString:@"Product"]){
        self.title = @"Products";
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,IsActive,Family,ProductCode,CreatedDate,Id FROM Product2"];
        [[SFRestAPI sharedInstance] send:request delegate:self];
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"arrow_back.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    ateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                target:self
                                              selector:@selector(rotateMove)
                                              userInfo:nil
                                               repeats:YES];

}
-(void)rotateMove{
    [SVProgressHUD dismiss];
}
#pragma Backbutton clicked
-(void)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)send:(SFRestRequest *)request delegate:(nullable id<SFRestDelegate>)delegate{
    // showDetailsVC
}

#pragma mark - SFRestDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    [self rotateMove];
    if(jsonResponse !=nil && ![jsonResponse isEqual:@""] && ![jsonResponse isEqual:@"<>"] && ![jsonResponse isKindOfClass:[NSNull class]]){
        NSArray *records = jsonResponse[@"records"];
        NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
        self.dataRows = [records mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"No data found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // return [self.dataRows count];
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
    
    if (self.isFilterApplied) {
        if([self.relatedTypeIs isEqualToString:@"RelatedTo"]){
            if(self.filteredContentList!=nil && [self.filteredContentList count]>0){
                OppViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"OppViewCellIdentifier"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                // Opp
                NSString *namestr =  [self.filteredContentList[indexPath.row] objectForKey:@"Name"];
                if(namestr !=nil && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
                    cell.titleLbl.text = namestr;
                }else{
                    cell.titleLbl.text = @"Not available";
                }
                NSString *statusMsgStr = [[self.filteredContentList[indexPath.row] objectForKey:@"Account"] objectForKey:@"Name"] ;
                if(statusMsgStr !=nil && ![statusMsgStr isKindOfClass:[NSNull class]] &&![statusMsgStr isEqualToString:@"<null>"]){
                    cell.prodName.text = statusMsgStr;
                }else{
                    cell.prodName.text = @"Not available";
                }
                return cell;
            }else{
                
            }
        }else if([self.relatedTypeIs isEqualToString:@"Contact"]){
            if(self.filteredContentList!=nil && [self.filteredContentList count]>0){
                OppViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"OppViewCellIdentifier"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                // Opp
                /*NSString *namestr =  [self.filteredContentList[indexPath.row] objectForKey:@"Name"];
                if(namestr !=nil && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
                    cell.titleLbl.text = namestr;
                }else{
                    cell.titleLbl.text = @"Not available";
                }
                NSString *statusMsgStr = [[self.filteredContentList[indexPath.row] objectForKey:@"Account"] objectForKey:@"Name"] ;
                if(statusMsgStr !=nil && ![statusMsgStr isKindOfClass:[NSNull class]] &&![statusMsgStr isEqualToString:@"<null>"]){
                    cell.prodName.text = statusMsgStr;
                }else{
                    cell.prodName.text = @"Not available";
                }*/
                NSString *namestr= [self.filteredContentList[indexPath.row] objectForKey:@"Name"];
                if(namestr!=nil && ![namestr isEqual:@""] && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
                    cell.textLabel.text = namestr;
                }else{
                    cell.textLabel.text = @"NA";
                }
                // details
                NSString *titleNameStr= [[self.filteredContentList[indexPath.row] objectForKey:@"Account"] objectForKey:@"Name"];
                if(titleNameStr!=nil && ![titleNameStr isEqual:@""] && ![titleNameStr isKindOfClass:[NSNull class]] &&![titleNameStr isEqualToString:@"<null>"]){
                    cell.detailTextLabel.text = titleNameStr;
                }else{
                    cell.detailTextLabel.text = @"NA";
                }

                return cell;
            }else{
                
            }
            
        }else if([self.relatedTypeIs isEqualToString:@"Product"]){
            if(self.dataRows!=nil && [self.dataRows count]>0){
                OppViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"OppViewCellIdentifier"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                // Opp
                NSString *namestr =  [self.dataRows[indexPath.row] objectForKey:@"Name"];
                if(namestr !=nil && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
                    cell.titleLbl.text = namestr;
                }else{
                    cell.titleLbl.text = @"Not available";
                }
                NSString *statusMsgStr = [self.dataRows[indexPath.row] objectForKey:@"ProductCode"] ;
                if(statusMsgStr !=nil && ![statusMsgStr isKindOfClass:[NSNull class]] &&![statusMsgStr isEqualToString:@"<null>"]){
                    cell.prodName.text = statusMsgStr;
                }else{
                    cell.prodName.text = @"Not available";
                }
                return cell;
            }else{
                
            }
        }
        return nil;
    }else{
        if([self.relatedTypeIs isEqualToString:@"RelatedTo"]){
            if(self.dataRows!=nil && [self.dataRows count]>0){
                OppViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"OppViewCellIdentifier"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                // Opp
                NSString *namestr =  [self.dataRows[indexPath.row] objectForKey:@"Name"];
                if(namestr !=nil && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
                    cell.titleLbl.text = namestr;
                }else{
                    cell.titleLbl.text = @"Not available";
                }
                NSString *statusMsgStr = [[self.dataRows[indexPath.row] objectForKey:@"Account"] objectForKey:@"Name"] ;
                if(statusMsgStr !=nil && ![statusMsgStr isKindOfClass:[NSNull class]] &&![statusMsgStr isEqualToString:@"<null>"]){
                    cell.prodName.text = statusMsgStr;
                }else{
                    cell.prodName.text = @"Not available";
                }
                return cell;
            }else{
                
            }
        }else if([self.relatedTypeIs isEqualToString:@"Contact"]){
            if(self.dataRows!=nil && [self.dataRows count]>0){
                OppViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"OppViewCellIdentifier"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                // Opp
               /* NSString *namestr =  [self.dataRows[indexPath.row] objectForKey:@"Name"];
                if(namestr !=nil && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
                    cell.titleLbl.text = namestr;
                }else{
                    cell.titleLbl.text = @"Not available";
                }
                NSString *statusMsgStr = [[self.dataRows[indexPath.row] objectForKey:@"Account"] objectForKey:@"Name"] ;
                if(statusMsgStr !=nil && ![statusMsgStr isKindOfClass:[NSNull class]] &&![statusMsgStr isEqualToString:@"<null>"]){
                    cell.prodName.text = statusMsgStr;
                }else{
                    cell.prodName.text = @"Not available";
                }*/
                NSString *namestr= [self.dataRows[indexPath.row] objectForKey:@"Name"];
                if(namestr!=nil && ![namestr isEqual:@""] && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
                    cell.titleLbl.text = namestr;
                }else{
                    cell.titleLbl.text = @"Not available";
                }
                // details
                NSString *titleNameStr= [self.dataRows[indexPath.row] objectForKey:@"Title"];
                if(titleNameStr!=nil && ![titleNameStr isEqual:@""] && ![titleNameStr isKindOfClass:[NSNull class]] &&![titleNameStr isEqualToString:@"<null>"]){
                    cell.prodName.text = titleNameStr;
                }else{
                    cell.prodName.text = @"Not available";
                }

                return cell;
            }else{
                
            }
        }else if([self.relatedTypeIs isEqualToString:@"Product"]){
            if(self.dataRows!=nil && [self.dataRows count]>0){
                OppViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"OppViewCellIdentifier"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                // Opp
                NSString *namestr =  [self.dataRows[indexPath.row] objectForKey:@"Name"];
                if(namestr !=nil && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
                    cell.titleLbl.text = namestr;
                }else{
                    cell.titleLbl.text = @"Not available";
                }
                NSString *statusMsgStr = [self.dataRows[indexPath.row] objectForKey:@"ProductCode"] ;
                if(statusMsgStr !=nil && ![statusMsgStr isKindOfClass:[NSNull class]] &&![statusMsgStr isEqualToString:@"<null>"]){
                    cell.prodName.text = statusMsgStr;
                }else{
                    cell.prodName.text = @"Not available";
                }
                return cell;
            }else{
                
            }
        }
        return nil;
    }

    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     if([self.relatedTypeIs isEqualToString:@"Contact"]){
         return 110;
     }else{
         return 55;
     }
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    /*UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 100)] ;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.tableview.frame.size.width, 30)];
    //    [headerView addSubview:label];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:18.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [headerView setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:241.0/255.0f blue:241/255.0f alpha:1.0f]];
    //[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]
    
    // 65
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.delegate = self;
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    searchController.delegate = self;
    [headerView addSubview:searchBar];
    return headerView;*/
    if([self.relatedTypeIs isEqualToString:@"RelatedTo"]){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 100)] ;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.tableview.frame.size.width, 30)];
        //    [headerView addSubview:label];
        [label setTextColor:[UIColor darkGrayColor]];
        [label setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:18.0f]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [headerView setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:241.0/255.0f blue:241/255.0f alpha:1.0f]];
        //[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]
        
        // 65
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        searchBar.delegate = self;
        UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        searchController.searchResultsDataSource = self;
        searchController.searchResultsDelegate = self;
        searchController.delegate = self;
        [headerView addSubview:searchBar];
        return headerView;
    }else  if([self.relatedTypeIs isEqualToString:@"Contact"]){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 100)] ;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.tableview.frame.size.width, 30)];
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

    }else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 100)] ;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.tableview.frame.size.width, 30)];
        //    [headerView addSubview:label];
        [label setTextColor:[UIColor darkGrayColor]];
        [label setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:18.0f]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [headerView setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:241.0/255.0f blue:241/255.0f alpha:1.0f]];
        //[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]
        
        // 65
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        searchBar.delegate = self;
        UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        searchController.searchResultsDataSource = self;
        searchController.searchResultsDelegate = self;
        searchController.delegate = self;
        [headerView addSubview:searchBar];
        return headerView;
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
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd MMM yyyy hh:mm" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //OppDataDO *contact;
    if(self.isFilterApplied){
        if([self.filteredContentList count] !=0 && ![self.filteredContentList isKindOfClass:[NSNull class]]){
            if([self.selectedTypeFromCreate isEqualToString:@"Event"]){
                if([self.relatedTypeIs isEqualToString:@"RelatedTo"]){
                    [self.delegate selectedRelated:[self.filteredContentList objectAtIndex:indexPath.row] :@"RelatedTo"];
                }else if([self.relatedTypeIs isEqualToString:@"Contact"]){
                    [self.delegate selectedContact:[self.filteredContentList objectAtIndex:indexPath.row] :@"Contact"];
                }
            }else if([self.selectedTypeFromCreate isEqualToString:@"Task"]){
                if([self.relatedTypeIs isEqualToString:@"RelatedTo"]){
                    [self.delegate selectedRelated:[self.filteredContentList objectAtIndex:indexPath.row] :@"RelatedTo"];
                }else if([self.relatedTypeIs isEqualToString:@"Contact"]){
                    [self.delegate selectedContact:[self.filteredContentList objectAtIndex:indexPath.row] :@"Contact"];
                }
                
            }
            else if([self.selectedTypeFromCreate isEqualToString:@"Product"]){
                [self.delegate selectedProducts:[self.filteredContentList objectAtIndex:indexPath.row] :@"Product"];
            }
            else if([self.selectedTypeFromCreate isEqualToString:@"Notes"]){
                if([self.relatedTypeIs isEqualToString:@"RelatedTo"]){
                    [self.delegate selectedRelated:[self.filteredContentList objectAtIndex:indexPath.row] :@"RelatedTo"];
                }else if([self.relatedTypeIs isEqualToString:@"Contact"]){
                    [self.delegate selectedContact:[self.filteredContentList objectAtIndex:indexPath.row] :@"Contact"];
                }
                
            }
        }
    }else{
        if([self.selectedTypeFromCreate isEqualToString:@"Event"]){
            if([self.relatedTypeIs isEqualToString:@"RelatedTo"]){
                //contact=[self.dataRows objectAtIndex:indexPath.row];
                // [self.eventdelegate selectedEventContact:[self.dataRows objectAtIndex:indexPath.row] :@"RelatedTo"];
                [self.delegate selectedRelated:[self.dataRows objectAtIndex:indexPath.row] :@"RelatedTo"];
            }else if([self.relatedTypeIs isEqualToString:@"Contact"]){
                //contact=[self.dataRows objectAtIndex:indexPath.row];
                // [self.eventdelegate selectedEventContact:[self.dataRows objectAtIndex:indexPath.row] :@"Contact"];
                [self.delegate selectedContact:[self.dataRows objectAtIndex:indexPath.row] :@"Contact"];
            }
        }else if([self.selectedTypeFromCreate isEqualToString:@"Task"]){
            if([self.relatedTypeIs isEqualToString:@"RelatedTo"]){
                //contact=[self.dataRows objectAtIndex:indexPath.row];
                [self.delegate selectedRelated:[self.dataRows objectAtIndex:indexPath.row] :@"RelatedTo"];
            }else if([self.relatedTypeIs isEqualToString:@"Contact"]){
                //contact=[self.dataRows objectAtIndex:indexPath.row];
                [self.delegate selectedContact:[self.dataRows objectAtIndex:indexPath.row] :@"Contact"];
            }
            
        }
        else if([self.selectedTypeFromCreate isEqualToString:@"Product"]){
            [self.delegate selectedProducts:[self.dataRows objectAtIndex:indexPath.row] :@"Product"];
        }
        else if([self.selectedTypeFromCreate isEqualToString:@"Notes"]){
            if([self.relatedTypeIs isEqualToString:@"RelatedTo"]){
                //contact=[self.dataRows objectAtIndex:indexPath.row];
                [self.delegate selectedRelated:[self.dataRows objectAtIndex:indexPath.row] :@"RelatedTo"];
            }else if([self.relatedTypeIs isEqualToString:@"Contact"]){
                //contact=[self.dataRows objectAtIndex:indexPath.row];
                [self.delegate selectedContact:[self.dataRows objectAtIndex:indexPath.row] :@"Contact"];
            }
            
        }
    }

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
    if([self.selectedTypeFromCreate isEqualToString:@"Task"]){
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
    
   /* if([self.selectedTypeFromCreate isEqualToString:@"ALL"]){
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
    }else{*/
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
   // }
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
            SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,Title,LastName,Phone, Email, Id,Owner.Id,Account.Name FROM Contact where CreatedDate = Yesterday"]; // LIMIT 20
            // select Id,lastname from contact where CreatedDate = Yesterday
            [[SFRestAPI sharedInstance] send:request delegate:self];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
