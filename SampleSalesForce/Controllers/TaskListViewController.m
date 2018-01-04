//
//  TaskListViewController.m
//  SampleSalesForce
//
//  Created by Apple on 10/26/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "TaskListViewController.h"
#import "TextFieldCell.h"
#import "EventDateView.h"
#import "SubmitButtonCell.h"
#import "LabelSwitchCell.h"
#import "OppViewCell.h"
#import "TextViewCell.h"
#import "Utilities.h"


@interface TaskListViewController ()<UITextFieldDelegate,EventDateViewDelegate,SubmitButtonDelegate,ToggleSwitchDelegate,UITextViewDelegate>
@property (nonatomic, strong) Utilities *util;

@end

@implementation TaskListViewController
@synthesize activeField;
@synthesize keyboardOpen;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.util = [[Utilities alloc] init];

    if([self.selectedTypeIs isEqualToString:@"Event"]){
        self.title = @"Add Event";
        //Theam blue
       // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:3.0/255.0 green:35.0/255.0 blue:102.0/255.0 alpha:1]];
       // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:140.0/255.0 green:112.0/255.0 blue:201.0/255.0 alpha:1]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0/255.0 green:107.0/255.0 blue:241.0/255.0 alpha:1]];

    }else{
        self.title = @"Add Task";
       // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:100.0/255.0 green:178.0/255.0 blue:71.0/255.0 alpha:1]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0/255.0 green:107.0/255.0 blue:241.0/255.0 alpha:1]];

    }
    UIImage *buttonImage = [UIImage imageNamed:@"arrow_back.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Picker
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    self.opDataDo = [[OppDataDO alloc] init];
    if (self.editMode) {
        self.enableFields=TRUE;
    }else{
        self.enableFields=FALSE;
    }
    
    self.pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-170-44, self.view.bounds.size.width, 44)];
    self.pickerToolBar.translucent=YES;
    self.pickerToolBar.barTintColor=[UIColor colorWithRed:3.0/255.0 green:35.0/255.0 blue:96.0/255.0 alpha:1];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    [self.datePickerview addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerValueSelected:)];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(pickerValueCanceled:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    doneBtn.tintColor = [UIColor whiteColor];
    cancelBtn.tintColor = [UIColor whiteColor];
    [barItems addObject:cancelBtn];
    [barItems addObject:flexibleItem];
    [barItems addObject:doneBtn];
    [self.pickerToolBar setItems:barItems animated:YES];
    [self.view addSubview:self.pickerToolBar];
    
    [self.pickerToolBar setHidden:TRUE];
    [self.datePickerview setHidden:TRUE];
    [self.pickerViewObj setHidden:TRUE];
    self.datePickerview.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
    self.pickerViewObj.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];

   // [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
//    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,IsActive,Family,ProductCode,CreatedDate,Id FROM Product2"];
//    [[SFRestAPI sharedInstance] send:request delegate:self];
    ateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                target:self
                                              selector:@selector(rotateMove)
                                              userInfo:nil
                                               repeats:YES];
    /*NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
  //  [infoDict setObject:@"Brian Scott" forKey:@"Who"]; // name
    [infoDict setObject:@"00646000004YDAJ" forKey:@"WhatId"]; // related to
    [infoDict setObject:@"Meeting" forKey:@"Subject"];
    [infoDict setObject:@"00546000000I9hV" forKey:@"OwnerId"];
    [infoDict setObject:self.opDataDo.closeDate forKey:@"ActivityDate"];
    [infoDict setObject:@"Deal" forKey:@"Description"];
      SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Task" fields:infoDict];
     [[SFRestAPI sharedInstance] send:request delegate:self];*/
    
}
-(void)rotateMove{
    [SVProgressHUD dismiss];
}
#pragma Backbutton clicked
-(void)backBtnClicked:(id)sender{
  //  [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:TRUE];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification  object:nil];
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
        self.dataRows = [records mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
       });
       // [self.navigationController popViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:nil];
        
        if([self.selectedTypeIs isEqualToString:@"Event"]){
            [self dismissViewControllerAnimated:YES completion:nil];
            if([self.create_Activites_delegate respondsToSelector:@selector(CreatedEvent:)]) {
                [self.create_Activites_delegate CreatedEvent:@"CreatedEvent"];
            }
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
            if([self.create_Activites_delegate respondsToSelector:@selector(CreatedTask:)]) {
                [self.create_Activites_delegate CreatedTask:@"CreatedTask"];
            }
        }

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"No data found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
    }
    
}
- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    NSLog(@"message.... %@", error.userInfo);
    NSDictionary *dict = error.userInfo;
    NSMutableArray *aray =  [[NSMutableArray alloc] init];
    aray = [dict objectForKey:@"error"];
  //  NSDictionary *errorDict  = [[aray objectAtIndex:0] objectForKey:@"error"];
    NSString *messageStr = [[aray objectAtIndex:0] objectForKey:@"message"];
    NSString *errrorCodeStr = [[aray objectAtIndex:0] objectForKey:@"errorCode"];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errrorCodeStr message:messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        alert.tag = 100;
        [alert show];
      //  [self.tableview reloadData];
    });
    //add your failed error handling here
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if([self.selectedTypeIs isEqualToString:@"Event"]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}
- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}
-(void)changeToggleState:(BOOL)state index:(NSIndexPath *)index{
    [self.view endEditing:TRUE];
    [self.pickerToolBar setHidden:FALSE];
    if ([self.datePickerview isHidden]) {
            self.tableview.frame=CGRectMake(0, self.tableview.frame.origin.y, self.tableview.frame.size.width, self.tableview.frame.size.height-250);
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    [self.pickerViewObj selectRow:0 inComponent:0 animated:FALSE];
    [self.datePickerview setHidden:TRUE];
    [self.pickerViewObj setHidden:FALSE];
    self.pickerOpen=TRUE;
}

- (void)datePickerChanged:(UIDatePicker *)datePicker1{
   // [self.activeField resignFirstResponder];
    datePicker1.minimumDate=nil;
    datePicker1.maximumDate=nil;
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if (self.selectedPicker==4001) {
            datePicker1.minimumDate=[NSDate date];
        }
        if (self.selectedPicker==4002) {
            datePicker1.minimumDate=[NSDate date];
        }
    }else{
        if (self.selectedPicker==4001) {
            datePicker1.minimumDate=[NSDate date];
        }
    }
}


