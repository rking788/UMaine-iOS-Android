//
//  AddCourseViewController.m
//  iUMaine
//
//  Created by Robert King on 10/2/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import "AddCourseViewController.h"

@implementation AddCourseViewController
@synthesize navBar;
@synthesize tableV;
@synthesize lblStrs;
@synthesize detLblStrs;

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
    
    // Add save and cancel buttons to the navigation bar
    [self.navBar.topItem setLeftBarButtonItem: [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target: self action: @selector(cancel)] autorelease]];
    [self.navBar.topItem setRightBarButtonItem: [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target: self action: nil] autorelease]];
    
    // Set the labels to be displayed in the rows of the table view
    self.lblStrs = [NSArray arrayWithObjects: @"Department", @"Course Number", @"Section", nil];
    self.detLblStrs = [NSMutableArray arrayWithObjects: @"ECE", @"", @"", nil];
}

- (void)viewDidUnload
{
    [self setNavBar:nil];
    [self setTableV:nil];
    [self setLblStrs: nil];
    [self setDetLblStrs: nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [navBar release];
    [tableV release];
    [lblStrs release];
    [detLblStrs release];
    [super dealloc];
}

- (void) cancel
{
    [self dismissModalViewControllerAnimated: YES];
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lblStrs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddCourseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    UILabel* lbl = [cell textLabel];
    UILabel* lbl2 = [cell detailTextLabel];
    
    // [lbl setText: @"Course Name"];
    // [lbl setTextColor: [UIColor colorWithRed:(66.0/255.0) green:(41.0/255.0) blue:(3.0/255) alpha:1.0]];
    // UIFont* textFont = [UIFont fontWithName: @"Baskerville" size: 17.0];
    // [lbl setFont: textFont];
    // [lbl2 setText: @"12:00 PM"];
    
    [lbl setText: [self.lblStrs objectAtIndex: indexPath.row]];
    NSString* detText = [self.detLblStrs objectAtIndex: indexPath.row];
    
    if(detText && (![detText isEqualToString: @""]))
       [lbl2 setText: detText];
    else
       [lbl2 setText: @"Select one"];
       
    [cell setAccessoryType: UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
    
}

@end
