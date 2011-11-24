//
//  CourseDetailViewController.m
//  iUMaine
//
//  Created by Robert King on 11/12/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import "CourseDetailViewController.h"

@implementation CourseDetailViewController
@synthesize deptNumLbl;
@synthesize titleLbl;
@synthesize daysTimesLbl;
@synthesize instructorLbl;
@synthesize locationLbl;
@synthesize course;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialize the labels with the given course information
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterNoStyle];
    [self.deptNumLbl setText: [NSString stringWithFormat: @"%@ %@", 
                               [self.course depart], 
                               [formatter  stringFromNumber: [self.course number]]]];
    [self.titleLbl setText: [self.course title]];
    if(![[self.course days] isEqualToString: @"TBA"]){
        [self.daysTimesLbl setText: [NSString stringWithFormat: @"%@ %@", [self.course days], [self.course times]]];
    }
    else{
        [self.daysTimesLbl setText: @"TBA"];
    }
    [self.instructorLbl setText: [self.course instructor]];
    [self.locationLbl setText: [self.course location]];
}

- (void)viewDidUnload
{
    [self setDeptNumLbl:nil];
    [self setTitleLbl:nil];
    [self setDaysTimesLbl:nil];
    [self setInstructorLbl:nil];
    [self setLocationLbl:nil];
    [self setCourse: nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
