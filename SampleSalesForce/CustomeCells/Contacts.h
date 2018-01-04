//
//  Contacts.h
//  SampleSalesForce
//
//  Created by vamsee on 11/05/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Contacts : NSManagedObject
@property (nonatomic, retain) NSString * contactId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;

@end
