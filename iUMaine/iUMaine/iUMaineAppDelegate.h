//
//  iUMaineAppDelegate.h
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL?. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class SportEvent;

@interface iUMaineAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel* managedObjectModel;
    NSPersistentStoreCoordinator* persistentStoreCoordinator;
    
    NSUserDefaults* defaultPrefs;
    NSString* lastUpdateStr;

    BOOL gettingSports;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (strong, nonatomic) IBOutlet UIView *progressView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *progressText;

// Core Data related properties
@property (nonatomic, strong, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@property (nonatomic, strong) NSUserDefaults* defaultPrefs;
@property (nonatomic, strong) NSString* lastUpdateStr;
@property (nonatomic, assign, getter = isGettingSports) BOOL gettingSports;


- (NSString *)applicationDocumentsDirectory;
//- (void)saveContext;

- (void)loadDefaultDB;
+ (iUMaineAppDelegate*) sharedAppDelegate;

- (void) saveContext;

- (void) checkSportsUpdates;
- (void) updateOrAddEvent:(SportEvent *)newE;

- (void) checkForNewSemesters;
- (NSArray*) getLocalSemesters;
- (void) fetchSemesterCourses: (NSString*) semStr;

- (void) addProgressBarView;
- (void) animateProgressViewIn: (NSNumber*) show;
- (void) updateProgressBar: (NSNumber*) percent;
- (void) updateProgressTitle: (NSString*) text;

@end
