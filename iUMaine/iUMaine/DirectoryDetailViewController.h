//
//  DirectoryDetailViewController.h
//  iUMaine
//
//  Created by Robert King on 8/6/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Employee;

@interface DirectoryDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
                UIActionSheetDelegate>{
    UILabel *nameLbl;
    UILabel *titleLbl;
    UITableView *infoTableView;
    
    Employee* employee;
}

@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UITableView *infoTableView;

@property (strong, nonatomic) Employee* employee;
@property (strong, nonatomic) NSMutableDictionary* empDict;

- (void) fillEmployeeDict: (Employee*) emp;

@end
