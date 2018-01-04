//
//  CalendarListViewController.m
//  SampleSalesForce
//
//  Created by Apple on 10/27/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "CalendarListViewController.h"
#import "CalEventViewCell.h"
#import "EventDetailsViewController.h"
#import "TaskListViewController.h"
#import "NotesViewController.h"
#import "TextFieldCell.h"
#import "CalTaskViewCell.h"

@interface CalendarListViewController ()<selectedCalendarListDelegate,UITextFieldDelegate,createdActivitiesDelagate>
@property (strong, nonatomic) VCFloatingActionButton *addButton;

@end

@implementation CalendarListViewController
@synthesize addButton;

- (void)setUpNavBar {
    self.title = @"Calendar";
    UIImage *buttonImage = [UIImage imageNamed:@"arrow_back.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataRows = [[NSMutableArray alloc] init];
    self.tasksArray = [[NSMutableArray alloc] init];
    
    [self setUpNavBar];
    
    self.totalRecords = @"1";
    NSDate *todayDate = [NSDate date];
    NSString *todayDateStr = [self todayFullDate:todayDate];
    NSString *dateStr = [self todayOnly:todayDateStr];
    
    [self.datepicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
    [self.datepicker fillCurrentMonth];
    NSInteger intvale = [dateStr integerValue];
    NSInteger indexvalueIS;
    
    if(intvale == 31){
        indexvalueIS = intvale-1;
    }else{
        indexvalueIS = intvale-1;
    }
    [self.datepicker selectDateAtIndex:indexvalueIS];
    self.datepicker.alpha = 1.0f;
    //[self.datepicker fillCurrentDay];
    //    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 20, [UIScreen mainScreen].bounds.size.height - 44 - 20, 44, 44);
    //CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 20, [UIScreen mainScreen].bounds.size.height - 44 - 130, 44, 44);
    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 20, [UIScreen mainScreen].bounds.size.height - 44 - 60, 60, 60);
    addButton = [[VCFloatingActionButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"plus.png"] andPressedImage:[UIImage imageNamed:@"CloseTask.png"] withScrollview:self.tableview];
    addButton.imageArray = @[@"notes.png",@"calendarevent.png",@"task.png"];
    addButton.labelArray = @[@"Add Note",@"Add Event",@"Add Task"]; //
    addButton.hideWhileScrolling = YES;
    addButton.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.view addSubview:addButton];
    
    //    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
    //                                        init];
    //    refreshControl.tintColor = [UIColor colorWithRed:255.0/255.0  green:94.0/255.0 blue:90.0/255.0 alpha:1];
    //    [refreshControl addTarget:self action:@selector(loadingRefresh) forControlEvents:UIControlEventValueChanged];
    //    self.refreshControl1 = refreshControl;
    [self.tableview addSubview:self.refreshControl1];
    ateTimer = [NSTimer scheduledTimerWithTimeInterval:50.0
                                                target:self
                                              selector:@selector(rotateMove)
                                              userInfo:nil
                                               repeats:YES];
    
    /*[self.tableview registerNib:[UINib nibWithNibName:@"CalEventViewCellIdentifier1" bundle:nil] forCellReuseIdentifier:@"CalEventViewCell"];
     [self.tableview registerNib:[UINib nibWithNibName:@"CalTaskViewCellIdentifier" bundle:nil] forCellReuseIdentifier:@"CalTaskViewCell"];
     [self.tableview registerNib:[UINib nibWithNibName:@"TextFieldCellIdentifier" bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];*/
    
}
-(void)loadingRefresh{
    // [self updateSelectedDate];
}
-(void)rotateMove{
    [SVProgressHUD dismiss];
}
-(IBAction)leftBtnTapped:(id)sender{
    
}
-(IBAction)rightBtnTapped:(id)sender{
    
}
- (void)selectaddTaskBtnClicked:(NSNotification *)notification{
    NSString *cancelStrIS = [notification.userInfo  objectForKey:@"SELECTEDADDTASK"];
    if([cancelStrIS isEqualToString:@"taskAddSelected"]){
        // [self hideContentController:self.profileVCObj];
    }
    
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
-(NSString *)todayOnly:(NSString *)dateIS {
    
    //NSDate *todayDate = [NSDate date];
    //  2017 03 22
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateis = [dateFormatter dateFromString:dateIS];
    NSLog(@"%@",dateis);
    ///
    // NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    [df setDateFormat:@"d"];
    //    NSDate *date = [df dateFromString:str];
    //    NSLog(@"%@",date);
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"d"];
    NSString *convertedDateStr = [df1 stringFromDate:dateis];
    return convertedDateStr;
}

