//
//  OppDataDAO.m
//  SampleSalesForce
//
//  Created by Apple on 10/30/17.
//  Copyright © 2017 SampleSalesForceOrganizationName. All rights reserved.
//

#import "OppDataDAO.h"

@implementation OppDataDAO

@synthesize managedObjectContext;

-(id) init {
    self = [super init];
    
    if (self) {
        if (self.managedObjectContext == nil) {
            self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
            NSLog(@"After managedObjectContext: %@",  self.managedObjectContext);
        }
    }
    return self;
}

-(NSFetchRequest *) fetchedRequest {
    NSEntityDescription *enti = [NSEntityDescription entityForName:@"Opportunity" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:enti];
    return request;
}


-(NSFetchRequest *) fetchedRequest:(NSString *) entityName {
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    return request;
}

// create transaction with TransaxionDataDO
-(BOOL)insertOrderProductData:(OppDataDO*)OppDataDOData whoid:(NSString *)whoId {
    
    NSError *error;
    
    [OppDataDOData setWhoid:whoId];
    OppDataMO *entity=(OppDataMO*)[NSEntityDescription insertNewObjectForEntityForName:@"Opportunity" inManagedObjectContext:managedObjectContext];
    
    [OppDataDOData copyTo:entity];
    [self.managedObjectContext insertObject:entity];
    [self.managedObjectContext save:&error];
    
    if (error) {
        return FALSE;
    } else {
        
        return TRUE;
    }
}
-(NSMutableArray*)getOrderProductData:(NSString*)whoid
{
    NSError *error;
    NSFetchRequest* request=[self fetchedRequest];
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"(Whoid=%@)",whoid];
    [request setPredicate:pred];
    OppDataMO *matches=nil;
    NSArray *objects=[self.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    if ([objects count]==0) {
        NSLog(@"No matches found");
        return nil;
    }else{
        for (int i=0; i<[objects count]; i++) {
            OppDataDO *project=[[OppDataDO alloc]init];
            matches=objects[i];
            [project copyFrom:matches];
            [array addObject:project];
        }
        
    }
    return array;
    
}

@end
