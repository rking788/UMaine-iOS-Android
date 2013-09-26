//
//  dbInitializer.m
//  iUMaine
//
//  Created by RKing on 4/20/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "dbInitializer.h"
#import "Course.h"

#define USM_CAMPUS  1

@implementation DBInitializer

@synthesize managedObjectContext;

- (void) initDatabaseWithCampus: (NSString*) _campus{
    
    // Make sure the context is initialized
    if(managedObjectContext == nil){
        NSLog(@"Cannot initialize the database, the managedobjectcontext is not initialized");
    }
    
    NSString* bundlePath = [[NSBundle mainBundle] resourcePath];

    // Init All Lots
    NSString* tempStr = [NSString stringWithFormat: @"lots_%@.csv", _campus];
    [self initLotsWithFile: [bundlePath stringByAppendingPathComponent: tempStr]];
    
#if 0 
    // Init Commuter Lots
    NSString* tempStr = [NSString stringWithFormat: @"commuter_%@.csv", _campus];
    [self initLotsOfType: @"commuter" withFile: [bundlePath stringByAppendingPathComponent: tempStr]];

    // Init Faculty/Staff Lots
    tempStr = [NSString stringWithFormat: @"faculty_%@.csv", _campus];
    [self initLotsOfType: @"faculty" withFile: [bundlePath stringByAppendingPathComponent: tempStr]];
    
    // Init Resident Lots
    tempStr = [NSString stringWithFormat: @"resident_%@.csv", _campus];
    [self initLotsOfType: @"resident" withFile: [bundlePath stringByAppendingPathComponent: tempStr]];
    
    // Init Visitor Lots
    tempStr = [NSString stringWithFormat: @"visitor_%@.csv", _campus];
    [self initLotsOfType: @"visitor" withFile: [bundlePath stringByAppendingPathComponent: tempStr]];
#endif
    // Init Buildings
    tempStr = [NSString stringWithFormat: @"buildings_%@.csv", _campus];
    [self initBuildingsWithFile: [bundlePath stringByAppendingPathComponent: tempStr]];
    
    // Init Employees
    tempStr = [NSString stringWithFormat: @"directory_%@.csv", _campus];
    [self initEmployeesWithFile: [bundlePath stringByAppendingPathComponent: tempStr]];
    
    // Init Fall 2011 courses
   // [self initCoursesForSeason: @"fall" andYear: @"2011"];
    
}

- (void) initLotsOfType:(NSString*) permitType withFile:(NSString*) filePath{
    //NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath];
    NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath encoding: NSUTF8StringEncoding error: nil];
    
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
            
            [lotObj setValue: [[lineFields objectAtIndex:0] stringByReplacingOccurrencesOfString: @"\"" withString: @""] forKey: @"title"];
            [lotObj setValue: permitType forKey: @"permittype"];
            [lotObj setValue: [NSNumber numberWithInt:[[lineFields objectAtIndex: 1] integerValue]] forKey: @"latitude"];
            [lotObj setValue: [NSNumber numberWithInt:[[lineFields objectAtIndex: 2] integerValue]] forKey: @"longitude"];
#if USM_CAMPUS
            NSInteger campusNum = (NSInteger) [[[lineFields objectAtIndex: 4] stringByReplacingOccurrencesOfString: @"\"" withString: @""] integerValue];
            [lotObj setValue: [NSNumber numberWithInt: campusNum] forKey: @"campusNum"];
#endif
        }
        
        cur = (NSString*)[enumer nextObject];
    }
    
    if(![self.managedObjectContext save:&err]){
        // Handle the error here
        NSLog(@"Failed to save the lot objects to managedObjectContext");
    }
    
    
}

