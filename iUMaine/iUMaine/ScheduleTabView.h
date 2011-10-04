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

@interface ScheduleTabView : UIView
{
    NSInteger actTag;
}

@property (nonatomic, assign) NSInteger actTag;

- (void) tabPressed: (id) sender;

@end
