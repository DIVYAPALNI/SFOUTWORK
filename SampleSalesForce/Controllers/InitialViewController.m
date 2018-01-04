/*
 Copyright (c) 2013-present, salesforce.com, inc. All rights reserved.
 
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

#import "InitialViewController.h"
#import "InitialViewCell.h"
#import "AppDelegate.h"
#import "TextFieldCell.h"
#import "SubmitButtonCell.h"

@interface InitialViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,SubmitButtonDelegate>

@property NSMutableArray *actions;
@property (weak, nonatomic) IBOutlet UITableView *actionList;

@property (strong, nonatomic) Contacts *contactManager;

@end

@implementation InitialViewController
@synthesize keyboardOpen;
@synthesize contactId;
@synthesize activeField;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
   /* UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,15,self.actionList.bounds.size.width-160,40)];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,self.actionList.bounds.size.width-160,20)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:[self.detailsArray valueForKey:@"Name"]];
    [iv addSubview:titleLabel];
    self.navigationItem.titleView = iv;*/

    self.title = [self.detailsArray valueForKey:@"Name"];
   // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:185.0/255.0 blue:251.0/255.0 alpha:1]];
   // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:3.0/255.0 green:35.0/255.0 blue:102.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0/255.0 green:107.0/255.0 blue:241.0/255.0 alpha:1]];

  //  [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    // Do any additional setup after loading the view, typically from a nib.
    if (self.editMode) {
        self.enableFields=TRUE;
    }else{
        self.enableFields=FALSE;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    self.opDataDo = [[OppDataDO alloc] init];
    self.opDataDo.contactId = [self.detailsArray valueForKey:@"Id"];
    
    ateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                target:self
                                              selector:@selector(rotateMove)
                                              userInfo:nil
                                               repeats:YES];

}
-(void)rotateMove{
    [SVProgressHUD dismiss];
}

