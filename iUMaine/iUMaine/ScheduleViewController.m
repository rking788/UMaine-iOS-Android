//
//  ScheduleViewController.m
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "iUMaineAppDelegate.h"
#import "ScheduleViewController.h"
#import "ScheduleTabView.h"
#import "CourseDetailViewController.h"
#import "AddCourseViewController.h"
#import "Schedule.h"
#import "Course.h"

@implementation ScheduleViewController
@synthesize schedTabView;
@synthesize contentTable;
@synthesize appDel;
@synthesize scheduleCourseCell;
@synthesize userDefs;
@synthesize semStr;
@synthesize activeCourses;
@synthesize schedulesDict;

#pragma mark - TODO CRITICAL Need to filter the courses displayed in the view based on the days that they meet
#pragma mark - TODO CRITICAL There are courses in the database with WEIRD "days" property values for example CET in 2012 spring SMS in 2012 spring as well. (go to sqlitemanager and sort by days)

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add this view controller as the delegate for the tab view
    self.schedTabView.delegate = self;
    
    // Not sure why this works ha, found it on StackOverflow
    // hides all separators under empty cells
    [self hideEmptySeparators];

    // Set the title to the current semester being viewed 
    // This should check to see if there was a semester previously open or open a default one
    self.userDefs = [NSUserDefaults standardUserDefaults];
    NSString* lastSem = [self.userDefs objectForKey: @"LastViewedSemester"];
    if(lastSem){
        self.semStr = lastSem;
        self.navigationItem.title = lastSem;
    }
    else{
        self.appDel = (iUMaineAppDelegate*) [[UIApplication sharedApplication] delegate];
        NSArray* sems = [self.appDel getLocalSemesters];
        // Finds the current semester based on today's date or just the first one in the list
        NSString* title = [ScheduleViewController scheduleTitleFromSemesters: sems];
        if(title){
            NSArray* semesterParts = [title componentsSeparatedByString: @" "];
            self.semStr = [NSString stringWithFormat: @"%@%@", [semesterParts objectAtIndex: 1], [[semesterParts objectAtIndex: 0] lowercaseString]];
            self.navigationItem.title = title;
        }
    }
    
    // Load all of the schedules currently stored on the phone
    self.schedulesDict = [[NSMutableDictionary alloc] init];
   	[self loadSchedulesIntoDict: self.schedulesDict];
    if([self.schedulesDict objectForKey: self.semStr]){
        self.activeCourses = [ScheduleViewController sortCourses: [[self.schedulesDict objectForKey: self.semStr] courses]];
    }   
    else{
        Schedule* newSched = [NSEntityDescription insertNewObjectForEntityForName: @"Schedule" inManagedObjectContext: self.appDel.managedObjectContext];
        newSched.semester = self.semStr;
        [self.schedulesDict setObject: newSched forKey: semStr];
        self.activeCourses = [ScheduleViewController sortCourses: [[self.schedulesDict objectForKey: self.semStr] courses]];
        [self.appDel saveContext];
    }
    
    // Setup the nav bar right button to the add symbol to add a course
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem: UIBarButtonSystemItemAdd 
                                              target: self action: @selector(addBtnClicked)];
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
    [self setSchedTabView:nil];
    [self setContentTable:nil];
    [self setScheduleCourseCell:nil];
    [self setSemStr: nil];
    [self setAppDel: nil];
    [self setActiveCourses: nil];
    [self setSchedulesDict: nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [schedTabView release];
    [contentTable release];
    [scheduleCourseCell release];
    [semStr release];
    [appDel release];
    [activeCourses release];
    [schedulesDict release];
    [super dealloc];
}


