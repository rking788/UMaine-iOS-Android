//
//  ScheduleViewController.h
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCourseViewController.h"
#import "ScheduleTabView.h"

@class ScheduleTabView;
@class iUMaineAppDelegate;
@class Course;

@interface ScheduleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddCourseToScheduleDelegate, ScheduleDisplayDelegate> {

    ScheduleTabView *schedTabView;
    UITableView *contentTable;
    UITableViewCell *scheduleCourseCell;
    
    iUMaineAppDelegate* appDel;
    
    NSUserDefaults* userDefs;
    NSString* semStr;
    
    /* This array stores a list of courses for the "Active Schedule" or active semester
     * the courses are sorted based on their starting times, it makes it quicker when
     * populating the UITableView
     */
    NSMutableArray* activeCourses;
    NSMutableDictionary* schedulesDict;
}
@property (nonatomic, retain) IBOutlet ScheduleTabView *schedTabView;
@property (nonatomic, retain) IBOutlet UITableView *contentTable;
@property (nonatomic, retain) IBOutlet UITableViewCell *scheduleCourseCell;

@property (nonatomic, retain) iUMaineAppDelegate* appDel;

@property (nonatomic, retain) NSUserDefaults* userDefs;
@property (nonatomic, retain) NSString* semStr;
@property (nonatomic, retain) NSMutableArray* activeCourses;
@property (nonatomic, retain) NSMutableDictionary* schedulesDict;

- (void) addBtnClicked;
- (void) hideEmptySeparators;
- (void) loadSchedulesIntoDict: (NSMutableDictionary*) schedules;
+ (NSString*) scheduleTitleFromSemesters: (NSArray*) sems;
+ (NSMutableArray*) sortCourses: (NSSet*) unsortedCourses;
+ (void) insertCourse: (Course*) c IntoArray: (NSMutableArray*) outArr;
+ (float) courseStartTime: (Course*) c;

@end