-(NSString *)today:(NSDate *)dateIS {
    
    //NSDate *todayDate = [NSDate date];
    //  2017 03 22
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSString *str = [dateFormatter stringFromDate:dateIS];
    NSLog(@"%@",str);
    ///
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *date = [df dateFromString:str];
    NSLog(@"%@",date);
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"d"];
    NSString *convertedDateStr = [df1 stringFromDate:date];
    return convertedDateStr;
}
-(NSString *)todayFullDate:(NSDate *)dateIS {
    
    //NSDate *todayDate = [NSDate date];
    //  2017 03 22
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSString *str = [dateFormatter stringFromDate:dateIS];
    NSLog(@"%@",str);
    ///
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *date = [df dateFromString:str];
    NSLog(@"%@",date);
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    NSString *convertedDateStr = [df1 stringFromDate:date];
    return convertedDateStr;
}

- (void)updateSelectedDate
{
    self.dataRows = [[NSMutableArray alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMMyyyy" options:0 locale:nil];
    self.selectedDateLabel.text = [formatter stringFromDate:self.datepicker.selectedDate];
    
    NSString *formstedStr =[formatter stringFromDate:self.datepicker.selectedDate] ;
    self.selectedDate = [self selectedDateIs:formstedStr];
    NSLog(@"selected date%@",self.selectedDate);
    if(self.selectedDate!=nil && [self.selectedDate length]>0){
        self.datepicker.userInteractionEnabled = NO;
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
        // 07-11-17
        //  Event Query : SELECT ActivityDate,CreatedDate,Subject,What.Name,Who.Name,what.type FROM Event where what.type = 'Opportunity'
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:[NSString stringWithFormat:@"SELECT AccountId, Account.Name, Subject,Id, WhatId, What.Name, WhoId, Who.Name,What.Type, StartDateTime,Type,Description,EndDateTime FROM Event WHERE what.type = 'Opportunity' and ActivityDate =%@", self.selectedDate]];
        [[SFRestAPI sharedInstance] send:request delegate:self];
    }
    
}

-(NSString *)selectedDateIs:(NSString *)dateIS {
    
    //NSDate *todayDate = [NSDate date];
    //  2017 03 22
    /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
     NSString *str = [dateFormatter stringFromDate:dateIS];
     NSLog(@"%@",str);*/
    ///
    //October 29, Sunday
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy MMMM dd,EEEE"];
    NSDate *date = [df dateFromString:dateIS];
    NSLog(@"%@",date);
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    NSString *convertedDateStr = [df1 stringFromDate:date];
    return convertedDateStr;
}

#pragma Backbutton clicked
-(void)backBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)send:(SFRestRequest *)request delegate:(nullable id<SFRestDelegate>)delegate{
    
}

