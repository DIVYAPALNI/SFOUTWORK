//
//  OppDataDAO.h
//  SampleSalesForce
//
//  Created by Apple on 10/30/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OppDataDO.h"
#import "OppDataMO.h"
#import "AppDelegate.h"

@interface OppDataDAO : NSObject
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

//-(BOOL)insertOrderProductData:(NSString *)groupId;
-(BOOL)insertOrderProductData:(OppDataDO*)transData groupID:(NSString *)groupId ;
-(NSMutableArray*)getOrderProductData:(NSString*)groupId;
@end
