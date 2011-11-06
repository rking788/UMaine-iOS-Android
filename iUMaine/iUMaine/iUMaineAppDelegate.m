//
//  iUMaineAppDelegate.m
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "iUMaineAppDelegate.h"
#import "MapViewController.h"
#import "SportEvent.h"
#import "Course.h"
#import "AvailableCourses.h"
#import "TBXML.h"

// Only import this file when we need to initialize the sqlite file 
//#import "dbInitializer.h"

@implementation iUMaineAppDelegate

// TODO: need to explicitly write these accessors
@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator;

@synthesize window=_window;

@synthesize tabBarController=_tabBarController;
@synthesize defaultPrefs;
@synthesize lastUpdateStr;
@synthesize gettingSports;

// Constant for the abbreviations dictionary name
NSString* const ABBRSDICTNAME = @"sportsAbbrsDict.txt";

// Constant for the UMaine sports site URL format
// First %@ is for the sport abbreviation
// Second %@ is for the year
NSString* const SCHEDURLFORMAT = @"http://www.goblackbears.com/sports/%@/%@/schedule%@";
NSString* const RSSSUFFIX = @"?print=rss";

// Constant for the database file name
NSString* const DBFILENAME = @"iUMaine.sqlite"; 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    
    // Migrate the default DB if necessary
    [self loadDefaultDB];
    
    // Assign the managedObjectContext to the MapViewController
    NSManagedObjectContext* context = [self managedObjectContext];
    
    // May be dangerous to assume the mapviewcontroler is at index 1
    MapViewController* mapViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    mapViewController.managedObjectContext = context;
    
    // Initialize the database file (should be removed after .sqlite file is setup
    //DBInitializer* dbIniter = [[DBInitializer alloc] init];
    //dbIniter.managedObjectContext = self.managedObjectContext;
    //[dbIniter initDatabase];
    //[dbIniter release];
    
    self.defaultPrefs = [NSUserDefaults standardUserDefaults];
    
    // Start a new thread to check the server for new sports information
    [NSThread detachNewThreadSelector: @selector(checkSportsUpdates) 
                             toTarget: self withObject: nil];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
*/
- (NSManagedObjectContext *) managedObjectContext {

    if (managedObjectContext != nil) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
 
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL* storeURL = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"iUMaine.sqlite"]];
    NSError *error = nil;
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Handle the error.
        NSLog(@"Failed to create the persistent store in iUMaineAppDelegate with error: %@", [error localizedDescription]);
    }    
    
    return persistentStoreCoordinator;
}

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)loadDefaultDB{
    
    BOOL success;
    NSError* err;
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* dbPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:DBFILENAME];
    
    success = [fm fileExistsAtPath:dbPath];
    
    // If the database exists then just return
    if(success){
        NSLog(@"DB File exists");
        return;
    }

    NSString* defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBFILENAME];
    
    // If there is a default database file copy it, if not then fail
    //if([fm fileExistsAtPath:defaultDBPath]){
        success = [fm copyItemAtPath:defaultDBPath toPath:dbPath error:&err];
        
        if(!success){
            NSLog(@"Failed to copy the default database");
            NSAssert1(0, @"Failed to copy the default DB with message '%@'.", [err localizedDescription]);
        }
  //  }
   // else{
    //    NSLog(@"Default database does not exist");
    //    NSAssert1(0, @"Default database file does not exist", nil);
   // }
    
}

+ (iUMaineAppDelegate*) sharedAppDelegate
{
    return (iUMaineAppDelegate*) [[UIApplication sharedApplication] delegate];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
 //   [self saveContext];
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [defaultPrefs release];
    [lastUpdateStr release];
    [super dealloc];
}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (void) saveContext
{
    NSError* err;
    if(managedObjectContext != nil){
        if([managedObjectContext hasChanges] && ![managedObjectContext save:&err]){
            // Handle the error in here 
        }
    }   
}

