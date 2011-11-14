//
//  SportsViewController.h
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iUMaineAppDelegate;

#define PREV_KEY    @"previous"
#define CUR_KEY     @"current"
#define FUT_KEY     @"future"

@interface SportsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource> {
    iUMaineAppDelegate* appDel;
    
    NSDictionary* sportsAbbrDict;
    NSDictionary* eventsDict;
    NSDictionary* eventsSubSetDict;
    UITableViewCell *currentEventCell;
    UITableViewCell *otherEventCell;
    UITableView *tableV;

    BOOL firstView;
    
    NSString* curSport;
    UIActionSheet* actSheet;
}
@property (nonatomic, retain) IBOutlet UITableView *tableV;
@property (nonatomic, assign) IBOutlet UITableViewCell *currentEventCell;
@property (nonatomic, assign) IBOutlet UITableViewCell *otherEventCell;

@property (nonatomic, retain) iUMaineAppDelegate* appDel;
@property (nonatomic, retain) NSDictionary* sportsAbbrDict;
@property (nonatomic, retain) NSDictionary* eventsDict;
@property (nonatomic, retain) NSDictionary* eventsSubSetDict;

@property (nonatomic, assign, getter = isFirstView) BOOL firstView;

@property (nonatomic, retain) NSString* curSport;
@property (nonatomic, retain) UIActionSheet* actSheet;

- (void) showLoadingView;
- (void) loadSportsEvents;
- (NSInteger) pastPresentFutureDate: (NSDate*) date;
- (void) selectSportBtnClicked;
- (void) dismissActionSheet;
- (void) showEventsForSport: (NSString*) sport;
- (void) scrollToCurrentOrFutureEvents: (BOOL) force;

@end
