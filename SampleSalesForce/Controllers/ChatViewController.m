//
//  ChatViewController.m
//  SampleSalesForce
//
//  Created by Apple on 11/17/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "ChatViewController.h"
#import "TextFieldCell.h"

@interface ChatViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) Utilities *util;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Comments";
    self.util = [[Utilities alloc] init];

    self.dataRows = [[NSMutableArray alloc] init];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:3.0/255.0 green:35.0/255.0 blue:102.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0/255.0 green:107.0/255.0 blue:241.0/255.0 alpha:1]];

    UIImage *buttonImage = [UIImage imageNamed:@"arrow_back.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    self.navigationItem.rightBarButtonItem = nil;
    NSLog(@"infor array is%@",self.infoArray);
    NSString *str = [NSString stringWithFormat:@"SELECT ID,(SELECT Id, CommentBody, FeedItemId,CreatedDate,CreatedBy.FirstName,CreatedBy.LastName FROM FeedComments) FROM FeedItem WHERE  ParentId = '%@'",self.recordId];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:str];
    [[SFRestAPI sharedInstance] send:request delegate:self];

    ateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                target:self
                                              selector:@selector(rotateMove)
                                              userInfo:nil
                                               repeats:YES];

//    int totalSizeis = [[[self.infoArray  objectAtIndex:indexPath.row] objectForKey:@"totalSize"] intValue];
//    if(totalSizeis == 1){
//    }else if(totalSizeis == 2){
//
//    }else if(totalSizeis == 3){
//
//    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     redLevel    = rand() / (float) RAND_MAX;
     greenLevel  = rand() / (float) RAND_MAX;
     blueLevel   = rand() / (float) RAND_MAX;
    
