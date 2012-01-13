//
//  CampusSelectionViewController.m
//  iUMaine
//
//  Created by Robert King on 12/8/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import "CampusSelectionViewController.h"
#import "iUMaineAppDelegate.h"
#import "constants.h"

@implementation CampusSelectionViewController

@synthesize campusSelDict;
@synthesize selIndex;
@synthesize scD;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle: UITableViewStyleGrouped];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController.navigationBar setTintColor: [UIColor colorWithRed: (66.0/255.0) green: (41.0/255.0) blue: (3.0/255.0) alpha: 1.0]];
    [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithTitle: @"Save" style: UIBarButtonItemStyleDone target:self action: @selector(save)]];
    [self.tableView setBackgroundColor: [UIColor colorWithRed:(238.0/255.0) green:(230.0/255.0) blue:(192.0/255) alpha:1.0]];

    // Read in the dictionary of available campuses from the text file in the main bundle
    NSString* campusPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: CAMPUSDICTNAME];
    self.campusSelDict = [[NSDictionary alloc] initWithContentsOfFile: campusPath];
    
    NSArray* arr = [[self.campusSelDict allValues] sortedArrayUsingSelector: @selector( localizedCaseInsensitiveCompare:)];
    self.selIndex = [arr indexOfObject: @"Orono"];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationPortrait) ||
            (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.campusSelDict allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    UILabel* lbl = [cell textLabel];
    [lbl setText: [[[self.campusSelDict allValues] sortedArrayUsingSelector: @selector( localizedCaseInsensitiveCompare:)] objectAtIndex: indexPath.row]];

    if(self.selIndex == indexPath.row)
        [cell setAccessoryType: UITableViewCellAccessoryCheckmark];
    else
        [cell setAccessoryType: UITableViewCellAccessoryNone];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    [[tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: self.selIndex inSection: indexPath.section]] setAccessoryType: UITableViewCellAccessoryNone];
    
    self.selIndex = indexPath.row;
    [[tableView cellForRowAtIndexPath: indexPath] setAccessoryType: UITableViewCellAccessoryCheckmark];
}

- (void) save
{
    
    NSString* campLongName = [[[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: self.selIndex inSection:0]] textLabel] text];
 
    NSString* campShortName = [[self.campusSelDict allKeysForObject: campLongName] objectAtIndex: 0];
 
    // This variable needs to be set IMMEDIATELY so that the right .sqlite file will be used
    iUMaineAppDelegate* appD = (iUMaineAppDelegate*)[[UIApplication sharedApplication] delegate];
    [iUMaineAppDelegate setSelCampus: campShortName];
    [appD loadDefaultDB];
    
    [self.scD campusSelected: campShortName];
}

@end
