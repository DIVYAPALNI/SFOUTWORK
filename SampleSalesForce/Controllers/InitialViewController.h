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

#import <UIKit/UIKit.h>
#import "Contacts.h"
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
#import "OppDataDO.h"
#import "SVProgressHUD.h"

@interface InitialViewController : UIViewController<SFRestDelegate>{
    NSTimer *ateTimer;

}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Contacts *contactIsFromDetailsView;;
@property (nonatomic, strong) NSMutableArray *detailsArray;
@property (assign,nonatomic) BOOL enableFields;
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic) BOOL showEditButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic,strong)OppDataDO *opDataDo;
@property (assign, nonatomic) BOOL keyboardOpen;
@property (strong, nonatomic) NSString *contactId;
@property (nonatomic, strong) UITextField *activeField;

@end
