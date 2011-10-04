//
//  AddCourseViewController.h
//  iUMaine
//
//  Created by Robert King on 10/2/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCourseViewController : UIViewController {
    UINavigationBar *navBar;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

- (void) cancel;

@end
