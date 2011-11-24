//
//  CourseDetailSelectionViewController.m
//  iUMaine
//
//  Created by Robert King on 11/9/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import "CourseDetailSelectionViewController.h"

@implementation CourseDetailSelectionViewController

@synthesize searchBar;
@synthesize contentArr;
@synthesize delegate;
@synthesize row;
@synthesize savedSearchTerm;
@synthesize searchResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    // Add save and cancel buttons to the navigation bar
    [self.navigationItem setLeftBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target: self action: @selector(cancel)]];
    [self.navigationController.navigationBar setTintColor: [UIColor colorWithRed: (66.0/255.0) green: (41.0/255.0) blue: (3.0/255.0) alpha: 1.0]];

    [self.searchBar setAutocapitalizationType: UITextAutocapitalizationTypeNone];
    [self.searchBar setAutocorrectionType: UITextAutocorrectionTypeNo];
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setContentArr: nil];
    [self setDelegate: nil];
    [self setSearchResults: nil];
    [self setSavedSearchTerm: nil];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) cancel
{
    [self.delegate detailSelection: nil ForSection: self.row];
    //[self dismissModalViewControllerAnimated: YES];
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
    NSInteger rows = 0;
    
    if(tableView != self.searchDisplayController.searchResultsTableView)
        rows = [self.contentArr count];
    else
        rows = [self.searchResults count];
    
    return rows;
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
    
    if(tableView != self.searchDisplayController.searchResultsTableView)
        [lbl setText: [self.contentArr objectAtIndex: indexPath.row]];
    else
        [lbl setText: [self.searchResults objectAtIndex: indexPath.row]];
    
    [lbl setTextColor: [UIColor colorWithRed:(66.0/255.0) green:(41.0/255.0) blue:(3.0/255) alpha:1.0]];
    UIFont* textFont = [UIFont fontWithName: @"Baskerville" size: 17.0];
    [lbl setFont: textFont];
    
    [tableView setBackgroundColor: [UIColor colorWithRed:(238.0/255.0) green:(230.0/255.0) blue:(192.0/255) alpha:1.0]];
    [tableView setSeparatorColor: [UIColor colorWithRed:(66.0/255.0) green:(41.0/255.0) blue:(3.0/255) alpha:1.0]];
    
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
     [detailViewController release];
     */
    [tableView deselectRowAtIndexPath: indexPath animated: YES];

    if(tableView != self.searchDisplayController.searchResultsTableView)
        [self.delegate detailSelection: [self.contentArr objectAtIndex: indexPath.row] ForSection: self.row];
    else
        [self.delegate detailSelection: [self.searchResults objectAtIndex: indexPath.row] ForSection: self.row];
}

#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{	
	[self handleSearchForTerm: searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	[self setSavedSearchTerm: nil];
	
	[self.tableView reloadData];
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{	
	[self setSavedSearchTerm: searchTerm];
	
	if ([self searchResults] == nil)
	{
        self.searchResults = [[NSMutableArray alloc] init];
	}
	
	[[self searchResults] removeAllObjects];
	
	if ([[self savedSearchTerm] length] != 0)
	{
		for (NSString* str in self.contentArr)
		{
			if ([str rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
			{
				[self.searchResults addObject: str];
			}
		}
	}
}

@end
