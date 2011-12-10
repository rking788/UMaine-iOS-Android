//
//  AddCourseViewController.m
//  iUMaine
//
//  Created by Robert King on 10/2/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AddCourseViewController.h"
#import "iUMaineAppDelegate.h"
#import "Course.h"
#import "constants.h"

@implementation AddCourseViewController
@synthesize navBar;
@synthesize tableV;
@synthesize semStr;
@synthesize lblStrs;
@synthesize detLblStrs;
@synthesize departArr;
@synthesize courseNumArr;
@synthesize sectionArr;
@synthesize delegate;

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
    [self.navBar.topItem setLeftBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target: self action: @selector(cancel)]];
    [self.navBar.topItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithTitle: @"Add" style: UIBarButtonItemStyleDone target:self action: @selector(addCourse)]];
    
    // Set the labels to be displayed in the rows of the table view
    self.lblStrs = [NSArray arrayWithObjects: @"Department", @"Course Number", @"Section", nil];
    self.detLblStrs = [NSMutableArray arrayWithObjects: @"", @"", @"", nil];
    
    [self checkLastViewedDepart];
    
    if(![[self.detLblStrs objectAtIndex: 0] isEqualToString: @""])
        [self loadCourseNumsWithDepart: [self.detLblStrs objectAtIndex: 0]];

    [self loadDeparts];
}

- (void)viewDidUnload
{
    [self setNavBar:nil];
    [self setTableV:nil];
    [self setLblStrs: nil];
    [self setDetLblStrs: nil];
    [self setDepartArr: nil];
    [self setCourseNumArr: nil];
    [self setSectionArr: nil];
    [self setSemStr: nil];
    [self setDelegate: nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) cancel
{
    [self dismissModalViewControllerAnimated: YES];
}

- (void) addCourse
{
    NSString* departStr = [self.detLblStrs objectAtIndex: 0];
    NSString* courseNum = [self.detLblStrs objectAtIndex: 1];
    NSString* sectionNum = [[[self.detLblStrs objectAtIndex: 2] componentsSeparatedByString: @" "] objectAtIndex: 0];
  
    NSLog( @"Adding a course with the following information: Department(%@), CourseNumber(%@), SectionNumber(%@)", 
          [self.detLblStrs objectAtIndex: 0], [self.detLblStrs objectAtIndex: 1], sectionNum);
    
    if([departStr isEqualToString: @""]){
        NSLog( @"Display a warning that you cannot add a course without a department selected");
        return;
    }
    
    if([courseNum isEqualToString: @""]){
        NSLog( @"Display a warning that you cannot add a course without a course number selected");
        return;
    }
    
    if([sectionNum isEqualToString: @""]){
        NSLog( @"Display a warning that you cannot add a course without a section selected");
        return;
    }
    
    NSManagedObjectContext* MOC = [(iUMaineAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext: MOC];
    [fetchrequest setEntity:entity];
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterNoStyle];
    NSNumber* cNum = [formatter numberFromString: courseNum];
    NSNumber* sNum = [formatter numberFromString: sectionNum];
    
    [fetchrequest setFetchLimit: 1];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(semester == %@) AND (depart == %@) AND (number == %@) AND (section == %@)", self.semStr, departStr, cNum, sNum];
    [fetchrequest setPredicate: predicate];
    
    NSError *error = nil;
    NSArray *array = [MOC executeFetchRequest:fetchrequest error:&error];
    
    if (array != nil) {
        
        for(Course* _c in array){
            if(_c){
                [self.delegate addCourse: _c];
            }
            else{
                NSLog(@"Error fetching a course matching the given details");
            }
        }
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching a course matching the given details");
    }
    
}

- (void) checkLastViewedDepart
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey: DEFS_LASTVIEWEDDEPART])
        [self.detLblStrs replaceObjectAtIndex: 0  withObject: [defaults objectForKey: DEFS_LASTVIEWEDDEPART]];
}

- (void) setLastViewedDepart: (NSString*) departStr
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (![[self.detLblStrs objectAtIndex: 0] isEqualToString: @""])
        [defaults setObject: departStr forKey: DEFS_LASTVIEWEDDEPART]; 
}

