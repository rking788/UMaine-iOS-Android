//
//  Schedule.h
//  iUMaine
//
//  Created by Robert King on 10/2/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Schedule : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * season;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSSet *courses;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
