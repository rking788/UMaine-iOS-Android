//
//  ScheduleTabView.h
//  iUMaine
//
//  Created by Robert King on 10/1/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum TABVIEWTAGS
{
    kMONTAG = 30,
    kTUETAG = 31,
    kWEDTAG = 32,
    kTHUTAG = 33,
    kFRITAG = 34,
    kWEEKTAG = 35
} TABVIEWTAGS;

@protocol ScheduleDisplayDelegate <NSObject>

- (void) activeDayChanged;

@end

@interface ScheduleTabView : UIView
{
    NSInteger actTag;

    id<ScheduleDisplayDelegate> __unsafe_unretained delegate;
}

@property (nonatomic, assign) NSInteger actTag;

@property (unsafe_unretained) id<ScheduleDisplayDelegate> delegate;

- (void) tabPressed: (id) sender;
- (NSString*) activeDay;

@end
