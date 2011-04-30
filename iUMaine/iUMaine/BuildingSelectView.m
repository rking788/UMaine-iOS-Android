//
//  BuildingSelectView.m
//  iUMaine
//
//  Created by RKing on 4/26/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "BuildingSelectView.h"

@implementation BuildingSelectView
@synthesize searchBar;
@synthesize tblView;
@synthesize listContents;
@synthesize listSubContents;
@synthesize searchListContents;
@synthesize managedObjectContext;
@synthesize selectDelegate;
@synthesize searching;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [searchBar release];
    [listContents release];
    [listSubContents release];
    [searchListContents release];
    [selectDelegate release];
    [tblView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) cancelClicked: (id) sender{
    [self setSearching: NO];
    [searchBar setText: @""];
    [self.selectDelegate selectBuildingLocation:nil];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self isSearching]){
        return [self.searchListContents count];
    }
    else{
        return [self.listContents count];        
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    if([self isSearching]){
        UILabel* lbl = [cell textLabel];
        [lbl setText: [self.searchListContents objectAtIndex:indexPath.row]];
    }
    else{
        NSString *cellValue = [self.listContents objectAtIndex:indexPath.row];
        UILabel* lbl = [cell textLabel];
        [lbl setText: cellValue];
        UILabel* lbl2 = [cell detailTextLabel];
        [lbl2 setText: [self.listSubContents objectAtIndex:indexPath.row]];
    }
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
    if([self isSearching]){
        [self.selectDelegate selectBuildingLocation: [self.searchListContents objectAtIndex:indexPath.row]];
    }
    else{
        [self.selectDelegate selectBuildingLocation: [self.listContents objectAtIndex:indexPath.row]];        
    }
}

- (void) populateListContents{
    // TODO: This list should be distinct 
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
    [fetchrequest setEntity:entity];
    
    NSSortDescriptor* sortDescript = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray* sortDescripts = [[NSArray alloc] initWithObjects:sortDescript, nil];
    [fetchrequest setSortDescriptors: sortDescripts];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchrequest error:&error];
    
    if (array != nil) {
        //NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity: [array count]];
        //NSMutableArray* subcontentsArr = [[NSMutableArray alloc] initWithCapacity: [array count]];
        
        for(NSManagedObject* manObj in array){
            // TODO: Probably remove this titleString variable and combine it with the next line
            NSString* titleString = [manObj valueForKey:@"title"];
            [self.listContents addObject: titleString];
            [self.listSubContents addObject:[NSString stringWithFormat:@"Lat: %@, Long: %@", [manObj valueForKey:@"latitude"], [manObj valueForKey:@"longitude"]]];
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching lots");
    }
    
    [sortDescript release];
    [sortDescripts release];
    [fetchrequest release];
}


#pragma mark - Search Bar methods

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    NSLog(@"New text: %@", searchText);
    
    [self.searchListContents removeAllObjects];
    
    if([searchText length] > 0){
        [self setSearching: YES];
        [self searchTable];
    }
    else{
        [self setSearching: NO];
    }
    
    [self.tblView reloadData];
}

- (void) searchBarButtonClicked: (UISearchBar*) theSearchBar{
    [self searchTable];
}

- (void) searchTable{
    
    NSUInteger i = 0;
    for(NSString* str in self.listContents){
        NSRange range = [str rangeOfString:[searchBar text] options:NSCaseInsensitiveSearch];
        
        if(range.length > 0){
            [self.searchListContents addObject:[self.listContents objectAtIndex:i]];
        }

        i++;
    }
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setListSubContents: [[NSMutableArray alloc] init]];
    [self setListContents: [[NSMutableArray alloc] init]];
    [self setSearchListContents: [[NSMutableArray alloc] init]];
    
    [self populateListContents];
    
    self.navigationItem.title = @"Search";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                               target:self action:@selector(cancelClicked:)] autorelease];
   
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [self setSearching: NO];
    [self.tableView setDelegate:self];
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setListContents: nil];
    [self setListSubContents: nil];
    [self setSelectDelegate: nil];
    [self setSearchListContents: nil];
    [self setTblView:nil];
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