#pragma mark - Sports related methods
- (void) checkSportsUpdates
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSDate* lastScanDate = [self.defaultPrefs objectForKey: @"LastSportsUpdate"];
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];

    [self setLastUpdateStr: [dateformatter stringFromDate: lastScanDate]];
    
    NSURLResponse* resp = nil;
    NSError* err = nil;
    
    // Add the event information into the POST request content
    NSURL* url = [NSURL URLWithString:@"http://mainelyapps.com/umaine/FetchSportsUpdates.php"];
    NSString* content = [NSString stringWithFormat: @"date=%@", self.lastUpdateStr];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [content dataUsingEncoding: NSUTF8StringEncoding]];
    
    NSData* ret = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
    NSString* retStr = [[NSString alloc] initWithData: ret encoding: NSUTF8StringEncoding];
    
    // Check if there were any new events or not
    if(![retStr isEqualToString: @""]){
        // Get an array of the new events
        NSArray* eventsArr = [retStr componentsSeparatedByString: @"\n"];
        
        // The event lines are in the form
        // date;home;recapLink;result;sport;teamA;teamB;year;\n
        for(NSString* eventLine in eventsArr){
            NSArray* eComps = [eventLine componentsSeparatedByString: @";"];
            
            if ([eComps count] == 1) {
                continue;
            }
            
            SportEvent* tempEvent = [[SportEvent alloc] initWithEntity: [NSEntityDescription entityForName:@"SportEvent" inManagedObjectContext: self.managedObjectContext] insertIntoManagedObjectContext: nil];

            // Date
            [tempEvent setDate: [dateformatter dateFromString: [eComps objectAtIndex: 0]]];
            
            // Home
            [tempEvent setHome: [NSNumber numberWithInteger: [[eComps objectAtIndex: 1] integerValue]]];
            
            // Recap Link
            NSString* recapStr = [eComps objectAtIndex: 2];
            if([recapStr isEqualToString: @""])
                [tempEvent setRecapLink: nil];
            else
                [tempEvent setRecapLink: recapStr];
            
            // Result
            NSString* resultStr = [eComps objectAtIndex: 3];
            if([resultStr isEqualToString: @""])
                [tempEvent setResultStr: nil];
            else
                [tempEvent setResultStr: resultStr];
            
            // Sport
            [tempEvent setSport: [eComps objectAtIndex: 4]];
            
            // Team A
            [tempEvent setTeamA: [eComps objectAtIndex: 5]];
            
            // Team B
            [tempEvent setTeamB: [eComps objectAtIndex: 6]];
            
            // Year
            [tempEvent setYearRange: [eComps objectAtIndex: 7]];
            
            [self updateOrAddEvent: tempEvent];
            
            [tempEvent release];
        }
        
        // Just updated the events so set the last event update as today's date
        NSDate* lastUpdate = [NSDate date];
        [self.defaultPrefs setObject: lastUpdate forKey: @"LastSportsUpdate"];
        [self setLastUpdateStr: [dateformatter stringFromDate: [NSDate date]]];
    }
    
    [retStr release];
    [request release];
    [dateformatter release];
    [pool release];
    
    [self checkForNewSemesters];
}

- (void) updateOrAddEvent:(SportEvent *)newE
{
    // See if event is already on the phone
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SportEvent" inManagedObjectContext: self.managedObjectContext];
    [fetchrequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(date == %@) AND (sport == %@) AND (teamA == %@) AND (teamB == %@)",
                              newE.date,
                              newE.sport,
                              newE.teamA,
                              newE.teamB];
    
    [fetchrequest setPredicate:predicate];
    
    [fetchrequest setFetchLimit: 1];
    
    NSError *error = nil;
    SportEvent* event = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchrequest error:&error];
    
    if (array != nil) {
        if([array count] > 0){
            event = [array objectAtIndex: 0];
        }
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching lots");
    }
    
    if(!event){
        // Add the new event into the persistent store
        event = [NSEntityDescription insertNewObjectForEntityForName: @"SportEvent" inManagedObjectContext: self.managedObjectContext];
        
        [event setDate: newE.date];
        [event setHome: newE.home];
        [event setSport: newE.sport];
        [event setTeamA: newE.teamA];
        [event setTeamB: newE.teamB];
        [event setYearRange: newE.yearRange];
    }
    
    [event setRecapLink: newE.recapLink];
    [event setResultStr: newE.resultStr];
    
    // Save the context
    NSError* err = nil;

    if(![self.managedObjectContext save:&err]){
        // Handle the error here
        NSLog(@"Failed to save the managedObjectContext");
    }
    
    [fetchrequest release];
}

- (void) checkForNewSemesters
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSArray* localSemesters = [[self getLocalSemesters] retain];
    NSMutableArray* newSemesters = [[NSMutableArray alloc] init];
    
    NSURLResponse* resp = nil;
    NSError* err = nil;
    
    // Add the event information into the POST request content
    NSURL* url = [NSURL URLWithString:@"http://mainelyapps.com/umaine/FetchAvailableCourses.php"];
    NSString* content = [NSString stringWithFormat: @"op=%@", @"getsemesters"];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [content dataUsingEncoding: NSUTF8StringEncoding]];
    
    NSData* ret = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
    NSString* tempRetStr = [[NSString alloc] initWithData: ret encoding: NSUTF8StringEncoding];
    
    NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    NSString* retStr = [tempRetStr stringByTrimmingCharactersInSet: charSet];
    [tempRetStr release];
    
    if(![retStr isEqualToString: @""]){
        // Get an array of the semesters stored on the server
        NSArray* semArr = [retStr componentsSeparatedByString: @"\n"];
        
        for(NSString* sem in semArr){
            if(![localSemesters containsObject: sem]){
                [self fetchSemesterCourses: sem];
            }
        }
    }
    
    [request release];
    [newSemesters release];
    [localSemesters release];
 //   [pool release];
}

