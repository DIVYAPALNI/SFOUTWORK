//
//  NotesViewController.h
//  SampleSalesForce
//
//  Created by Apple on 11/10/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesforceSDKManager.h"
#import <SalesforceSDKCore/SFRestRequest.h>
#import "SFDefaultUserManagementViewController.h"
#import "InitialViewController.h"
#import "Contacts.h"
#import "AppDelegate.h"
#import "SFIdentityData.h"
#import "SFUserAccountManager.h"
#import "SFRestAPI.h"
#import "SFLogger.h"
#import "SalesforceSDKManagerWithSmartStore.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "OppDataDO.h"
#import "RelatedToViewController.h"

@interface NotesViewController : UIViewController<SFRestDelegate,RelatedSelectDelagate>{
    NSTimer *ateTimer;
}
@property (assign,nonatomic) BOOL enableFields;
@property (nonatomic, assign) BOOL editMode;
@property (assign, nonatomic) BOOL keyboardOpen;
@property (nonatomic, strong) NSMutableArray *dataRows;
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic,strong)OppDataDO *opDataDo;
@property (nonatomic, strong) UITextField *activeField;

@end