- (void) initLotsWithFile:(NSString*) filePath{
    //NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath];
    NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath encoding: NSUTF8StringEncoding error: nil];
    
    NSError* err = nil;
    NSArray* lines = [fileContents componentsSeparatedByString:@"\n"];
    NSArray* lineFields = nil;
    NSEnumerator* enumer = [lines objectEnumerator];
    NSString* cur = [enumer nextObject];
    NSManagedObject* lotObj = nil; 
    
    while(cur){
        if([cur length] != 0){
            lineFields = [cur componentsSeparatedByString: @";"];
            lotObj = [NSEntityDescription insertNewObjectForEntityForName: @"ParkingLot" inManagedObjectContext: self.managedObjectContext];
            
            [lotObj setValue: [[lineFields objectAtIndex: 0] stringByReplacingOccurrencesOfString: @"\"" withString: @""] forKey: @"title"];
            [lotObj setValue: [NSNumber numberWithInt: [[[lineFields objectAtIndex: 1] stringByReplacingOccurrencesOfString: @"\"" withString: @""] integerValue]] forKey: @"latitude"];
            [lotObj setValue: [NSNumber numberWithInt:[[[lineFields objectAtIndex: 2] stringByReplacingOccurrencesOfString: @"\"" withString: @""] integerValue]] forKey: @"longitude"];
            [lotObj setValue: [[lineFields objectAtIndex: 3] stringByReplacingOccurrencesOfString: @"\"" withString: @""]  forKey: @"permittype"];
#if USM_CAMPUS
            NSInteger campusNum = (NSInteger) [[[lineFields objectAtIndex: 4] stringByReplacingOccurrencesOfString: @"\"" withString: @""] integerValue];
            [lotObj setValue: [NSNumber numberWithInt: campusNum] forKey: @"campusNum"];
#endif
        }
        
        cur = (NSString*)[enumer nextObject];
    }
    
    if(![self.managedObjectContext save:&err]){
        // Handle the error here
        NSLog(@"Failed to save the lot objects to managedObjectContext");
    }
    
    
}

- (void) initBuildingsWithFile: (NSString*) filePath
{
    //NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath];
    NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath encoding: NSUTF8StringEncoding error: nil];
    
    NSError* err = nil;
    NSArray* lines = [fileContents componentsSeparatedByString:@"\n"];
    NSArray* lineFields = nil;
    NSEnumerator* enumer = [lines objectEnumerator];
    NSString* cur = [enumer nextObject];
    NSManagedObject* buildingObj = nil;
    
    while(cur){
        if([cur length] != 0){
            lineFields = [cur componentsSeparatedByString: @";"];
            buildingObj = [NSEntityDescription insertNewObjectForEntityForName: @"Building" inManagedObjectContext: managedObjectContext];
            
            [buildingObj setValue: [[lineFields objectAtIndex:0] stringByReplacingOccurrencesOfString: @"\"" withString: @""] forKey: @"title"];
            
            //NSInteger latInt = (NSInteger) ([[[lineFields objectAtIndex: 1] stringByReplacingOccurrencesOfString: @"\"" withString: @""] floatValue] * 1000000.0);
            //NSInteger longInt = (NSInteger) ([[[lineFields objectAtIndex: 2] stringByReplacingOccurrencesOfString: @"\"" withString: @""] floatValue] * 1000000.0);
            NSInteger latInt = (NSInteger) [[[lineFields objectAtIndex: 1] stringByReplacingOccurrencesOfString: @"\"" withString: @""] integerValue];
            NSInteger longInt = (NSInteger)[[[lineFields objectAtIndex: 2] stringByReplacingOccurrencesOfString: @"\"" withString: @""] integerValue];
#if USM_CAMPUS
            NSInteger campusNum = (NSInteger) [[[lineFields objectAtIndex: 4] stringByReplacingOccurrencesOfString: @"\"" withString: @""] integerValue];
            [buildingObj setValue: [NSNumber numberWithInt: campusNum] forKey: @"campusNum"];
#endif
            [buildingObj setValue: [NSNumber numberWithInt: latInt] forKey: @"latitude"];
            [buildingObj setValue: [NSNumber numberWithInt: longInt] forKey: @"longitude"];
        }
        
        cur = (NSString*)[enumer nextObject];
    }
    
    if(![managedObjectContext save:&err]){
        // Handle the error here
        NSLog(@"Failed to save the building objects to managedObjectContext");
    }
    
}

- (void) initEmployeesWithFile: (NSString*) filePath
{
    NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath encoding:NSUTF8StringEncoding error: nil];
    
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
            deptURL = nil;
            personalURL = nil;
            //deptURL = [[lineFields objectAtIndex: 9] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            //personalURL = [[lineFields objectAtIndex: 10] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
            
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
    
}

- (void) initCoursesForSeason: (NSString*) season andYear: (NSString*) year
{
    NSString* semester = [NSString stringWithFormat: @"%@%@", year, season];
    NSString* bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString* fileName = [NSString stringWithFormat: @"%@.csv", semester];
    NSString* filePath = [bundlePath stringByAppendingPathComponent: fileName];
//    NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath];
    NSString* fileContents = [[NSString alloc] initWithContentsOfFile: filePath encoding: NSUTF8StringEncoding error: nil];
    
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
    
}

@end
