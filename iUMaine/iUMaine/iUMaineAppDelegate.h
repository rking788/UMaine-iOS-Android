//
//  iUMaineAppDelegate.h
//  iUMaine
//
//  Created by Teacher on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iUMaineViewController;

@interface iUMaineAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet iUMaineViewController *viewController;

@end
