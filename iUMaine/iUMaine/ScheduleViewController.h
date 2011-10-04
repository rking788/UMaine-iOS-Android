//
//  ScheduleViewController.h
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleTabView;

@interface ScheduleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    ScheduleTabView *schedTabView;
    UITableView *contentTable;
    UITableViewCell *scheduleCourseCell;
}
@property (nonatomic, retain) IBOutlet ScheduleTabView *schedTabView;
@property (nonatomic, retain) IBOutlet UITableView *contentTable;
@property (nonatomic, retain) IBOutlet UITableViewCell *scheduleCourseCell;

- (void) addBtnClicked;
- (void) hideEmptySeparators;

@end