-(void)pickerValueCanceled:(id)sender{
    [self.datePickerview setHidden:TRUE];
    [self.pickerToolBar setHidden:TRUE];
    [self.pickerViewObj setHidden:TRUE];
    self.pickerOpen=FALSE;
    self.tableview.frame=CGRectMake(0, self.tableview.frame.origin.y, self.tableview.frame.size.width, self.tableview.frame.size.height+250);
    self.selectedPicker=0;
    self.seletedPickerRow=0;
}


-(void)pickerValueSelected:(id)sender{
    [self.datePickerview setHidden:TRUE];
    [self.pickerToolBar setHidden:TRUE];
    [self.pickerViewObj setHidden:TRUE];
    [self.activeField resignFirstResponder];
    self.tableview.frame=CGRectMake(0, self.tableview.frame.origin.y, self.tableview.frame.size.width, self.tableview.frame.size.height+250);
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        [self.activeField resignFirstResponder];

        if (self.selectedPicker==4001) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];// MM/dd/yyyy hh:mm:ss a
            NSString *strDate = [dateFormatter stringFromDate:self.datePickerview.date];
            NSIndexPath *index=[NSIndexPath indexPathForRow:4 inSection:1];
            EventDateView *cell=[self.tableview cellForRowAtIndexPath:index];
            [cell.eventDate setText:strDate];
            [self.opDataDo setStartDate:strDate];
            
            self.pickerOpen=FALSE;
            self.seletedPickerRow=0;
            [self.tableview reloadData];
        }
        if (self.selectedPicker==4002) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];// MM/dd/yyyy hh:mm:ss a
            NSString *strDate = [dateFormatter stringFromDate:self.datePickerview.date];
            NSIndexPath *index=[NSIndexPath indexPathForRow:5 inSection:1];
            EventDateView *cell=[self.tableview cellForRowAtIndexPath:index];
            [cell.eventDate setText:strDate];
            [self.opDataDo setEndDate:strDate];
            self.pickerOpen=FALSE;
            self.seletedPickerRow=0;
            [self.tableview reloadData];
        }
    }else{
        if (self.selectedPicker==4001) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];// MM/dd/yyyy hh:mm:ss a
            NSString *strDate = [dateFormatter stringFromDate:self.datePickerview.date];
            NSIndexPath *index=[NSIndexPath indexPathForRow:4 inSection:1];
            EventDateView *cell=[self.tableview cellForRowAtIndexPath:index];
            [cell.eventDate setText:strDate];
            [self.opDataDo setCloseDate:strDate];
            
            self.pickerOpen=FALSE;
            self.seletedPickerRow=0;
            [self.tableview reloadData];
            
        }

    }
    
}
- (void)keyboardDidShow:(NSNotification *)sender {
    if (self.pickerOpen) {
        [self.datePickerview setHidden:TRUE];
        [self.pickerToolBar setHidden:TRUE];
        [self.pickerViewObj setHidden:TRUE];
        self.pickerOpen=FALSE;
        self.tableview.frame=CGRectMake(0,0, self.view.frame.size.width, self.tableview.frame.size.height+250);
    }
    
    if (!keyboardOpen) {
        self.keyboardOpen=TRUE;
        self.tableview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.tableview.frame.size.height-250);
    }
}

