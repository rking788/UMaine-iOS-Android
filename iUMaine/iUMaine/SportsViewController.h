//
//  SportsViewController.h
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iUMaineAppDelegate;

@interface SportsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    iUMaineAppDelegate* appDel;
    
    NSDictionary* sportsAbbrDict;
}

@property (nonatomic, retain) iUMaineAppDelegate* appDel;
@property (nonatomic, retain) NSDictionary* sportsAbbrDict;

@end
