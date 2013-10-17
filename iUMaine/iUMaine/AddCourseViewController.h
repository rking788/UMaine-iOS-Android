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

@interface AddCourseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIBarPositioningDelegate,CourseDetailSelectionDelegate> {
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

@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) IBOutlet UITableView *tableV;

@property (nonatomic, strong) NSString* semStr;

@property (nonatomic, strong) NSArray* lblStrs;
@property (nonatomic, strong) NSMutableArray* detLblStrs;

@property (nonatomic, strong) NSArray* departArr;
@property (nonatomic, strong) NSArray* courseNumArr;
@property (nonatomic, strong) NSArray* sectionArr;

@property (nonatomic, strong) id<AddCourseToScheduleDelegate> delegate;

- (void) cancel;
- (void) addCourse;
- (void) showSelectionViewController: (NSArray*) contents ForSelectedRow: (NSUInteger) row;
- (void) checkLastViewedDepart;
- (void) setLastViewedDepart: (NSString*) departStr;
- (void) loadDeparts;
- (void) loadCourseNumsWithDepart: (NSString*) depart;
- (void) loadSectionsWithDepart: (NSString*) depart WithCourseNum: (NSString*) num;

@end
