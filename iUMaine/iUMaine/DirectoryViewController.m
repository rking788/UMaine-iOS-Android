//
//  DirectoryViewController.m
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "DirectoryViewController.h"
#import "Person.h"

@implementation DirectoryViewController
@synthesize listContent, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;


- (void)viewDidLoad
{
    
    
	self.title = @"Person";
	
    // Create the master list for the main view controller.
	 self.listContent = [[NSArray alloc] initWithObjects:
            [Person personWithType:@"Device" firstName:@"iPhone" lastName:@"iPhone"],
            [Person personWithType:@"Device" firstName:@"iPod" lastName:@"iPhone"],
            [Person personWithType:@"Device" firstName:@"iPod touch" lastName:@"iPhone"],
            [Person personWithType:@"Desktop" firstName:@"iMac" lastName:@"iPhone"],
            [Person personWithType:@"Desktop" firstName:@"Mac Pro" lastName:@"iPhone"],
            [Person personWithType:@"Portable" firstName:@"iBook" lastName:@"iPhone"],
            [Person personWithType:@"Portable" firstName:@"MacBook" lastName:@"iPhone"],
            [Person personWithType:@"Portable" firstName:@"MacBook Pro" lastName:@"iPhone"],
            [Person personWithType:@"Portable" firstName:@"PowerBook" lastName:@"iPhone"], nil];
    
	// create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
    
     [super viewDidLoad];
   
}


- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
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
    self.filteredListContent = nil;
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [listContent release];
	[filteredListContent release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.listContent count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	Person *person = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        person = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        person = [self.listContent objectAtIndex:indexPath.row];
    }
	
	cell.textLabel.text = person.firstName;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *detailsViewController = [[UIViewController alloc] init];
    
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	Person *person = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        person = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        person = [self.listContent objectAtIndex:indexPath.row];
    }
	detailsViewController.title = person.firstName;
    
    [[self navigationController] pushViewController:detailsViewController animated:YES];
    [detailsViewController release];
}



- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (Person *person in listContent)
	{
		if ([scope isEqualToString:@"All"] || [person.type isEqualToString:scope])
		{
			NSComparisonResult result = [person.firstName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[self.filteredListContent addObject:person];
            }
		}
	}
}



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


@end