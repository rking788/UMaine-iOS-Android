//
//  Course.h
//  iUMaine
//
//  Created by Robert King on 11/6/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AvailableCourses, Schedule;

@interface Course : NSManagedObject

@property (nonatomic, strong) NSNumber * section;
@property (nonatomic, strong) NSString * semester;
@property (nonatomic, strong) NSString * instructor;
@property (nonatomic, strong) NSDate * endDate;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSString * days;
@property (nonatomic, strong) NSString * times;
@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSNumber * idNum;
@property (nonatomic, strong) NSString * depart;
@property (nonatomic, strong) AvailableCourses *semesteravailable;
@property (nonatomic, strong) Schedule *schedule;

@end
