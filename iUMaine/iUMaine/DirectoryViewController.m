
#import "DirectoryViewController.h"
#import "iUMaineAppDelegate.h"
#import "DirectoryDetailViewController.h"
#import "Employee.h"

@implementation DirectoryViewController

@synthesize mainTableView;
@synthesize employeeArr;
@synthesize searchResults;
@synthesize savedSearchTerm;

- (void)dealloc
{	
	//[mainTableView release], mainTableView = nil;
	[employeeArr release], employeeArr = nil;
	[searchResults release], searchResults = nil;
    [savedSearchTerm release], savedSearchTerm = nil;
    [super dealloc];
}

- (void)viewDidUnload
{	
	[super viewDidUnload];
	
	// Save the state of the search UI so that it can be restored if the view is re-created.
	[self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
	
	//[self setSearchResults:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Allocate the array of employee objects
    self.employeeArr = [[NSMutableArray alloc] init];
	
    // Fill the array of employees
    [self fillEmployees];
    
	// Restore search term
	if ([self savedSearchTerm]){
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{	
    [super viewWillAppear:animated];
	
	[self.mainTableView reloadData];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{	
	[self setSavedSearchTerm:searchTerm];
	
	if ([self searchResults] == nil)
	{
        self.searchResults = [[NSMutableArray alloc] init];
	}
	
	[[self searchResults] removeAllObjects];
	
	if ([[self savedSearchTerm] length] != 0)
	{
		for (Employee *emp in [self employeeArr])
		{
            NSString* currentString = [NSString stringWithFormat: @"%@, %@ %@", 
                                       [emp valueForKey: @"lname"], 
                                       [emp valueForKey: @"fname"], 
                                       [emp valueForKey:@"mname"], nil];
			if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
			{
				[self.searchResults addObject: emp];
			}
		}
	}
    NSLog(@"Finished Searching");
}

- (void) fillEmployees
{
    NSManagedObjectContext* manObjCon = [[iUMaineAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext: manObjCon];
    [fetchrequest setEntity:entity];
    
    NSSortDescriptor* sortDescript = [[NSSortDescriptor alloc] initWithKey:@"lname" ascending:YES];
    NSArray* sdArr = [[NSArray alloc] initWithObjects: sortDescript, nil];
    [fetchrequest setSortDescriptors: sdArr];
    
    NSDictionary* entityProps = [entity propertiesByName];
    NSArray* propArr = [[NSArray alloc] initWithObjects: [entityProps objectForKey: @"fname"], [entityProps objectForKey: @"mname"], [entityProps objectForKey:@"lname"], [entityProps objectForKey: @"title"], nil];
    [fetchrequest setPropertiesToFetch: propArr];
    
    NSError *error = nil;
    NSArray *array = [manObjCon executeFetchRequest:fetchrequest error:&error];
    if (array != nil) {
        
        for(Employee* emp in array){            
            [self.employeeArr addObject: emp];
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching the list of employees");
    }
    
    [propArr release];
    [sortDescript release];
    [sdArr release];
    [fetchrequest release];
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{	
	NSInteger rows;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView])
		rows = [[self searchResults] count];
	else
		rows = [[self employeeArr] count];

	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSInteger row = [indexPath row];
	NSString *contentForThisRow = nil;
    NSString* detailText = nil;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView]){
		contentForThisRow = [[[self searchResults] objectAtIndex:row] valueForKey: @"lname"];
        contentForThisRow = [contentForThisRow stringByAppendingFormat: @", %@ %@", 
                             [[self.searchResults objectAtIndex: row] valueForKey: @"fname"], 
                             [[self.searchResults objectAtIndex: row] valueForKey: @"mname"]];
        detailText = [[self.searchResults objectAtIndex: row] title];
    }
	else{
		contentForThisRow = [[[self employeeArr] objectAtIndex:row] valueForKey: @"lname"];
        contentForThisRow = [contentForThisRow stringByAppendingFormat: @", %@ %@", 
                             [[self.employeeArr objectAtIndex: row] valueForKey: @"fname"], 
                             [[self.employeeArr objectAtIndex: row] valueForKey: @"mname"]];
        detailText = [[self.employeeArr objectAtIndex: row] title];
    }
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		// Do anything that should be the same on EACH cell here.  Fonts, colors, etc.
	}
	
	// Do anything that COULD be different on each cell here.  Text, images, etc.
	[[cell textLabel] setText:contentForThisRow];
	[[cell detailTextLabel] setText:  detailText];
    
    // Set the accessory view to be the little arrow
    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Display the course details
    DirectoryDetailViewController* ddvc = [[DirectoryDetailViewController alloc] initWithNibName:@"DirectoryDetailView" bundle:nil];
    
    if (tableView == [[self searchDisplayController] searchResultsTableView]){
        [ddvc setEmployee: [self.searchResults objectAtIndex: indexPath.row]];
    }
    else{
        [ddvc setEmployee: [self.employeeArr objectAtIndex: indexPath.row]];
    }
    [self.navigationController pushViewController:ddvc animated:YES];
    [ddvc release];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{	
	[self handleSearchForTerm:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
   return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	[self setSavedSearchTerm:nil];
	
	[[self mainTableView] reloadData];
}

@end
