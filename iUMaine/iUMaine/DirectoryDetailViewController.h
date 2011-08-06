//
//  DirectoryDetailViewController.h
//  iUMaine
//
//  Created by Robert King on 8/6/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Employee;

@interface DirectoryDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UILabel *nameLbl;
    UILabel *titleLbl;
    UITableView *infoTableView;
    
    Employee* employee;
}

@property (retain, nonatomic) IBOutlet UILabel *nameLbl;
@property (retain, nonatomic) IBOutlet UILabel *titleLbl;
@property (retain, nonatomic) IBOutlet UITableView *infoTableView;

@property (retain, nonatomic) Employee* employee;
@property (retain, nonatomic) NSMutableDictionary* empDict;

- (void) fillEmployeeDict: (Employee*) emp;

@end
