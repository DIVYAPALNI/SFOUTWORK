//
//  EventDetailsViewController.m
//  SampleSalesForce
//
//  Created by Apple on 10/31/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "TextFieldCell.h"
#import "EventDateView.h"
#import "SubmitButtonCell.h"
#import "LabelSwitchCell.h"
#import "TextViewCell.h"

@interface EventDetailsViewController ()<UITextFieldDelegate,EventDateViewDelegate,SubmitButtonDelegate,ToggleSwitchDelegate,UITextViewDelegate>

@end

@implementation EventDetailsViewController
@synthesize activeField;
@synthesize keyboardOpen;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Details";
    self.selectedSegmentType = @"Feeds";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    self.opDataDo = [[OppDataDO alloc] init];
    if (self.editMode) {
        self.enableFields=TRUE;
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.enableFields=FALSE;
       // self.navigationItem.rightBarButtonItem = nil;

    }
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:3.0/255.0 green:35.0/255.0 blue:102.0/255.0 alpha:1]];
   // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0/255.0 green:107.0/255.0 blue:241.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0/255.0 green:107.0/255.0 blue:241.0/255.0 alpha:1]];

    self.pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-170-44-64, self.view.bounds.size.width, 44)];
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
    self.opDataDo.recordId = self.recordObjectId;
    ateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                target:self
                                              selector:@selector(rotateMove)
                                              userInfo:nil
                                               repeats:YES];

}
-(void)rotateMove{
    [SVProgressHUD dismiss];
}
- (IBAction)back:(id)sender {
   // [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:TRUE];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)keyboardDidShow:(NSNotification *)sender {
    if (self.pickerOpen) {
        [self.datePickerview setHidden:TRUE];
        [self.pickerToolBar setHidden:TRUE];
        [self.pickerViewObj setHidden:TRUE];
        self.pickerOpen=FALSE;
        self.tableview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.tableview.frame.size.height+250);
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    /*  if (self.enableFields) {
     if (self.enableFields) {
     return 2;
     }else{
     return 1;
     }
     }else{
     if (self.enableFields) {
     return 1;
     }else{
     return 0;
     
     }
     }*/
    if (self.enableFields) {
        return 2;
    }else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        //return 6;
        if (self.enableFields) {
            if([self.selectedTypeIs isEqualToString:@"Event"]){
                return 5;

            }else{
                return 4;
            }
        }else{
            if([self.selectedTypeIs isEqualToString:@"Event"]){
                return 5;
            }else{
                return 4;
            }
        }
        
    }else{
        //return 1;
        if (self.enableFields) {
            return 1;
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //   NSDictionary *obj = self.infoArray[indexPath.row];
    //     StartDateTime = "2017-10-29T15:00:00.000+0000";

    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if(indexPath.section == 0){
            if (indexPath.row==0) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
//
//                [cell.displayIcon.layer setCornerRadius:30.0f];
//                [cell.displayIcon.layer setBorderWidth:3.0f];
//                [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
                
                [cell.displayIcon.layer setCornerRadius:30.0f];
                [cell.displayIcon.layer setBorderWidth:3.0f];
                [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
                [cell.displayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Profile_Small.png"]]];
                [cell.displayIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                NSString *dispIconStr =[[self.infoArray  valueForKey:@"Who"] valueForKey:@"Name"];
                if (dispIconStr!=nil && ![dispIconStr isKindOfClass:[NSNull class]] &&![dispIconStr isEqualToString:@"<null>"]) {
                    NSString *str = [[dispIconStr substringToIndex:1] uppercaseString];
                    [cell.displayIcon setTitle:str forState:UIControlStateNormal];
                }else{
                    [cell.displayIcon setTitle:@"O" forState:UIControlStateNormal];
                }


                self.opDataDo.title =[self.infoArray  valueForKey:@"Subject"];
                if (self.opDataDo.title!=nil && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]) {
                    [cell.titleName setText:self.opDataDo.title];
                }else{
                    [cell.titleName setText:@""];
                }
                
                self.opDataDo.statusMsg =[[self.infoArray  valueForKey:@"What"] valueForKey:@"Name"];
                if (self.opDataDo.statusMsg!=nil && ![self.opDataDo.statusMsg isKindOfClass:[NSNull class]] &&![self.opDataDo.statusMsg isEqualToString:@"<null>"]) {
                    [cell.AccName setText:[NSString stringWithFormat:@"%@",self.opDataDo.statusMsg]];
                }else{
                    [cell.AccName setText:@""];
                }
                
                NSString*createdDateIS = [self fullDate:[self.infoArray  valueForKey:@"StartDateTime"]];
                self.opDataDo.createdDate =createdDateIS ;
                if (self.opDataDo.createdDate!=nil && ![self.opDataDo.createdDate isKindOfClass:[NSNull class]] &&![self.opDataDo.createdDate isEqualToString:@"<null>"]) {
                    [cell.CreatedDate setText:[NSString stringWithFormat:@"Created Date: %@",self.opDataDo.createdDate]];
                }else{
                    [cell.CreatedDate setText:@""];
                }
                self.opDataDo.ownerName =[[self.infoArray  valueForKey:@"Who"] valueForKey:@"Name"];
                if (self.opDataDo.ownerName!=nil && ![self.opDataDo.ownerName isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]) {
                    [cell.ownedByName setText:[NSString stringWithFormat:@"Ownername: %@",self.opDataDo.ownerName]];
                }else{
                    [cell.ownedByName setText:@"NA"];
                }
                
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                }
                NSString *whatTypeIS = [[self.infoArray  valueForKey:@"What"] valueForKey:@"Type"];
                if (whatTypeIS!=nil && ![whatTypeIS isKindOfClass:[NSNull class]] &&![whatTypeIS isEqualToString:@"<null>"]) {
                    [cell.textfieldTitle setText:[NSString stringWithFormat:@"%@",whatTypeIS]];
                }else{
                    [cell.textfieldTitle setText:@""];
                }

                return cell;
            }else if (indexPath.row==1){
                // Event Start Date
                EventDateView *cell=[tableView dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setIndex:indexPath];
                [cell setDelegate:self];
                [cell.headerlabel setText:@"StartDate"];

                if (self.enableFields) {
                    [cell.eventDateButton setHidden:FALSE];
                    [cell.eventDateButton setEnabled:TRUE];
                    [cell.eventDate setEnabled:TRUE];
                    if (self.opDataDo.startDate!=nil && ![self.opDataDo.startDate isKindOfClass:[NSNull class]] &&![self.opDataDo.startDate isEqualToString:@"<null>"]) {
                        [cell.eventDate setText:self.opDataDo.startDate];
                    }else{
                        [cell.eventDate setText:@""];
                    }
                    
                }else{
                    [cell.eventDateButton setHidden:TRUE];
                    [cell.eventDateButton setEnabled:FALSE];
                    [cell.eventDate setEnabled:FALSE];
                    NSString*createdDateIS = [self fullDate:[self.infoArray  valueForKey:@"StartDateTime"]];
                    self.opDataDo.startDate =createdDateIS ;
                    if (self.opDataDo.startDate!=nil && ![self.opDataDo.startDate isKindOfClass:[NSNull class]] &&![self.opDataDo.startDate isEqualToString:@"<null>"]) {
                        [cell.eventDate setText:self.opDataDo.startDate];
                    }else{
                        [cell.eventDate setText:@""];
                    }
                    
                }
                return cell;
              }
            else if (indexPath.row==2){
                // Event End Date
                EventDateView *cell=[tableView dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier1" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setIndex:indexPath];
                [cell setDelegate:self];
                [cell.headerlabel setText:@"EndDate"];
                if (self.enableFields) {
                    [cell.eventDateButton setHidden:FALSE];
                    [cell.eventDateButton setEnabled:TRUE];
                    [cell.eventDate setEnabled:TRUE];
                    if (self.opDataDo.endDate!=nil && ![self.opDataDo.endDate isKindOfClass:[NSNull class]] &&![self.opDataDo.endDate isEqualToString:@"<null>"]) {
                        [cell.eventDate setText:self.opDataDo.endDate];
                    }else{
                        [cell.eventDate setText:@""];
                    }
                }else{
                    [cell.eventDateButton setHidden:TRUE];
                    [cell.eventDateButton setEnabled:FALSE];
                    [cell.eventDate setEnabled:FALSE];
                    NSString*closeDateIS = [self fullDate:[self.infoArray  valueForKey:@"EndDateTime"]];
                    self.opDataDo.endDate =closeDateIS ;
                    if (self.opDataDo.endDate!=nil && ![self.opDataDo.endDate isKindOfClass:[NSNull class]] &&![self.opDataDo.endDate isEqualToString:@"<null>"]) {
                        [cell.eventDate setText:self.opDataDo.endDate];
                    }else{
                        [cell.eventDate setText:@""];
                    }
                }
                return cell;
            }else if (indexPath.row==3) {
                // Event Type
                LabelSwitchCell *cell =nil;
                static NSString *rowIdentifier = @"OptionCellIdentifier1";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier];
                [cell setDelegate:self];
                [cell setIndexpath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.fieldTitle setText:@"Type"];

                if (self.enableFields) {
                    [cell.toggleButton setHidden:FALSE];
                    [cell.toggleButton setTag:1001];
                    
                    // self.opDataDo.stage =[self.infoArray  valueForKey:@"StageName"];
                    if (self.opDataDo.stage!=nil && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]) {
                        [cell.fieldContent setText:self.opDataDo.stage];
                    }else{
                        [cell.fieldContent setText:@""];
                    }
                }else{
                    [cell.toggleButton setHidden:TRUE];
                    [cell.toggleButton setTag:1001];
                    self.opDataDo.stage =[self.infoArray  valueForKey:@"Type"];
                    if (self.opDataDo.stage!=nil && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]) {
                        [cell.fieldContent setText:self.opDataDo.stage];
                    }else{
                        [cell.fieldContent setText:@""];
                    }
                    
                }
                
                return cell;
            }
            else if (indexPath.row==4) {
                //Event Description
              /*  TextViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TextViewCellIdentifier"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textview setDelegate:self];
                [cell.textview setKeyboardType:UIKeyboardTypeDefault];
                [cell.textview setTag:1003];
                [cell.textViewtitle setText:@"Description"]; //Description
                if (self.enableFields) {
                    [cell.textview setEditable:TRUE];
                    //self.opDataDo.title =[self.infoArray  valueForKey:@"Description"];
                    if (self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]) {
                        [cell.textview setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textview setText:@""];
                    }
                }else{
                    [cell.textview setEditable:FALSE];
                    self.opDataDo.nextStep =[self.infoArray  valueForKey:@"Description"];
                    if (self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]) {
                        [cell.textview setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textview setText:@""];
                    }
                    
                }
                // TextFieldCellIdentifier2
                return cell;*/
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier2";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                //                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1002];
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
                    self.opDataDo.nextStep =[self.infoArray  valueForKey:@"Description"];
                    if(self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textfield setText:@""];
                    }
                    
                }
                return cell;
        }
        }
    else if (indexPath.section==1) {
            static NSString *CellIdentifier= @"SubmitCellIdentifier";
            SubmitButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell setDelegate:self];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            return nil;
    }else{ // Task
        if(indexPath.section == 0){
            if (indexPath.row==0) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                
                self.opDataDo.title =[self.infoArray  valueForKey:@"Subject"];
                if (self.opDataDo.title!=nil && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]) {
                    [cell.titleName setText:self.opDataDo.title];
                }else{
                    [cell.titleName setText:@""];
                }
                [cell.displayIcon.layer setCornerRadius:30.0f];
                [cell.displayIcon.layer setBorderWidth:3.0f];
                [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
//                [cell.displayIcon setTitle:[[[[self.infoArray  valueForKey:@"Who"] valueForKey:@"Name"] substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
                NSString *dispIconStr =[[self.infoArray  valueForKey:@"Who"] valueForKey:@"Name"];
                if (dispIconStr!=nil && ![dispIconStr isKindOfClass:[NSNull class]] &&![dispIconStr isEqualToString:@"<null>"]) {
                    NSString *str = [[dispIconStr substringToIndex:1] uppercaseString];
                    [cell.displayIcon setTitle:str forState:UIControlStateNormal];
                }else{
                    [cell.displayIcon setTitle:@"O" forState:UIControlStateNormal];
                }

                self.opDataDo.statusMsg =[[self.infoArray  valueForKey:@"What"] valueForKey:@"Name"];
                if (self.opDataDo.statusMsg!=nil && ![self.opDataDo.statusMsg isKindOfClass:[NSNull class]] &&![self.opDataDo.statusMsg isEqualToString:@"<null>"]) {
                    [cell.AccName setText:[NSString stringWithFormat:@"%@",self.opDataDo.statusMsg]];
                }else{
                    [cell.AccName setText:@""];
                }
                
                NSString*createdDateIS = [self.infoArray  valueForKey:@"ActivityDate"];
                self.opDataDo.createdDate =createdDateIS ;
                if (self.opDataDo.createdDate!=nil && ![self.opDataDo.createdDate isKindOfClass:[NSNull class]] &&![self.opDataDo.createdDate isEqualToString:@"<null>"]) {
                    [cell.CreatedDate setText:[NSString stringWithFormat:@"Created Date: %@",self.opDataDo.createdDate]];
                }else{
                    [cell.CreatedDate setText:@"NA"];
                }
                self.opDataDo.ownerName =[[self.infoArray  valueForKey:@"Who"] valueForKey:@"Name"];
                if (self.opDataDo.ownerName!=nil && ![self.opDataDo.ownerName isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]) {
                    [cell.ownedByName setText:[NSString stringWithFormat:@"Ownername:%@",self.opDataDo.ownerName]];
                }else{
                    [cell.ownedByName setText:@"NA"];
                }
                
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                }
                return cell;
            }else if (indexPath.row==1){
                EventDateView *cell=[tableView dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setIndex:indexPath];
                [cell setDelegate:self];
                [cell.headerlabel setText:@"Close Date"];

                if (self.enableFields) {
                    [cell.eventDateButton setHidden:FALSE];
                    [cell.eventDateButton setEnabled:TRUE];
                    [cell.eventDate setEnabled:TRUE];
                    if (self.opDataDo.closeDate!=nil && [self.opDataDo.closeDate length]>0) {
                        [cell.eventDate setText:self.opDataDo.closeDate];
                    }else{
                        [cell.eventDate setText:@"NA"];
                    }
                    
                }else{
                    [cell.eventDateButton setHidden:TRUE];
                    [cell.eventDateButton setEnabled:FALSE];
                    [cell.eventDate setEnabled:FALSE];
                    // self.opDataDo.closeDate =[self.infoArray valueForKey:@"DueDate"];
                    NSString*createdDateIS = [self.infoArray  valueForKey:@"ActivityDate"]; // ActivityDate
                    self.opDataDo.closeDate =createdDateIS ;
                    if (self.opDataDo.closeDate!=nil && ![self.opDataDo.closeDate isKindOfClass:[NSNull class]] &&![self.opDataDo.closeDate isEqualToString:@"<null>"]) {
                        [cell.eventDate setText:self.opDataDo.closeDate];
                    }else{
                        [cell.eventDate setText:@""];
                    }
                }
                return cell;
            }else if (indexPath.row==2) {
                LabelSwitchCell *cell =nil;
                static NSString *rowIdentifier = @"OptionCellIdentifier1";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier];
                [cell setDelegate:self];
                [cell setIndexpath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                if (self.enableFields) {
                    [cell.toggleButton setHidden:FALSE];
                    [cell.toggleButton setTag:1001];
                    
                    [cell.fieldTitle setText:@"Status"];
                    // self.opDataDo.stage =[self.infoArray  valueForKey:@"StageName"];
                    if (self.opDataDo.stage!=nil && [self.opDataDo.stage length]>0) {
                        [cell.fieldContent setText:self.opDataDo.stage];
                    }else{
                        [cell.fieldContent setText:@""];
                    }
                }else{
                    [cell.toggleButton setHidden:TRUE];
                    [cell.toggleButton setTag:1001];
                    [cell.fieldTitle setText:@"Status"];
                    self.opDataDo.stage =[self.infoArray  valueForKey:@"Status"];
                    if (self.opDataDo.stage!=nil && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]) {
                        [cell.fieldContent setText:self.opDataDo.stage];
                    }else{
                        [cell.fieldContent setText:@""];
                    }
                }
                return cell;
            }
            else if (indexPath.row==3) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier2";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setTag:1002];
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
                    self.opDataDo.nextStep =[self.infoArray  valueForKey:@"Description"];
                    if(self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isKindOfClass:[NSNull class]] &&![self.opDataDo.nextStep isEqualToString:@"<null>"]){
                        [cell.textfield setText:self.opDataDo.nextStep];
                    }else{
                        [cell.textfield setText:@""];
                    }
                    
                }
                return cell;

                return cell;
            }
            
        }else if (indexPath.section==1) {
            static NSString *CellIdentifier= @"SubmitCellIdentifier";
            SubmitButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell setDelegate:self];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }

    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0){
        if(indexPath.row == 0){
            return 165;
        }else if(indexPath.row==3){
            if([self.selectedTypeIs isEqualToString:@"Event"]){
                if (self.opDataDo.stage!=nil && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]) {
                    return 75;
                }else{
                    return 0;
                }

            }else{
                if (self.opDataDo.stage!=nil && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]) {
                    return 75;
                }else{
                    return 0;
                }

            }
        }else {
            return 75;
        }
    }else {
        return 75;
    }
}
-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0:{
            self.selectedSegmentType = @"Feeds";
        }
        break;
        case 1:{
            self.selectedSegmentType = @"Details";
        }
        break;
        case 2:{
            self.selectedSegmentType = @"Related To";
        }
        break;
        default:
        break;
    }
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.frame.size.width, 25)];
    [headerView setBackgroundColor:[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f]];
    
    return headerView;
}

