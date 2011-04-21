//
//  dbInitializer.m
//  iUMaine
//
//  Created by RKing on 4/20/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

//#import "dbInitializer.h"


@implementation DBInitializer

@synthesize managedObjectContext;

- (void) initializeDatabase{
    
    // Make sure the context is initialized
    if(managedObjectContext == nil){
        NSLog(@"Cannot initialize the database, the managedobjectcontext is not initialized");
    }
    
    // Init Commuter Lots
    [self initLotsOfType: @"commuter" withFile: @"/Users/teacher/Desktop/commuter.csv"];
    
    // Init Faculty/Staff Lots
    [self initLotsOfType: @"faculty" withFile: @"/Users/teacher/Desktop/faculty.csv"];
    
    // Init Resident Lots
    [self initLotsOfType: @"resident" withFile: @"/Users/teacher/Desktop/resident.csv"];
    
    // Init Visitor Lots
    [self initLotsOfType: @"visitor" withFile: @"/Users/teacher/Desktop/visitor.csv"];
    
    // Init Buildings
    [self initBuildingsWithFile: @"/Users/teacher/Desktop/buildings.csv"];
    
}

- (void) initLotsOfType:(NSString*) permitType withFile:(NSString*) filePath{
    NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath];
    
    NSError* err = nil;
    NSArray* lines = [fileContents componentsSeparatedByString:@"\n"];
    NSArray* lineFields = nil;
    NSEnumerator* enumer = [lines objectEnumerator];
    NSString* cur = [enumer nextObject];
    NSManagedObject* lotObj = nil; 
    
    while(cur){
        if([cur length] != 0){
            lineFields = [cur componentsSeparatedByString: @","];
            lotObj = [NSEntityDescription insertNewObjectForEntityForName: @"ParkingLot" inManagedObjectContext: managedObjectContext];
            
            [lotObj setTitle:[[lineFields objectAtIndex:0] stringByReplacingOccurrencesOfString: @"\"" withString: @""]];
            [lotObj setPermittype: permitType];
            [lotObj setLatitude:[NSNumber numberWithInt:[[lineFields objectAtIndex: 1] integerValue]]];
            [lotObj setLongitude:[NSNumber numberWithInt:[[lineFields objectAtIndex: 2] integerValue]]];
            
        }
        
        cur = (NSString*)[enumer nextObject];
    }
    
    if(![managedObjectContext save:&err]){
        // Handle the error here
        NSLog(@"Failed to save the lot objects to managedObjectContext");
    }
    
    [fileContents release];
    
}

- (void) initBuildingsWithFile: (NSString*) filePath{
    NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath];
    
    NSError* err = nil;
    NSArray* lines = [fileContents componentsSeparatedByString:@"\n"];
    NSArray* lineFields = nil;
    NSEnumerator* enumer = [lines objectEnumerator];
    NSString* cur = [enumer nextObject];
    NSManagedObject* buildingObj = nil;
    
    while(cur){
        if([cur length] != 0){
            lineFields = [cur componentsSeparatedByString: @","];
            buildingObj = [NSEntityDescription insertNewObjectForEntityForName: @"Building" inManagedObjectContext: managedObjectContext];
            
            [buildingObj setTitle:[[lineFields objectAtIndex:0] stringByReplacingOccurrencesOfString: @"\"" withString: @""]];
            [buildingObj setLatitude:[NSNumber numberWithInt:[[lineFields objectAtIndex: 1] integerValue]]];
            [buildingObj setLongitude:[NSNumber numberWithInt:[[lineFields objectAtIndex: 2] integerValue]]];
            
        }
        
        cur = (NSString*)[enumer nextObject];
    }
    
    if(![managedObjectContext save:&err]){
        // Handle the error here
        NSLog(@"Failed to save the building objects to managedObjectContext");
    }
    
    [fileContents release];

}

@end
