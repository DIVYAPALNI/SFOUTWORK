//
//  ProdListViewController.m
//  SampleSalesForce
//
//  Created by Apple on 11/9/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "ProdListViewController.h"
#import "OppViewCell.h"

@interface ProdListViewController ()

@end

@implementation ProdListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Product List";
    UIImage *buttonImage = [UIImage imageNamed:@"arrow_back.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBtnItem;

    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeClear];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,IsActive,Family,ProductCode,CreatedDate,Id FROM Product2"];
    [[SFRestAPI sharedInstance] send:request delegate:self];
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
    if(jsonResponse !=nil && ![jsonResponse isEqual:@""] && ![jsonResponse isEqual:@"<>"]){
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
    return [self.dataRows count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.dataRows!=nil && [self.dataRows count]>0){
        OppViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"OppViewCellIdentifier"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSString *namestr =  [self.dataRows[indexPath.row] objectForKey:@"Name"];
        if(namestr !=nil && ![namestr isKindOfClass:[NSNull class]] &&![namestr isEqualToString:@"<null>"]){
            cell.prodName.text = namestr;
            
        }else{
            cell.prodName.text = @"Not available";
        }
        NSString *prodCode =  [self.dataRows[indexPath.row] objectForKey:@"ProductCode"];
        if(prodCode !=nil && ![prodCode isKindOfClass:[NSNull class]] &&![prodCode isEqualToString:@"<null>"]){
            cell.prodCode.text = prodCode;
            
        }else{
            cell.prodCode.text = @"Not available";
        }

        NSString *prodFamily =  [self.dataRows[indexPath.row] objectForKey:@"Family"];
        if(prodFamily !=nil && ![prodFamily isKindOfClass:[NSNull class]] &&![prodFamily isEqualToString:@"<null>"]){
            cell.prodFamily.text = prodFamily;
            
        }else{
            cell.prodFamily.text = @"Not available";
        }
        /*NSString *prodActive =  [self.dataRows[indexPath.row] objectForKey:@"IsActive"];
        if(prodActive !=nil && ![prodActive isKindOfClass:[NSNull class]] &&![prodActive isEqualToString:@"<null>"]){
            if([prodActive isEqualToString:@"0"]){
                [cell.checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"emptyCheckbox.png"] forState:UIControlStateNormal];
            }else{
                [cell.checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
            }
            
        }else{
            [cell.checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"emptyCheckbox.png"] forState:UIControlStateNormal];
        }*/
        int value = [[self.dataRows[indexPath.row] objectForKey:@"IsActive"] intValue];
        if(value == 1){
            [cell.checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        }else{
            [cell.checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"emptyCheckbox.png"] forState:UIControlStateNormal];
        }
        NSString*createdDateIS = [self fullDate:[self.dataRows[indexPath.row] objectForKey:@"CreatedDate"]];
        if (createdDateIS!=nil && ![createdDateIS isKindOfClass:[NSNull class]] &&![createdDateIS isEqualToString:@"<null>"]) {
            [cell.prodCreatedDate setText:createdDateIS];
        }else{
            [cell.prodCreatedDate setText:@""];
        }

        
        return cell;
    }else{
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
