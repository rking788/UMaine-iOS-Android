//
//  CourseDetailViewController.h
//  iUMaine
//
//  Created by Robert King on 11/12/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface CourseDetailViewController : UIViewController{
    UILabel* deptNumLbl;
    
    Course* course;
}

@property (retain, nonatomic) IBOutlet UILabel *deptNumLbl;
@property (retain, nonatomic) IBOutlet UILabel *titleLbl;
@property (retain, nonatomic) IBOutlet UILabel *daysTimesLbl;
@property (retain, nonatomic) IBOutlet UILabel *instructorLbl;
@property (retain, nonatomic) IBOutlet UILabel *locationLbl;

@property (nonatomic, retain) Course* course;

@end
