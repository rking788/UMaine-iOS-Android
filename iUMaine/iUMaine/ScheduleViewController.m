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
@synthesize allAvailableSemesters;
@synthesize actSheet;

#pragma mark - TODO CRITICAL: Make it possible to select a different semester by clicking the navigation bar leftbarbuttonitem
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
    self.appDel = (iUMaineAppDelegate*) [[UIApplication sharedApplication] delegate];
    self.allAvailableSemesters = [self.appDel getLocalSemesters];
    NSString* lastSem = [self.userDefs objectForKey: @"LastViewedSemester"];
    
    if(lastSem){
        self.semStr = lastSem;
        self.navigationItem.title = lastSem;
    }
    else{
        // Finds the current semester based on today's date or just the first one in the list
        NSString* title = [ScheduleViewController scheduleTitleFromSemesters: self.allAvailableSemesters];
        if(title){
            NSArray* semesterParts = [title componentsSeparatedByString: @" "];
            self.semStr = [NSString stringWithFormat: @"%@%@", [semesterParts objectAtIndex: 1], [[semesterParts objectAtIndex: 0] lowercaseString]];
            self.navigationItem.title = title;
        }
    }
    
    // Load all of the schedules currently stored on the phone
    self.schedulesDict = [[NSMutableDictionary alloc] init];
   	[self loadSchedulesIntoDict: self.schedulesDict];
 
    [self switchToSemester: self.semStr];
    
    // Set the left button to display a pickerview to allow selection of the semesters
    UIBarButtonItem* semesterSelectBtn = [[UIBarButtonItem alloc] initWithTitle: @"Semesters" style: UIBarButtonItemStyleBordered target:self action: @selector(showPickerview)];
    self.navigationItem.leftBarButtonItem = semesterSelectBtn;
    
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
    [self setAllAvailableSemesters: nil];
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
    [allAvailableSemesters release];
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

- (void) switchToSemester: (NSString*) semesterStr
{
    if([self.schedulesDict objectForKey: semesterStr]){
        self.activeCourses = [ScheduleViewController sortCourses: [[self.schedulesDict objectForKey: semesterStr] courses]];
    }   
    else{
        Schedule* newSched = [NSEntityDescription insertNewObjectForEntityForName: @"Schedule" inManagedObjectContext: self.appDel.managedObjectContext];
        newSched.semester = semesterStr;
        [self.schedulesDict setObject: newSched forKey: semesterStr];
        self.activeCourses = [ScheduleViewController sortCourses: [[self.schedulesDict objectForKey: semesterStr] courses]];
        [self.appDel saveContext];
    }
    
    self.navigationItem.title = [ScheduleViewController semesterStrToReadable: semesterStr];
}

+ (NSString*) semesterStrToReadable: (NSString*) semesterStr
{
    NSString* yearStr = [semesterStr substringToIndex: 4];
    semesterStr = [semesterStr stringByReplacingCharactersInRange: NSMakeRange(0, 4) withString: @""];
    
    NSString* firstChar = [[semesterStr substringToIndex: 1] capitalizedString];
    NSString* seasonStr = [semesterStr stringByReplacingCharactersInRange: NSMakeRange(0, 1) withString: firstChar];
    
    return [NSString stringWithFormat: @"%@ %@", seasonStr, yearStr];
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

- (void) showPickerview{
    self.actSheet = [[UIActionSheet alloc] initWithTitle: @"Select a semester" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]; 

    NSInteger nCur = [self.allAvailableSemesters indexOfObject: self.semStr];
    if(nCur == NSNotFound)
        nCur = 0;
    
    [self.actSheet setActionSheetStyle: UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    UIPickerView* pickView = [[UIPickerView alloc] initWithFrame: pickerFrame];
    pickView.showsSelectionIndicator = YES;
    pickView.dataSource = self;
    pickView.delegate = self;
    pickView.tag = 150;
    [pickView selectRow: nCur inComponent: 0 animated: NO];
    [actSheet addSubview: pickView];
    
    UISegmentedControl* closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Done", nil]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    [self.actSheet addSubview:closeButton];
    [closeButton release];
    
    [self.actSheet showInView: self.view.window];
    
    [self.actSheet setBounds:CGRectMake(0, 0, 320, 485)];
    [self.actSheet autorelease];
    
}

- (void) dismissActionSheet{
    [self.actSheet dismissWithClickedButtonIndex:0 animated:YES];
    UIPickerView* picker = (UIPickerView*) [self.actSheet viewWithTag:150];
    [self setActSheet:nil];
    
    // If they didn't actually switch to a new semester then just return
    if([[self.allAvailableSemesters objectAtIndex: [picker selectedRowInComponent: 0]] isEqualToString: self.semStr])
        return;
    
    self.semStr = [self.allAvailableSemesters objectAtIndex: [picker selectedRowInComponent:0]];
    
    if(!self.semStr){
        self.semStr = [self.allAvailableSemesters objectAtIndex: 0];
    }
    
    // TODO: Do what should be done
    [self switchToSemester: self.semStr];
    [self.contentTable reloadData];
}

#pragma mark - UIPickerView delegate and datasource methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.allAvailableSemesters count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString* readableSem = [ScheduleViewController semesterStrToReadable: [self.allAvailableSemesters objectAtIndex: row]];
    return readableSem;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
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