-(void)opendatepicker:(NSIndexPath*)index{
    [self.view endEditing:TRUE];
    self.datePickerview.minimumDate=nil;
    self.datePickerview.maximumDate=nil;
    if (index.row==1) {
        self.selectedPicker=4001;
        self.datePickerview.minimumDate=[NSDate date];
        NSIndexPath *index1=[NSIndexPath indexPathForRow:1 inSection:0];
        if (!keyboardOpen && !self.pickerOpen) {
            self.tableview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.tableview.frame.size.height-250);
        }
        
        [self.tableview scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.datePickerview setDate:[NSDate date]];
        [self.datePickerview setHidden:FALSE];
        [self.pickerToolBar setHidden:FALSE];
        self.pickerOpen=TRUE;

    }
    if (index.row==2) {
        self.selectedPicker=4002;
        self.datePickerview.minimumDate=[NSDate date];
        NSIndexPath *index1=[NSIndexPath indexPathForRow:2 inSection:0];
        if (!keyboardOpen && !self.pickerOpen) {
            self.tableview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.tableview.frame.size.height-250);
        }
        
        [self.tableview scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.datePickerview setDate:[NSDate date]];
        [self.datePickerview setHidden:FALSE];
        [self.pickerToolBar setHidden:FALSE];
        self.pickerOpen=TRUE;

    }
}
-(void)changeToggleState:(BOOL)state index:(NSIndexPath *)index{
    [self.view endEditing:TRUE];
    [self.pickerToolBar setHidden:FALSE];
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if (index.section==0) {
            if (index.row==3) {  // speciality // Praticetype // Classification
                self.selectedPicker=1001;
                self.pickerArray = [[NSArray alloc] initWithObjects:@"Call",@"Email",@"Meeting",@"Send Letter/Quote",@"Other",nil];
                [self.pickerViewObj reloadAllComponents];
                
            }else if (index.row==3){
                self.selectedPicker=1002;
                self.pickerArray = [[NSArray alloc] initWithObjects:@"20",@"40",@"60",@"80",nil];
                [self.pickerViewObj reloadAllComponents];
            }
            
            [self.pickerViewObj reloadAllComponents];
            if ([self.pickerViewObj isHidden] && [self.datePickerview isHidden]) {
                self.tableview.frame=CGRectMake(0, self.tableview.frame.origin.y, self.tableview.frame.size.width, self.tableview.frame.size.height-250);
                [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }else{
        if (index.section==0) {
            if (index.row==2) {  // speciality // Praticetype // Classification
                self.selectedPicker=1001;
                self.pickerArray = [[NSArray alloc] initWithObjects:@"Open",@"Close",@"Pending",@"Inprogress",nil];
                [self.pickerViewObj reloadAllComponents];
                
            }else if (index.row==3){
                self.selectedPicker=1002;
                self.pickerArray = [[NSArray alloc] initWithObjects:@"20",@"40",@"60",@"80",nil];
                [self.pickerViewObj reloadAllComponents];
            }
            
            [self.pickerViewObj reloadAllComponents];
            if ([self.pickerViewObj isHidden] && [self.datePickerview isHidden]) {
                self.tableview.frame=CGRectMake(0, self.tableview.frame.origin.y, self.tableview.frame.size.width, self.tableview.frame.size.height-250);
                [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }

    [self.pickerViewObj selectRow:0 inComponent:0 animated:FALSE];
    [self.datePickerview setHidden:TRUE];
    [self.pickerViewObj setHidden:FALSE];
    self.pickerOpen=TRUE;
}

- (void)datePickerChanged:(UIDatePicker *)datePicker1
{
    datePicker1.minimumDate=nil;
    datePicker1.maximumDate=nil;
    if (self.selectedPicker==4001) {
        datePicker1.minimumDate=[NSDate date];
    }
    if (self.selectedPicker==4002) {
        datePicker1.minimumDate=[NSDate date];
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
    
    self.tableview.frame=CGRectMake(0, self.tableview.frame.origin.y, self.tableview.frame.size.width, self.tableview.frame.size.height+250);
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if (self.selectedPicker==4001) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];// MM/dd/yyyy hh:mm:ss a
            NSString *strDate = [dateFormatter stringFromDate:self.datePickerview.date];
            
            NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:1];
            EventDateView *cell=[self.tableview cellForRowAtIndexPath:index];
            [cell.eventDate setText:strDate];
            [self.opDataDo setStartDate:strDate];
            
        } else if (self.selectedPicker==4002) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];// MM/dd/yyyy hh:mm:ss a
            NSString *strDate = [dateFormatter stringFromDate:self.datePickerview.date];
            
            NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:1];
            EventDateView *cell=[self.tableview cellForRowAtIndexPath:index];
            [cell.eventDate setText:strDate];
            [self.opDataDo setEndDate:strDate];
            
        }else if(self.selectedPicker==1001){
            self.opDataDo.stage=[self.pickerArray objectAtIndex:self.seletedPickerRow];
        }else if(self.selectedPicker==1002){
            self.opDataDo.probability=[self.pickerArray objectAtIndex:self.seletedPickerRow];
        }
    }else{
        if (self.selectedPicker==4001) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];// MM/dd/yyyy hh:mm:ss a
            NSString *strDate = [dateFormatter stringFromDate:self.datePickerview.date];
            
            NSIndexPath *index=[NSIndexPath indexPathForRow:3 inSection:1];
            EventDateView *cell=[self.tableview cellForRowAtIndexPath:index];
            [cell.eventDate setText:strDate];
            [self.opDataDo setCloseDate:strDate];
            
        }else if(self.selectedPicker==1001){
            self.opDataDo.stage=[self.pickerArray objectAtIndex:self.seletedPickerRow];
        }else if(self.selectedPicker==1002){
            self.opDataDo.probability=[self.pickerArray objectAtIndex:self.seletedPickerRow];
        }

    }
    self.pickerOpen=FALSE;
    self.seletedPickerRow=0;
    [self.tableview reloadData];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSInteger nextTag = activeField.tag + 1;
    UIResponder* nextResponder = [self.tableview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [self.activeField resignFirstResponder];
    }
    
    return FALSE;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    BOOL hasNewLineCharacterTyped = (text.length == 1) && [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location != NSNotFound;
    if (hasNewLineCharacterTyped) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.tableview.contentInset = contentInsets;
    [textView resignFirstResponder];
    if (textView.tag==1003) {
        self.opDataDo.nextStep=textView.text;
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.activeField=textField;
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        if (self.activeField.tag==1000) {
        }else if (self.activeField.tag == 1001){
            NSIndexPath *index=[NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1002){
            NSIndexPath *index=[NSIndexPath indexPathForRow:4 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if(self.activeField.tag>=4001){
            NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else if(self.activeField.tag>=4002){
            NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }

    }else{
        if (self.activeField.tag==1000) {
        }else if (self.activeField.tag == 1001){
            NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1002){
            NSIndexPath *index=[NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if(self.activeField.tag>=4001){
            NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 1001:
            self.opDataDo.stage=textField.text;
            break;
            case 1002:
            self.opDataDo.nextStep = textField.text;
            break;
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return  [self.pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    if (self.selectedPicker==1001) {
        return self.pickerArray[row];;
    }else if(self.selectedPicker == 1002){
        return self.pickerArray[row];
        
    }else{
        return self.pickerArray[row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 44.0f;
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    self.seletedPickerRow=row;
}

-(CGSize)sizeOfMultiLineLabel:(NSString*)text font:(UIFont*)font {
    
    //Width of the Label
    CGFloat aLabelSizeWidth = self.tableview.frame.size.width-40;
    
    return [text boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{
                                        NSFontAttributeName : font
                                        }
                              context:nil].size;
}
-(IBAction)editBtnTapped:(id)sender{
    /* if (self.showEditButton) {
     SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT name,StageName,Probability,Owner.Name, Account.Name, CloseDate, Amount FROM opportunity WHERE stagename NOT IN ('Closed Won', 'Closed Lost')"]; // LIMIT 20
     [[SFRestAPI sharedInstance] send:request delegate:self];
     }else{
     
     }*/
    if (!self.enableFields) {
        self.enableFields=TRUE;
        [self.editButton setEnabled:FALSE];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [self.tableview reloadData];
    }
}
- (void)send:(SFRestRequest *)request delegate:(nullable id<SFRestDelegate>)delegate{
    // showDetailsVC
}

#pragma mark - SFRestDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    if(jsonResponse !=nil && ![jsonResponse isEqual:@""] && [jsonResponse isEqual:@"<>"]){
        NSArray *records = jsonResponse[@"records"];
        NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
        //self.dataRows = [records mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
           // [self.navigationController popViewControllerAnimated:YES];
            if([self.selectedTypeIs isEqualToString:@"Event"]){
                [self dismissViewControllerAnimated:YES completion:nil];
                if([self.selcted_calendar_List_Delegate respondsToSelector:@selector(selectedCalendarEventVc:)]) {
                    [self.selcted_calendar_List_Delegate selectedCalendarEventVc:@"EventEdit"];
                }
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
                if([self.selcted_calendar_List_Delegate respondsToSelector:@selector(selectedCalendarTaskVc:)]) {
                    [self.selcted_calendar_List_Delegate selectedCalendarTaskVc:@"TaskEdit"];
                }
            }
            [self.tableview reloadData];
        });
    }else{
       // [self.navigationController popViewControllerAnimated:YES];
       // [self dismissViewControllerAnimated:YES completion:nil];
        if([self.selectedTypeIs isEqualToString:@"Event"]){
            [self dismissViewControllerAnimated:YES completion:nil];
            if([self.selcted_calendar_List_Delegate respondsToSelector:@selector(selectedCalendarEventVc:)]) {
                [self.selcted_calendar_List_Delegate selectedCalendarEventVc:@"EventEdit"];
            }
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
            if([self.selcted_calendar_List_Delegate respondsToSelector:@selector(selectedCalendarTaskVc:)]) {
                [self.selcted_calendar_List_Delegate selectedCalendarTaskVc:@"TaskEdit"];
            }
        }

    }
}
- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}
- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}

-(void)submitData{
    //    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT StageName,Probability,CloseDate, Amount, NextStep FROM opportunity WHERE stagename NOT IN ('Closed Won', 'Closed Lost')"]; // LIMIT 20
    
    // NSString *reqStr = [NSString stringWithFormat:@"SELECT StageName,Probability,CloseDate, Amount, NextStep FROM opportunity WHERE  StageName = NOT IN ('Closed Won', 'Closed Lost')"];
    if([self.selectedTypeIs isEqualToString:@"Event"]){
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
        NSString *startStr = [self updateEventDateFormat:self.opDataDo.startDate];
        NSString *endStr = [self updateEventDateFormat:self.opDataDo.endDate];
        [infoDict setObject:startStr forKey:@"StartDateTime"]; // 2017-11-14T07:00:00.000+0000
        [infoDict setObject:endStr forKey:@"EndDateTime"]; // "2017-11-14T08:00:00.000+0000"
        [infoDict setObject:self.opDataDo.stage forKey:@"Type"];
        [infoDict setObject:self.opDataDo.nextStep forKey:@"Description"];
        
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Event" objectId:self.recordObjectId fields:infoDict];
        [[SFRestAPI sharedInstance] send:request delegate:self];

    }else{
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
        [infoDict setObject:self.opDataDo.closeDate forKey:@"ActivityDate"];
        [infoDict setObject:self.opDataDo.stage forKey:@"Status"];
        [infoDict setObject:self.opDataDo.nextStep forKey:@"Description"];
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Task" objectId:self.recordObjectId fields:infoDict];
        [[SFRestAPI sharedInstance] send:request delegate:self];

    }
    
}
- (NSString *)updateTaskDateFormat:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
   // [dateFormatter setLocale:enUSPOSIXLocale];
    // [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss'Z'"];
    // Dec 11, 2017, 5:33 AM

    [dateFormatter setDateFormat:@"MMM dd, yyyy, hh:mm a"]; // dd MMM yyyy hh:mm
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSString *userVisibleDateTimeString;
    if (date != nil) { // yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd'" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}
- (NSString *)updateEventDateFormat:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    // [dateFormatter setLocale:enUSPOSIXLocale];
    // [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss'Z'"];
    //
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"]; // dd MMM yyyy hh:mm
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSString *userVisibleDateTimeString;
    if (date != nil) { // yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd'" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       // [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}


@end
