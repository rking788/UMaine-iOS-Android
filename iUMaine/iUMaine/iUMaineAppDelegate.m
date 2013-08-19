//
//  iUMaineAppDelegate.m
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "iUMaineAppDelegate.h"
#import "ScheduleViewController.h"
#import "SportsViewController.h"
#import "MapViewController.h"
#import "SportEvent.h"
#import "Course.h"
#import "AvailableCourses.h"
#import "TBXML.h"
#import "constants.h"
#import "CampusSpecifics.h"
#import <Crashlytics/Crashlytics.h>

#define INIT_DB 0

// Only import this file when we need to initialize the sqlite file 
#if INIT_DB
#import "dbInitializer.h"
#endif

#pragma mark - TODO CRITICAL: SOME LONG RUNNING TASK IS NOT BEING PERFORMED IN THE BACKGROUND FIND OUT WHAT IT IS. (SCREEN FREEZES ON LAUNCH AFTER FRESH INSTALL ) SOME SERVER COMMUNICATION OR SOMETHING PROBABLY
#pragma mark - TODO: Need better icons for the tab bar icons

@implementation iUMaineAppDelegate

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize window=_window;

@synthesize svcInst;
@synthesize spvcInst;
@synthesize mvcInst;
@synthesize tabBarController=_tabBarController;
@synthesize progressView;
@synthesize progressBar;
@synthesize progressText;
@synthesize defaultPrefs;
@synthesize campusSpecifics;
@synthesize lastUpdateStr;
@synthesize gettingSports;

// Static value for the selected campus, use accessor
static NSString* selCampus;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"24cfbdb25b3fc903efc0e555e1983a86ce707993"];
    
    /**
     * This needs to be done absolutely first, before the ScheduleViewController is loaded.
     * Otherwise, the campus select VC will always be shown
     */
    self.defaultPrefs = [NSUserDefaults standardUserDefaults];
    selCampus = [self.defaultPrefs objectForKey: DEFS_SELCAMPUSKEY];
    
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    
    self.gettingSports = NO;
    
    [self addProgressBarView];
    
    // Initialize the database file (should be removed after .sqlite file is setup
#if INIT_DB
    selCampus = @"USM";
    DBInitializer* dbIniter = [[DBInitializer alloc] init];
    dbIniter.managedObjectContext = self.managedObjectContext;
    [dbIniter initDatabaseWithCampus: selCampus];
#endif

    if(selCampus){
        [self checkServer];
        
        [self setCampusSpecifics: [[CampusSpecifics alloc] initWithCampusName: selCampus]];

        // Migrate the default DB if necessary
        [self loadDefaultDB];
    }
    
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

    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
 
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSString* dbFileName = [NSString stringWithFormat: @"%@.sqlite", [iUMaineAppDelegate getSelCampus]];
    
    NSURL* storeURL = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: dbFileName]];
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];

    // These options are needed to map between the old model and the new model
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options: options error: &error]) {
        // Handle the error.
        NSLog(@"Failed to create the persistent store in iUMaineAppDelegate with error: %@", [error localizedDescription]);
    }    
    
    return _persistentStoreCoordinator;
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
    NSString* dbFileName = [NSString stringWithFormat: @"%@.sqlite",  [iUMaineAppDelegate getSelCampus]];
    
    NSLog(@"Using DB with filename: %@ first time (loaddefaultDB)", [NSString stringWithFormat: @"%@.sqlite",  [iUMaineAppDelegate getSelCampus]]);
    NSString* dbPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: dbFileName];
    
    success = [fm fileExistsAtPath: dbPath];
    
    // If the database exists then just return
    if(success){
        NSLog(@"DB File exists");
        return;
    }
    
    NSLog(@"Using DB with filename: %@ second time (loaddefaultDB)", [NSString stringWithFormat: @"%@.sqlite",   [iUMaineAppDelegate getSelCampus]]);
    NSString* defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: dbFileName];
    
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

+ (NSString*) getSelCampus
{
    return selCampus;
}

