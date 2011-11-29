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
    UITableViewCell *__unsafe_unretained currentEventCell;
    UITableViewCell *__unsafe_unretained otherEventCell;
    UITableView *tableV;

    BOOL firstView;
    
    NSString* curSport;
    UIActionSheet* actSheet;
}
@property (nonatomic, strong) IBOutlet UITableView *tableV;
@property (nonatomic, unsafe_unretained) IBOutlet UITableViewCell *currentEventCell;
@property (nonatomic, unsafe_unretained) IBOutlet UITableViewCell *otherEventCell;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *loadingView;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;

@property (nonatomic, strong) iUMaineAppDelegate* appDel;
@property (nonatomic, strong) NSDictionary* sportsAbbrDict;
@property (nonatomic, strong) NSDictionary* eventsDict;
@property (nonatomic, strong) NSDictionary* eventsSubSetDict;

@property (nonatomic, assign, getter = isFirstView) BOOL firstView;

@property (nonatomic, strong) NSString* curSport;
@property (nonatomic, strong) UIActionSheet* actSheet;

- (void) showLoadingView;
- (void) loadSportsEvents;
- (NSInteger) pastPresentFutureDate: (NSDate*) date;
- (void) selectSportBtnClicked;
- (void) dismissActionSheet;
- (void) showEventsForSport: (NSString*) sport;
- (void) scrollToCurrentOrFutureEvents: (BOOL) force;
- (void) displayLoadingView;
- (void) hideLoadingView;
- (void) displayEvents;

@end
