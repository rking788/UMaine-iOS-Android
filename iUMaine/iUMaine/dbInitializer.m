//
//  dbInitializer.m
//  iUMaine
//
//  Created by RKing on 4/20/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "dbInitializer.h"
#import "Course.h"

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
    
    // Init Fall 2011 courses
   // [self initCoursesForSeason: @"fall" andYear: @"2011"];
    
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
            float latfloat = [[lineFields objectAtIndex: 1] floatValue];
            float longfloat = [[lineFields objectAtIndex: 2] floatValue];
            NSInteger latInt = (NSInteger) ([[lineFields objectAtIndex: 1] floatValue] * 1000000.0);
            NSInteger longInt = (NSInteger) ([[lineFields objectAtIndex: 2] floatValue] * 1000000.0);
            [buildingObj setLatitude:[NSNumber numberWithInt: latInt]];
            [buildingObj setLongitude:[NSNumber numberWithInt: longInt]];
            
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

- (void) initCoursesForSeason: (NSString*) season andYear: (NSString*) year
{
    NSString* semester = [NSString stringWithFormat: @"%@%@", year, season];
    NSString* filePath = [NSString stringWithFormat: @"/Users/rking/Desktop/%@.csv", semester];
    NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath];
    
    NSLog(@"Loading courses from file: %@", filePath);
    
    NSError* err = nil;
    NSArray* lines = [fileContents componentsSeparatedByString:@"\n"];
    NSArray* lineFields = nil;
    NSEnumerator* enumer = [lines objectEnumerator];
    NSString* cur = [enumer nextObject];
    Course* courseObj = nil;
    
    // Employee Fields
    NSString* depart = nil;
    NSNumber* number = nil;
    NSString* title = nil;
    NSNumber* section = nil;
    NSString* type = nil;
    NSNumber* idNum = nil;
    NSString* days = nil;
    NSString* times = nil;
    NSString* location = nil;
    NSString* instructor = nil;
    NSDate* startDate = nil;
    NSDate* endDate = nil;
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"L/d/yy"];
    
    while(cur){
        if([cur length] != 0){
            lineFields = [cur componentsSeparatedByString: @";"];
            courseObj = [NSEntityDescription insertNewObjectForEntityForName: @"Course" inManagedObjectContext: self.managedObjectContext];
            
            depart = [[lineFields objectAtIndex: 1] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            number = [NSNumber numberWithInteger:[[[lineFields objectAtIndex: 2] stringByReplacingOccurrencesOfString: @"\"" withString: @""] integerValue]];
            title = [[lineFields objectAtIndex: 3] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            section = [NSNumber numberWithInteger: [[[lineFields objectAtIndex: 4] stringByReplacingOccurrencesOfString: @"\"" withString: @""] integerValue]];
            type = [[lineFields objectAtIndex: 5] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            idNum = [NSNumber numberWithInteger:[[[lineFields objectAtIndex: 6] stringByReplacingOccurrencesOfString: @"\"" withString: @""] integerValue]];
          
            if([[lineFields objectAtIndex: 7] isEqualToString: @"\"TBA\""]){
                days = nil;
                times = nil;
            }
            else{
                NSArray* daysTimes = [[lineFields objectAtIndex: 7] componentsSeparatedByString: @" "];
            
                days = [[daysTimes objectAtIndex: 0] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
                NSString* tempTimes = [NSString stringWithFormat: @"%@%@%@", [daysTimes objectAtIndex: 1], [daysTimes objectAtIndex: 2], [daysTimes objectAtIndex: 3]];
                times = [tempTimes stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            }
            location = [[lineFields objectAtIndex: 8] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            instructor = [[lineFields objectAtIndex: 9] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            NSArray* startEndArr = [[lineFields objectAtIndex: 10] componentsSeparatedByString: @" - "];
            
            if (![[lineFields objectAtIndex: 10] isEqualToString: @"\"TBA\""]){
                startDate = [df dateFromString: [[startEndArr objectAtIndex: 0] stringByReplacingOccurrencesOfString: @"\"" withString:@""]];
            
                endDate = [df dateFromString: [[startEndArr objectAtIndex: 1] stringByReplacingOccurrencesOfString: @"\"" withString: @""]];
            }
            else{
                startDate = nil;
                endDate = nil;
            }
            
            [courseObj setDepart: depart];
            [courseObj setNumber: number];
            [courseObj setTitle: title];
            [courseObj setSection: section];
            [courseObj setType: type];
            [courseObj setIdNum: idNum];
            [courseObj setDays: days];
            [courseObj setTimes: times];
            [courseObj setLocation: location];
            [courseObj setInstructor: instructor];
            [courseObj setStartDate: startDate];
            [courseObj setEndDate: endDate];
            [courseObj setSemester: semester];
        }
        
        cur = (NSString*)[enumer nextObject];
    }
    
    if(![self.managedObjectContext save:&err]){
        // Handle the error here
        NSLog(@"Failed to save the course objects to managedObjectContext during initialization");
    }
    
    [fileContents release];
    [df release];
}

@end
