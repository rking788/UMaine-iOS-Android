
#import "DirectoryViewController.h"

@implementation DirectoryViewController

@synthesize mainTableView;
@synthesize contentsList;
@synthesize searchResults;
@synthesize savedSearchTerm;

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	//[mainTableView release], mainTableView = nil;
	[contentsList release], contentsList = nil;
	[searchResults release], searchResults = nil;
    [savedSearchTerm release], savedSearchTerm = nil;
	
    //[super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	// Save the state of the search UI so that it can be restored if the view is re-created.
	[self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
	
	[self setSearchResults:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Red", @"Blue", @"Green", @"Black", @"Purple",@"Red", @"Blue", @"Green", @"Black", @"Purple",@"Red", @"Blue", @"Green", @"Black", @"Purple", nil];
	[self setContentsList:array];
	[array release], array = nil;
	
	// Restore search term
	if ([self savedSearchTerm])
	{
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewWillAppear:animated];
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
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
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setSavedSearchTerm:searchTerm];
	
	if ([self searchResults] == nil)
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setSearchResults:array];
		[array release], array = nil;
	}
	
	[[self searchResults] removeAllObjects];
	
	if ([[self savedSearchTerm] length] != 0)
	{
		for (NSString *currentString in [self contentsList])
		{
			if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
			{
				[[self searchResults] addObject:currentString];
			}
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger rows;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView])
		rows = [[self searchResults] count];
	else
		rows = [[self contentsList] count];
	
	NSLog(@"rows is: %d", rows);
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger row = [indexPath row];
	NSString *contentForThisRow = nil;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView])
		contentForThisRow = [[self searchResults] objectAtIndex:row];
	else
		contentForThisRow = [[self contentsList] objectAtIndex:row];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		// Do anything that should be the same on EACH cell here.  Fonts, colors, etc.
	}
	
	// Do anything that COULD be different on each cell here.  Text, images, etc.
	[[cell textLabel] setText:contentForThisRow];
	
	//NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self handleSearchForTerm:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setSavedSearchTerm:nil];
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
