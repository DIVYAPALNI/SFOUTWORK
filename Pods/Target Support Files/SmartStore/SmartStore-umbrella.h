#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SFAlterSoupLongOperation.h"
#import "SFQuerySpec.h"
#import "SFSmartSqlHelper.h"
#import "SFSmartStore.h"
#import "SFSmartStoreDatabaseManager.h"
#import "SFSmartStoreInspectorViewController.h"
#import "SFSmartStoreUpgrade.h"
#import "SFSmartStoreUtils.h"
#import "SFSoupIndex.h"
#import "SFSoupSpec.h"
#import "SFStoreCursor.h"
#import "SalesforceSDKManagerWithSmartStore.h"
#import "SmartStore.h"

FOUNDATION_EXPORT double SmartStoreVersionNumber;
FOUNDATION_EXPORT const unsigned char SmartStoreVersionString[];