- (void)keyboardDidHide:(NSNotification *)sender {
    if (keyboardOpen) {
        self.tableview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.tableview.frame.size.height+250);
        keyboardOpen=FALSE;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSInteger nextTag = activeField.tag + 1;
    UIResponder* nextResponder = [self.tableview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [self.activeField resignFirstResponder];
    }
    if(textField.tag == 1001){
        [self.activeField resignFirstResponder];
    }
    return FALSE;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.activeField=textField;
    
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if (self.activeField.tag==1000) {
        }else if (self.activeField.tag == 1001){
           // [self.activeField resignFirstResponder];
            NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1002){
            [self.activeField resignFirstResponder];
            self.activeField.tintColor = [UIColor clearColor];
            NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1003){
            [self.activeField resignFirstResponder];
            self.activeField.tintColor = [UIColor clearColor];
            NSIndexPath *index=[NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1004){
            [self.activeField resignFirstResponder];
            self.activeField.tintColor = [UIColor clearColor];
            NSIndexPath *index=[NSIndexPath indexPathForRow:4 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1005){
            NSIndexPath *index=[NSIndexPath indexPathForRow:7 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }

        else if(self.activeField.tag>=4001){
            NSIndexPath *index=[NSIndexPath indexPathForRow:5 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }
        else if(self.activeField.tag>=4002){
            NSIndexPath *index=[NSIndexPath indexPathForRow:6 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }

    }else if([self.selectedTypeIs isEqualToString:@"Task"]){
        if (self.activeField.tag==1000) {
        }else if (self.activeField.tag == 1001){
            NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1002){
            [self.activeField resignFirstResponder];
            self.activeField.tintColor = [UIColor clearColor];
            NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1003){
            [self.activeField resignFirstResponder];
            self.activeField.tintColor = [UIColor clearColor];
            NSIndexPath *index=[NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1004){
            [self.activeField resignFirstResponder];
            self.activeField.tintColor = [UIColor clearColor];
            NSIndexPath *index=[NSIndexPath indexPathForRow:4 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1005){
            NSIndexPath *index=[NSIndexPath indexPathForRow:6 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else if(self.activeField.tag>=4001){
            NSIndexPath *index=[NSIndexPath indexPathForRow:5 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }

    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
            
        case 1001:
            self.opDataDo.title=textField.text;
            break;
        case 1002:
            self.opDataDo.companyName=textField.text; // contact
            break;
        case 1003:
            self.opDataDo.stage=textField.text;// related
            break;
        case 1004:
            self.opDataDo.productName=textField.text; // product
            break;
        /*case 1005:
           //self.opDataDo.nextStep=textField.text; // description
            break;*/
        default:
            break;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.enableFields) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if(section == 0){
            if (self.enableFields) {
                return 8;
            }else{
                return 8;
            }
            
        }else{
            if (self.enableFields) {
                return 1;
            }else{
                return 0;
            }
            
        }

    }else  if([self.selectedTypeIs isEqualToString:@"Task"]){
        if(section == 0){
            if (self.enableFields) {
                return 7;
            }else{
                return 7;
            }
            
        }else{
            if (self.enableFields) {
                return 1;
            }else{
                return 0;
            }
            
        }

    }
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if(indexPath.section == 0){
            if(indexPath.row ==0){
                // OppViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"TextFieldCellIdentifier"];
                OppViewCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }else if (indexPath.row==1) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier1";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1001];
                [cell.textfieldTitle setText:@"Title (required)"];
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                     [cell.textfield setText:self.opDataDo.title];
                     }else{
                     [cell.textfield setText:@""];
                     }

                }else{
                    [cell.textfield setEnabled:FALSE];
                    if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.title];
                    }else{
                        [cell.textfield setText:@""];
                    }

                }
                return cell;
            }else if (indexPath.row==2) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier2";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
//                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1002];
                [cell.textfieldTitle setText:@"Contact"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    if(self.opDataDo.companyName!=nil && ![self.opDataDo.companyName isEqual:@""] && ![self.opDataDo.companyName isKindOfClass:[NSNull class]] &&![self.opDataDo.companyName isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.companyName];
                    }else{
                        [cell.textfield setText:@""];
                    }

                }else{
                    [cell.textfield setEnabled:FALSE];
                    if(self.opDataDo.companyName!=nil && ![self.opDataDo.companyName isEqual:@""] && ![self.opDataDo.companyName isKindOfClass:[NSNull class]] &&![self.opDataDo.companyName isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.companyName];
                    }else{
                        [cell.textfield setText:@""];
                    }

                }
                return cell;
            }else if (indexPath.row==3) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier3";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
//                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1003];
                [cell.textfieldTitle setText:@"Opportunity"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    if(self.opDataDo.stage!=nil && ![self.opDataDo.stage isEqual:@""] && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.stage];
                    }else{
                        [cell.textfield setText:@""];
                    }

                }else{
                    [cell.textfield setEnabled:FALSE];
                    if(self.opDataDo.stage!=nil && ![self.opDataDo.stage isEqual:@""] && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.stage];
                    }else{
                        [cell.textfield setText:@""];
                    }

                }
                return cell;
            }else if (indexPath.row==4) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier4";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                //                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                [cell.textfield setTag:1004];
                [cell.textfieldTitle setText:@"Product"];
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    if(self.opDataDo.productName!=nil && ![self.opDataDo.productName isEqual:@""] && ![self.opDataDo.productName isKindOfClass:[NSNull class]] &&![self.opDataDo.productName isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.productName];
                    }else{
                        [cell.textfield setText:@""];
                    }
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                    if(self.opDataDo.productName!=nil && ![self.opDataDo.productName isEqual:@""] && ![self.opDataDo.productName isKindOfClass:[NSNull class]] &&![self.opDataDo.productName isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.productName];
                    }else{
                        [cell.textfield setText:@""];
                    }
                    
                }
                return cell;
            }else if (indexPath.row==5){
                EventDateView *cell=[self.tableview dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setIndex:indexPath];
                [cell setDelegate:self];
                if (self.enableFields) {
                    [cell.eventDateButton setHidden:FALSE];
                    [cell.eventDateButton setEnabled:TRUE];
                    [cell.eventDate setEnabled:TRUE];
                    if(self.opDataDo.startDate!=nil && ![self.opDataDo.startDate isEqual:@""] && ![self.opDataDo.startDate isKindOfClass:[NSNull class]] &&![self.opDataDo.startDate isEqualToString:@"<null>"]){
                     [cell.eventDate setText:self.opDataDo.startDate];
                     }else{
                     [cell.eventDate setText:@""];
                     }
                }else{
                    [cell.eventDateButton setHidden:TRUE];
                    [cell.eventDateButton setEnabled:FALSE];
                    [cell.eventDate setEnabled:FALSE];
                    //self.opDataDo.closeDate =[self.infoArray valueForKey:@"CloseDate"];
                    
                     if(self.opDataDo.startDate!=nil && ![self.opDataDo.startDate isEqual:@""] && ![self.opDataDo.startDate isKindOfClass:[NSNull class]] &&![self.opDataDo.startDate isEqualToString:@"<null>"]){
                     [cell.eventDate setText:self.opDataDo.startDate];
                     }else{
                     [cell.eventDate setText:@""];
                     }
                    
                }
                [cell.headerlabel setText:@"Start Date"];
                return cell;
                
            }else if (indexPath.row==6){
                EventDateView *cell=[self.tableview dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier1" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setIndex:indexPath];
                [cell setDelegate:self];
                if (self.enableFields) {
                    [cell.eventDateButton setHidden:FALSE];
                    [cell.eventDateButton setEnabled:TRUE];
                    [cell.eventDate setEnabled:TRUE];
                    if(self.opDataDo.endDate!=nil && ![self.opDataDo.endDate isEqual:@""] && ![self.opDataDo.endDate isKindOfClass:[NSNull class]] &&![self.opDataDo.endDate isEqualToString:@"<null>"]){
                        [cell.eventDate setText:self.opDataDo.endDate];
                    }else{
                        [cell.eventDate setText:@""];
                    }
                }else{
                    [cell.eventDateButton setHidden:TRUE];
                    [cell.eventDateButton setEnabled:FALSE];
                    [cell.eventDate setEnabled:FALSE];
                    //self.opDataDo.closeDate =[self.infoArray valueForKey:@"CloseDate"];
                    
                    if(self.opDataDo.endDate!=nil && ![self.opDataDo.endDate isEqual:@""] && ![self.opDataDo.endDate isKindOfClass:[NSNull class]] &&![self.opDataDo.endDate isEqualToString:@"<null>"]){
                        [cell.eventDate setText:self.opDataDo.endDate];
                    }else{
                        [cell.eventDate setText:@""];
                    }

                }
                [cell.headerlabel setText:@"End Date"];
                return cell;
                
            }else if (indexPath.row==7) {
                /*TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier5";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1005];
                [cell.textfieldTitle setText:@"Description"];
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    if(self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textfield setText:@""];
                    }

                }else{
                    [cell.textfield setEnabled:FALSE];
                    if(self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textfield setText:@""];
                    }

                }
                return cell;*/
                TextViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:@"DescriptionCellIdentifier"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell drawBordersToView];
                // cell.textview.editable=FALSE;
                [cell.descLbl setText:@"Description"];
                [cell.textview setTag:1007];
                cell.textview.delegate = self;
                
                //                if (self.taskData.descriptionis!=nil && [self.taskData.descriptionis length]>0) {
                //                    detailsCell.textview.text=self.taskData.descriptionis;
                //                }else{
                //                    detailsCell.textview.text=@"";
                //                }
                if (self.enableFields) {
                    [cell.textview setEditable:TRUE];
                    if(self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]){
                        [cell.textview setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textview setText:@""];
                    }
                }else{
                    [cell.textview setEditable:FALSE];
                    // array display
                    if(self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]){
                        [cell.textview setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textview setText:@""];
                    }
                }
                return cell;

            }
        }else if (indexPath.section==1) {
            static NSString *CellIdentifier= @"SubmitCellIdentifier";
            SubmitButtonCell* cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell setDelegate:self];
           // cell.submitButton.backgroundColor = [UIColor colorWithRed:140.0/255.0 green:112.0/255.0 blue:201.0/255.0 alpha:1];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }else  if([self.selectedTypeIs isEqualToString:@"Task"]){
        if(indexPath.section == 0){
            if(indexPath.row ==0){
                // OppViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"TextFieldCellIdentifier"];
                OppViewCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }else if (indexPath.row==1) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier1";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1001];
                [cell.textfieldTitle setText:@"Title (required)"];
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.title];
                    }else{
                        [cell.textfield setText:@""];
                    }
                }else{
                    [cell.textfield setEnabled:FALSE];
                    if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.title];
                    }else{
                        [cell.textfield setText:@""];
                    }
                }
                return cell;
            }else if (indexPath.row==2) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier2";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
              //  [cell.textfield setKeyboardType:UIKeyboardTypeDefault];

                [cell.textfield setTag:1002];
                [cell.textfieldTitle setText:@"Contact"];
                if (self.enableFields) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.textfield setEnabled:TRUE];
                    if(self.opDataDo.companyName!=nil && ![self.opDataDo.companyName isEqual:@""] && ![self.opDataDo.companyName isKindOfClass:[NSNull class]] &&![self.opDataDo.companyName isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.companyName];
                    }else{
                        [cell.textfield setText:@""];
                    }

                }else{
                    [cell.textfield setEnabled:FALSE];
                    if(self.opDataDo.companyName!=nil && ![self.opDataDo.companyName isEqual:@""] && ![self.opDataDo.companyName isKindOfClass:[NSNull class]] &&![self.opDataDo.companyName isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.companyName];
                    }else{
                        [cell.textfield setText:@""];
                    }
                    

                }
                return cell;
            }else if (indexPath.row==3) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier3";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                //[cell.textfield setKeyboardType:UIKeyboardTypeDefault];

                [cell.textfield setTag:1003];
                [cell.textfieldTitle setText:@"Opportunity"];
                if (self.enableFields) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.textfield setEnabled:TRUE];
                    if(self.opDataDo.stage!=nil && ![self.opDataDo.stage isEqual:@""] && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.stage];
                    }else{
                        [cell.textfield setText:@""];
                    }
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                }else{
                    [cell.textfield setEnabled:FALSE];
                    if(self.opDataDo.stage!=nil && ![self.opDataDo.stage isEqual:@""] && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.stage];
                    }else{
                        [cell.textfield setText:@""];
                    }

                }
                return cell;
            }else if (indexPath.row==4) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier4";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                [cell.textfield setDelegate:self];
                //                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1004];
                [cell.textfieldTitle setText:@"Product"];
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    if(self.opDataDo.productName!=nil && ![self.opDataDo.productName isEqual:@""] && ![self.opDataDo.productName isKindOfClass:[NSNull class]] &&![self.opDataDo.productName isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.productName];
                    }else{
                        [cell.textfield setText:@""];
                    }
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                    if(self.opDataDo.productName!=nil && ![self.opDataDo.productName isEqual:@""] && ![self.opDataDo.productName isKindOfClass:[NSNull class]] &&![self.opDataDo.productName isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.productName];
                    }else{
                        [cell.textfield setText:@""];
                    }
                    
                }
                return cell;
            }else if (indexPath.row==5){
                EventDateView *cell=[self.tableview dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setIndex:indexPath];
                [cell setDelegate:self];
                if (self.enableFields) {
                    [cell.eventDateButton setHidden:FALSE];
                    [cell.eventDateButton setEnabled:TRUE];
                    [cell.eventDate setEnabled:TRUE];
                  if(self.opDataDo.closeDate!=nil && ![self.opDataDo.closeDate isEqual:@""] && ![self.opDataDo.closeDate isKindOfClass:[NSNull class]] &&![self.opDataDo.closeDate isEqualToString:@"<null>"]){
                     [cell.eventDate setText:self.opDataDo.closeDate];
                     }else{
                     [cell.eventDate setText:@""];
                     }
                }else{
                    [cell.eventDateButton setHidden:TRUE];
                    [cell.eventDateButton setEnabled:FALSE];
                    [cell.eventDate setEnabled:FALSE];
                    //self.opDataDo.closeDate =[self.infoArray valueForKey:@"CloseDate"];
                     if(self.opDataDo.closeDate!=nil && ![self.opDataDo.closeDate isEqual:@""] && ![self.opDataDo.closeDate isKindOfClass:[NSNull class]] &&![self.opDataDo.closeDate isEqualToString:@"<null>"]){
                     [cell.eventDate setText:self.opDataDo.closeDate];
                     }else{
                     [cell.eventDate setText:@""];
                     }
                }
                [cell.headerlabel setText:@"Due Date"];
                return cell;
                
            }else if (indexPath.row==6) {
                /*TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier5";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1005];
                [cell.textfieldTitle setText:@"Description"];
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    if(self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textfield setText:@""];
                    }

                }else{
                    [cell.textfield setEnabled:FALSE];
                    // array display
                    if(self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textfield setText:@""];
                    }

                }
                
                return cell;*/
                TextViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:@"DescriptionCellIdentifier"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell drawBordersToView];
               // cell.textview.editable=FALSE;
                [cell.descLbl setText:@"Description"];
                [cell.textview setTag:1007];
                cell.textview.delegate = self;
                
