//
//  OppDataDO.m
//  SampleSalesForce
//
//  Created by Apple on 10/30/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "OppDataDO.h"

@implementation OppDataDO
@synthesize title;
@synthesize closeDate;
@synthesize companyName;
@synthesize statusMsg;
@synthesize rupees;
@synthesize whoid;
@synthesize stage;
@synthesize probability;
@synthesize amount;
@synthesize nextStep;
@synthesize recordId;
@synthesize createdDate;
@synthesize ownerName;
@synthesize email;
@synthesize phoneno;
@synthesize contactId;
// req
@synthesize startDate;
@synthesize endDate;
@synthesize whatId;
@synthesize productId;
@synthesize productName;

-(void) copyFrom:(OppDataMO *) OppDataMO{
    self.title=OppDataMO.title;
    self.closeDate=OppDataMO.closeDate;
    self.companyName=OppDataMO.companyName;
    self.statusMsg=OppDataMO.statusMsg;
    self.rupees=OppDataMO.rupees;
    self.whoid=OppDataMO.whoid;
    
    self.stage=OppDataMO.stage;
    self.probability=OppDataMO.probability;
    self.amount=OppDataMO.amount;
    self.nextStep=OppDataMO.nextStep;
    self.recordId=OppDataMO.recordId;
    self.ownerName=OppDataMO.ownerName;

    self.email=OppDataMO.email;
    self.phoneno=OppDataMO.phoneno;
    self.contactId=OppDataMO.contactId;
    self.startDate=OppDataMO.startDate;
    self.endDate=OppDataMO.endDate;
    self.whatId=OppDataMO.whatId;
    // new
    self.productName=OppDataMO.productName;
    self.productId=OppDataMO.productId;
}

-(void) copyTo:(OppDataMO *) OppDataMO{
    
  OppDataMO.title=  self.title;
  OppDataMO.closeDate =   self.closeDate;
  OppDataMO.companyName =  self.companyName;
  OppDataMO.statusMsg =   self.statusMsg;
  OppDataMO.rupees =   self.rupees;
   OppDataMO.whoid =  self.whoid;
    OppDataMO.stage =  self.stage;
    OppDataMO.probability =   self.probability;
    OppDataMO.amount =   self.amount;
    OppDataMO.nextStep =  self.nextStep;
    OppDataMO.recordId =  self.recordId;
    OppDataMO.ownerName =  self.ownerName;
    OppDataMO.phoneno =  self.phoneno;
    OppDataMO.email =  self.email;
    OppDataMO.contactId =  self.contactId;

    OppDataMO.startDate =  self.startDate;
    OppDataMO.endDate =  self.startDate;
    OppDataMO.whatId =  self.whatId;

    // new
    OppDataMO.productName = self.productName;
    OppDataMO.productId = self.productId;

}
- (OppDataDO *)initWithTaskDictionary:(NSDictionary*)dictionary{
  //  self.util=[[Utilities alloc] init];
    
    if([dictionary objectForKey:@"title"] != nil && ![[dictionary objectForKey:@"title"] isKindOfClass:[NSNull class]]){
        [self setTitle:[dictionary objectForKey:@"title"]];
    }
    if([dictionary objectForKey:@"date"] != nil && ![[dictionary objectForKey:@"date"] isKindOfClass:[NSNull class]]){
        [self setCloseDate:[dictionary objectForKey:@"date"]];
    }
    if([dictionary objectForKey:@"companyName"] != nil && ![[dictionary objectForKey:@"companyName"] isKindOfClass:[NSNull class]]){
        [self setCompanyName:[dictionary objectForKey:@"companyName"]];
    }
    if([dictionary objectForKey:@"statusMsg"] != nil && ![[dictionary objectForKey:@"statusMsg"] isKindOfClass:[NSNull class]]){
        [self setStatusMsg:[dictionary objectForKey:@"statusMsg"]];
    }
    if([dictionary objectForKey:@"rupees"] != nil && ![[dictionary objectForKey:@"rupees"] isKindOfClass:[NSNull class]]){
        [self setRupees:[dictionary objectForKey:@"rupees"]];
    }
    if([dictionary objectForKey:@"whoid"] != nil && ![[dictionary objectForKey:@"whoid"] isKindOfClass:[NSNull class]]){
        [self setWhoid:[dictionary objectForKey:@"whoid"]];
    }
    if([dictionary objectForKey:@"Id"] != nil && ![[dictionary objectForKey:@"Id"] isKindOfClass:[NSNull class]]){
        [self setRecordId:[dictionary objectForKey:@"Id"]];
    }
    if([dictionary objectForKey:@"Id"] != nil && ![[dictionary objectForKey:@"Id"] isKindOfClass:[NSNull class]]){
        [self setRecordId:[dictionary objectForKey:@"Id"]];
    }

    return self;
    
}

+ (id) objectWithDictionary:(NSDictionary*)dictionary{
    id obj = [[OppDataDO alloc] initWithTaskDictionary:dictionary];
    return obj;
}

/*-(NSMutableDictionary*)dictionaryWithTaskRepresentation{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    self.util=[[Utilities alloc] init];
    if (self.logtype!=nil && [self.logtype length]>0) {
        [dict setObject:self.logtype forKey:@"logtype"];
    }
    if (self.punchintime!=nil && [self.punchintime length]>0) {
        [dict setObject:self.punchintime forKey:@"punchintime"];
    }
    if (self.purpose!=nil && [self.purpose length]>0) {
        [dict setObject:self.purpose forKey:@"purpose"];
    }
    if (![Utilities objectIsNull:self.addressDict]) {
        [dict setObject:self.addressDict forKey:@"locationin"];
    }else{
        [dict setObject:@"" forKey:@"locationin"];
    }
    
    
    return dict;
    
}*/

@end