#pragma mark - SFRestDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSString *localCount;
    NSMutableArray *countArray = [[NSMutableArray alloc] init];
    
    if(jsonResponse !=nil && ![jsonResponse isEqual:@""] && ![jsonResponse isEqual:@"<>"] && ![jsonResponse isKindOfClass:[NSNull class]]){
        NSArray *records = jsonResponse[@"records"];
        NSLog(@"request:Events : #records: %lu", (unsigned long)records.count); // Event
        NSNumber *total = [jsonResponse objectForKey:@"totalSize"];
        localCount = [NSString stringWithFormat:@"%@",total];
        if(records!=nil && ![records isEqual:@""] && ![records isKindOfClass:[NSNull class]] && [records count]>0){
            for(NSDictionary *dict123 in records){
                NSString *trimmed = [NSString stringWithFormat:@"%@",[[dict123 valueForKey:@"attributes"] valueForKey:@"type"]];
                NSString *newReplacedString = [trimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString * newstr = [newReplacedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                NSString * str1 = [newstr stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString* cleanedString = [[str1 stringByReplacingOccurrencesOfString:@")" withString:@""]
                                           stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
                NSString* cleanedString1 = [[cleanedString stringByReplacingOccurrencesOfString:@"(" withString:@""]
                                            stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
                [countArray addObject:cleanedString1];
            }
            NSString *str;
            str = [countArray objectAtIndex:0];
            if(str !=nil && ![str isEqual:@""] && ![str isEqual:@"<>"] && ![str isKindOfClass:[NSNull class]]){
                if([str isEqualToString:@"Event"]){
                    for(NSDictionary *dict in records){
                        [self.dataRows addObject:dict];
                        self.statusType = @"Task";
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self rotateMove];
                        [self.tableview reloadData];
                        self.datepicker.userInteractionEnabled = YES;
                    });
                }else{
                    // task
                    if([self.eventType isEqualToString:@"YES"]){
                        self.eventType = @"NO";
                        self.statusType = nil;
                        for(NSDictionary *dict in records){
                            [self.dataRows addObject:dict];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self rotateMove];
                            [self.tableview reloadData];
                            self.datepicker.userInteractionEnabled = YES;
                            
                        });
                        //    [self.tableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                        
                        
                    }else{
                        self.statusType = @"Task";
                    }
                }
            } else {
                // if event is 0
                if([self.eventTypeIS isEqualToString:@"TaskIS"]){
                    self.statusType = nil;
                    self.eventTypeIS = nil;
                }else{
                    self.statusType = @"Task";
                    self.eventTypeIS = nil;
                }
            }
            if(self.totalRecords!=0) {
                if([self.statusType isEqualToString:@"Task"]){
                    NSLog(@"task selected date %@",self.selectedDate);
                    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
                    SFRestRequest *request  = [[SFRestAPI sharedInstance] requestForQuery:[NSString stringWithFormat:@"SELECT AccountId, Account.Name, Subject,Id, WhatId, What.Name, WhoId, Who.Name,What.Type, ActivityDate,Task.ReminderDateTime,Status,Description FROM Task WHERE what.type = 'Opportunity' and ActivityDate =%@", self.selectedDate]]; // LIMIT 20
                    [[SFRestAPI sharedInstance] send:request delegate:self];
                    self.eventType =@"YES";
                    self.totalRecords = @"0";
                    self.eventTypeIS = @"TaskIS";
                }
            }else{
                self.statusType = nil;
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.datepicker.userInteractionEnabled = YES;
                [self rotateMove];
                [self.tableview reloadData];
            });
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self rotateMove];
            [self.tableview reloadData];
            self.datepicker.userInteractionEnabled = YES;
        });
    }
    
}
-(void)reloadData{
    self.datepicker.userInteractionEnabled = YES;
    [self rotateMove];
    [self.tableview reloadData];
}
- (void)request:(SFRestRequest *)request didFailLoadWithError:(nonnull NSError *)error {
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section ==0){
        @try {
            return [self.dataRows count];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception is%@", exception.reason);
        }
        @finally {
        }
    } else {
        if(self.dataRows==nil && [self.dataRows count]==0){
            return 1;
        }
        return 0;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *statusLblStr;
    //[self.refreshControl1 endRefreshing];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if(indexPath.section == 0) {
        if(self.dataRows!=nil && ![self.dataRows isEqual:@""] && ![self.dataRows isKindOfClass:[NSNull class]] && [self.dataRows count]>0){
            NSDictionary *obj = self.dataRows[indexPath.row];
            typeIs = [[obj objectForKey:@"attributes"] objectForKey:@"type"];
            if([typeIs isEqualToString:@"Event"]) {
                static NSString *CellIdentifier = @"CalEventViewCellIdentifier1";
                CalEventViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell = [[CalEventViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                //cell.backgroundColor = [UIColor redColor];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                statusLblStr =  obj[@"Subject"];
                if(statusLblStr !=nil && ![statusLblStr isEqual:@""] && ![statusLblStr isKindOfClass:[NSNull class]] &&![statusLblStr isEqualToString:@"<null>"]){
                    cell.statusOfEventLbl.text = obj[@"Subject"];
                    cell.eventTypeLbl.text = @"Not available";
                    cell.phoneImg.image = nil;
                    NSString *whoName = [[obj valueForKey:@"What"] valueForKey:@"Name"];
                    if(whoName!=nil && ![whoName isEqual:@""] && ![whoName isKindOfClass:[NSNull class]] &&![whoName isEqualToString:@"<null>"]){
                        NSString *name = [[obj valueForKey:@"What"] valueForKey:@"Name"];
                        if(name!=nil && ![name isEqual:@""] && ![name isKindOfClass:[NSNull class]] &&![name isEqualToString:@"<null>"]){
                            cell.nameLbl.text =  [[obj valueForKey:@"What"] valueForKey:@"Name"];
                        }else{
                            cell.nameLbl.text =  @"Not available";
                        }
                    }else{
                        cell.nameLbl.text = @"Not available";
                    }
                    NSString *oppname = [[obj valueForKey:@"Who"] valueForKey:@"Name"];
                    if(oppname!=nil && ![oppname isEqual:@""] && ![oppname isKindOfClass:[NSNull class]] &&![whoName isEqualToString:@"<null>"]){
                        cell.oppNameLbl.text =  oppname;

                    }else{
                        cell.oppNameLbl.text = @"Not available";
                    }

                    cell.eventTypeLbl.text = [[obj objectForKey:@"attributes"] objectForKey:@"type"];
                    cell.phoneImg.image = [UIImage imageNamed:@"Event.png"];

                    NSString *createdDateStr =  obj[@"StartDateTime"]; // StartDateTime
                    //2017-11-06T11:30:00.000+0000
                    if(createdDateStr !=nil &&![createdDateStr isEqual:@""] && ![createdDateStr isKindOfClass:[NSNull class]] &&![createdDateStr isEqualToString:@"<null>"]){
                        cell.dateLbl.text = [self onlyTaskDate:createdDateStr];
                        //cell.timeLbl.text = [self onlyTaskTime:createdDateStr];
                        NSString *string = [self onlyTaskTime:createdDateStr];
                        NSCharacterSet *separator = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                        NSArray *stringComponents = [string componentsSeparatedByCharactersInSet:separator];
                        NSLog(@"the array %@",stringComponents);
//                        cell.timeLbl.text  = [stringComponents objectAtIndex:0];
//                        cell.timeSecLbl.text = [stringComponents objectAtIndex:1];
                        cell.startDateLbl.text = [self onlyTaskDate:createdDateStr];

                    }else{
                        cell.dateLbl.text = @"NA";
                        cell.timeLbl.text = @"NA";
                    }
                    NSString *enddateDateStr =  obj[@"EndDateTime"]; // StartDateTime
                    //2017-11-06T11:30:00.000+0000
                    if(enddateDateStr !=nil &&![enddateDateStr isEqual:@""] && ![enddateDateStr isKindOfClass:[NSNull class]] &&![enddateDateStr isEqualToString:@"<null>"]){
                        cell.endDateLbl.text = [self onlyTaskDate:enddateDateStr];
                    }else{
                        cell.dateLbl.text = @"NA";
                        cell.timeLbl.text = @"NA";
                    }
                    // cell.endDateLbl.text = [self onlyTaskDate:createdDateStr];
                    [cell.displayIcon setImage:[UIImage imageNamed:@"CallEventDetails.png"] forState:UIControlStateNormal];

                }else{
                    cell.statusOfEventLbl.text = @"Not available";
                }
                cell.buttomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                cell.buttomView.layer.borderWidth = 1.0f;
                return cell;
            }
            
            else{
                           // CalEventViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"CalEventViewCellIdentifier2"];
                            static NSString *CellIdentifier = @"CalTaskViewCellIdentifier";
                            CalTaskViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[CalTaskViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                            }
            
                            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                            statusLblStr =  obj[@"Subject"];
            
                            if(statusLblStr !=nil && ![statusLblStr isEqual:@""] && ![statusLblStr isKindOfClass:[NSNull class]] &&![statusLblStr isEqualToString:@"<null>"]){
                                cell.statusOfEventLbl.text = obj[@"Subject"];
                            }else{
                                cell.statusOfEventLbl.text =@"Not available";
                            }
                            cell.eventTypeLbl.text = @"Not available";
                            cell.phoneImg.image = nil;
            
                            NSString *whatName = [[obj objectForKey:@"What"] objectForKey:@"Name"];
                            NSString *whoName = [[obj valueForKey:@"Who"] valueForKey:@"Name"];
            
                            if((whatName!=nil && ![whatName isEqual:@""] && ![whatName isKindOfClass:[NSNull class]] &&![whatName isEqualToString:@"<null>"]) && (whoName!=nil && ![whoName isEqual:@""] && ![whoName isKindOfClass:[NSNull class]] &&![whoName isEqualToString:@"<null>"])){
                                // display opp name
                                 cell.nameLbl.text =  [[obj objectForKey:@"What"] objectForKey:@"Name"];
            
                               /* NSString *name = [[obj objectForKey:@"What"] objectForKey:@"Name"];
                                if(name!=nil && ![name isEqual:@""] && ![name isKindOfClass:[NSNull class]] &&![name isEqualToString:@"<null>"]){
                                    cell.nameLbl.text =  [[obj objectForKey:@"What"] objectForKey:@"Name"];
                                }else{
                                    // what name is nill
                                    NSString *whoName = [[obj valueForKey:@"Who"] valueForKey:@"Name"];
                                    if(whoName!=nil && ![whoName isEqual:@""] && ![whoName isKindOfClass:[NSNull class]] &&![whoName isEqualToString:@"<null>"]){
                                        cell.nameLbl.text =  whoName;
                                    }else{
                                        cell.oppNameLbl.text = @"Not available";
                                    }
                                   // cell.nameLbl.text =  @"Not available";
                                }*/
                            }else if((whatName!=nil && ![whatName isEqual:@""] && ![whatName isKindOfClass:[NSNull class]] &&![whatName isEqualToString:@"<null>"]) && (whoName==nil && [whoName isEqual:@""] && [whoName isKindOfClass:[NSNull class]] &&[whoName isEqualToString:@"<null>"])){
                                // display opp name
                                cell.nameLbl.text =  [[obj objectForKey:@"What"] objectForKey:@"Name"];
            
                            }else if((whatName ==nil && ![whatName isEqual:@""] && [whatName isKindOfClass:[NSNull class]] &&[whatName isEqualToString:@"<null>"]) && (whoName!=nil && ![whoName isEqual:@""] && ![whoName isKindOfClass:[NSNull class]] && ![whoName isEqualToString:@"<null>"])){
                                // display opp name
                                cell.nameLbl.text =  [[obj objectForKey:@"Who"] objectForKey:@"Name"];
                            }else{
                                cell.nameLbl.text = @"NA";
                            }
            
            
                            NSString *eventTypeStr = [[obj objectForKey:@"attributes"] objectForKey:@"type"];
                            if(eventTypeStr!=nil && ![eventTypeStr isEqual:@""] && ![eventTypeStr isKindOfClass:[NSNull class]] &&![eventTypeStr isEqualToString:@"<null>"]){
                                cell.eventTypeLbl.text = eventTypeStr;
                            }else{
                                cell.eventTypeLbl.text = @"Not Available";
                            }
                            cell.phoneImg.image = [UIImage imageNamed:@"task.png"];
            
                            NSString *activityDateStr =  obj[@"ActivityDate"];
                            if(activityDateStr !=nil && ![activityDateStr isEqual:@""] && ![activityDateStr isEqual:@""] && ![activityDateStr isKindOfClass:[NSNull class]] &&![activityDateStr isEqualToString:@"<null>"]){
                                cell.dateLbl.text = [self headerTaskDate:activityDateStr];
                            }else{
                                cell.dateLbl.text = @"NA";
                            }
                            NSString *reminderDateStr =  obj[@"ReminderDateTime"];
                            if(reminderDateStr !=nil && ![reminderDateStr isEqual:@""] && ![reminderDateStr isEqual:@""] && ![reminderDateStr isKindOfClass:[NSNull class]] &&![reminderDateStr isEqualToString:@"<null>"]){
            
                                NSString *string = [self onlyTaskTime:reminderDateStr];
                                NSCharacterSet *separator = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                                NSArray *stringComponents = [string componentsSeparatedByCharactersInSet:separator];
                                NSLog(@"the array %@",stringComponents);
                               // cell.timeLbl.text  = [stringComponents objectAtIndex:0];
                              //  cell.timeSecLbl.text = [stringComponents objectAtIndex:1];
            
                            }else{
                                // cell.dateLbl.text = @"NA";
                                cell.timeLbl.text = @"NA";
                            }
                            [cell.displayIcon setImage:[UIImage imageNamed:@"CallTaskDetails.png"] forState:UIControlStateNormal];
                            cell.buttomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                            cell.buttomView.layer.borderWidth = 1.0f;
                            return cell;
            
                        }
        }else{
            
        }
    } else {
        // TextFieldCell *cell =nil;
        
        //static NSString *rowIdentifier = @"TextFieldCellIdentifier";
        static NSString *rowIdentifier = @"TextFieldCellIdentifier";
        TextFieldCell *cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier];
        if (cell == nil) {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rowIdentifier];
        }
        cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textfieldTitle.text = @"No Activities Found";
        return cell;
    }
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section ==0){
        if([typeIs isEqualToString:@"Event"]){
            return 130;
        }else{
            return 83;
            
        }
    }else if(indexPath.section == 1){
        if([self.dataRows count] == 0){
            return 50;
        }else{
            return 0;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //return 110;
    return 0;
}
- (NSString *)headerDateIs:(NSString *)dateString {
    NSString *userVisibleDateTimeString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //yyyy-MM-dd
    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm"];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}
- (NSString *)headerTaskDate:(NSString *)dateString {
    NSString *userVisibleDateTimeString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //yyyy-MM-dd // 2017-11-07
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, MMM dd, yyyy"];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

- (NSString *)onlyAmOrPMDateIs:(NSString *)dateString {
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
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"hh:mm a" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
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
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"hh:mm a" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}
- (NSString *)onlyTaskDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    // [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss'Z'"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    //  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSString *userVisibleDateTimeString;
    if (date != nil) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEE, MMM dd, yyyy hh:mm a" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}
- (NSString *)onlyTaskTime:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    // [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss'Z'"];
    //  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSString *userVisibleDateTimeString;
    if (date != nil) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"hh:mm a" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     EventDetailsViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showEventDetailsVC"];
     [oppVC setEditMode:FALSE];
     oppVC.showEditButton = FALSE;
     oppVC.infoArray = [self.dataRows objectAtIndex:indexPath.row] ;
     oppVC.recordObjectId =[[self.dataRows objectAtIndex:indexPath.row] objectForKey:@"Id"];
     oppVC.selectedTypeIs = [[[self.dataRows objectAtIndex:indexPath.row] objectForKey:@"attributes"] objectForKey:@"type"];
     [self.navigationController pushViewController:oppVC animated:YES];*/
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EventDetailsViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showEventDetailsVC"];
    [oppVC setEditMode:FALSE];
    oppVC.showEditButton = FALSE;
    //   oppVC.selcted_calendar_List_Delegate = self;
    [oppVC setSelcted_calendar_List_Delegate:self];
    oppVC.infoArray = [self.dataRows objectAtIndex:indexPath.row] ;
    oppVC.recordObjectId =[[self.dataRows objectAtIndex:indexPath.row] objectForKey:@"Id"];
    oppVC.selectedTypeIs = [[[self.dataRows objectAtIndex:indexPath.row] objectForKey:@"attributes"] objectForKey:@"type"];
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:oppVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectedCalendarEventVc:(NSString *)eventType{
    if([eventType isEqualToString:@"EventEdit"]){
        // call sfdc soql query
        [self updateRecords];
    }
}
-(void)selectedCalendarTaskVc:(NSString *)taskType{
    /* if([taskType isEqualToString:@"TaskEdit"]){
     // call sfdc soql query
     NSLog(@"task selected date %@",self.selectedDate);
     [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
     SFRestRequest *request  = [[SFRestAPI sharedInstance] requestForQuery:[NSString stringWithFormat:@"SELECT AccountId, Account.Name, Subject,Id, WhatId, What.Name, WhoId, Who.Name,What.Type, ActivityDate,Task.ReminderDateTime,Status,Description FROM Task WHERE what.type = 'Opportunity' and ActivityDate =%@", self.selectedDate]]; // LIMIT 20
     [[SFRestAPI sharedInstance] send:request delegate:self];
     
     }*/
    [self updateRecords];
    
}
// created task
-(void)CreatedTask:(NSString *)typeIS{
    if([typeIS isEqualToString:@"CreatedTask"]){
        // call sfdc soql query
        /* NSLog(@"task selected date %@",self.selectedDate);
         [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
         SFRestRequest *request  = [[SFRestAPI sharedInstance] requestForQuery:[NSString stringWithFormat:@"SELECT AccountId, Account.Name, Subject,Id, WhatId, What.Name, WhoId, Who.Name,What.Type, ActivityDate,Task.ReminderDateTime,Status,Description FROM Task WHERE what.type = 'Opportunity' and ActivityDate =%@", self.selectedDate]]; // LIMIT 20
         [[SFRestAPI sharedInstance] send:request delegate:self];*/
        [self updateRecords];
        
    }
    
}
// created event
-(void)CreatedEvent:(NSString *)typeIS{
    if([typeIS isEqualToString:@"CreatedEvent"]){
        // call sfdc soql query
        [self updateRecords];
    }
    
}
- (void)updateRecords
{
    self.dataRows = [[NSMutableArray alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMMyyyy" options:0 locale:nil];
    self.selectedDateLabel.text = [formatter stringFromDate:[NSDate date]];
    
    NSString *formstedStr =[formatter stringFromDate:[NSDate date]] ;
    self.selectedDate = [self selectedDateIs:formstedStr];
    NSLog(@"selected date%@",self.selectedDate);
    if(self.selectedDate!=nil && [self.selectedDate length]>0){
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
        // 07-11-17
        //  Event Query : SELECT ActivityDate,CreatedDate,Subject,What.Name,Who.Name,what.type FROM Event where what.type = 'Opportunity'
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:[NSString stringWithFormat:@"SELECT AccountId, Account.Name, Subject,Id, WhatId, What.Name, WhoId, Who.Name,What.Type, StartDateTime,Type,Description,EndDateTime FROM Event WHERE what.type = 'Opportunity' and ActivityDate =%@", self.selectedDate]];
        [[SFRestAPI sharedInstance] send:request delegate:self];
    }
    
}

@end

