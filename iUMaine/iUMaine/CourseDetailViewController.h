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

@property (strong, nonatomic) IBOutlet UILabel *deptNumLbl;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *daysTimesLbl;
@property (strong, nonatomic) IBOutlet UILabel *instructorLbl;
@property (strong, nonatomic) IBOutlet UILabel *locationLbl;

@property (nonatomic, strong) Course* course;

@end
