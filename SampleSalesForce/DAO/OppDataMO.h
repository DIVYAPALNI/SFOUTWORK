//
//  OppDataMO.h
//  
//
//  Created by Apple on 10/30/17.
//
//

#import <CoreData/CoreData.h>

@interface OppDataMO : NSManagedObject
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
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *whatId;
// new
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productId;

@end
