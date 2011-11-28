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

@interface ScheduleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
            AddCourseToScheduleDelegate, ScheduleDisplayDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {

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
                
    NSArray* allAvailableSemesters;
    UIActionSheet* actSheet;
}
@property (nonatomic, strong) IBOutlet ScheduleTabView *schedTabView;
@property (nonatomic, strong) IBOutlet UITableView *contentTable;
@property (nonatomic, strong) IBOutlet UITableViewCell *scheduleCourseCell;

@property (nonatomic, strong) iUMaineAppDelegate* appDel;

@property (nonatomic, strong) NSUserDefaults* userDefs;
@property (nonatomic, strong) NSString* semStr;
@property (nonatomic, strong) NSMutableArray* activeCourses;
@property (nonatomic, strong) NSMutableDictionary* schedulesDict;

@property (atomic, strong) NSArray* allAvailableSemesters;
@property (nonatomic, strong) UIActionSheet* actSheet;

- (void) addBtnClicked;
- (void) hideEmptySeparators;
- (void) loadSchedulesIntoDict: (NSMutableDictionary*) schedules;
- (void) switchToSemester: (NSString*) semesterStr;
+ (NSString*) scheduleTitleFromSemesters: (NSArray*) sems;
+ (NSMutableArray*) sortCourses: (NSSet*) unsortedCourses;
+ (void) insertCourse: (Course*) c IntoArray: (NSMutableArray*) outArr;
+ (float) courseStartTime: (Course*) c;
+ (NSString*) semesterStrToReadable: (NSString*) semStr;
- (void) showPickerview;
- (void) dismissActionSheet;

@end
