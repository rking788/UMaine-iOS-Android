//
//  dbInitializer.m
//  iUMaine
//
//  Created by RKing on 4/20/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "dbInitializer.h"


@implementation DBInitializer

@synthesize managedObjectContext;

- (void) initDatabase{
    
    // Make sure the context is initialized
    if(managedObjectContext == nil){
        NSLog(@"Cannot initialize the database, the managedobjectcontext is not initialized");
    }
    
    // Init Commuter Lots
    [self initLotsOfType: @"commuter" withFile: @"/Users/rking/Desktop/commuter.csv"];
    
    // Init Faculty/Staff Lots
    [self initLotsOfType: @"faculty" withFile: @"/Users/rking/Desktop/faculty.csv"];
    
    // Init Resident Lots
    [self initLotsOfType: @"resident" withFile: @"/Users/rking/Desktop/resident.csv"];
    
    // Init Visitor Lots
    [self initLotsOfType: @"visitor" withFile: @"/Users/rking/Desktop/visitor.csv"];
    
    // Init Buildings
    [self initBuildingsWithFile: @"/Users/rking/Desktop/building_coords.csv"];
    
    // Init Employees
    [self initEmployeesWithFile: @"/Users/rking/Desktop/staff.csv"];
    
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
            lotObj = [NSEntityDescription insertNewObjectForEntityForName: @"ParkingLot" inManagedObjectContext: self.managedObjectContext];
            
            [lotObj setTitle:[[lineFields objectAtIndex:0] stringByReplacingOccurrencesOfString: @"\"" withString: @""]];
            [lotObj setPermittype: permitType];
            [lotObj setLatitude:[NSNumber numberWithInt:[[lineFields objectAtIndex: 1] integerValue]]];
            [lotObj setLongitude:[NSNumber numberWithInt:[[lineFields objectAtIndex: 2] integerValue]]];
            
        }
        
        cur = (NSString*)[enumer nextObject];
    }
    
    if(![self.managedObjectContext save:&err]){
        // Handle the error here
        NSLog(@"Failed to save the lot objects to managedObjectContext");
    }
    
    [fileContents release];
    
}

- (void) initBuildingsWithFile: (NSString*) filePath
{
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

- (void) initEmployeesWithFile: (NSString*) filePath
{
    NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath];
    
    NSError* err = nil;
    NSArray* lines = [fileContents componentsSeparatedByString:@"\n"];
    NSArray* lineFields = nil;
    NSEnumerator* enumer = [lines objectEnumerator];
    NSString* cur = [enumer nextObject];
    NSManagedObject* employeeObj = nil;
    
    // Employee Fields
    NSNumber* idint = nil;
    NSString* fname = nil;
    NSString* mname = nil;
    NSString* lname = nil;
    NSString* dept = nil;
    NSString* title = nil;
    NSString* phone = nil;
    NSString* email = nil;
    NSString* office = nil;
    NSString* deptURL = nil;
    NSString* personalURL = nil;
    
    while(cur){
        if([cur length] != 0){
            lineFields = [cur componentsSeparatedByString: @";"];
            employeeObj = [NSEntityDescription insertNewObjectForEntityForName: @"Employee" inManagedObjectContext: self.managedObjectContext];
    
            idint = [NSNumber numberWithInteger:[[[lineFields objectAtIndex: 0] stringByReplacingOccurrencesOfString: @"\"" withString: @""] integerValue]];
            fname = [[lineFields objectAtIndex: 1] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            mname = [[lineFields objectAtIndex: 2] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            lname = [[lineFields objectAtIndex: 3] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            dept = [[lineFields objectAtIndex: 4] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            title = [[lineFields objectAtIndex: 5] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            phone = [[lineFields objectAtIndex: 6] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            email = [[lineFields objectAtIndex: 7] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            office = [[lineFields objectAtIndex: 8] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            deptURL = [[lineFields objectAtIndex: 9] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            personalURL = [[lineFields objectAtIndex: 10] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            
            [employeeObj setValue: idint forKey: @"id"];
            [employeeObj setValue: fname forKey: @"fname"];
            [employeeObj setValue: mname forKey: @"mname"];
            [employeeObj setValue: lname forKey: @"lname"];
            [employeeObj setValue: dept forKey: @"department"];
            [employeeObj setValue: title forKey: @"title"];
            [employeeObj setValue: phone forKey: @"phone"];
            [employeeObj setValue: email forKey: @"email"];
            [employeeObj setValue: office forKey: @"office"];
            [employeeObj setValue: deptURL forKey: @"deptURL"];
            [employeeObj setValue: personalURL forKey: @"personalURL"];
        }
        
        cur = (NSString*)[enumer nextObject];
    }
    
    if(![self.managedObjectContext save:&err]){
        // Handle the error here
        NSLog(@"Failed to save the employee objects to managedObjectContext");
    }
    
    [fileContents release];
}

@end