-(IBAction)back:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.enableFields) {
        return 2;
    }else{
        return 1;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    //return [self.detailsArray count];
    if(section == 0){
        //return 6;
        if (self.enableFields) {
            return 3;
        }else{
            return 3;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    if(indexPath.section ==0){
        if(indexPath.row ==0){
            InitialViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InitialDetailViewCellIdentifier"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.displayIcon.layer setCornerRadius:50.0f];
            [cell.displayIcon.layer setBorderWidth:3.0f];
            [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];

//            NSString *color=[delegate.colorcode valueForKey:[[[self.detailsArray valueForKey:@"Name"] substringToIndex:1] uppercaseString]];
            //NSArray *array=[color componentsSeparatedByString:@","];
//            [cell.displayIcon setBackgroundColor:[UIColor colorWithRed:[[array objectAtIndex:0] floatValue]/255.0f green:[[array objectAtIndex:1] floatValue]/255.0f blue:[[array objectAtIndex:2] floatValue]/255.0f alpha:1.0f]];
            [cell.displayIcon setTitle:[[[self.detailsArray valueForKey:@"Name"] substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
            [cell.displayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Profile_BG.png"]]];
            [cell.displayIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            NSString *titleStr =[self.detailsArray valueForKey:@"Title"];
            
            if (titleStr!=nil && ![titleStr isEqual:@"<null>"] &&![titleStr isKindOfClass:[NSNull class]] && [titleStr length]>0) {
                cell.title.text = [self.detailsArray valueForKey:@"Title"];
            }else{
                cell.title.text = @"NA";
            }
            // name
            NSString *nameStr =[self.detailsArray valueForKey:@"Name"];
            if (nameStr!=nil && ![nameStr isEqual:@"<null>"] &&![nameStr isKindOfClass:[NSNull class]] && [nameStr length]>0) {
                cell.name.text = [self.detailsArray valueForKey:@"Name"];
            }else{
                cell.name.text = @"NA";
            }
            // last name
            NSString *lastnameStr =[self.detailsArray valueForKey:@"LastName"];
            if (lastnameStr!=nil && ![lastnameStr isEqual:@"<null>"] &&![lastnameStr isKindOfClass:[NSNull class]] && [lastnameStr length]>0) {
                cell.lastName.text = [self.detailsArray valueForKey:@"LastName"];
            }else{
                cell.lastName.text = @"NA";
            }
            return cell;

        }else if(indexPath.row ==1){
            TextFieldCell *cell =nil;
            static NSString *rowIdentifier = @"TextFieldCellIdentifier1";
            cell = [self.actionList dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell.textfield setDelegate:self];
            [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
            [cell.textfield setTag:1001];
            if (self.enableFields) {
                [cell.textfield setEnabled:TRUE];
                [cell.textfieldTitle setText:@"Phone Number"];
                [cell.textfield setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
                if (self.opDataDo.phoneno!=nil && ![self.opDataDo.phoneno isEqual:@"<null>"] &&![self.opDataDo.phoneno isKindOfClass:[NSNull class]] && [self.opDataDo.phoneno length]>0) {
                    [cell.textfield setText:self.opDataDo.phoneno];
                }else{
                    [cell.textfield setText:@""];
                }
            }else{
                [cell.textfield setEnabled:FALSE];
                [cell.textfieldTitle setText:@"Phone Number"];
                self.opDataDo.phoneno =  [self.detailsArray valueForKey:@"Phone"];
                if (self.opDataDo.phoneno!=nil && ![self.opDataDo.phoneno isEqual:@"<null>"] &&![self.opDataDo.phoneno isKindOfClass:[NSNull class]] && [self.opDataDo.phoneno length]>0) {
                    [cell.textfield setText:self.opDataDo.phoneno];
                }else{
                    [cell.textfield setText:@""];
                }
                
            }
            return cell;

        }else{
            TextFieldCell *cell =nil;
            static NSString *rowIdentifier = @"TextFieldCellIdentifier1";
            cell = [self.actionList dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell.textfield setDelegate:self];
            [cell.textfield setKeyboardType:UIKeyboardTypeDefault];
            [cell.textfield setTag:1002];
            if (self.enableFields) {
                [cell.textfield setEnabled:TRUE];
                [cell.textfieldTitle setText:@"Email"];
                [cell.textfield setKeyboardType:UIKeyboardTypeEmailAddress];
                if (self.opDataDo.email!=nil && ![self.opDataDo.email isEqual:@"<null>"] &&![self.opDataDo.email isKindOfClass:[NSNull class]] && [self.opDataDo.email length]>0) {
                 [cell.textfield setText:self.opDataDo.email];
                 }else{
                 [cell.textfield setText:@""];
                 }
            }else{
                [cell.textfield setEnabled:FALSE];
                [cell.textfieldTitle setText:@"Email"];
                self.opDataDo.email =  [self.detailsArray valueForKey:@"Email"];
                if (self.opDataDo.email!=nil && ![self.opDataDo.email isEqual:@"<null>"] &&![self.opDataDo.email isKindOfClass:[NSNull class]] && [self.opDataDo.email length]>0) {
                 [cell.textfield setText:self.opDataDo.email];
                 }else{
                 [cell.textfield setText:@""];
                 }
                
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
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer hiding the empty Table View cells
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0){
        if(indexPath.row ==0){
            return 189;

        }else{
            return 75;
        }
    }else{
        return 75;
    }
}
- (void)keyboardDidShow:(NSNotification *)sender {

    if (!keyboardOpen) {
        self.keyboardOpen=TRUE;
        self.actionList.frame=CGRectMake(0, 0, self.view.frame.size.width, self.actionList.frame.size.height-250);
    }
}

- (void)keyboardDidHide:(NSNotification *)sender {
    if (keyboardOpen) {
        self.actionList.frame=CGRectMake(0, 0, self.view.frame.size.width, self.actionList.frame.size.height+250);
        keyboardOpen=FALSE;
    }
}

-(IBAction)editBtnTapped:(id)sender{
    if (!self.enableFields) {
        self.enableFields=TRUE;
        [self.editButton setEnabled:FALSE];
        
       /* UIImage *buttonImage = [UIImage imageNamed:@"Save.png"];// set your image Name
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:buttonImage forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = barButton;*/
        self.navigationItem.rightBarButtonItem = nil;
        [self.actionList reloadData];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:TRUE];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification  object:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSInteger nextTag = activeField.tag + 1;
    UIResponder* nextResponder = [self.actionList viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [self.activeField resignFirstResponder];
    }
    
    return FALSE;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.activeField=textField;
  if (self.activeField.tag == 1001){
        NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:0];
        [self.actionList scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    else if (self.activeField.tag == 1002){
        NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:0];
        [self.actionList scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
            
        case 1001:
            self.opDataDo.phoneno=textField.text;
            break;
        case 1002:
            self.opDataDo.email=textField.text;
            break;
            break;
        default:
            break;
    }
    
}

-(void)submitData{
    //    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT StageName,Probability,CloseDate, Amount, NextStep FROM opportunity WHERE stagename NOT IN ('Closed Won', 'Closed Lost')"]; // LIMIT 20
    
   // NSString *reqStr = [NSString stringWithFormat:@"SELECT StageName,Probability,CloseDate, Amount, NextStep FROM opportunity WHERE  StageName = NOT IN ('Closed Won', 'Closed Lost')"];
    
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
    [infoDict setObject:self.opDataDo.email forKey:@"Email"];
    [infoDict setObject:self.opDataDo.phoneno forKey:@"Phone"];
    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Contact" objectId:self.opDataDo.contactId fields:infoDict];
    [[SFRestAPI sharedInstance] send:request delegate:self];
    
}
- (void)send:(SFRestRequest *)request delegate:(nullable id<SFRestDelegate>)delegate{
    // showDetailsVC
}

#pragma mark - SFRestDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    [self rotateMove];
    if(jsonResponse !=nil && ![jsonResponse isEqual:@""] && [jsonResponse isEqual:@"<>"]){
        NSArray *records = jsonResponse[@"records"];
        NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
        //self.dataRows = [records mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.actionList reloadData];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        
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

@end