+ (void) setSelCampus:(NSString *)campus
{
    selCampus = campus;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [self saveContext];
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

- (void) resetContext
{
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
}

- (void) saveContext
{
    NSError* err;
    if(self.managedObjectContext != nil){
        if([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&err]){
            // Handle the error in here 
        }
    }   
}

- (void) campusSelected:(NSString *)campusStr
{
    // If a new campus was selected we want to set the managed object context to nil
    // so that if a DB file was previously loaded, the new one will be loaded for the new campus
//    _managedObjectModel = nil;
//    _managedObjectContext = nil;
//    _persistentStoreCoordinator = nil;
    
    [iUMaineAppDelegate setSelCampus: campusStr];
    
    [self setCampusSpecifics: [[CampusSpecifics alloc] initWithCampusName: selCampus]];
    
    // Set the selected campus in the user defaults
    [self.defaultPrefs setObject:  [iUMaineAppDelegate getSelCampus] forKey: DEFS_SELCAMPUSKEY];
    [self.defaultPrefs synchronize];
    
    // Now that we know which DB file to use we can check for sports and course updates
    [self checkServer];
}

- (void) checkServer
{
    // Start a new thread to check the server for new sports information
    
    self.gettingSports = YES;
    [NSThread detachNewThreadSelector: @selector(checkSportsUpdates) 
                             toTarget: self withObject: nil];
}

#pragma mark - Sports related methods
- (void) checkSportsUpdates
{
    @autoreleasepool {
        // Set up a new managed object context for the background thread operations
        NSManagedObjectContext* backgroundMOC = nil; 
        iUMaineAppDelegate* appDel = (iUMaineAppDelegate*)[[UIApplication sharedApplication] delegate];
        backgroundMOC = [[NSManagedObjectContext alloc] init];
        [backgroundMOC setUndoManager: nil];
        [backgroundMOC setPersistentStoreCoordinator: appDel.persistentStoreCoordinator];
        
        NSDate* lastScanDate = [self.defaultPrefs objectForKey: DEFS_LASTSPORTSUPDATE];
        NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];

        [self setLastUpdateStr: [dateformatter stringFromDate: lastScanDate]];
        if(!self.lastUpdateStr)
            self.lastUpdateStr = @"2011-11-22 00:00:00";
        
        NSURLResponse* resp = nil;
        NSError* err = nil;
        
        // Add the event information into the POST request content
        NSURL* url = [NSURL URLWithString:@"http://mainelyapps.com/umaine/sports/FetchSportsUpdates.php"];
        // NSString* content = [NSString stringWithFormat: @"date=%@", self.lastUpdateStr];
        NSString* content = [NSString stringWithFormat: @"date=%@&campus=%@", self.lastUpdateStr,  [iUMaineAppDelegate getSelCampus]];
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: url];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: [content dataUsingEncoding: NSUTF8StringEncoding]];
        
        NSData* ret = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
        NSString* retStr = [[NSString alloc] initWithData: ret encoding: NSUTF8StringEncoding];
        
        // Check if there were any new events or not
        if(![retStr isEqualToString: @""]){
            // Get an array of the new events
            NSArray* eventsArr = [retStr componentsSeparatedByString: @"\n"];
            
            [self performSelectorOnMainThread: @selector(updateProgressTitle:) 
                                   withObject: @"Downloading Sports Events" waitUntilDone: YES];
            [self performSelectorOnMainThread: @selector(updateProgressBar:) 
                                   withObject: [NSNumber numberWithFloat: 0.0] 
                                waitUntilDone: YES];
            [self performSelectorOnMainThread: @selector(animateProgressViewIn:) 
                                   withObject: [NSNumber numberWithBool: YES] waitUntilDone: YES];
            
            float totalEvents = [eventsArr count];
            float currentEvent = 0.0;
            // The event lines are in the form
            // date;home;recapLink;result;sport;teamA;teamB;year;\n
            for(NSString* eventLine in eventsArr){
                
                NSArray* eComps = [eventLine componentsSeparatedByString: @";"];
                
                if ([eComps count] == 1) {
                    continue;
                }
                
                SportEvent* tempEvent = [[SportEvent alloc] initWithEntity: [NSEntityDescription entityForName:@"SportEvent" inManagedObjectContext: backgroundMOC] insertIntoManagedObjectContext: nil];

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
                
                [self updateOrAddEvent: tempEvent WithMOC: backgroundMOC];
                
                ++currentEvent;
                
                [self performSelectorOnMainThread: @selector(updateProgressBar:) 
                                       withObject: [NSNumber numberWithFloat: (currentEvent/totalEvents)] 
                                    waitUntilDone: YES];
            }
            
            [self performSelectorOnMainThread: @selector(animateProgressViewIn:) 
                                   withObject: [NSNumber numberWithBool: NO] waitUntilDone: YES];
            
            // Just updated the events so set the last event update as today's date
            NSDate* lastUpdate = [NSDate date];
            [self.defaultPrefs setObject: lastUpdate forKey: DEFS_LASTSPORTSUPDATE];
            [self setLastUpdateStr: [dateformatter stringFromDate: [NSDate date]]];
        }
    
        [backgroundMOC save: &err];
    
        [self performSelectorOnMainThread: @selector( doneLoadingSports) withObject: nil waitUntilDone: NO];
    }
    
    [self checkForNewSemesters];
}