+ (NSString*) scheduleTitleFromSemesters: (NSArray*) sems
{
    NSString* ret = @"";
    NSDateComponents* components = [[NSCalendar currentCalendar] components: NSMonthCalendarUnit | NSYearCalendarUnit fromDate: [NSDate date]];
    NSInteger month = [components month];
    NSInteger year = [components year];
    BOOL isSpring = ((month >= 1) && (month <= 5));
    BOOL isFall = ((month >= 8) && (month <= 12));
    BOOL isSummer = ((month >= 6) && (month <= 8));
    
    // This is set up this way because technically isSummer and isFall can 
    // both be true (beginning and end of august? 
    if(isSpring){
        if([sems containsObject: [NSString stringWithFormat: @"%dspring", year]])
            ret = [NSString stringWithFormat: @"Spring %d", year];
    }
    if(isFall){
        if([sems containsObject: [NSString stringWithFormat: @"%dfall", year]])
            ret = [NSString stringWithFormat: @"Fall %d", year];
    }
    if(isSummer){
        if([sems containsObject: [NSString stringWithFormat: @"%dsummer", year]])
            ret = [NSString stringWithFormat: @"Summer %d", year];
    }
    
    return ret;
}

+ (NSArray*) sortCourses:(NSSet *)unsortedCourses
{
    NSMutableArray* retArr = [NSMutableArray arrayWithCapacity: [unsortedCourses count]];
    
    NSEntityDescription* desc = [NSEntityDescription entityForName: @"Course" inManagedObjectContext: [[(iUMaineAppDelegate*)[UIApplication sharedApplication] delegate] managedObjectContext]];
    
    for(Course* _c in [unsortedCourses allObjects]){
        [ScheduleViewController insertCourse: _c IntoArray: retArr];
    }
    
    return retArr;
}

+ (void) insertCourse:(Course *) c IntoArray:(NSMutableArray *)outArr
{
    // If the course is already in the array then just exit
    if([outArr containsObject: c])
        return;
    
    float time = [ScheduleViewController courseStartTime: c];
    BOOL wasInserted = NO;
    
    if([outArr count] == 0){
        [outArr addObject: c];
        return;
    }
    
    for (NSInteger i = 0; i < [outArr count]; ++i){
        float tTime = [ScheduleViewController courseStartTime: [outArr objectAtIndex: i]];
    
        if(time < tTime){
            [outArr insertObject: c atIndex: i];
            wasInserted = YES;
            break;
        }
    }
    
    if(!wasInserted)
        [outArr addObject: c];
}

+ (float) courseStartTime: (Course*) c
{
    float ret = -1.0;
    
    if([c.times isEqualToString: @"TBA"])
        return ret;
    
    NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString: @"APM"];
    
    NSString* startTime = [[c.times componentsSeparatedByString: @" - "] objectAtIndex: 0]; 
    NSInteger hours = [[[startTime componentsSeparatedByString: @":"] objectAtIndex: 0] integerValue];
    NSInteger mins = [[[[startTime componentsSeparatedByString: @":"] objectAtIndex: 1] stringByTrimmingCharactersInSet: charSet] integerValue];

    NSRange pmRange = [startTime rangeOfString: @"PM"];

    
    if(pmRange.location != NSNotFound){
        if(hours != 12)
            ret = 12.0 + (float) hours + ((float) mins / 60.0);
        else
            ret = 12.0 + ((float) mins / 60.0);
    }
    else{
        if(hours != 12)
            ret = ((float) hours) + ((float) mins/60.0);
        else
            ret = 0.0 + ((float) mins / 60.0);
    }
    
    return ret;
}

- (void) loadSchedulesIntoDict:(NSMutableDictionary *)schedules
{
    NSManagedObjectContext* MOC = self.appDel.managedObjectContext;
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"Schedule"];
    
    NSError *error = nil;
    NSArray *array = [MOC executeFetchRequest:fetchRequest error:&error];
    
    if (array != nil) {
        
        for(Schedule* sched in array){
            [schedules setObject: sched forKey: sched.semester];
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching schedule object in ScheduleViewController");
    }
    
    [fetchRequest release];
}

- (void) addBtnClicked
{
    AddCourseViewController* acvc = [[AddCourseViewController alloc] initWithNibName: @"AddCourseView" bundle: nil];
    
    [acvc setSemStr: self.semStr];
    [acvc setDelegate: self];
    
    [acvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController: acvc animated: YES];
    [acvc release];
}

