//
//  AvailableCourses.h
//  iUMaine
//
//  Created by Robert King on 11/3/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AvailableCourses : NSManagedObject

@property (nonatomic, retain) NSString * semesterStr;
@property (nonatomic, retain) NSSet *courses;
@end

@interface AvailableCourses (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(NSManagedObject *)value;
- (void)removeCoursesObject:(NSManagedObject *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