- (void) updateOrAddEvent:(SportEvent *)newE WithMOC:(NSManagedObjectContext *)moc
{
    // See if event is already on the phone
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SportEvent" inManagedObjectContext: moc];
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
    NSArray *array = [moc executeFetchRequest:fetchrequest error:&error];
    
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
        event = [NSEntityDescription insertNewObjectForEntityForName: @"SportEvent" inManagedObjectContext: moc];
        
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

    if(![moc save:&err]){
        // Handle the error here
        NSLog(@"Failed to save the managedObjectContext");
    }
    
}

- (void) doneLoadingSports
{
    self.gettingSports = NO;
    
    // Readjust the map view so the map isn't shrunk for the progress bar
    [self.mvcInst growMapView];
    
    // Load the new sports into the sports view and display them
    [self.spvcInst displayEvents];
    [self.spvcInst hideLoadingView];
}

- (void) checkForNewSemesters
{
    @autoreleasepool {
        NSManagedObjectContext* backgroundMOC2 = nil;
        iUMaineAppDelegate* appDel = (iUMaineAppDelegate*)[[UIApplication sharedApplication] delegate];
        backgroundMOC2 = [[NSManagedObjectContext alloc] init];
        [backgroundMOC2 setUndoManager: nil];
        [backgroundMOC2 setPersistentStoreCoordinator: appDel.persistentStoreCoordinator];
        
        NSArray* localSemesters = [self getLocalSemestersWithMOC: backgroundMOC2];
        
        NSURLResponse* resp = nil;
        NSError* err = nil;
        
        // Add the event information into the POST request content
        NSURL* url = [NSURL URLWithString:@"http://mainelyapps.com/umaine/FetchAvailableCourses.php"];
        NSString* content = [NSString stringWithFormat: @"op=%@&campus=%@", @"getsemesters",  [iUMaineAppDelegate getSelCampus]];
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: url];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: [content dataUsingEncoding: NSUTF8StringEncoding]];
        
        NSData* ret = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
        NSString* tempRetStr = [[NSString alloc] initWithData: ret encoding: NSUTF8StringEncoding];
        
        NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
        NSString* retStr = [tempRetStr stringByTrimmingCharactersInSet: charSet];
        
        if(![retStr isEqualToString: @""]){
            // Get an array of the semesters stored on the server
            NSArray* semArr = [retStr componentsSeparatedByString: @"\n"];
            
            for(NSString* sem in semArr){
                if(![localSemesters containsObject: sem]){
                    [self fetchSemesterCourses: sem WithMOC: backgroundMOC2];
                }
            }
        
            [self performSelectorOnMainThread: @selector(reloadSVCSemesters) withObject: nil waitUntilDone: NO];
        }
        
    }
}

- (NSArray*) getLocalSemestersWithMOC:(NSManagedObjectContext *)moc
{
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AvailableCourses" inManagedObjectContext: moc];
    [fetchrequest setEntity:entity];
    
    NSDictionary* entityProps = [entity propertiesByName];
    NSArray* propArr = [[NSArray alloc] initWithObjects: [entityProps objectForKey: @"semesterStr"], nil];
    [fetchrequest setPropertiesToFetch: propArr];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:fetchrequest error:&error];
    if (array != nil) {
        
        for(NSManagedObject* obj in array){
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching the list of local semesters");
    }

    
    return [array valueForKey: @"semesterStr"];
}

