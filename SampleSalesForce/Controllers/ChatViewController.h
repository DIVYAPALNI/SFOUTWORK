//
//  ChatViewController.h
//  SampleSalesForce
//
//  Created by Apple on 11/17/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OppDataDO.h"
#import <SalesforceSDKCore/SFRestAPI.h>
#import "SalesforceSDKManager.h"
#import <SalesforceSDKCore/SFRestRequest.h>
#import "SFDefaultUserManagementViewController.h"
#import "InitialViewController.h"
#import "Contacts.h"
#import "AppDelegate.h"
#import "AddRecords.h"
#import "SFIdentityData.h"
#import "SFUserAccountManager.h"
#import "SFRestAPI.h"
#import "SFLogger.h"
#import "SalesforceSDKManagerWithSmartStore.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "Utilities.h"

@interface ChatViewController : UIViewController<SFRestDelegate>{
    NSTimer *ateTimer;
    CGFloat redLevel;
    CGFloat greenLevel;
    CGFloat blueLevel;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;

}
@property (nonatomic,strong) NSMutableArray *infoArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSString *recordId;
@property (nonatomic, strong) NSMutableArray *dataRows;
// display values
@property (strong, nonatomic) NSString *oppNameStr;
@property (strong, nonatomic) NSString *ownerNameStr;
@property (strong, nonatomic) NSString *oppCreatedDateStr;
//comments
@property (strong, nonatomic) NSString *commentCount;
//display array objects
@property (strong, nonatomic) NSString *oppFieldNameStr;
@property (strong, nonatomic) NSString *oppNewAmountStr;
@property (strong, nonatomic) NSString *oppOldAmountStr;
@property (strong, nonatomic) NSString *oppNewStageStr;
@property (strong, nonatomic) NSString *oppOldStageStr;
@property (strong, nonatomic) NSString *oppNewProbStr;
@property (strong, nonatomic) NSString *oppOldProbStr;
@property (strong, nonatomic) NSString *oppStatusStr;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextFld;

// button actions
- (IBAction)sendBtnTapped:(id)sender;

@end
