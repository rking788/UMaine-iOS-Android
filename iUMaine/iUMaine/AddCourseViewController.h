//
//  AddCourseViewController.h
//  iUMaine
//
//  Created by Robert King on 10/2/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDetailSelectionViewController.h"

@class Course;

@protocol AddCourseToScheduleDelegate <NSObject>

- (void) addCourse: (Course*) _c;

@end

@interface AddCourseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CourseDetailSelectionDelegate> {
    UINavigationBar *navBar;
    UITableView *tableV;
    
    NSString* semStr;
    
    NSArray* lblStrs;
    NSMutableArray* detLblStrs;
    
    NSArray* departArr;
    NSArray* courseNumArr;
    NSArray* sectionArr;
    
    id<AddCourseToScheduleDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UITableView *tableV;

@property (nonatomic, retain) NSString* semStr;

@property (nonatomic, retain) NSArray* lblStrs;
@property (nonatomic, retain) NSMutableArray* detLblStrs;

@property (nonatomic, retain) NSArray* departArr;
@property (nonatomic, retain) NSArray* courseNumArr;
@property (nonatomic, retain) NSArray* sectionArr;

@property (nonatomic, retain) id<AddCourseToScheduleDelegate> delegate;

- (void) cancel;
- (void) addCourse;
- (void) showSelectionViewController: (NSArray*) contents ForSelectedRow: (NSUInteger) row;
- (void) checkLastViewedDepart;
- (void) setLastViewedDepart: (NSString*) departStr;
- (void) loadDeparts;
- (void) loadCourseNumsWithDepart: (NSString*) depart;
- (void) loadSectionsWithDepart: (NSString*) depart WithCourseNum: (NSString*) num;

@end
