//
//  Course.h
//  iUMaine
//
//  Created by Robert King on 11/3/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AvailableCourses;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSNumber * section;
@property (nonatomic, retain) NSString * semester;
@property (nonatomic, retain) NSString * instructor;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * days;
@property (nonatomic, retain) NSString * times;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * idNum;
@property (nonatomic, retain) NSString * depart;
@property (nonatomic, retain) AvailableCourses *semesteravailable;
@property (nonatomic, retain) NSManagedObject *schedule;

@end
