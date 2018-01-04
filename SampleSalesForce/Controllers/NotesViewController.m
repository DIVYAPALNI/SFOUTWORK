//
//  NotesViewController.m
//  SampleSalesForce
//
//  Created by Apple on 11/10/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "NotesViewController.h"
#import "OppViewCell.h"
#import "TextFieldCell.h"
#import "SubmitButtonCell.h"
#import "TextViewCell.h"
#import "Utilities.h"

@interface NotesViewController ()<UITextFieldDelegate,SubmitButtonDelegate,RelatedSelectDelagate,UITextViewDelegate>
@property (nonatomic, strong) Utilities *util;

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *buttonImage = [UIImage imageNamed:@"arrow_back.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    self.util = [[Utilities alloc] init];

    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    //theam blue
   // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:3.0/255.0 green:35.0/255.0 blue:102.0/255.0 alpha:1]];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:248.0/255.0 green:80.0/255.0 blue:96.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0/255.0 green:107.0/255.0 blue:241.0/255.0 alpha:1]];

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"Add Note";

    // Picker
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    self.opDataDo = [[OppDataDO alloc] init];
    if (self.editMode) {
        self.enableFields=TRUE;
    }else{
        self.enableFields=FALSE;
    }
    ateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                target:self
                                              selector:@selector(rotateMove)
                                              userInfo:nil
                                               repeats:YES];

}
-(void)rotateMove{
    [SVProgressHUD dismiss];
}

-(void)backBtnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:TRUE];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification  object:nil];
}

- (void)keyboardDidShow:(NSNotification *)sender {
        self.tableview.frame=CGRectMake(0,0, self.view.frame.size.width, self.tableview.frame.size.height+250);
    
    if (!self.keyboardOpen) {
        self.keyboardOpen=TRUE;
        self.tableview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.tableview.frame.size.height-250);
    }
}

- (void)keyboardDidHide:(NSNotification *)sender {
    if (self.keyboardOpen) {
        self.tableview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.tableview.frame.size.height+250);
        self.keyboardOpen=FALSE;
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
        if(section == 0){
            if (self.enableFields) {
                return 4;
            }else{
                return 4;
            }
            
        }else{
            if (self.enableFields) {
                return 1;
            }else{
                return 0;
            }
            
        }
}
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
                static NSString *rowIdentifier = @"TextFieldCellIdentifier3";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
              //  [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                
                [cell.textfield setTag:1001];
                [cell.textfieldTitle setText:@"Related To"];
                if (self.enableFields) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            }else if (indexPath.row==2) {
                TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier1";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1002];
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
            }else if (indexPath.row==3) {
                /*TextFieldCell *cell =nil;
                static NSString *rowIdentifier = @"TextFieldCellIdentifier3";
                cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textfield setDelegate:self];
                [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
                [cell.textfield setTag:1003];
                [cell.textfieldTitle setText:@"Body"];
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
                [cell.descLbl setText:@"Body"];
                [cell.textview setTag:1002];
                cell.textview.delegate = self;
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
            return cell;
        }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section ==0) {
        if(indexPath.row ==0) {
            return 0;
        }else if(indexPath.row ==3) {
            return 100;
        } else {
            return 75;
        }
    } else {
        return 75;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0){
        if(indexPath.row == 1){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RelatedToViewController *oppVC = [storyboard instantiateViewControllerWithIdentifier:@"showRelatedVC"];
                oppVC.relatedTypeIs =@"RelatedTo";
                oppVC.selectedTypeFromCreate = @"Notes";
                oppVC.delegate = self;
                [self.navigationController pushViewController:oppVC animated:YES];
            }
        }else{
        }
}
-(void)selectedRelated:(NSDictionary *)customer :(NSString *)typeIS{
    [self.navigationController popViewControllerAnimated:YES];
    self.opDataDo.stage = [customer objectForKey:@"Name"];
    self.opDataDo.whatId = [customer objectForKey:@"Id"];
    [self.tableview reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSInteger nextTag = self.activeField.tag + 1;
    UIResponder* nextResponder = [self.tableview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [self.activeField resignFirstResponder];
    }
    
    return FALSE;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.activeField=textField;
        if (self.activeField.tag==1000) {
        }else if (self.activeField.tag == 1001){
            NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else if (self.activeField.tag == 1002){
            NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
      /*  else if (self.activeField.tag == 1003){
            NSIndexPath *index=[NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }*/
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
            
        case 1001:
            self.opDataDo.stage=textField.text; //related
            break;
        case 1002:
            self.opDataDo.title=textField.text; // contact
            break;
        case 1003:
           // self.opDataDo.stage=textField.text;// body
            break;
        default:
            break;
    }
    
}

-(void)submitData{
      //  [infoDict setObject:self.opDataDo.nextStep forKey:@"Body"];
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];

    if(self.opDataDo.stage!=nil && ![self.opDataDo.stage isEqual:@""] && ![self.opDataDo.stage isKindOfClass:[NSNull class]] &&![self.opDataDo.stage isEqualToString:@"<null>"]){
        if(self.opDataDo.title!=nil && ![self.opDataDo.title isEqual:@""] && ![self.opDataDo.title isKindOfClass:[NSNull class]] &&![self.opDataDo.title isEqualToString:@"<null>"]){
            [infoDict setObject:self.opDataDo.title forKey:@"Title"];
            [infoDict setObject:self.opDataDo.whatId forKey:@"ParentId"];
            if(![Utilities objectIsNull:self.opDataDo.nextStep]){
                [infoDict setObject:self.opDataDo.nextStep forKey:@"Body"];
                [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
                SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Note" fields:infoDict];
                [[SFRestAPI sharedInstance] send:request delegate:self];
            }else{
                [infoDict setObject:@"" forKey:@"Body"];
                [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
                SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Note" fields:infoDict];
                [[SFRestAPI sharedInstance] send:request delegate:self];
            }
        }else{
            [self.util showAlert:@"Title cannot be empty" title:@""];
        }
    }else{
        [self.util showAlert:@"Opportunity cannot be empty" title:@""];
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
        self.dataRows = [records mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"No data found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
        if (textView.tag == 1002) {
            NSIndexPath *index=[NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [textView becomeFirstResponder];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.tableview.contentInset = contentInsets;
    [textView resignFirstResponder];
        if (textView.tag==1002) {
            self.opDataDo.nextStep=textView.text;
        }else{
        }
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
@end