//    self.view.backgroundColor = [UIColor colorWithRed: redLevel
//                                                green: greenLevel
//                                                 blue: blueLevel
//                                                alpha: 1.0];

}
-(void)rotateMove{
    [SVProgressHUD dismiss];
}
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    [self rotateMove];
        NSMutableArray *records;
        NSDictionary *feedCommentsDict = [[NSDictionary alloc] init];
    NSMutableArray *feedCommentArray = [[NSMutableArray alloc] init];

        if(jsonResponse !=nil && ![jsonResponse isEqual:@""] && ![jsonResponse isEqual:@"<>"]){
            records = jsonResponse[@"records"];
            NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
            NSLog(@"rec: %@", records); // array
            for(NSDictionary *dict in records){
                feedCommentsDict = [dict valueForKey:@"FeedComments"];
                //[self.dataRows addObject:feedCommentsDict];
                if ([feedCommentsDict isKindOfClass:[NSNull class]]) {
                    
                }else{
                    feedCommentArray = [feedCommentsDict objectForKey:@"records"];
                    for(NSDictionary *dict in feedCommentArray){
                        [self.dataRows addObject:dict];
                    }

                }

            }
            NSLog(@"dataRows: %@", self.dataRows); // array
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"No data found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section ==0){
        return 1;
    }
    else  if(section ==1){
        return [self.dataRows count];
    }
    else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
            TextFieldCell *cell =nil;
            static NSString *rowIdentifier = @"TextFieldCellIdentifierFeed";
            cell = [self.tableview dequeueReusableCellWithIdentifier:rowIdentifier forIndexPath:indexPath];
            [cell.textfield setDelegate:self];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            // display 
           [cell.displayIcon.layer setCornerRadius:30.0f];
           [cell.displayIcon.layer setBorderWidth:3.0f];
           [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
        [cell.displayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Profile_Small.png"]]];
        [cell.displayIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [cell.displayIcon setTitle:[[self.oppNameStr substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
       // [cell.displayIcon.layer setBorderColor:[UIColor colorWithRed:39.0/255.0 green:66.0/255.0 blue:123.0/255.0 alpha:1].CGColor];
        NSString *title = [NSString stringWithFormat:@"%@-%@",self.oppNameStr,self.ownerNameStr];
         cell.titleName.text = title;
         cell.CreatedDate.text = [self fullDate:self.oppCreatedDateStr];
        
        int totalSizeis = [[self.infoArray valueForKey:@"totalSize"] intValue];
        if(totalSizeis == 1){
            NSArray *updateFieldArray = [[self.infoArray valueForKey:@"records"] valueForKey:@"FieldName"];
            NSString *updateFieldIs;
            for(int i=0; i<[updateFieldArray count];i++){
                updateFieldIs = [updateFieldArray objectAtIndex:i];
                //amount
                if([updateFieldIs isEqualToString:@"Opportunity.Amount"]){
                    // amount object
                    NSArray *newAmountArray =[[self.infoArray  valueForKey:@"records"] valueForKey:@"NewValue"];
                    NSNumber *newamountint;
                    NSArray *oldAmountArray =[[self.infoArray valueForKey:@"records"] valueForKey:@"OldValue"];
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
                    NSString *amount = [NSString stringWithFormat:@"Amount from $%@to$%@",oldAmountStr,newAmountStr];
                   // cell.amountLbl.text = amount;
                    [self setOppStatusStr:[NSString stringWithFormat:@"%@",amount]];
                }
                else if([updateFieldIs isEqualToString:@"Opportunity.StageName"]){
                    NSArray *newStageArray = [[self.infoArray  valueForKey:@"records"] valueForKey:@"NewValue"];
                    NSArray *oldStageArray = [[self.infoArray  valueForKey:@"records"] valueForKey:@"OldValue"];
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
                    NSString *displayStage = [NSString stringWithFormat:@"%@ %@to%@",@"Stage from",oldStageStr,newStageStr];
                  //  cell.amountLbl.text = displayStage;
                    //[self setOppStatusStr:[NSString stringWithFormat:@"%@,%@",self.oppStatusStr,displayStage]];
                    [self setOppStatusStr:[NSString stringWithFormat:@"%@",displayStage]];
                }
                else if([updateFieldIs isEqualToString:@"Opportunity.Probability"]){
                    NSArray *newProbArray = [[self.infoArray valueForKey:@"records"] valueForKey:@"NewValue"];
                    NSArray *oldProbArray = [[self.infoArray  valueForKey:@"records"] valueForKey:@"OldValue"];
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
                    NSString *displayProb = [NSString stringWithFormat:@"%@ %@to%@",@"Probability(%) from",oldProbStr,newProbStr];
                    //cell.amountLbl.text = displayProb;
                   // [self setOppStatusStr:[NSString stringWithFormat:@"%@,%@",self.oppStatusStr,displayProb]];
                    [self setOppStatusStr:[NSString stringWithFormat:@"%@",displayProb]];

                }
            }
            cell.oppStatusLbl.text = self.oppStatusStr;
        }
        else if(totalSizeis == 2){
            // updated records
            NSArray *updateFieldArray = [[self.infoArray  valueForKey:@"records"] valueForKey:@"FieldName"];
            NSString *updateFieldIs;
            
            for(int i=0; i<[updateFieldArray count];i++){
                updateFieldIs = [updateFieldArray objectAtIndex:i];
                //amount
                if([updateFieldIs isEqualToString:@"Opportunity.Amount"]){
                    // amount object
                    NSArray *newAmountArray =[[self.infoArray valueForKey:@"records"] valueForKey:@"NewValue"];
                    NSNumber *newamountint;
                    NSArray *oldAmountArray =[[self.infoArray valueForKey:@"records"] valueForKey:@"OldValue"];
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
                    NSString *amount = [NSString stringWithFormat:@"Amount from $%@to$%@",oldAmountStr,newAmountStr];
                   // cell.amountLbl.text = amount;
                    [self setOppStatusStr:[NSString stringWithFormat:@"%@,%@",self.oppStatusStr,amount]];
                }
                else if([updateFieldIs isEqualToString:@"Opportunity.StageName"]){
                    NSArray *newStageArray = [[self.infoArray  valueForKey:@"records"] valueForKey:@"NewValue"];
                    NSArray *oldStageArray = [[self.infoArray   valueForKey:@"records"] valueForKey:@"OldValue"];
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
                    NSString *displayStage = [NSString stringWithFormat:@"%@%@to%@",@"Stage from",oldStageStr,newStageStr];
                   // cell.stageLbl.text = displayStage;
                    [self setOppStatusStr:[NSString stringWithFormat:@"%@",displayStage]];
                }
                else if([updateFieldIs isEqualToString:@"Opportunity.Probability"]){
                    NSArray *newProbArray = [[self.infoArray  valueForKey:@"records"] valueForKey:@"NewValue"];
                    NSArray *oldProbArray = [[self.infoArray valueForKey:@"records"] valueForKey:@"OldValue"];
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
                    NSString *displayProb = [NSString stringWithFormat:@"%@ %@to%@",@"Probability(%) from",oldProbStr,newProbStr];
                   // cell.amountLbl.text = displayProb;
                    [self setOppStatusStr:[NSString stringWithFormat:@"%@,%@",self.oppStatusStr,displayProb]];

                }
            }
            cell.oppStatusLbl.text = self.oppStatusStr;
        } else if(totalSizeis == 3){
            // updated records
            NSArray *updateFieldArray = [[self.infoArray  valueForKey:@"records"] valueForKey:@"FieldName"];
            NSString *updateFieldIs;
            
            for(int i=0; i<[updateFieldArray count];i++){
                updateFieldIs = [updateFieldArray objectAtIndex:i];
                
                if([updateFieldIs isEqualToString:@"Opportunity.Amount"]){
                    // amount object
                    NSArray *newAmountArray =[[self.infoArray  valueForKey:@"records"] valueForKey:@"NewValue"];
                    NSNumber *newamountint;
                    NSArray *oldAmountArray =[[self.infoArray  valueForKey:@"records"] valueForKey:@"OldValue"];
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
                    NSString *amount = [NSString stringWithFormat:@"Amount from $%@to$%@",oldAmountStr,newAmountStr];
                    //cell.amountLbl.text = amount;
                   // [self setOppStatusStr:[NSString stringWithFormat:@"%@",amount]];
                    [self setOppStatusStr:[NSString stringWithFormat:@"%@,%@",self.oppStatusStr,amount]];

                }
                else if([updateFieldIs isEqualToString:@"Opportunity.StageName"]){
                    NSArray *newStageArray = [[self.infoArray valueForKey:@"records"] valueForKey:@"NewValue"];
                    NSArray *oldStageArray = [[self.infoArray  valueForKey:@"records"] valueForKey:@"OldValue"];
                    
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
                    NSString *displayStage = [NSString stringWithFormat:@"%@%@to%@",@"Stage from ",oldStageStr,newStageStr];
                    //cell.stageLbl.text = displayStage;
                    [self setOppStatusStr:[NSString stringWithFormat:@"%@",displayStage]];
                }
                else if([updateFieldIs isEqualToString:@"Opportunity.Probability"]){
                    NSArray *newProbArray = [[self.infoArray valueForKey:@"records"] valueForKey:@"NewValue"];
                    NSArray *oldProbArray = [[self.infoArray  valueForKey:@"records"] valueForKey:@"OldValue"];
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
                        newProbStr = [NSString stringWithFormat:@"%@%@ ",newprob,@"%"];
                    }else{
                        newProbStr = @"nill";
                    }
                    //old value
                    if(oldprob!=nil && ![oldprob isEqual:@""] && ![oldprob isKindOfClass:[NSNull class]] &&![oldprob isEqualToString:@"<null>"]){
                        oldProbStr = [NSString stringWithFormat:@"%@%@ ",oldprob,@"%"];
                    }else{
                        oldProbStr = @"nill";
                    }
                    // display Prob is
                    NSString *displayProb = [NSString stringWithFormat:@"%@ %@to%@",@"Probability(%) from ",oldProbStr,newProbStr];
                    //cell.probabilityLbl.text = displayProb;
                    [self setOppStatusStr:[NSString stringWithFormat:@"%@,%@",self.oppStatusStr,displayProb]];

                }
            }
        }
        cell.oppStatusLbl.text = self.oppStatusStr;

       /* for(int i=0; i<[updateFieldArray count];i++){
            self.oppFieldNameStr = [updateFieldArray objectAtIndex:i];
            
            if([self.oppFieldNameStr isEqualToString:@"Opportunity.StageName"]){
                self.oppOldStageStr = [[self.infoArray valueForKey:@"records"] valueForKey:@"OldValue"];
                self.oppNewStageStr = [[self.infoArray valueForKey:@"records"] valueForKey:@"NewValue"];
            }else if([self.oppFieldNameStr isEqualToString:@"Opportunity.Amount"]){
                self.oppOldAmountStr = [[self.infoArray valueForKey:@"records"] valueForKey:@"OldValue"];
                self.oppNewAmountStr = [[self.infoArray valueForKey:@"records"] valueForKey:@"NewValue"];
            }else if([self.oppFieldNameStr isEqualToString:@"Opportunity.Probability"]){
                self.oppOldProbStr = [[self.infoArray valueForKey:@"records"] valueForKey:@"OldValue"];
                self.oppNewProbStr = [[self.infoArray valueForKey:@"records"] valueForKey:@"NewValue"];
            }
            // amount
            if(self.oppOldAmountStr!=nil && ![self.oppOldAmountStr isEqual:@""] && ![self.oppOldAmountStr isKindOfClass:[NSNull class]] &&![self.oppOldAmountStr isEqualToString:@"<null>"]){
                [self setOppStatusStr:[NSString stringWithFormat:@"%@",self.oppOldAmountStr]];
            }
            if(self.oppNewAmountStr!=nil && ![self.oppNewAmountStr isEqual:@""] && ![self.oppNewAmountStr isKindOfClass:[NSNull class]] &&![self.oppNewAmountStr isEqualToString:@"<null>"]){
                [self setOppStatusStr:[NSString stringWithFormat:@"$%@to$%@",self.oppStatusStr,self.oppNewAmountStr]];
            }
            // stage
            if(self.oppOldStageStr!=nil && ![self.oppOldStageStr isEqual:@""] && ![self.oppOldStageStr isKindOfClass:[NSNull class]] &&![self.oppOldStageStr isEqualToString:@"<null>"]){
                [self setOppStatusStr:[NSString stringWithFormat:@"%@,%@",self.oppStatusStr,self.oppOldStageStr]];
            }
            if(self.oppNewStageStr!=nil && ![self.oppNewStageStr isEqual:@""] && ![self.oppNewStageStr isKindOfClass:[NSNull class]] &&![self.oppNewStageStr isEqualToString:@"<null>"]){
                [self setOppStatusStr:[NSString stringWithFormat:@"%@to%@",self.oppStatusStr,self.oppNewStageStr]];
            }
            // probability
            if(self.oppOldProbStr!=nil && ![self.oppOldProbStr isEqual:@""] && ![self.oppOldProbStr isKindOfClass:[NSNull class]] &&![self.oppOldProbStr isEqualToString:@"<null>"]){
                [self setOppStatusStr:[NSString stringWithFormat:@"%@,%@",self.oppStatusStr,self.oppOldProbStr]];
            }
            if(self.oppNewStageStr!=nil && ![self.oppNewStageStr isEqual:@""] && ![self.oppNewStageStr isKindOfClass:[NSNull class]] &&![self.oppNewStageStr isEqualToString:@"<null>"]){
                [self setOppStatusStr:[NSString stringWithFormat:@"%@to%@",self.oppStatusStr,self.oppNewStageStr]];
            }
            cell.oppStatusLbl.text = self.oppStatusStr;

        }*/
        //self.oppCreatedDateStr;
        return cell;
    }else if (indexPath.section==1) {
        static NSString *CellIdentifier= @"TextFieldCellIdentifierComment";
        TextFieldCell* cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.textfield setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.displayIcon.layer setCornerRadius:20.0f];
        [cell.displayIcon.layer setBorderWidth:3.0f];
        [cell.displayIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
        [cell.displayIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Profile_Small.png"]]];
        [cell.displayIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.displayIcon setTitle:[[self.ownerNameStr substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
        NSString *title = [NSString stringWithFormat:@"%@",self.ownerNameStr];
        cell.titleName.text = title;
        NSString *createDateStr = [self fullDate:[[self.dataRows  objectAtIndex:indexPath.row] objectForKey:@"CreatedDate"]];
        cell.CreatedDate.text = createDateStr;
        NSString *comment = [[self.dataRows  objectAtIndex:indexPath.row] objectForKey:@"CommentBody"];
        cell.commentTextView.text = comment;
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section ==0) {
        return 115;
    } else if(indexPath.section ==1) {
        return 125;
    }else{
        return 0;
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
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd MMMM yyyy hh:mm a" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        userVisibleDateTimeString = [dateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = textInputView.frame;
        frame.origin.y -= kbSize.height;
        textInputView.frame = frame;
        
       // frame = bubbleTable.frame;
       // frame.size.height -= kbSize.height;
       // bubbleTable.frame = frame;
    }];
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = textInputView.frame;
        frame.origin.y += kbSize.height;
        textInputView.frame = frame;
        //frame = bubbleTable.frame;
       // frame.size.height += kbSize.height;
       // bubbleTable.frame = frame;
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:TRUE];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification  object:nil];
}
-(IBAction)createdFeedComment:(id)sender{
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
    if(self.commentsTextFld.text !=nil && self.commentsTextFld.text !=nil && ![self.commentsTextFld.text isEqual:@""] && ![self.commentsTextFld.text isEqual:@"<>"]){
        [infoDict setObject:self.recordId forKey:@"ParentId"];
       // [infoDict setObject:@"" forKey:@"Id"];
        [infoDict setObject:self.commentsTextFld.text forKey:@"CommentBody"];
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"FeedComment" objectId:self.recordId fields:infoDict];
        [[SFRestAPI sharedInstance] send:request delegate:self];
    }else{
        [self.util showAlert:@"Comments cannot be empty" title:@""];
    }    
  //  SELECT Id,ParentId,CommentBody,CommentType,Status FROM FeedComment

}
@end
