//
//  OpportunityDetailsViewController.m
//  SampleSalesForce
//
//  Created by Apple on 10/30/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "OpportunityDetailsViewController.h"
#import "TextFieldCell.h"
#import "EventDateView.h"
#import "SubmitButtonCell.h"
#import "LabelSwitchCell.h"
#import "ChatViewController.h"

@interface OpportunityDetailsViewController ()<UITextFieldDelegate,EventDateViewDelegate,SubmitButtonDelegate,ToggleSwitchDelegate>

@end

@implementation OpportunityDetailsViewController
@synthesize activeField;
@synthesize keyboardOpen;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    self.selectedSegmentType = @"Details";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    self.opDataDo = [[OppDataDO alloc] init];
    self.feedsArray = [[NSMutableArray alloc] init];
    self.notesArray = [[NSMutableArray alloc] init];
    displayArray = [[NSMutableArray alloc] init];
    if (self.editMode) {
        self.enableFields=TRUE;
    }else{
        self.enableFields=FALSE;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:3.0/255.0 green:35.0/255.0 blue:102.0/255.0 alpha:1]];
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
        self.tableview.frame=CGRectMake(10, 10, self.view.frame.size.width-20, self.tableview.frame.size.height+250);
    }
    
    if (!keyboardOpen) {
        self.keyboardOpen=TRUE;
        self.tableview.frame=CGRectMake(10, 10, self.view.frame.size.width-20, self.tableview.frame.size.height-250);
    }
}

