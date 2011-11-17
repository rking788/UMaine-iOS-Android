//
//  BuildingSelectView.m
//  iUMaine
//
//  Created by RKing on 4/26/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "BuildingSelectView.h"
#import "Location.h"

@implementation BuildingSelectView
@synthesize searchBar;
@synthesize tblView;
@synthesize listContents;
@synthesize listSubContents;
@synthesize listLocations;
@synthesize searchListContents;
@synthesize searchListSubContents;
@synthesize searchListLocations;
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
    [listLocations release];
    [searchListContents release];
    [searchListSubContents release];
    [searchListLocations release];
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
    [self.selectDelegate selectBuildingLocation:nil withLatitude:0.0 withLongitude:0.0];
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
        UILabel* lbl2 = [cell detailTextLabel];
        NSString* lbl2text = [self.searchListSubContents objectAtIndex: indexPath.row];
        [lbl2 setText: lbl2text];
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
        NSArray* temparr = [[self.searchListLocations objectAtIndex: indexPath.row] componentsSeparatedByString:@","];
        double dLat = ([[temparr objectAtIndex: 0] doubleValue]/1000000);
        double dLong = ([[temparr objectAtIndex: 1] doubleValue]/1000000);
        [self.selectDelegate selectBuildingLocation: [self.searchListContents objectAtIndex:indexPath.row] withLatitude: dLat withLongitude: dLong];
    }
    else{
        NSArray* temparr = [[self.listLocations objectAtIndex: indexPath.row] componentsSeparatedByString:@","];
        double dLat = ([[temparr objectAtIndex: 0] doubleValue]/1000000);
        double dLong = ([[temparr objectAtIndex: 1] doubleValue]/1000000);
        [self.selectDelegate selectBuildingLocation: [self.listContents objectAtIndex:indexPath.row]withLatitude: dLat withLongitude: dLong];        
    }
}

- (void) populateListContents{
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
    [fetchrequest setEntity:entity];
    
    NSSortDescriptor* sortDescript = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray* sortDescripts = [[NSArray alloc] initWithObjects:sortDescript, nil];
    [fetchrequest setSortDescriptors: sortDescripts];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchrequest error:&error];
    
    if (array != nil) {

        for(Location* loc in array){
            [self.listContents addObject: [loc valueForKey: @"title"]];
        
            if([[[loc entity] name] isEqualToString: @"Building"]){
                [self.listSubContents addObject: @""];
            }
            else{
                NSString* firstCharStr = [[[loc valueForKey: @"permittype"] substringToIndex: 1] capitalizedString];
                NSString* typeStr = [[loc valueForKey: @"permittype"] stringByReplacingCharactersInRange: NSMakeRange(0, 1) withString: firstCharStr];
                [self.listSubContents addObject: typeStr];
            }
            
            [self.listLocations addObject:[NSString stringWithFormat:@"%@,%@", [loc valueForKey:@"latitude"], [loc valueForKey:@"longitude"]]];
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
    
    [self.searchListContents removeAllObjects];
    [self.searchListSubContents removeAllObjects];
    [self.searchListLocations removeAllObjects];
    
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
            [self.searchListContents addObject:[self.listContents objectAtIndex: i]];
            [self.searchListSubContents addObject:[self.listSubContents objectAtIndex: i]];
            [self.searchListLocations addObject: [self.listLocations objectAtIndex: i]];
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
    [self setListLocations: [[NSMutableArray alloc] init]];
    [self setSearchListContents: [[NSMutableArray alloc] init]];
    [self setSearchListSubContents: [[NSMutableArray alloc] init]];
    [self setSearchListLocations: [[NSMutableArray alloc] init]];
    
    [self populateListContents];
    
    self.navigationItem.title = @"Search";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                               target:self action:@selector(cancelClicked:)] autorelease];
    [self.navigationController.navigationBar setTintColor: [UIColor colorWithRed: (3.0/255.0) 
                                                                           green: (32.0/255.0) 
                                                                            blue: (62.0/255.0) 
                                                                           alpha:1.0]];
   
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
    [self setSearchListSubContents: nil];
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