- (void) fetchSemesterCourses:(NSString *)semStr WithMOC:(NSManagedObjectContext *)moc
{
    AvailableCourses* ac = [NSEntityDescription insertNewObjectForEntityForName: @"AvailableCourses" 
                                                inManagedObjectContext: moc];
    
    [ac setSemesterStr: semStr];
    
    NSURLResponse* resp = nil;
    NSError* err = nil;
    
    // Add the event information into the POST request content
    NSString* campusName =  [iUMaineAppDelegate getSelCampus];
    NSURL* url = [NSURL URLWithString:@"http://mainelyapps.com/umaine/FetchAvailableCourses.php"];
    NSString* content = [NSString stringWithFormat: @"op=%@&sem=%@&campus=%@", @"getallforsemester", semStr, campusName];
    
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
        
        [self performSelectorOnMainThread: @selector(updateProgressTitle:) 
                               withObject: [NSString stringWithFormat: @"Downloading Courses for %@", [iUMaineAppDelegate semesterStrToReadable: semStr]] waitUntilDone: YES];
        [self performSelectorOnMainThread: @selector(updateProgressBar:) 
                               withObject: [NSNumber numberWithFloat: 0.0] 
                            waitUntilDone: YES];
        [self performSelectorOnMainThread: @selector(animateProgressViewIn:) 
                               withObject: [NSNumber numberWithBool: YES] waitUntilDone: YES];
                
        float totalCourseNum = [courseLines count];
        float currentCourseNum = 0.0;
        for(__strong NSString* line in courseLines){
            if([line isEqualToString: @""])
                continue;
            
            Course* tempC = [NSEntityDescription insertNewObjectForEntityForName: @"Course" inManagedObjectContext: moc];
            
            /* Create the relationship between the newly created availablecourses and this new course object */
            tempC.semesteravailable = ac;
            
            NSRange textRange = [line rangeOfString:@"&amp;"];
            if(textRange.location != NSNotFound)
                line = [line stringByReplacingOccurrencesOfString: @"&amp;" withString: @"&"];
            
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
        
            ++currentCourseNum;
            [self performSelectorOnMainThread: @selector(updateProgressBar:) 
                                   withObject: [NSNumber numberWithFloat: (currentCourseNum/totalCourseNum)] 
                                waitUntilDone: YES];
        }
        
        [self performSelectorOnMainThread: @selector(animateProgressViewIn:) 
                               withObject: [NSNumber numberWithBool: NO] waitUntilDone: YES];
    }
    
    
    /* This should be changed so that it inserts new courses from the server,
     not gets it from the persistent store, it should also create a new 
     available semester and assign that to its semester available property */
#if 0    
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext: moc];
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
    
    // Change this save context to use the background context
    //[self saveContext];
    [moc save: &err];
}

- (void) reloadSVCSemesters
{
    if(!svcInst)
        return;
    
    [self.svcInst setAllAvailableSemesters: [self getLocalSemestersWithMOC: self.managedObjectContext]];
}

- (void) addProgressBarView
{
    UITabBar* tBar = self.tabBarController.tabBar;
    CGRect tbFrame = CGRectMake(0, tBar.frame.origin.y,  self.progressView.frame.size.width, progressView.frame.size.height);
    [progressView setFrame: tbFrame];

    [self.tabBarController.view addSubview: progressView];
    NSInteger tabBarIndex = [self.tabBarController.view.subviews indexOfObject: self.tabBarController.tabBar];
    NSInteger progressIndex = [self.tabBarController.view.subviews indexOfObject: self.progressView];
    [self.tabBarController.view exchangeSubviewAtIndex: tabBarIndex withSubviewAtIndex: progressIndex];
}

- (void) animateProgressViewIn: (NSNumber*) show
{
    [UIView beginAnimations:@"fixupViews" context:nil];
    
    if ([show boolValue]) {
        // Animate the map view up so the Google logo isn't hidden
        if(self.mvcInst && self.mvcInst.isViewLoaded && self.mvcInst.view.window){
            [self.mvcInst shrinkMapView];
        }
        
        // Display the progress view
        CGRect progressViewFrame = [self.progressView frame];
        progressViewFrame.origin.x = 0;
        progressViewFrame.origin.y = (self.tabBarController.tabBar.frame.origin.y - self.progressView.frame.size.height);
        [self.progressView setFrame: progressViewFrame];
    } else {
        // Animate the map view back down
        if(self.mvcInst && self.mvcInst.isViewLoaded && self.mvcInst.view.window){
            [self.mvcInst growMapView];
        }
        
        // Hide the progress view

        CGRect progressViewFrame = [self.progressView frame];
        progressViewFrame.origin.x = 0;
        progressViewFrame.origin.y = self.tabBarController.tabBar.frame.origin.y;
        [self.progressView setFrame: progressViewFrame];         

    }
    
    [UIView commitAnimations];
}


- (void) updateProgressBar: (NSNumber*) percent
{
    [self.progressBar setProgress: [percent floatValue]];
}

- (void) updateProgressTitle: (NSString*) text
{
    [self.progressText setText: text];
}

+ (NSString*) semesterStrToReadable: (NSString*) semesterStr
{
    NSString* yearStr = [semesterStr substringToIndex: 4];
    semesterStr = [semesterStr stringByReplacingCharactersInRange: NSMakeRange(0, 4) withString: @""];
    
    NSString* firstChar = [[semesterStr substringToIndex: 1] capitalizedString];
    NSString* seasonStr = [semesterStr stringByReplacingCharactersInRange: NSMakeRange(0, 1) withString: firstChar];
    
    return [NSString stringWithFormat: @"%@ %@", seasonStr, yearStr];
}


@end