- (void)keyboardDidHide:(NSNotification *)sender {
    if (keyboardOpen) {
        self.tableview.frame=CGRectMake(10, 10, self.view.frame.size.width-20, self.tableview.frame.size.height+250);
        keyboardOpen=FALSE;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if([self.selectedSegmentType isEqualToString:@"Details"]){
        if (self.enableFields) {
            return 2;
        }else{
            return 1;
        }
    }else if([self.selectedSegmentType isEqualToString:@"Feeds"]){
        if (self.enableFields) {
            return 3;
        }else{
            return 3;
        }
    }else{
        return 1;

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if([self.selectedSegmentType isEqualToString:@"Details"]){
        if(section == 0){
            //return 6;
            if (self.enableFields) {
                return 7;
            }else{
                return 7;
            }
            
        }else{
            //return 1;
            if (self.enableFields) {
                return 1;
            }else{
                return 0;
            }
        }
    }else if([self.selectedSegmentType isEqualToString:@"Feeds"]){
        if (self.enableFields) {
            if(section ==0){
                return 1;
            }else if(section ==1){
                return 1;
            }else if(section ==2){
                return [self.feedsArray count];
            }
        }else{
            if(section ==0){
                return 1;
            }else if(section ==1){
                return 1;
            }else if(section ==2){
                return [self.feedsArray count];
            }
        }

    }else if([self.selectedSegmentType isEqualToString:@"Note"]){
        if (self.enableFields) {
            if(section ==0){
                return 1;
            }else if(section ==1){
                return 1;
            }else if(section ==2){
                return [self.notesArray count];
            }
        }else{
            if(section ==0){
                return 1;
            }else if(section ==1){
                return 1;
            }else if(section ==2){
                return [self.notesArray count];
            }
        }
        
    }else{
        if (self.enableFields) {
            return 3;
        }else{
            return 3;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if([self.selectedSegmentType isEqualToString:@"Details"]){
        if(indexPath.section == 0){
            if (indexPath.row==0) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                
                [cell.displayIcon.layer setCornerRadius:50.0f];
                [cell.displayIcon.layer setBorderWidth:3.0f];
                [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
                [cell.displayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Profile_BG.png"]]];
                [cell.displayIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.displayIcon setTitle:[[[self.infoArray valueForKey:@"Name"] substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
                self.opDataDo.title =[self.infoArray  valueForKey:@"Name"];
                if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                    [cell.titleName setText:self.opDataDo.title];
                }else{
                    [cell.titleName setText:@""];
                }
                self.opDataDo.statusMsg =[[self.infoArray  valueForKey:@"Account"] valueForKey:@"Name"];
                if(self.opDataDo.statusMsg!=nil && ![self.opDataDo.statusMsg isEqual:@""] && ![self.opDataDo.statusMsg isKindOfClass:[NSNull class]] &&![self.opDataDo.statusMsg isEqualToString:@"<null>"]){
                    [cell.AccName setText:self.opDataDo.statusMsg];
                }else{
                    [cell.AccName setText:@""];
                }
                self.oppCreatedFullDateStr = [self.infoArray  valueForKey:@"CreatedDate"];
                NSString*createdDateIS = [self fullDate:[self.infoArray  valueForKey:@"CreatedDate"]];
                self.opDataDo.createdDate =createdDateIS ;
                if(self.opDataDo.createdDate!=nil && ![self.opDataDo.createdDate isEqual:@""] && ![self.opDataDo.createdDate isKindOfClass:[NSNull class]] &&![self.opDataDo.createdDate isEqualToString:@"<null>"]){
                    [cell.CreatedDate setText:self.opDataDo.createdDate];
                }else{
                    [cell.CreatedDate setText:@""];
                }
                self.opDataDo.ownerName =[[self.infoArray  valueForKey:@"Owner"] valueForKey:@"Name"];
                if(self.opDataDo.ownerName!=nil && ![self.opDataDo.ownerName isEqual:@""] && ![self.opDataDo.ownerName isKindOfClass:[NSNull class]] &&![self.opDataDo.ownerName isEqualToString:@"<null>"]){
                    [cell.ownedByName setText:[NSString stringWithFormat:@"Owner by %@",self.opDataDo.ownerName]];
                }else{
                    [cell.ownedByName setText:@""];
                }
                
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                }
                return cell;
            }else if (indexPath.row==1){
                EventDateView *cell=[tableView dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier12" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setIndex:indexPath];
                [cell setDelegate:self];
                [cell.segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }else if (indexPath.row==2){
                EventDateView *cell=[tableView dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier" forIndexPath:indexPath];
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
                    self.opDataDo.closeDate =[self.infoArray valueForKey:@"CloseDate"];
                    
                    if(self.opDataDo.closeDate!=nil && ![self.opDataDo.closeDate isEqual:@""] && ![self.opDataDo.closeDate isKindOfClass:[NSNull class]] &&![self.opDataDo.closeDate isEqualToString:@"<null>"]){
                        [cell.eventDate setText:self.opDataDo.closeDate];
                    }else{
                        [cell.eventDate setText:@""];
                    }
                    
                }
                [cell.headerlabel setText:@"Close Date"];
                return cell;
            }else if (indexPath.row==3) {
                
                LabelSwitchCell *cell =nil;
                static NSString *rowIdentifier = @"OptionCellIdentifier1";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier];
                [cell setDelegate:self];
                [cell setIndexpath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                if (self.enableFields) {
                    [cell.toggleButton setHidden:FALSE];
                    [cell.toggleButton setTag:1001];
                    
                    [cell.fieldTitle setText:@"Stage"];
                    // self.opDataDo.stage =[self.infoArray  valueForKey:@"StageName"];
                    if(self.opDataDo.stage!=nil && ![self.opDataDo.stage isEqual:@""] && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]){
                        [cell.fieldContent setText:self.opDataDo.stage];
                    }else{
                        [cell.fieldContent setText:@""];
                    }
                }else{
                    [cell.toggleButton setHidden:TRUE];
                    [cell.toggleButton setTag:1001];
                    [cell.fieldTitle setText:@"Stage"];
                    self.opDataDo.stage =[self.infoArray  valueForKey:@"StageName"];
                    if(self.opDataDo.stage!=nil && ![self.opDataDo.stage isEqual:@""] && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]){
                        [cell.fieldContent setText:self.opDataDo.stage];
                    }else{
                        [cell.fieldContent setText:@""];
                    }
                }
                return cell;
            }
            else if (indexPath.row==4) {
                LabelSwitchCell *cell =nil;
                static NSString *rowIdentifier = @"OptionCellIdentifier1";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier];
                [cell setDelegate:self];
                [cell setIndexpath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                if (self.enableFields) {
                    [cell.toggleButton setHidden:FALSE];
                    [cell.toggleButton setTag:1002];
                    NSString *probStr = @"(%)";
                    [cell.fieldTitle setText:[NSString stringWithFormat:@"%@%@",@"Probability",probStr]];
                    //    NSInteger  prob = [[self.infoArray valueForKey:@"Probability"] integerValue];
                    // self.opDataDo.probability = [NSString stringWithFormat:@"%ld",(long)prob];
                    
                    if(self.opDataDo.probability!=nil && ![self.opDataDo.probability isEqual:@""] && ![self.opDataDo.probability isKindOfClass:[NSNull class]] &&![self.opDataDo.probability isEqualToString:@"<null>"]){
                        [cell.fieldContent setText:[NSString stringWithFormat:@"%@",self.opDataDo.probability]];
                    }else{
                        [cell.fieldContent setText:@"0.0"];
                    }
                }else{
                    [cell.toggleButton setHidden:TRUE];
                    [cell.toggleButton setTag:1002];
                    NSString *probStr = @"(%)";
                    [cell.fieldTitle setText:[NSString stringWithFormat:@"%@%@",@"Probability",probStr]];
                    NSInteger  prob = [[self.infoArray valueForKey:@"Probability"] integerValue];
                    self.opDataDo.probability = [NSString stringWithFormat:@"%ld",(long)prob];
                    
                    if (self.opDataDo.probability!=nil && [self.opDataDo.probability length]>0) {
                        [cell.fieldContent setText:[NSString stringWithFormat:@"%@%@",self.opDataDo.probability,@"%"]];
                    }else{
                        [cell.fieldContent setText:@"0.0"];
                    }
                    
                }
                return cell;
                
            }else if (indexPath.row==5) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier1";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1003];
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    NSString *rupee = @"($)";
                    [cell.textfieldTitle setText:[NSString stringWithFormat:@"%@ %@",@"Amount",rupee]];
                    // NSNumber *amount = [self.infoArray valueForKey:@"Amount"];
                    //NSInteger value = [[self.infoArray valueForKey:@"Amount"] integerValue];
                    //self.opDataDo.amount =[NSString stringWithFormat:@"%ld",(long)value];
                    if(self.opDataDo.amount!=nil && ![self.opDataDo.amount isEqual:@""] && ![self.opDataDo.amount isKindOfClass:[NSNull class]] &&![self.opDataDo.amount isEqualToString:@"<null>"]){
                        [cell.textfield setText:[NSString stringWithFormat:@"%@",self.opDataDo.amount]];
                    }else{
                        [cell.textfield setText:@"0.0"];
                    }
                    
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                    NSString *rupee = @"($)";
                    [cell.textfieldTitle setText:[NSString stringWithFormat:@"%@ %@",@"Amount",rupee]];
                    // NSNumber *amount = [self.infoArray valueForKey:@"Amount"];
                    /*NSInteger value = [[self.infoArray valueForKey:@"Amount"] integerValue];
                     self.opDataDo.amount =[NSString stringWithFormat:@"%ld",(long)value];
                     
                     if(self.opDataDo.amount!=nil && ![self.opDataDo.amount isEqual:@""] && ![self.opDataDo.amount isKindOfClass:[NSNull class]] &&![self.opDataDo.amount isEqualToString:@"<null>"]){
                     [cell.textfield setText:[NSString stringWithFormat:@"%@ %@",@"$",self.opDataDo.amount]];
                     }else{
                     [cell.textfield setText:@"0.0"];
                     }*/
                    NSNumber *amount =  [self.infoArray valueForKey:@"Amount"];
                    
                    NSString *value = [NSString stringWithFormat:@"%@",amount];
                    if (value!=nil && ![value isEqual:@"<null>"] && ![value isKindOfClass:[NSNull class]]&& [rupee length]>0 ) {
                        self.opDataDo.amount = value;
                        [cell.textfield setText:[NSString stringWithFormat:@"%@ %@",@"$",self.opDataDo.amount]];
                    }else{
                        [cell.textfield setText:@"$0.0"];
                    }
                    
                    
                }
                return cell;
            }else if (indexPath.row==6) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier2";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1004];
                [cell.textfieldTitle setText:@"Executive summary"];
                //self.opDataDo.nextStep =self.opDataDo.;
                self.opDataDo.nextStep =[self.infoArray valueForKey:@"NextStep"];
                
                if (self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isEqual:@"<null>"] &&![self.opDataDo.nextStep isKindOfClass:[NSNull class]]) {
                    [cell.textfield setText:self.opDataDo.nextStep];
                }else{
                    [cell.textfield setText:@"NA"];
                }
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                }
                return cell;
            }
        }else if (indexPath.section==1) {
            static NSString *CellIdentifier= @"SubmitCellIdentifier";
            SubmitButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell setDelegate:self];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        return nil;

    }else if([self.selectedSegmentType isEqualToString:@"Feeds"]){
        if(indexPath.section == 0){
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                
            [cell.displayIcon.layer setCornerRadius:50.0f];
            [cell.displayIcon.layer setBorderWidth:3.0f];
            [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
            [cell.displayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Profile_BG.png"]]];
            [cell.displayIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.displayIcon setTitle:[[[self.infoArray valueForKey:@"Name"] substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
                self.opDataDo.title = [self.infoArray  valueForKey:@"Name"];
            self.ownerNameStr = [self.infoArray  valueForKey:@"Name"];
            
                if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                    [cell.titleName setText:self.opDataDo.title];
                }else{
                    [cell.titleName setText:@""];
                }
                self.opDataDo.statusMsg =[[self.infoArray  valueForKey:@"Account"] valueForKey:@"Name"];
                if(self.opDataDo.statusMsg!=nil && ![self.opDataDo.statusMsg isEqual:@""] && ![self.opDataDo.statusMsg isKindOfClass:[NSNull class]] &&![self.opDataDo.statusMsg isEqualToString:@"<null>"]){
                    [cell.AccName setText:self.opDataDo.statusMsg];
                }else{
                    [cell.AccName setText:@""];
                }
                
                NSString*createdDateIS = [self fullDate:[self.infoArray  valueForKey:@"CreatedDate"]];
                self.opDataDo.createdDate =createdDateIS ;
                if(self.opDataDo.createdDate!=nil && ![self.opDataDo.createdDate isEqual:@""] && ![self.opDataDo.createdDate isKindOfClass:[NSNull class]] &&![self.opDataDo.createdDate isEqualToString:@"<null>"]){
                    [cell.CreatedDate setText:self.opDataDo.createdDate];
                }else{
                    [cell.CreatedDate setText:@""];
                }
                self.opDataDo.ownerName =[[self.infoArray  valueForKey:@"Owner"] valueForKey:@"Name"];
                if(self.opDataDo.ownerName!=nil && ![self.opDataDo.ownerName isEqual:@""] && ![self.opDataDo.ownerName isKindOfClass:[NSNull class]] &&![self.opDataDo.ownerName isEqualToString:@"<null>"]){
                    [cell.ownedByName setText:[NSString stringWithFormat:@"Owner by %@",self.opDataDo.ownerName]];
                }else{
                    [cell.ownedByName setText:@""];
                }
                
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                }
                return cell;
            }else if (indexPath.section==1){
                EventDateView *cell=[tableView dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier12" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setIndex:indexPath];
                [cell setDelegate:self];
                [cell.segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }else if(indexPath.section == 2){
                // Feed List
                // updated fields
                int totalSizeis = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"totalSize"] intValue];
                if(totalSizeis == 1){
                    //array -1
                    TextFieldCell *cell =nil;
                    static NSString *rowIdentifier = @"TextFieldCellIdentifierFeed1";
                    cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.textfield setDelegate:self];
                    [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                    [cell.displayIcon.layer setCornerRadius:30.0f];
                    [cell.displayIcon.layer setBorderWidth:3.0f];
                    [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
                    [cell.displayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Profile_Small.png"]]];
                    [cell.displayIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                  //  [cell.displayIcon setTitle:[self.ownerNameStr uppercaseString] forState:UIControlStateNormal];
                    [cell.displayIcon setTitle:[[self.ownerNameStr substringToIndex:1] uppercaseString] forState:UIControlStateNormal];

                  //  self.oppCreatedFullDateStr = [self.infoArray  valueForKey:@"CreatedDate"];
                    NSString*createdDateIS = [self fullDateForFeed:[self.infoArray  valueForKey:@"CreatedDate"]];
                    self.opDataDo.createdDate =createdDateIS ;
                    if(self.opDataDo.createdDate!=nil && ![self.opDataDo.createdDate isEqual:@""] && ![self.opDataDo.createdDate isKindOfClass:[NSNull class]] &&![self.opDataDo.createdDate isEqualToString:@"<null>"]){
                        [cell.CreatedDate setText:self.opDataDo.createdDate];
                    }else{
                        [cell.CreatedDate setText:@""];
                    }
                    // [cell.displayIcon setTitle:[[[self.feedsArray valueForKey:@"FieldName"] substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
                    self.opDataDo.title =self.accountNameStr;
                    if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                        [cell.titleName setText:[NSString stringWithFormat:@"%@ %@",self.opDataDo.title,@"updated this record"]];
                    }else{
                        [cell.titleName setText:@""];
                    }
                    // updated records
                    NSArray *updateFieldArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"FieldName"];
                    NSString *updateFieldIs;
                    
                    for(int i=0; i<[updateFieldArray count];i++){
                        updateFieldIs = [updateFieldArray objectAtIndex:i];
                        //amount
                        if([updateFieldIs isEqualToString:@"Opportunity.Amount"]){
                            // amount object
                            NSArray *newAmountArray =[[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"NewValue"];
                            NSNumber *newamountint;
                            NSArray *oldAmountArray =[[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"OldValue"];
                            NSNumber *oldamountint;
                            NSString *oldAmountValue;
                            NSString *newAmountValue;
                            NSString *newAmountStr;
                            NSString *oldAmountStr;
                            
                            for(int i=0; i<[newAmountArray count];i++){
                                newamountint = [newAmountArray objectAtIndex:0];
                                newAmountValue =[NSString stringWithFormat:@"%@",newamountint] ;
                            }
                            for(int i=0; i<[oldAmountArray count];i++){
                                oldamountint = [oldAmountArray objectAtIndex:0];
                                oldAmountValue =[NSString stringWithFormat:@"%@",oldamountint] ;
                            }
                            
                            // new value
                            if(newAmountValue!=nil && ![newAmountValue isEqual:@""] && ![newAmountValue isKindOfClass:[NSNull class]] &&![newAmountValue isEqualToString:@"<null>"]){
                                newAmountStr = newAmountValue;
                            }else{
                                newAmountStr = @"nill";
                            }
                            //old value
                            if(oldAmountValue!=nil && ![oldAmountValue isEqual:@""] && ![oldAmountValue isKindOfClass:[NSNull class]] &&![oldAmountValue isEqualToString:@"<null>"]){
                                oldAmountStr = oldAmountValue;
                            }else{
                                oldAmountStr = @"nill";
                            }
                            // display amount
                            NSString *amount = [NSString stringWithFormat:@"Amount from $%@ to $%@",oldAmountStr,newAmountStr];
                            cell.amountLbl.text = amount;
                            cell.amountTitleLbl.text = @"Amount";
                        }
                        else if([updateFieldIs isEqualToString:@"Opportunity.StageName"]){
                            NSArray *newStageArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"NewValue"];
                            NSArray *oldStageArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"OldValue"];
                            NSString *newStageStr;
                            NSString *oldStageStr;
                            NSString *newstage;
                            NSString *oldstage;
                            for(int i=0; i<[newStageArray count];i++){
                                newstage = [newStageArray objectAtIndex:0];
                            }
                            for(int i=0; i<[oldStageArray count];i++){
                                oldstage = [oldStageArray objectAtIndex:0];
                            }
                            
                            if(newstage!=nil && ![newstage isEqual:@""] && ![newstage isKindOfClass:[NSNull class]] &&![newstage isEqualToString:@"<null>"]){
                                newStageStr = newstage;
                            }else{
                                newStageStr = @"nill";
                            }
                            //old value
                            if(oldstage!=nil && ![oldstage isEqual:@""] && ![oldstage isKindOfClass:[NSNull class]] &&![oldstage isEqualToString:@"<null>"]){
                                oldStageStr = oldstage;
                            }else{
                                oldStageStr = @"nill";
                            }
                            NSString *displayStage = [NSString stringWithFormat:@"%@ %@ to %@",@"Stage from",oldStageStr,newStageStr];
                            cell.amountLbl.text = displayStage;
                            cell.amountTitleLbl.text = @"Stage";

                        }
                        else if([updateFieldIs isEqualToString:@"Opportunity.Probability"]){
                            NSArray *newProbArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"NewValue"];
                            NSArray *oldProbArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"OldValue"];
                            NSString *newProbStr;
                            NSString *oldProbStr;
                            NSString *newprob;
                            NSString *oldprob;
                            NSNumber *newprobint;
                            NSNumber *oldprobint;
                            
                            for(int i=0; i<[newProbArray count];i++){
                                newprobint = [newProbArray objectAtIndex:0];
                                newprob =[NSString stringWithFormat:@"%@",newprobint] ;
                            }
                            for(int i=0; i<[oldProbArray count];i++){
                                oldprobint = [oldProbArray objectAtIndex:0];
                                oldprob =[NSString stringWithFormat:@"%@",oldprobint] ;
                            }
                            
                            if(newprob!=nil && ![newprob isEqual:@""] && ![newprob isKindOfClass:[NSNull class]] &&![newprob isEqualToString:@"<null>"]){
                                newProbStr = [NSString stringWithFormat:@"%@%@ ",newprob,@"(%)"];
                            }else{
                                newProbStr = @"nill";
                            }
                            //old value
                            if(oldprob!=nil && ![oldprob isEqual:@""] && ![oldprob isKindOfClass:[NSNull class]] &&![oldprob isEqualToString:@"<null>"]){
                                oldProbStr = [NSString stringWithFormat:@"%@%@ ",oldprob,@"(%)"];
                            }else{
                                oldProbStr = @"nill";
                            }
                            // display Prob is
                            NSString *displayProb = [NSString stringWithFormat:@"%@ %@ to %@",@"Probability(%) from",oldProbStr,newProbStr];
                            cell.amountLbl.text = displayProb;
                            cell.amountTitleLbl.text = @"Probability";

                        }
                    }
                    cell.commentsBtn.tag = indexPath.row;
                    [cell.commentsBtn addTarget:self action:@selector(commentsBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                    
                    return cell;
                } else  if(totalSizeis == 2){
                    //array 2
                    TextFieldCell *cell =nil;
                    static NSString *rowIdentifier = @"TextFieldCellIdentifierFeed2";
                    cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.textfield setDelegate:self];
                    [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                    
                    [cell.displayIcon.layer setCornerRadius:30.0f];
                    [cell.displayIcon.layer setBorderWidth:3.0f];
                    [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
                    [cell.displayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Profile_Small.png"]]];
                    [cell.displayIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    //[cell.displayIcon setTitle:[self.ownerNameStr uppercaseString] forState:UIControlStateNormal];
                    [cell.displayIcon setTitle:[[self.ownerNameStr substringToIndex:1] uppercaseString] forState:UIControlStateNormal];

                    NSString*createdDateIS = [self fullDateForFeed:[self.infoArray  valueForKey:@"CreatedDate"]];
                    self.opDataDo.createdDate =createdDateIS ;
                    if(self.opDataDo.createdDate!=nil && ![self.opDataDo.createdDate isEqual:@""] && ![self.opDataDo.createdDate isKindOfClass:[NSNull class]] &&![self.opDataDo.createdDate isEqualToString:@"<null>"]){
                        [cell.CreatedDate setText:self.opDataDo.createdDate];
                    }else{
                        [cell.CreatedDate setText:@""];
                    }

                    self.opDataDo.title =self.accountNameStr;
                    if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                        [cell.titleName setText:[NSString stringWithFormat:@"%@ %@",self.opDataDo.title,@"updated this record"]];
                    }else{
                        [cell.titleName setText:@""];
                    }
                    // updated records
                    NSArray *updateFieldArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"FieldName"];
                    NSString *updateFieldIs;
                    
                    for(int i=0; i<[updateFieldArray count];i++){
                        updateFieldIs = [updateFieldArray objectAtIndex:i];
                        //amount
                        if([updateFieldIs isEqualToString:@"Opportunity.Amount"]){
                            // amount object
                            NSArray *newAmountArray =[[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"NewValue"];
                            NSNumber *newamountint;
                            NSArray *oldAmountArray =[[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"OldValue"];
                            NSNumber *oldamountint;
                            NSString *oldAmountValue;
                            NSString *newAmountValue;
                            NSString *newAmountStr;
                            NSString *oldAmountStr;
                            
                            for(int i=0; i<[newAmountArray count];i++){
                                newamountint = [newAmountArray objectAtIndex:1];
                                newAmountValue =[NSString stringWithFormat:@"%@",newamountint] ;
                            }
                            for(int i=0; i<[oldAmountArray count];i++){
                                oldamountint = [oldAmountArray objectAtIndex:1];
                                oldAmountValue =[NSString stringWithFormat:@"%@",oldamountint] ;
                            }
                            
                            // new value
                            if(newAmountValue!=nil && ![newAmountValue isEqual:@""] && ![newAmountValue isKindOfClass:[NSNull class]] &&![newAmountValue isEqualToString:@"<null>"]){
                                newAmountStr = newAmountValue;
                            }else{
                                newAmountStr = @"nill";
                            }
                            //old value
                            if(oldAmountValue!=nil && ![oldAmountValue isEqual:@""] && ![oldAmountValue isKindOfClass:[NSNull class]] &&![oldAmountValue isEqualToString:@"<null>"]){
                                oldAmountStr = oldAmountValue;
                            }else{
                                oldAmountStr = @"nill";
                            }
                            // display amount
                            NSString *amount = [NSString stringWithFormat:@"Amount from $%@ to $%@",oldAmountStr,newAmountStr];
                            cell.amountLbl.text = amount;
                            cell.amountTitleLbl.text = @"Amount";

                        }
                        else if([updateFieldIs isEqualToString:@"Opportunity.StageName"]){
                            NSArray *newStageArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"NewValue"];
                            NSArray *oldStageArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"OldValue"];
                            NSString *newStageStr;
                            NSString *oldStageStr;
                            NSString *newstage;
                            NSString *oldstage;
                            for(int i=0; i<[newStageArray count];i++){
                                newstage = [newStageArray objectAtIndex:0];
                            }
                            for(int i=0; i<[oldStageArray count];i++){
                                oldstage = [oldStageArray objectAtIndex:0];
                            }

                            if(newstage!=nil && ![newstage isEqual:@""] && ![newstage isKindOfClass:[NSNull class]] &&![newstage isEqualToString:@"<null>"]){
                                newStageStr = newstage;
                            }else{
                                newStageStr = @"nill";
                            }
                            //old value
                            if(oldstage!=nil && ![oldstage isEqual:@""] && ![oldstage isKindOfClass:[NSNull class]] &&![oldstage isEqualToString:@"<null>"]){
                                oldStageStr = oldstage;
                            }else{
                                oldStageStr = @"nill";
                            }
                            NSString *displayStage = [NSString stringWithFormat:@"%@ %@ to %@",@"Stage from",oldStageStr,newStageStr];
                            if(cell.amountLbl.text && ![cell.amountLbl.text isEqual:@""] && ![cell.amountLbl.text isKindOfClass:[NSNull class]] &&![cell.amountLbl.text  isEqualToString:@"<null>"]){
                                cell.stageLbl.text = displayStage;
                                cell.stageTitleLbl.text = @"Stage";
                            }else{
                                cell.amountLbl.text = displayStage;
                                cell.amountTitleLbl.text = @"Stage";
                            }
                            //cell.stageTitleLbl.text = @"Probability";

                        }
                        else if([updateFieldIs isEqualToString:@"Opportunity.Probability"]){
                            NSArray *newProbArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"NewValue"];
                            NSArray *oldProbArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"OldValue"];
                            NSString *newProbStr;
                            NSString *oldProbStr;
                            NSString *newprob;
                            NSString *oldprob;
                            NSNumber *newprobint;
                            NSNumber *oldprobint;

                            for(int i=0; i<[newProbArray count];i++){
                                newprobint = [newProbArray objectAtIndex:1];
                                newprob =[NSString stringWithFormat:@"%@",newprobint] ;
                            }
                            for(int i=0; i<[oldProbArray count];i++){
                                oldprobint = [oldProbArray objectAtIndex:1];
                                oldprob =[NSString stringWithFormat:@"%@",oldprobint] ;
                            }
                            
                            if(newprob!=nil && ![newprob isEqual:@""] && ![newprob isKindOfClass:[NSNull class]] &&![newprob isEqualToString:@"<null>"]){
                                newProbStr = [NSString stringWithFormat:@"%@%@ ",newprob,@"(%)"];
                            }else{
                                newProbStr = @"nill";
                            }
                            //old value
                            if(oldprob!=nil && ![oldprob isEqual:@""] && ![oldprob isKindOfClass:[NSNull class]] &&![oldprob isEqualToString:@"<null>"]){
                                oldProbStr = [NSString stringWithFormat:@"%@%@ ",oldprob,@"(%)"];
                            }else{
                                oldProbStr = @"nill";
                            }
                            // display Prob is
                            NSString *displayProb = [NSString stringWithFormat:@"%@ %@ to %@",@"Probability(%) from",oldProbStr,newProbStr];
                            cell.stageLbl.text = displayProb;
                            cell.stageTitleLbl.text = @"Probability";
                        }
                    }
                    cell.commentsBtn.tag = indexPath.row;
                    [cell.commentsBtn addTarget:self action:@selector(commentsBtnTapped:) forControlEvents:UIControlEventTouchUpInside];

                    // display stage
                    return cell;
                }
               else  if(totalSizeis == 3){
                   TextFieldCell *cell =nil;
                   static NSString *rowIdentifier = @"TextFieldCellIdentifierFeed3";
                   cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                   [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                   [cell.textfield setDelegate:self];
                   [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                   
                   [cell.displayIcon.layer setCornerRadius:30.0f];
                   [cell.displayIcon.layer setBorderWidth:3.0f];
                   [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
                   [cell.displayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Profile_Small.png"]]];
                   [cell.displayIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                  // [cell.displayIcon setTitle:[self.ownerNameStr uppercaseString] forState:UIControlStateNormal];
                   [cell.displayIcon setTitle:[[self.ownerNameStr substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
                   
                   NSString*createdDateIS = [self fullDateForFeed:[self.infoArray  valueForKey:@"CreatedDate"]];
                   self.opDataDo.createdDate =createdDateIS ;
                   if(self.opDataDo.createdDate!=nil && ![self.opDataDo.createdDate isEqual:@""] && ![self.opDataDo.createdDate isKindOfClass:[NSNull class]] &&![self.opDataDo.createdDate isEqualToString:@"<null>"]){
                       [cell.CreatedDate setText:self.opDataDo.createdDate];
                   }else{
                       [cell.CreatedDate setText:@""];
                   }

                   self.opDataDo.title =self.accountNameStr;
                   if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                       [cell.titleName setText:[NSString stringWithFormat:@"%@ %@",self.opDataDo.title,@"updated this record"]];
                   }else{
                       [cell.titleName setText:@""];
                   }
                   // updated records
                   NSArray *updateFieldArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"FieldName"];
                   NSString *updateFieldIs;
                   
                   for(int i=0; i<[updateFieldArray count];i++){
                       updateFieldIs = [updateFieldArray objectAtIndex:i];
                       
                       if([updateFieldIs isEqualToString:@"Opportunity.Amount"]){
                           // amount object
                           NSArray *newAmountArray =[[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"NewValue"];
                           NSNumber *newamountint;
                           NSArray *oldAmountArray =[[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"OldValue"];
                           NSNumber *oldamountint;
                           NSString *oldAmountValue;
                           NSString *newAmountValue;
                           NSString *newAmountStr;
                           NSString *oldAmountStr;
                         

                           for(int i=0; i<[newAmountArray count];i++){
                               newamountint = [newAmountArray objectAtIndex:1];
                               newAmountValue =[NSString stringWithFormat:@"%@",newamountint] ;
                           }
                           for(int i=0; i<[oldAmountArray count];i++){
                               oldamountint = [oldAmountArray objectAtIndex:1];
                               oldAmountValue =[NSString stringWithFormat:@"%@",oldamountint] ;
                           }

                           // new value
                           if(newAmountValue!=nil && ![newAmountValue isEqual:@""] && ![newAmountValue isKindOfClass:[NSNull class]] &&![newAmountValue isEqualToString:@"<null>"]){
                               newAmountStr = newAmountValue;
                           }else{
                               newAmountStr = @"nill";
                           }
                           //old value
                           if(oldAmountValue!=nil && ![oldAmountValue isEqual:@""] && ![oldAmountValue isKindOfClass:[NSNull class]] &&![oldAmountValue isEqualToString:@"<null>"]){
                               oldAmountStr = oldAmountValue;
                           }else{
                               oldAmountStr = @"nill";
                           }
                           // display amount
                           NSString *amount = [NSString stringWithFormat:@"Amount from $%@ to $%@",oldAmountStr,newAmountStr];
                           cell.amountLbl.text = amount;
                           cell.amountTitleLbl.text = @"Amount";
                       }
                       else if([updateFieldIs isEqualToString:@"Opportunity.StageName"]){
                           NSArray *newStageArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"NewValue"];
                           NSArray *oldStageArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"OldValue"];
                 
                           NSString *newStageStr;
                           NSString *oldStageStr;
                           NSString *newstage;
                           NSString *oldstage;
                           for(int i=0; i<[newStageArray count];i++){
                               newstage = [newStageArray objectAtIndex:0];
                           }
                           for(int i=0; i<[oldStageArray count];i++){
                               oldstage = [oldStageArray objectAtIndex:0];
                           }
                           if(newstage!=nil && ![newstage isEqual:@""] && ![newstage isKindOfClass:[NSNull class]] &&![newstage isEqualToString:@"<null>"]){
                               newStageStr = newstage;
                           }else{
                               newStageStr = @"nill";
                           }
                           //old value
                           if(oldstage!=nil && ![oldstage isEqual:@""] && ![oldstage isKindOfClass:[NSNull class]] &&![oldstage isEqualToString:@"<null>"]){
                               oldStageStr = oldstage;
                           }else{
                               oldStageStr = @"nill";
                           }
                           NSString *displayStage = [NSString stringWithFormat:@"%@ %@ to %@",@"Stage from ",oldStageStr,newStageStr];
                           cell.stageLbl.text = displayStage;
                           cell.stageTitleLbl.text = @"Stage";

                       }
                       else if([updateFieldIs isEqualToString:@"Opportunity.Probability"]){
                           NSArray *newProbArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"NewValue"];
                           NSArray *oldProbArray = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"records"] valueForKey:@"OldValue"];
                           NSString *newProbStr;
                           NSString *oldProbStr;
                           NSString *newprob;
                           NSString *oldprob;
                           NSNumber *newprobint;
                           NSNumber *oldprobint;
                           
                           for(int i=0; i<[newProbArray count];i++){
                               newprobint = [newProbArray objectAtIndex:2];
                               newprob =[NSString stringWithFormat:@"%@",newprobint] ;
                           }
                           for(int i=0; i<[oldProbArray count];i++){
                               oldprobint = [oldProbArray objectAtIndex:2];
                               oldprob =[NSString stringWithFormat:@"%@",oldprobint] ;
                           }

                           if(newprob!=nil && ![newprob isEqual:@""] && ![newprob isKindOfClass:[NSNull class]] &&![newprob isEqualToString:@"<null>"]){
                               newProbStr = [NSString stringWithFormat:@"%@%@ ",newprob,@"(%)"];
                           }else{
                               newProbStr = @"nill";
                           }
                           //old value
                           if(oldprob!=nil && ![oldprob isEqual:@""] && ![oldprob isKindOfClass:[NSNull class]] &&![oldprob isEqualToString:@"<null>"]){
                               oldProbStr = [NSString stringWithFormat:@"%@%@ ",oldprob,@"(%)"];
                           }else{
                               oldProbStr = @"nill";
                           }
                           // display Prob is
                           NSString *displayProb = [NSString stringWithFormat:@"%@ %@ to %@",@"Probability(%) from ",oldProbStr,newProbStr];
                           if(displayProb && ![displayProb isEqual:@""] && ![displayProb isKindOfClass:[NSNull class]] &&![displayProb  isEqualToString:@"<null>"]){
                               cell.probabilityLbl.text = displayProb;
                               cell.probabilityTitleLbl.text = @"Probability";

                           }else{
                               cell.probabilityLbl.text = @"NA";
                               cell.probabilityTitleLbl.text = @"Probability";

                           }

                       }
                   }
                   // display stage
                   cell.commentsBtn.tag = indexPath.row;
                   [cell.commentsBtn addTarget:self action:@selector(commentsBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                   return cell;
                }
            }
            return nil;
            
    }else if([self.selectedSegmentType isEqualToString:@"Notes"]){
        if(indexPath.section == 0){
            if (indexPath.row==0) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                
                [cell.displayIcon.layer setCornerRadius:50.0f];
                [cell.displayIcon.layer setBorderWidth:3.0f];
                [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
                [cell.displayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Profile_BG.png"]]];
                [cell.displayIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.displayIcon setTitle:[[[self.infoArray valueForKey:@"Name"] substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
                self.opDataDo.title =[self.infoArray  valueForKey:@"Name"];
                if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                    [cell.titleName setText:self.opDataDo.title];
                }else{
                    [cell.titleName setText:@""];
                }
                self.opDataDo.statusMsg =[[self.infoArray  valueForKey:@"Account"] valueForKey:@"Name"];
                if(self.opDataDo.statusMsg!=nil && ![self.opDataDo.statusMsg isEqual:@""] && ![self.opDataDo.statusMsg isKindOfClass:[NSNull class]] &&![self.opDataDo.statusMsg isEqualToString:@"<null>"]){
                    [cell.AccName setText:self.opDataDo.statusMsg];
                }else{
                    [cell.AccName setText:@""];
                }
                self.oppCreatedFullDateStr = [self.infoArray  valueForKey:@"CreatedDate"];
                NSString*createdDateIS = [self fullDate:[self.infoArray  valueForKey:@"CreatedDate"]];
                self.opDataDo.createdDate =createdDateIS ;
                if(self.opDataDo.createdDate!=nil && ![self.opDataDo.createdDate isEqual:@""] && ![self.opDataDo.createdDate isKindOfClass:[NSNull class]] &&![self.opDataDo.createdDate isEqualToString:@"<null>"]){
                    [cell.CreatedDate setText:self.opDataDo.createdDate];
                }else{
                    [cell.CreatedDate setText:@""];
                }
                self.opDataDo.ownerName =[[self.infoArray  valueForKey:@"Owner"] valueForKey:@"Name"];
                if(self.opDataDo.ownerName!=nil && ![self.opDataDo.ownerName isEqual:@""] && ![self.opDataDo.ownerName isKindOfClass:[NSNull class]] &&![self.opDataDo.ownerName isEqualToString:@"<null>"]){
                    [cell.ownedByName setText:[NSString stringWithFormat:@"Owner by %@",self.opDataDo.ownerName]];
                }else{
                    [cell.ownedByName setText:@""];
                }
                
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                }
                return cell;
            }else if (indexPath.row==1){
                EventDateView *cell=[tableView dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier12" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setIndex:indexPath];
                [cell setDelegate:self];
                [cell.segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }else if (indexPath.row==2){
                EventDateView *cell=[tableView dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier" forIndexPath:indexPath];
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
                    self.opDataDo.closeDate =[self.infoArray valueForKey:@"CloseDate"];
                    
                    if(self.opDataDo.closeDate!=nil && ![self.opDataDo.closeDate isEqual:@""] && ![self.opDataDo.closeDate isKindOfClass:[NSNull class]] &&![self.opDataDo.closeDate isEqualToString:@"<null>"]){
                        [cell.eventDate setText:self.opDataDo.closeDate];
                    }else{
                        [cell.eventDate setText:@""];
                    }
                    
                }
                [cell.headerlabel setText:@"Close Date"];
                return cell;
            }else if (indexPath.row==3) {
                
                LabelSwitchCell *cell =nil;
                static NSString *rowIdentifier = @"OptionCellIdentifier1";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier];
                [cell setDelegate:self];
                [cell setIndexpath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                if (self.enableFields) {
                    [cell.toggleButton setHidden:FALSE];
                    [cell.toggleButton setTag:1001];
                    
                    [cell.fieldTitle setText:@"Stage"];
                    // self.opDataDo.stage =[self.infoArray  valueForKey:@"StageName"];
                    if(self.opDataDo.stage!=nil && ![self.opDataDo.stage isEqual:@""] && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]){
                        [cell.fieldContent setText:self.opDataDo.stage];
                    }else{
                        [cell.fieldContent setText:@""];
                    }
                }else{
                    [cell.toggleButton setHidden:TRUE];
                    [cell.toggleButton setTag:1001];
                    [cell.fieldTitle setText:@"Stage"];
                    self.opDataDo.stage =[self.infoArray  valueForKey:@"StageName"];
                    if(self.opDataDo.stage!=nil && ![self.opDataDo.stage isEqual:@""] && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]){
                        [cell.fieldContent setText:self.opDataDo.stage];
                    }else{
                        [cell.fieldContent setText:@""];
                    }
                }
                return cell;
            }
            else if (indexPath.row==4) {
                LabelSwitchCell *cell =nil;
                static NSString *rowIdentifier = @"OptionCellIdentifier1";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier];
                [cell setDelegate:self];
                [cell setIndexpath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                if (self.enableFields) {
                    [cell.toggleButton setHidden:FALSE];
                    [cell.toggleButton setTag:1002];
                    NSString *probStr = @"(%)";
                    [cell.fieldTitle setText:[NSString stringWithFormat:@"%@%@",@"Probability",probStr]];
                    //    NSInteger  prob = [[self.infoArray valueForKey:@"Probability"] integerValue];
                    // self.opDataDo.probability = [NSString stringWithFormat:@"%ld",(long)prob];
                    
                    if(self.opDataDo.probability!=nil && ![self.opDataDo.probability isEqual:@""] && ![self.opDataDo.probability isKindOfClass:[NSNull class]] &&![self.opDataDo.probability isEqualToString:@"<null>"]){
                        [cell.fieldContent setText:[NSString stringWithFormat:@"%@",self.opDataDo.probability]];
                    }else{
                        [cell.fieldContent setText:@"0.0"];
                    }
                }else{
                    [cell.toggleButton setHidden:TRUE];
                    [cell.toggleButton setTag:1002];
                    NSString *probStr = @"(%)";
                    [cell.fieldTitle setText:[NSString stringWithFormat:@"%@%@",@"Probability",probStr]];
                    NSInteger  prob = [[self.infoArray valueForKey:@"Probability"] integerValue];
                    self.opDataDo.probability = [NSString stringWithFormat:@"%ld",(long)prob];
                    
                    if (self.opDataDo.probability!=nil && [self.opDataDo.probability length]>0) {
                        [cell.fieldContent setText:[NSString stringWithFormat:@"%@%@",self.opDataDo.probability,@"%"]];
                    }else{
                        [cell.fieldContent setText:@"0.0"];
                    }
                    
                }
                return cell;
                
            }else if (indexPath.row==5) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier1";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1003];
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    NSString *rupee = @"($)";
                    [cell.textfieldTitle setText:[NSString stringWithFormat:@"%@ %@",@"Amount",rupee]];
                    // NSNumber *amount = [self.infoArray valueForKey:@"Amount"];
                    //NSInteger value = [[self.infoArray valueForKey:@"Amount"] integerValue];
                    //self.opDataDo.amount =[NSString stringWithFormat:@"%ld",(long)value];
                    if(self.opDataDo.amount!=nil && ![self.opDataDo.amount isEqual:@""] && ![self.opDataDo.amount isKindOfClass:[NSNull class]] &&![self.opDataDo.amount isEqualToString:@"<null>"]){
                        [cell.textfield setText:[NSString stringWithFormat:@"%@",self.opDataDo.amount]];
                    }else{
                        [cell.textfield setText:@"0.0"];
                    }
                    
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                    NSString *rupee = @"($)";
                    [cell.textfieldTitle setText:[NSString stringWithFormat:@"%@ %@",@"Amount",rupee]];
                    // NSNumber *amount = [self.infoArray valueForKey:@"Amount"];
                    /*NSInteger value = [[self.infoArray valueForKey:@"Amount"] integerValue];
                     self.opDataDo.amount =[NSString stringWithFormat:@"%ld",(long)value];
                     
                     if(self.opDataDo.amount!=nil && ![self.opDataDo.amount isEqual:@""] && ![self.opDataDo.amount isKindOfClass:[NSNull class]] &&![self.opDataDo.amount isEqualToString:@"<null>"]){
                     [cell.textfield setText:[NSString stringWithFormat:@"%@ %@",@"$",self.opDataDo.amount]];
                     }else{
                     [cell.textfield setText:@"0.0"];
                     }*/
                    NSNumber *amount =  [self.infoArray valueForKey:@"Amount"];
                    
                    NSString *value = [NSString stringWithFormat:@"%@",amount];
                    if (value!=nil && ![value isEqual:@"<null>"] && ![value isKindOfClass:[NSNull class]]&& [rupee length]>0 ) {
                        self.opDataDo.amount = value;
                        [cell.textfield setText:[NSString stringWithFormat:@"%@ %@",@"$",self.opDataDo.amount]];
                    }else{
                        [cell.textfield setText:@"$0.0"];
                    }
                    
                    
                }
                return cell;
            }else if (indexPath.row==6) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier2";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1004];
                [cell.textfieldTitle setText:@"Executive summary"];
                //self.opDataDo.nextStep =self.opDataDo.;
                self.opDataDo.nextStep =[self.infoArray valueForKey:@"NextStep"];
                
                if (self.opDataDo.nextStep!=nil && ![self.opDataDo.nextStep isEqual:@""] && ![self.opDataDo.nextStep isEqual:@"<null>"] &&![self.opDataDo.nextStep isKindOfClass:[NSNull class]]) {
                    [cell.textfield setText:self.opDataDo.nextStep];
                }else{
                    [cell.textfield setText:@"NA"];
                }
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                }
                return cell;
            }
        }else if (indexPath.section==1) {
            static NSString *CellIdentifier= @"SubmitCellIdentifier";
            SubmitButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell setDelegate:self];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        return nil;
        
    }else{
        if(indexPath.section == 0){
            if (indexPath.row==0) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                
                [cell.displayIcon.layer setCornerRadius:30.0f];
                [cell.displayIcon.layer setBorderWidth:3.0f];
                [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
                [cell.displayIcon setTitle:[[[self.infoArray valueForKey:@"Name"] substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
                self.opDataDo.title =[self.infoArray  valueForKey:@"Name"];
                if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                    [cell.titleName setText:self.opDataDo.title];
                }else{
                    [cell.titleName setText:@""];
                }
                self.opDataDo.statusMsg =[[self.infoArray  valueForKey:@"Account"] valueForKey:@"Name"];
                if(self.opDataDo.statusMsg!=nil && ![self.opDataDo.statusMsg isEqual:@""] && ![self.opDataDo.statusMsg isKindOfClass:[NSNull class]] &&![self.opDataDo.statusMsg isEqualToString:@"<null>"]){
                    [cell.AccName setText:self.opDataDo.statusMsg];
                }else{
                    [cell.AccName setText:@""];
                }
                
                NSString*createdDateIS = [self fullDate:[self.infoArray  valueForKey:@"CreatedDate"]];
                self.opDataDo.createdDate =createdDateIS ;
                if(self.opDataDo.createdDate!=nil && ![self.opDataDo.createdDate isEqual:@""] && ![self.opDataDo.createdDate isKindOfClass:[NSNull class]] &&![self.opDataDo.createdDate isEqualToString:@"<null>"]){
                    [cell.CreatedDate setText:self.opDataDo.createdDate];
                }else{
                    [cell.CreatedDate setText:@""];
                }
                self.opDataDo.ownerName =[[self.infoArray  valueForKey:@"Owner"] valueForKey:@"Name"];
                if(self.opDataDo.ownerName!=nil && ![self.opDataDo.ownerName isEqual:@""] && ![self.opDataDo.ownerName isKindOfClass:[NSNull class]] &&![self.opDataDo.ownerName isEqualToString:@"<null>"]){
                    [cell.ownedByName setText:[NSString stringWithFormat:@"Owner by %@",self.opDataDo.ownerName]];
                }else{
                    [cell.ownedByName setText:@""];
                }
                
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                }
                return cell;
            }else if (indexPath.row==1){
                EventDateView *cell=[tableView dequeueReusableCellWithIdentifier:@"EventDateCellIdentifier12" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setIndex:indexPath];
                [cell setDelegate:self];
                [cell.segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }else if(indexPath.row == 2){
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifierFeed";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                
                [cell.displayIcon.layer setCornerRadius:30.0f];
                [cell.displayIcon.layer setBorderWidth:3.0f];
                [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
                [cell.displayIcon setTitle:[[[self.infoArray valueForKey:@"Name"] substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
                self.opDataDo.title =[self.infoArray  valueForKey:@"Name"];
                if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
                    [cell.titleName setText:self.opDataDo.title];
                }else{
                    [cell.titleName setText:@""];
                }
                self.opDataDo.statusMsg =[[self.infoArray  valueForKey:@"Account"] valueForKey:@"Name"];
                if(self.opDataDo.statusMsg!=nil && ![self.opDataDo.statusMsg isEqual:@""] && ![self.opDataDo.statusMsg isKindOfClass:[NSNull class]] &&![self.opDataDo.statusMsg isEqualToString:@"<null>"]){
                    [cell.AccName setText:self.opDataDo.statusMsg];
                }else{
                    [cell.AccName setText:@""];
                }
                
                NSString*createdDateIS = [self fullDate:[self.infoArray  valueForKey:@"CreatedDate"]];
                self.opDataDo.createdDate =createdDateIS ;
                if(self.opDataDo.createdDate!=nil && ![self.opDataDo.createdDate isEqual:@""] && ![self.opDataDo.createdDate isKindOfClass:[NSNull class]] &&![self.opDataDo.createdDate isEqualToString:@"<null>"]){
                    [cell.CreatedDate setText:self.opDataDo.createdDate];
                }else{
                    [cell.CreatedDate setText:@""];
                }
                self.opDataDo.ownerName =[[self.infoArray  valueForKey:@"Owner"] valueForKey:@"Name"];
                if(self.opDataDo.ownerName!=nil && ![self.opDataDo.ownerName isEqual:@""] && ![self.opDataDo.ownerName isKindOfClass:[NSNull class]] &&![self.opDataDo.ownerName isEqualToString:@"<null>"]){
                    [cell.ownedByName setText:[NSString stringWithFormat:@"Owner by %@",self.opDataDo.ownerName]];
                }else{
                    [cell.ownedByName setText:@""];
                }
                
                if (self.enableFields) {
                    [cell.textfield setEnabled:TRUE];
                    
                }else{
                    [cell.textfield setEnabled:FALSE];
                }
                return cell;
            }
        }
        return nil;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.selectedSegmentType isEqualToString:@"Details"]){
        if (indexPath.section==0){
            if(indexPath.row == 0){
                return 250;
            }else if(indexPath.row == 1){
                return 70;
            }else {
                return 75;
                
            }
        }else {
            return 75;
        }

    }else if([self.selectedSegmentType isEqualToString:@"Feeds"]){
        if(indexPath.section ==0){
            return 250;
        }else if(indexPath.section ==1){
            return 60;
        }else if(indexPath.section ==2){
            int totalSizeis = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"totalSize"] intValue];
            if(totalSizeis ==1){
                return 200;
            }else if(totalSizeis ==2){
                return 255;
            }
            else if(totalSizeis ==3){
                return 308;
            }
        }else {
            return 0;
        }
    }else{
       /* if (indexPath.section==0){
            if(indexPath.row == 0){
                return 250;
            }else if(indexPath.row == 1){
                return 70;
            }else if(indexPath.row ==2){
                int totalSizeis = [[[self.feedsArray  objectAtIndex:indexPath.row] objectForKey:@"totalSize"] intValue];
                if(totalSizeis ==1){
                    return 220;
                }else if(totalSizeis ==2){
                    return 265;
                }
                else if(totalSizeis ==3){
                    return 308;
                }
            }else{
                return 0;
            }*/
        return 0;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.frame.size.width, 25)];
//    [headerView setBackgroundColor:[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f]];
    return 0;
}
-(void)commentsBtnTapped:(id)sender{
    UIButton *btn = (UIButton *)sender;
  //  int tag = btn;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController *chatVC = [storyboard instantiateViewControllerWithIdentifier:@"showChatVC"];
    chatVC.infoArray = [self.feedsArray objectAtIndex:btn.tag] ;
    chatVC.recordId = self.recordObjectId;
    chatVC.oppNameStr = self.opDataDo.statusMsg;
    chatVC.ownerNameStr = self.opDataDo.ownerName;
    chatVC.oppCreatedDateStr = self.oppCreatedFullDateStr;
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:chatVC];
    [self presentViewController:navController animated:YES completion:nil];
}
-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0:{
            self.selectedSegmentType = @"Details"; // Details
            [self.tableview reloadData];
           [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }
        break;
        case 1:{
          self.selectedSegmentType = @"Feeds";
          [self.navigationItem.rightBarButtonItem setEnabled:NO];
            [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
            NSString *str = [NSString stringWithFormat:@"SELECT ID, (SELECT ID, FieldName, OldValue, NewValue FROM FeedTrackedChanges) FROM FeedItem WHERE  ParentId = '%@'",self.recordObjectId];
            SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:str];
            [[SFRestAPI sharedInstance] send:request delegate:self];
            [self.tableview reloadData];
        }
        break;
        case 2:{
            self.selectedSegmentType = @"Notes";
            /*[self.navigationItem.rightBarButtonItem setEnabled:NO];
            [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
            NSString *str = [NSString stringWithFormat:@"SELECT ID,Body,Title FROM Notes"];
            SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:str];
            [[SFRestAPI sharedInstance] send:request delegate:self];*/
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Will provide by next release" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        break;
        default:
        break;
    }
}

-(void)opendatepicker:(NSIndexPath*)index{
    [self.view endEditing:TRUE];
    self.datePickerview.minimumDate=nil;
    self.datePickerview.maximumDate=nil;
    if (index.row==2) {
        self.selectedPicker=4001;
        self.datePickerview.minimumDate=[NSDate date];
    }
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
-(void)changeToggleState:(BOOL)state index:(NSIndexPath *)index{
    [self.view endEditing:TRUE];
    [self.pickerToolBar setHidden:FALSE];
    if (index.section==0) {
        if (index.row==3) {  // speciality // Praticetype // Classification
            self.selectedPicker=1001;
            self.pickerArray = [[NSArray alloc] initWithObjects:@"Qualification",@"Needs Analysis",@"Proposal",@"Negotiation",@"Closed Won", @"Closed Lost",nil];
            [self.pickerViewObj reloadAllComponents];
            
        }else if (index.row==4){
            self.selectedPicker=1002;
            self.pickerArray = [[NSArray alloc] initWithObjects:@"10",@"20",@"40",@"60",@"80",@"90",nil];
            [self.pickerViewObj reloadAllComponents];
        }
        
        [self.pickerViewObj reloadAllComponents];
        if ([self.pickerViewObj isHidden] && [self.datePickerview isHidden]) {
            self.tableview.frame=CGRectMake(10, self.tableview.frame.origin.y, self.tableview.frame.size.width, self.tableview.frame.size.height-250);
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    [self.pickerViewObj selectRow:0 inComponent:0 animated:FALSE];
    [self.datePickerview setHidden:TRUE];
    [self.pickerViewObj setHidden:FALSE];
    self.pickerOpen=TRUE;
}

- (void)datePickerChanged:(UIDatePicker *)datePicker1{
    [self.activeField resignFirstResponder];
    datePicker1.minimumDate=nil;
    datePicker1.maximumDate=nil;
    if (self.selectedPicker==4001) {
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
 replacementText:(NSString *)text
{
    
    BOOL hasNewLineCharacterTyped = (text.length == 1) && [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location != NSNotFound;
    if (hasNewLineCharacterTyped) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
        self.activeField=textField;
        if (self.activeField.tag==1000) {
        }else if (self.activeField.tag == 1001){
            NSIndexPath *index=[NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1002){
            NSIndexPath *index=[NSIndexPath indexPathForRow:4 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1003){
            NSIndexPath *index=[NSIndexPath indexPathForRow:5 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1004){
            NSIndexPath *index=[NSIndexPath indexPathForRow:6 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if(self.activeField.tag>=4001){
            NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
        switch (textField.tag) {
                
            case 1001:
                self.opDataDo.stage=textField.text;
                break;
            case 1002:
                self.opDataDo.probability=textField.text;
                break;
            case 1003:
                self.opDataDo.amount=textField.text;
                break;
            case 1004:
                self.opDataDo.nextStep=textField.text;
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
-(void)rotateMove{
    [SVProgressHUD dismiss];
}
#pragma mark - SFRestDelegate
- (NSData *)jsonData {
    
    NSDictionary *root = @{@"Sport" : @(10),          // I´m using literals here for brevity’s sake
                           @"Skill" : @(20),
                           @"Visibility" : @(30),
                           @"NotificationRange" : @(40)};
    
    if ([NSJSONSerialization isValidJSONObject:root]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:root
                                                           options:0
                                                             error:nil];
        return jsonData;
    }
    return nil;
}


- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    [self rotateMove];
   // NSError *error=nil;
   // NSData *data = [self jsonData];
    if([self.selectedSegmentType isEqualToString:@"Feeds"]){
//        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        NSMutableArray *records;
          NSMutableDictionary *feedTrackingDict = [[NSMutableDictionary alloc] init];
         NSMutableArray *feedTrackingArray = [[NSMutableArray alloc] init];
        if(jsonResponse !=nil && ![jsonResponse isEqual:@""] && ![jsonResponse isEqual:@"<>"]){
            records = jsonResponse[@"records"];
            NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
            NSLog(@"rec: %@", records); // array
            if(records!=nil && ![records isEqual:@""] && ![records isKindOfClass:[NSNull class]] && [records count]>0){
                for(NSDictionary *dict in records){
                    feedTrackingDict = [dict valueForKey:@"FeedTrackedChanges"];
                    /* feedTrackingArray = [feedTrackingDict objectForKey:@"records"];
                     for(NSDictionary *dict in feedTrackingArray){
                     [self.feedsArray addObject:dict];
                     }*/
                    [self.feedsArray addObject:feedTrackingDict];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableview reloadData];
                });
                NSLog(@"self.feedsArray: %@", self.feedsArray); // array
            }else{
                //
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableview reloadData];
                });
            }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableview reloadData];
                });
            }
    }else if([self.selectedSegmentType isEqualToString:@"Notes"]){
        if(jsonResponse !=nil && ![jsonResponse isEqual:@""] && [jsonResponse isEqual:@"<>"]){
            NSArray *records = jsonResponse[@"records"];
            NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
            self.notesArray = [records mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
                // [self.navigationController popViewControllerAnimated:YES];
                //[self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            // [self.navigationController popViewControllerAnimated:YES];
            //[self dismissViewControllerAnimated:YES completion:nil];
        }

    }
    else{
//        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        if(jsonResponse !=nil && ![jsonResponse isEqual:@""] && [jsonResponse isEqual:@"<>"]){
            NSArray *records = jsonResponse[@"records"];
            NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
            //self.dataRows = [records mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
                // [self.navigationController popViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            // [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }

    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableview reloadData];
//        // [self.navigationController popViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    });

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
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd MMM yyyy" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}
-(void)submitData{
    
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
    [infoDict setObject:self.opDataDo.nextStep forKey:@"NextStep"];
    [infoDict setObject:self.opDataDo.stage forKey:@"StageName"];
    [infoDict setObject:self.opDataDo.amount forKey:@"Amount"];
    [infoDict setObject:self.opDataDo.closeDate forKey:@"CloseDate"];
    [infoDict setObject:self.opDataDo.probability forKey:@"Probability"];
    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Opportunity" objectId:self.opDataDo.recordId fields:infoDict];
    [[SFRestAPI sharedInstance] send:request delegate:self];

}
- (NSString *)fullDateForFeed:(NSString *)dateString {
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

@end