- (void)hideEmptySeparators
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    [self.contentTable setTableFooterView:v];
    [v release];
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
 
    CourseDetailViewController* cdvc = [[CourseDetailViewController alloc] init];
    
    [cdvc setCourse: [self.activeCourses objectAtIndex: indexPath.row]];
    [self.navigationController pushViewController: cdvc animated:YES];
    
    [cdvc release];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the new course from the schedule object
    Schedule* curSched = [self.schedulesDict objectForKey: self.semStr];
    Course* c = [self.activeCourses objectAtIndex: indexPath.row];
    [curSched removeCoursesObject: c];
    [self.appDel saveContext];
    
    // Add the new course into the array of active courses
    [self.activeCourses removeObject: c];
    
    // Remove the object from the table view
    [tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* dayStr = [self.schedTabView activeDay];
    NSMutableArray* res = nil;
    NSInteger num = 0;
    
    if([dayStr isEqualToString: @"Week"])
        res = self.activeCourses;
    else{
        res = [NSMutableArray arrayWithArray: self.activeCourses];
        NSPredicate* pred = [NSPredicate predicateWithFormat: @"(SELF.days contains[c] %@) OR (SELF.days contains[c] %@)", dayStr, @"TBA"];
        [res filterUsingPredicate: pred];
    }
    
    num = [res count];
    
    if(num != 0){
        [self.contentTable setHidden: NO];
        [self.view sendSubviewToBack: [self.view viewWithTag: 82]];
    }
    else{
        [self.contentTable setHidden: YES];
        [self.view bringSubviewToFront: [self.view viewWithTag: 82]];
    }
    return num;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScheduleCourseCell";
    static NSString *CellNib = @"CustomScheduleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        
        cell = self.scheduleCourseCell;
    }
   
    NSString* dayStr = [self.schedTabView activeDay];
    NSMutableArray* res = nil;
    
    if([dayStr isEqualToString: @"Week"]){
        res = self.activeCourses;
    }
    else{
        res = [NSMutableArray arrayWithArray: self.activeCourses];
        NSPredicate* pred = [NSPredicate predicateWithFormat: @"(SELF.days contains[c] %@) OR (SELF.days contains[c] %@)", dayStr, @"TBA"];
        [res filterUsingPredicate: pred];
    }
    
    Course* curCourse = [res objectAtIndex: indexPath.row];
    
    UILabel* courseNumLbl = (UILabel*) [cell viewWithTag: 20];
    UILabel* titleLbl = (UILabel*) [cell viewWithTag: 21];
    UILabel* timeLbl = (UILabel*) [cell viewWithTag: 22];
    
    [titleLbl setText: curCourse.title];
    [courseNumLbl setText: [NSString stringWithFormat: @"%@ %@", curCourse.depart, curCourse.number]];
    [timeLbl setText: [[curCourse.times componentsSeparatedByString: @" - "] objectAtIndex: 0]];
    
    [cell setSelectionStyle: UITableViewCellSelectionStyleGray];
    
    // Configure the cell...
    //  UILabel* lbl = [cell textLabel];
    //  UILabel* lbl2 = [cell detailTextLabel];
    
    // [lbl setText: @"Course Name"];
    // [lbl setTextColor: [UIColor colorWithRed:(66.0/255.0) green:(41.0/255.0) blue:(3.0/255) alpha:1.0]];
    // UIFont* textFont = [UIFont fontWithName: @"Baskerville" size: 17.0];
    // [lbl setFont: textFont];
    // [lbl2 setText: @"12:00 PM"];
    
    return cell;
}

#pragma mark - AddCourseToScheduleDelegate Methods

- (void) addCourse:(Course *) _c
{
    // Insert the new course into the schedule object
    Schedule* curSched = [self.schedulesDict objectForKey: self.semStr];
    [curSched addCoursesObject: _c];
    [self.appDel saveContext];
    
    // Add the new course into the array of active courses
    [ScheduleViewController insertCourse: _c IntoArray: self.activeCourses];
    [self.contentTable reloadData];
    
    [self dismissModalViewControllerAnimated: YES];
}

#pragma mark - ScheduleDisplayDelegate Methods
- (void) activeDayChanged
{
    [self.contentTable reloadData];
}


@end
