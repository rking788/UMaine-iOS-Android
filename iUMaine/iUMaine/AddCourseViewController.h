//
//  AddCourseViewController.h
//  iUMaine
//
//  Created by Robert King on 10/2/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCourseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UINavigationBar *navBar;
    UITableView *tableV;
    
    NSArray* lblStrs;
    NSMutableArray* detLblStrs;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UITableView *tableV;

@property (nonatomic, retain) NSArray* lblStrs;
@property (nonatomic, retain) NSMutableArray* detLblStrs;

- (void) cancel;

@end
