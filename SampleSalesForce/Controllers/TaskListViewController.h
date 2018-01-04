//
//  TaskListViewController.h
//  SampleSalesForce
//
//  Created by Apple on 10/26/17.
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
#import "OpportunityViewController.h"

//#import "EventDateView.h"
@protocol createdActivitiesDelagate <NSObject>
-(void)CreatedTask:(NSString *)typeIS;
-(void)CreatedEvent:(NSString *)typeIS;

@end

@interface TaskListViewController : UIViewController<SFRestDelegate,RelatedSelectDelagate>{
    NSTimer *ateTimer;
}
@property (nonatomic, strong) NSMutableArray *dataRows;
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (assign,nonatomic) BOOL enableFields;
@property (nonatomic, assign) BOOL editMode;
@property (assign, nonatomic) BOOL keyboardOpen;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePickerview;
@property (nonatomic,strong) UIToolbar *pickerToolBar;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewObj;
@property (assign, nonatomic) NSInteger selectedPicker;
@property (nonatomic,assign) NSInteger seletedPickerRow;
@property (nonatomic,strong)NSArray *pickerArray;
@property (nonatomic,strong)NSString *pickerArraytype;
@property (nonatomic, assign) BOOL pickerOpen;
@property (nonatomic,strong)OppDataDO *opDataDo;
@property (nonatomic, strong) UITextField *activeField;
@property (nonatomic) BOOL showEditButton;
@property (nonatomic,strong)NSString *selectedTypeIs;
@property (assign,nonatomic) id<createdActivitiesDelagate> create_Activites_delegate;


@end
