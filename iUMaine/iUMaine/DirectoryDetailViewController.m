//
//  DirectoryDetailViewController.m
//  iUMaine
//
//  Created by Robert King on 8/6/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import "DirectoryDetailViewController.h"
#import "Employee.h"

@implementation DirectoryDetailViewController
@synthesize nameLbl;
@synthesize titleLbl;
@synthesize infoTableView;
@synthesize employee;
@synthesize empDict;

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

    // Set the name label
    NSString* nameStr = [NSString stringWithFormat: @"%@, %@ %@", [self.employee valueForKey: @"lname"], 
                         [self.employee valueForKey: @"fname"],
                         [self.employee valueForKey: @"mname"]];
    [self.nameLbl setText: nameStr];
    [self.titleLbl setText: [self.employee title]];

    // Fill employee information dictionary (should do it this way instead of just accessing
    // the Employee object directly in case there is missing information just makes it easier i think)
    [self fillEmployeeDict: self.employee];
}

- (void)viewDidUnload
{
    [self setNameLbl:nil];
    [self setTitleLbl:nil];
    [self setInfoTableView:nil];
    [self setEmployee: nil];
    [self setEmpDict: nil];
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
    [nameLbl release];
    [titleLbl release];
    [infoTableView release];
    [employee release];
    [empDict release];
    [super dealloc];
}

- (void) fillEmployeeDict:(Employee *)emp
{
    self.empDict = [[NSMutableDictionary alloc] init];
    
    // TODO: STill need to figure out how to set the order of these sections in the table view, 
    // Also need to change the section titles most are too long
    
    // Department
    if([self.employee department])
        [self.empDict setObject: [self.employee department] forKey: @"Department"];
    
    // Department URL
    if([self.employee deptURL])
        [self.empDict setObject: [self.employee deptURL] forKey: @"Department Website"];
    
    // Office
    if([self.employee office])
        [self.empDict setObject: [self.employee office] forKey: @"Office"];

    // Phone
    if(![[self.employee valueForKey: @"phone"] isEqualToString: @"NULL"])
        [self.empDict setObject: [self.employee valueForKey: @"phone"] forKey: @"Phone"];
    
    // Email
    if(![[self.employee valueForKey: @"email"] isEqualToString: @"NULL"])
        [self.empDict setObject: [self.employee valueForKey: @"email"] forKey: @"EMail Address"];
}

#pragma mark - Table view data source delegate methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.empDict allKeys] count];
}
                                     
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EmployeeInfoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    UILabel* lbl = [cell textLabel];
    UILabel* lbl2 = [cell detailTextLabel];
    
    NSString* titleStr = [[self.empDict allKeys] objectAtIndex: indexPath.section];
    NSString* contentStr = [self.empDict objectForKey: titleStr];
    
    [lbl setText: titleStr];
    [lbl2 setText: contentStr];
    
    return cell;
}

#pragma mark - Table view delegate methods
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

@end
