//
//  Schedule.h
//  iUMaine
//
//  Created by Robert King on 11/6/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSString * semester;
@property (nonatomic, retain) NSSet *courses;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
