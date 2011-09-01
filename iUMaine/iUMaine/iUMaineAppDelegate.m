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
    NSError* err;
    if(managedObjectContext != nil){
        if([managedObjectContext hasChanges] && ![managedObjectContext save:&err]){
            // Handle the error in here 
        }
    }
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
    
    // Add the course information into the POST request content
    NSURL* url = [NSURL URLWithString:@"http://mainelyapps.com/umaine/FetchSportsUpdates.php"];
    NSString* content = [NSString stringWithFormat: @"date=%@", self.lastUpdateStr];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [content dataUsingEncoding: NSUTF8StringEncoding]];
    
    NSData* ret = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
    NSString* retStr = [[NSString alloc] initWithData: ret encoding: NSUTF8StringEncoding];
    
    // Check if there were any new courses or not
    if(![retStr isEqualToString: @""]){
        // Get an array of the new courses
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
                [tempEvent setRecapLink: nil];
            else
                [tempEvent setRecapLink: resultStr];
            
            // Sport
            [tempEvent setSport: [eComps objectAtIndex: 4]];
            
            // Team A
            [tempEvent setTeamA: [eComps objectAtIndex: 5]];
            
            // Team B
            [tempEvent setTeamB: [eComps objectAtIndex: 6]];
            
            // Year
            [tempEvent setYear: [NSNumber numberWithInteger: [[eComps objectAtIndex: 7] integerValue]]];
            
            [self updateOrAddEvent: tempEvent];
            
            [tempEvent release];
        }
        
        // Just updated the courses so set the last course update as today's date
        NSDate* lastUpdate = [NSDate date];
        [self.defaultPrefs setObject: lastUpdate forKey: @"LastSportsUpdate"];
        [self setLastUpdateStr: [dateformatter stringFromDate: [NSDate date]]];
    }
    
    [retStr release];
    [request release];
    [dateformatter release];
    [pool release];
}

- (void) updateOrAddEvent:(SportEvent *)newE
{
    // See if course is already on the phone
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
        // Add the new course into the persistent store
        event = [NSEntityDescription insertNewObjectForEntityForName: @"SportEvent" inManagedObjectContext: self.managedObjectContext];
        
        [event setDate: newE.date];
        [event setHome: newE.home];
        [event setSport: newE.sport];
        [event setTeamA: newE.teamA];
        [event setTeamB: newE.teamB];
        [event setYear: newE.year];
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


@end
