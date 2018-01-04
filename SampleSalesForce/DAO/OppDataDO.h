//
//  OppDataDO.h
//  SampleSalesForce
//
//  Created by Apple on 10/30/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OppDataMO.h"

@interface OppDataDO : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *closeDate;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *statusMsg;
@property (nonatomic, strong) NSString *rupees;
@property (nonatomic, strong) NSString *whoid;
@property (nonatomic, strong) NSString *stage;
@property (nonatomic, strong) NSString *probability;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *nextStep;
@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phoneno;
@property (nonatomic, strong) NSString *contactId;
//requried
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *whatId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productId;

-(void) copyFrom:(OppDataMO *) OppDataMO;
-(void) copyTo:(OppDataMO *) OppDataMO;
- (OppDataDO *)initWithTaskDictionary:(NSDictionary*)dictionary;
+ (id) objectWithDictionary:(NSDictionary*)dictionary;



@end
