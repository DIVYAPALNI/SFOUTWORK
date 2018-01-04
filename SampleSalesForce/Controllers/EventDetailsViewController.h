//
//  EventDetailsViewController.h
//  SampleSalesForce
//
//  Created by Apple on 10/31/17.
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

@protocol selectedCalendarListDelegate <NSObject>
//- (void)gotoSelectedContactVC:(id)contact formID:(NSString *)formId ;
- (void)selectedCalendarEventVc:(NSString *)eventType;
- (void)selectedCalendarTaskVc:(NSString *)taskType;

@end


@interface EventDetailsViewController : UIViewController<SFRestDelegate>{
    NSTimer *ateTimer;
}
@property (assign,nonatomic) BOOL enableFields;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
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
@property (nonatomic, assign) BOOL editMode;
@property (assign, nonatomic) BOOL keyboardOpen;
@property (assign, nonatomic)NSMutableDictionary* stagesDict;
@property (assign, nonatomic)NSMutableDictionary* probDict;
@property (nonatomic) BOOL showEditButton;
@property (nonatomic,strong) NSMutableArray *infoArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic,strong)NSString *recordObjectId;
@property (nonatomic, strong) NSString *selectedTypeIs;
@property (strong, nonatomic) NSString *selectedSegmentType;
@property (strong, nonatomic) id<selectedCalendarListDelegate> selcted_calendar_List_Delegate;


@end