- (void) loadDeparts
{
    NSMutableSet* departSet = [NSMutableSet set];
    
    NSManagedObjectContext* MOC = [(iUMaineAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext: MOC];
    [fetchrequest setEntity:entity];
    
    NSSortDescriptor* sortDescript = [[NSSortDescriptor alloc] initWithKey:@"depart" ascending:YES];
    NSArray* sortDescripts = [[NSArray alloc] initWithObjects:sortDescript, nil];
    [fetchrequest setSortDescriptors: sortDescripts];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(semester == %@)", self.semStr];
    [fetchrequest setPredicate: predicate];
    
    NSDictionary* entityProps = [entity propertiesByName];
    NSArray* propArr = [[NSArray alloc] initWithObjects: [entityProps objectForKey: @"depart"], nil];
    [fetchrequest setPropertiesToFetch: propArr];
    
    NSError *error = nil;
    NSArray *array = [MOC executeFetchRequest:fetchrequest error:&error];
    
    if (array != nil) {
        
        for(Course* _c in array){
            [departSet addObject: _c.depart];
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching departments");
    }
    
    self.departArr; self.departArr = nil;
    self.departArr = [[departSet allObjects] sortedArrayUsingSelector: @selector( localizedCaseInsensitiveCompare:)];
    

}

- (void) loadCourseNumsWithDepart: (NSString*) depart
{
    NSMutableSet* numberSet = [NSMutableSet set];
    
    NSManagedObjectContext* MOC = [(iUMaineAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext: MOC];
    [fetchrequest setEntity:entity];
    
    NSSortDescriptor* sortDescript = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    NSArray* sortDescripts = [[NSArray alloc] initWithObjects:sortDescript, nil];
    [fetchrequest setSortDescriptors: sortDescripts];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(semester == %@) AND (depart == %@)", self.semStr, depart];
    [fetchrequest setPredicate: predicate];
    
    NSDictionary* entityProps = [entity propertiesByName];
    NSArray* propArr = [[NSArray alloc] initWithObjects: [entityProps objectForKey: @"number"], nil];
    [fetchrequest setPropertiesToFetch: propArr];
    
    NSError *error = nil;
    NSArray *array = [MOC executeFetchRequest:fetchrequest error:&error];
    
    if (array != nil) {
        
        for(Course* _c in array){
            [numberSet addObject: [_c.number stringValue]];
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching lots");
    }
    
    self.courseNumArr = [[numberSet allObjects] sortedArrayUsingSelector: @selector( localizedCaseInsensitiveCompare:)];
    

}

- (void) loadSectionsWithDepart: (NSString*) depart WithCourseNum: (NSString*) num
{
    NSMutableSet* sectSet = [NSMutableSet set];
    
    NSManagedObjectContext* MOC = [(iUMaineAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext: MOC];
    [fetchrequest setEntity:entity];
    
    NSSortDescriptor* sortDescript = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:YES];
    NSArray* sortDescripts = [[NSArray alloc] initWithObjects:sortDescript, nil];
    [fetchrequest setSortDescriptors: sortDescripts];
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterNoStyle];
    NSNumber* cNum = [formatter numberFromString: num];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(semester == %@) AND (depart == %@) AND (number == %@)", self.semStr, depart, cNum];
    [fetchrequest setPredicate: predicate];
    
    NSDictionary* entityProps = [entity propertiesByName];
    NSArray* propArr = [[NSArray alloc] initWithObjects: [entityProps objectForKey: @"section"], [entityProps objectForKey: @"type"], nil];
    [fetchrequest setPropertiesToFetch: propArr];
    
    NSError *error = nil;
    NSArray *array = [MOC executeFetchRequest:fetchrequest error:&error];
    
    if (array != nil) {
        
        for(Course* _c in array){
            NSString* sectAndType = [NSString stringWithFormat: @"%@ (%@)", [_c.section stringValue], _c.type];
            [sectSet addObject: sectAndType];
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching lots");
    }
    
    self.sectionArr = [[sectSet allObjects] sortedArrayUsingSelector: @selector( localizedCaseInsensitiveCompare:)];
    
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSArray* arr = nil;
    
    if( indexPath.row == 0)
        arr = self.departArr;
    else if(indexPath.row == 1)
        arr = self.courseNumArr;
    else if(indexPath.row == 2)
        arr = self.sectionArr;
        
    [self showSelectionViewController: arr ForSelectedRow: indexPath.row];
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSArray* arr = nil;
    
    if( indexPath.row == 0)
        arr = self.departArr;
    else if(indexPath.row == 1)
        arr = self.courseNumArr;
    else if(indexPath.row == 2)
        arr = self.sectionArr;
    
    [self showSelectionViewController: arr ForSelectedRow: indexPath.row];
}

- (void) showSelectionViewController: (NSArray*) contents ForSelectedRow:(NSUInteger)row
{
    CourseDetailSelectionViewController* cdsvc = [[CourseDetailSelectionViewController alloc]
                                                  initWithNibName: @"CourseDetailSelectionView" bundle: nil];
    
    [cdsvc setContentArr: contents];
    [cdsvc setRow: row];
    [cdsvc setDelegate: self];
    [cdsvc setModalTransitionStyle: UIModalTransitionStyleCoverVertical];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController: cdsvc];
    
    [navigationController.navigationBar.topItem setTitle: @"Selection"];
    [self presentModalViewController:navigationController animated:YES];
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
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

#pragma mark - CourseDetailSelectionDelegate Methods
- (void) detailSelection:(NSString*) selectionStr ForSection: (NSUInteger) rowSelected
{
     if(!selectionStr){
        [self dismissModalViewControllerAnimated: YES];
         return;
    }
    
    if(rowSelected == 0){
        [self setLastViewedDepart: selectionStr];
        [self loadCourseNumsWithDepart: selectionStr];
    }
    else if(rowSelected == 1){
        [self loadSectionsWithDepart: [self.detLblStrs objectAtIndex: 0]  WithCourseNum: selectionStr];
    }
    
    
    [self.detLblStrs replaceObjectAtIndex: rowSelected withObject: selectionStr];
    [self.tableV reloadData];
    
    [self dismissModalViewControllerAnimated: YES];
}

@end
