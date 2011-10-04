//
//  ScheduleViewController.m
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleTabView.h"
#import "AddCourseViewController.h"

@implementation ScheduleViewController
@synthesize schedTabView;
@synthesize contentTable;
@synthesize scheduleCourseCell;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem: UIBarButtonSystemItemAdd 
                                              target: self action: @selector(addBtnClicked)];
    
    // Set the table seperator color to that brownish color
    [self.contentTable setSeparatorColor: [UIColor colorWithRed:(66.0/255.0) green:(41.0/255.0) blue:(3.0/255) alpha:1.0]];

    // Not sure why this works ha, found it on StackOverflow
    // hides all separators under empty cells
    [self hideEmptySeparators];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [self setSchedTabView:nil];
    [self setContentTable:nil];
    [self setScheduleCourseCell:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [schedTabView release];
    [contentTable release];
    [scheduleCourseCell release];
    [super dealloc];
}

- (void) addBtnClicked
{
    AddCourseViewController* acvc = [[AddCourseViewController alloc] initWithNibName: @"AddCourseView" bundle: nil];
    
    [acvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController: acvc animated: YES];
    [acvc release];
}

- (void)hideEmptySeparators
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    [self.contentTable setTableFooterView:v];
    [v release];
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}


#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScheduleCourseCell";
    static NSString *CellNib = @"CustomScheduleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        
        cell = self.scheduleCourseCell;
    }
    
    UILabel* courseNumLbl = (UILabel*) [cell viewWithTag: 20];
    UILabel* titleLbl = (UILabel*) [cell viewWithTag: 21];
    UILabel* timeLbl = (UILabel*) [cell viewWithTag: 22];
    
    [titleLbl setText: @"Methods and Materials in Art Education "];
    
    // Configure the cell...
  //  UILabel* lbl = [cell textLabel];
  //  UILabel* lbl2 = [cell detailTextLabel];
    
   // [lbl setText: @"Course Name"];
   // [lbl setTextColor: [UIColor colorWithRed:(66.0/255.0) green:(41.0/255.0) blue:(3.0/255) alpha:1.0]];
   // UIFont* textFont = [UIFont fontWithName: @"Baskerville" size: 17.0];
   // [lbl setFont: textFont];
   // [lbl2 setText: @"12:00 PM"];
    
    return cell;

}

@end