- (NSArray*) getLocalSemesters
{
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AvailableCourses" inManagedObjectContext: self.managedObjectContext];
    [fetchrequest setEntity:entity];
    
    NSDictionary* entityProps = [entity propertiesByName];
    NSArray* propArr = [[NSArray alloc] initWithObjects: [entityProps objectForKey: @"semesterStr"], nil];
    [fetchrequest setPropertiesToFetch: propArr];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchrequest error:&error];
    if (array != nil) {
        
        for(NSManagedObject* obj in array){
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching the list of local semesters");
    }

    [propArr release];
    [fetchrequest release];
    
    return [array valueForKey: @"semesterStr"];
}

- (void) fetchSemesterCourses:(NSString *)semStr
{
    
    AvailableCourses* ac = [NSEntityDescription insertNewObjectForEntityForName: @"AvailableCourses" 
                                                inManagedObjectContext: self.managedObjectContext];
    
    [ac setSemesterStr: semStr];
    
    NSURLResponse* resp = nil;
    NSError* err = nil;
    
    // Add the event information into the POST request content
    NSURL* url = [NSURL URLWithString:@"http://mainelyapps.com/umaine/FetchAvailableCourses.php"];
    NSString* content = [NSString stringWithFormat: @"op=%@&sem=%@", @"getallforsemester", semStr];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [content dataUsingEncoding: NSUTF8StringEncoding]];
    
    NSData* ret = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
    NSString* retStr = [[NSString alloc] initWithData: ret encoding: NSUTF8StringEncoding];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"M/d/YY"];
    
    // Check if there were any new events or not
    if(![retStr isEqualToString: @""]){
        // Get an array of the new events
        NSArray* courseLines = [retStr componentsSeparatedByString: @"\n"];
        
        for(NSString* line in courseLines){
            if([line isEqualToString: @""])
                continue;
            
            Course* tempC = [NSEntityDescription insertNewObjectForEntityForName: @"Course" inManagedObjectContext: self.managedObjectContext];
            
            /* Create the relationship between the newly created availablecourses and this new course object */
            tempC.semesteravailable = ac;
            
            NSArray* elements = [line componentsSeparatedByString: @";"];

            /* Semester (not sure we need this since we have the above relationship "semesteravailable") */
            tempC.semester = semStr;
            /* Department */
            tempC.depart = [elements objectAtIndex: 0];
            /* Course Number */
            tempC.number = [NSNumber numberWithInteger: [[elements objectAtIndex: 1] integerValue]];
            /* Course Title */
            tempC.title = [elements objectAtIndex: 2];
            /* Section Number */
            tempC.section = [NSNumber numberWithInteger: [[elements objectAtIndex: 3] integerValue]];
            /* Course Type */
            tempC.type = [elements objectAtIndex: 4];
            /* Call Number */
            tempC.idNum = [NSNumber numberWithInteger: [[elements objectAtIndex: 5] integerValue]];
            /* Days */
            tempC.days = [elements objectAtIndex: 6];
            /* Times */
            if([tempC.days isEqualToString: @"TBA"])
                tempC.times = @"TBA";
            else
                tempC.times = [elements objectAtIndex: 7];
            /* Meeting location */
            tempC.location = [elements objectAtIndex: 8];
            /* Instructor */
            tempC.instructor = [elements objectAtIndex: 9];
            if([tempC.instructor isEqualToString: @""])
                tempC.instructor = @"N/A";
            /* Start Date */
            tempC.startDate = [dateFormatter dateFromString: [elements objectAtIndex: 10]];
            /* End Date */
            tempC.endDate = [dateFormatter dateFromString: [elements objectAtIndex: 11]];
        }
    }
    
    [retStr release];
    [request release];
    
    /* This should be changed so that it inserts new courses from the server,
     not gets it from the persistent store, it should also create a new 
     available semester and assign that to its semester available property */
#if 0    
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext: self.managedObjectContext];
    [fetchrequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(semester == %@)",
                              semStr];
    
    [fetchrequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchrequest error:&error];
    
    if (array != nil) {
        
        for(Course* c in array){
            c.semesteravailable = ac;
        }
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching lots");
    }
#endif    
    /* END THE SECTION THAT NEEDS TO BE CHANGED */
    
    
    
    [self saveContext];
}

@end