//                if (self.taskData.descriptionis!=nil && [self.taskData.descriptionis length]>0) {
//                    detailsCell.textview.text=self.taskData.descriptionis;
//                }else{
//                    detailsCell.textview.text=@"";
//                }
                if (self.enableFields) {
                    [cell.textview setEditable:TRUE];
                    if(self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]){
                        [cell.textview setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textview setText:@""];
                    }
                }else{
                    [cell.textview setEditable:FALSE];
                    // array display
                    if(self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]){
                        [cell.textview setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textview setText:@""];
                    }
                }
                return cell;
            }
        }else if (indexPath.section==1) {
            static NSString *CellIdentifier= @"SubmitCellIdentifier";
            SubmitButtonCell* cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell setDelegate:self];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            //cell.submitButton.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:178.0/255.0 blue:71.0/255.0 alpha:1];
            return cell;
        }
    }

    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section ==0) {
        if([self.selectedTypeIs isEqualToString:@"Event"]){
            if(indexPath.row ==0 || indexPath.row ==4) {
                return 0; //             return 60;
            }else if (indexPath.row==7){ // description
                return 100;
            } else {
                return 75;
            }
        }else{
            if(indexPath.row ==0  || indexPath.row ==4) {
                return 0; //             return 60;
            }else if (indexPath.row==6){ // description
                return 100;
            } else {
                return 75;
            }

        }
    } else {
        return 75;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
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
-(void)opendatepicker:(NSIndexPath*)index{
    [self.view endEditing:TRUE];
    self.datePickerview.minimumDate=nil;
    self.datePickerview.maximumDate=nil;
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if (index.row==5) {
            self.selectedPicker=4001;
            self.datePickerview.minimumDate=[NSDate date];
            NSIndexPath *index1=[NSIndexPath indexPathForRow:5 inSection:0];
            if (!keyboardOpen && !self.pickerOpen) {
                self.tableview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.tableview.frame.size.height-250);
            }
            [self.tableview scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        if (index.row==6) {
            self.selectedPicker=4002;
            self.datePickerview.minimumDate=[NSDate date];
            NSIndexPath *index1=[NSIndexPath indexPathForRow:6 inSection:0];
            if (!keyboardOpen && !self.pickerOpen) {
                self.tableview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.tableview.frame.size.height-250);
            }
            [self.tableview scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }else{
        if (index.row==5) {
            self.selectedPicker=4001;
            self.datePickerview.minimumDate=[NSDate date];
        }
        NSIndexPath *index1=[NSIndexPath indexPathForRow:5 inSection:0];
        if (!keyboardOpen && !self.pickerOpen) {
            self.tableview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.tableview.frame.size.height-250);
        }
        
        [self.tableview scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

    [self.datePickerview setDate:[NSDate date]];
    [self.datePickerview setHidden:FALSE];
    [self.pickerToolBar setHidden:FALSE];
    self.pickerOpen=TRUE;
}
-(void)submitData{
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        
        if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
            if(self.opDataDo.companyName!=nil && ![self.opDataDo.companyName isEqual:@""] && ![self.opDataDo.companyName isKindOfClass:[NSNull class]] &&![self.opDataDo.companyName isEqualToString:@"<null>"]){
                if(self.opDataDo.stage!=nil && ![self.opDataDo.stage isEqual:@""] && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]){
//                    if(self.opDataDo.productName!=nil && ![self.opDataDo.productName isEqual:@""] && ![self.opDataDo.productName isKindOfClass:[NSNull class]] &&![self.opDataDo.productName isEqualToString:@"<null>"]){
                        if(self.opDataDo.startDate!=nil && ![self.opDataDo.startDate isEqual:@""] && ![self.opDataDo.startDate isKindOfClass:[NSNull class]] &&![self.opDataDo.startDate isEqualToString:@"<null>"]){
                            if(self.opDataDo.endDate!=nil && ![self.opDataDo.endDate isEqual:@""] && ![self.opDataDo.endDate isKindOfClass:[NSNull class]] &&![self.opDataDo.endDate isEqualToString:@"<null>"]){
                                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
                                [infoDict setObject:self.opDataDo.title forKey:@"Subject"];
                                NSString *startStr = [self updateEventDateFormat:self.opDataDo.startDate];
                                NSString *endStr = [self updateEventDateFormat:self.opDataDo.endDate];

                                [infoDict setObject:startStr forKey:@"StartDateTime"];
                                [infoDict setObject:endStr forKey:@"EndDateTime"];
                                //[infoDict setObject:self.opDataDo.productId forKey:@"Product__c"];
                                if([Utilities objectIsNull:self.opDataDo.whoid]){
                                    [infoDict setObject:@"" forKey:@"WhoId"];
                                }else{
                                    [infoDict setObject:self.opDataDo.whoid forKey:@"WhoId"];
                                }
                                // opp
                                if([Utilities objectIsNull:self.opDataDo.whatId]){
                                    [infoDict setObject:@"" forKey:@"WhatId"];
                                    
                                }else{
                                    [infoDict setObject:self.opDataDo.whatId forKey:@"WhatId"];
                                }
                                // product
                               /* if([Utilities objectIsNull:self.opDataDo.productId]){
                                    [infoDict setObject:@"" forKey:@"Product__c"];
                                }else{
                                    [infoDict setObject:self.opDataDo.productId forKey:@"Product__c"];
                                }*/
                                // desc
                                if([Utilities objectIsNull:self.opDataDo.nextStep]){
                                    [infoDict setObject:@"" forKey:@"Description"];
                                    
                                }else{
                                    [infoDict setObject:self.opDataDo.nextStep forKey:@"Description"];
                                }
                                [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
                                SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Event" fields:infoDict];
                                [[SFRestAPI sharedInstance] send:request delegate:self];

                            }else{
                                [self.util showAlert:@"End date cannot be empty" title:@""];
                            }
                        }else{
                            [self.util showAlert:@"Start date cannot be empty" title:@""];
                        }
                    /*}else{
                        [self.util showAlert:@"Product cannot be empty" title:@""];
                    }*/
                }else{
                    [self.util showAlert:@"Relatedto cannot be empty" title:@""];
                }
            }else{
                [self.util showAlert:@"Contact cannot be empty" title:@""];
            }
        }else{
            [self.util showAlert:@"Title cannot be empty" title:@""];
        }

    }else{
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
        if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
            if(self.opDataDo.companyName!=nil && ![self.opDataDo.companyName isEqual:@""] && ![self.opDataDo.companyName isKindOfClass:[NSNull class]] &&![self.opDataDo.companyName isEqualToString:@"<null>"]){
                if(self.opDataDo.stage!=nil && ![self.opDataDo.stage isEqual:@""] && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]){
//                    if(self.opDataDo.productName!=nil && ![self.opDataDo.productName isEqual:@""] && ![self.opDataDo.productName isKindOfClass:[NSNull class]] &&![self.opDataDo.productName isEqualToString:@"<null>"]){
                        if(self.opDataDo.closeDate!=nil && ![self.opDataDo.closeDate isEqual:@""] && ![self.opDataDo.closeDate isKindOfClass:[NSNull class]] &&![self.opDataDo.closeDate isEqualToString:@"<null>"]){
                                [infoDict setObject:self.opDataDo.title forKey:@"Subject"];
                                //        [infoDict setObject:self.opDataDo.stage forKey:@"What.Name"]; // oppp
                                //        [infoDict setObject:self.opDataDo.companyName forKey:@"Who.Name"]; //contact
                                [infoDict setObject:self.opDataDo.closeDate forKey:@"ActivityDate"];
                         
                            if([Utilities objectIsNull:self.opDataDo.whoid]){
                                [infoDict setObject:@"" forKey:@"WhoId"];
                            }else{
                                [infoDict setObject:self.opDataDo.whoid forKey:@"WhoId"];

                               /* NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
                                [dict1 setObject:@"" forKey:@"WhoId"];
                                if(![Utilities objectIsNull:dict1]){
                                    [infoDict setObject:dict1 forKey:@"WhoId"];
                                }else{
                                    [infoDict setObject:@"" forKey:@"WhoId"];
                                }*/
                            }
                            // opp
                            if([Utilities objectIsNull:self.opDataDo.whatId]){
                                [infoDict setObject:@"" forKey:@"WhatId"];

                            }else{
                                [infoDict setObject:self.opDataDo.whatId forKey:@"WhatId"];

                               /* NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
                                [dict2 setObject:@"" forKey:@"WhatId"];
                                if(![Utilities objectIsNull:dict2]){
                                    [infoDict setObject:dict2 forKey:@"WhatId"];
                                    
                                }else{
                                    [infoDict setObject:@"" forKey:@"WhatId"];
                                }*/
                            }
                            // product
                            /*if([Utilities objectIsNull:self.opDataDo.productId]){
                                [infoDict setObject:@"" forKey:@"Product__c"];
                            }else{
                                [infoDict setObject:self.opDataDo.productId forKey:@"Product__c"];
                            }*/
                            // desc
                            if([Utilities objectIsNull:self.opDataDo.nextStep]){
                                [infoDict setObject:@"" forKey:@"Description"];
                            }else{
                                [infoDict setObject:self.opDataDo.nextStep forKey:@"Description"];
                            }
                            [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
                            SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Task" fields:infoDict];
                            [[SFRestAPI sharedInstance] send:request delegate:self];
                        }else{
                            [self.util showAlert:@"Due date cannot be empty" title:@""];
                        }
                    /*}else{
                        [self.util showAlert:@"Product cannot be empty" title:@""];
                    }*/
                }else{
                    [self.util showAlert:@"Opportunity cannot be empty" title:@""];
                }
            }else{
                [self.util showAlert:@"Contact cannot be empty" title:@""];
            }
        }else{
            [self.util showAlert:@"Title cannot be empty" title:@""];
        }

        
    }

}
// showRelatedVC
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if(indexPath.section ==0){
            if(indexPath.row ==2){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RelatedToViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showRelatedVC"];
                oppVC.relatedTypeIs =@"Contact";
                oppVC.selectedTypeFromCreate = @"Event";
                oppVC.delegate = self;
                oppVC.colorType = @"Event";
                [self.navigationController pushViewController:oppVC animated:YES];
            }else if(indexPath.row == 3){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RelatedToViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showRelatedVC"];
                oppVC.relatedTypeIs =@"RelatedTo";
                oppVC.selectedTypeFromCreate = @"Event";
                oppVC.delegate = self;
                oppVC.colorType = @"Event";
                [self.navigationController pushViewController:oppVC animated:YES];
            }
            else if(indexPath.row == 4){ // Products
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RelatedToViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showRelatedVC"];
                oppVC.relatedTypeIs =@"Product";
                oppVC.selectedTypeFromCreate = @"Product";
                oppVC.delegate = self;
                oppVC.colorType = @"Event";
                [self.navigationController pushViewController:oppVC animated:YES];
            }
        }else{
        }
    }else{
        if(indexPath.section ==0){
            if(indexPath.row ==2){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RelatedToViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showRelatedVC"];
                oppVC.relatedTypeIs =@"Contact";
                oppVC.selectedTypeFromCreate = @"Task";
                oppVC.colorType = @"Task";
                oppVC.delegate = self;
                [self.navigationController pushViewController:oppVC animated:YES];
            }else if(indexPath.row == 3){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RelatedToViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showRelatedVC"];
                oppVC.relatedTypeIs =@"RelatedTo";
                oppVC.selectedTypeFromCreate = @"Task";
                oppVC.colorType = @"Task";
                oppVC.delegate = self;
                [self.navigationController pushViewController:oppVC animated:YES];
            }
            else if(indexPath.row == 4){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RelatedToViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showRelatedVC"];
                oppVC.relatedTypeIs =@"Product";
                oppVC.selectedTypeFromCreate = @"Product";
                oppVC.colorType = @"Task";
                oppVC.delegate = self;
                [self.navigationController pushViewController:oppVC animated:YES];
            }
        }else{
        }
    }
}
-(void)selectedRelated:(NSDictionary *)customer :(NSString *)typeIS{
    [self.navigationController popViewControllerAnimated:YES];
    self.opDataDo.stage = [customer objectForKey:@"Name"];
    self.opDataDo.whatId = [customer objectForKey:@"Id"];
    [self.tableview reloadData];
}
-(void)selectedContact:(NSDictionary *)contact :(NSString *)typeIS{
    [self.navigationController popViewControllerAnimated:YES];
    self.opDataDo.whoid = [contact objectForKey:@"Id"]; //contact
    self.opDataDo.companyName = [contact objectForKey:@"Name"];
    [self.tableview reloadData];
}
-(void)selectedProducts:(NSDictionary *)product :(NSString *)typeIS{
    [self.navigationController popViewControllerAnimated:YES];
    self.opDataDo.productId = [product objectForKey:@"Id"]; //contact
    self.opDataDo.productName = [product objectForKey:@"Name"];
    [self.tableview reloadData];

}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if (textView.tag == 1007) {
            NSIndexPath *index=[NSIndexPath indexPathForRow:7 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [textView becomeFirstResponder];

    }else{
        if (textView.tag == 1007) {
            NSIndexPath *index=[NSIndexPath indexPathForRow:6 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [textView becomeFirstResponder];

    }
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.tableview.contentInset = contentInsets;
    [textView resignFirstResponder];
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if (textView.tag==1007) {
            self.opDataDo.nextStep=textView.text;
        }else{
            
        }

    }else{
        if (textView.tag==1007) {
            self.opDataDo.nextStep=textView.text;
        }else{
            
        }

    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    BOOL hasNewLineCharacterTyped = (text.length == 1) && [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location != NSNotFound;
    if (hasNewLineCharacterTyped) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (NSString *)updateEventDateFormat:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    // [dateFormatter setLocale:enUSPOSIXLocale];
    // [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss'Z'"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"]; // dd MMM yyyy hh:mm
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSString *userVisibleDateTimeString;
    if (date != nil) { // yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd'" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
