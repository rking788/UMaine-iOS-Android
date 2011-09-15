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

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

// Core Data related properties
@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@property (nonatomic, retain) NSUserDefaults* defaultPrefs;
@property (nonatomic, retain) NSString* lastUpdateStr;
@property (nonatomic, assign, getter = isGettingSports) BOOL gettingSports;


- (NSString *)applicationDocumentsDirectory;
//- (void)saveContext;

- (void)loadDefaultDB;
+ (iUMaineAppDelegate*) sharedAppDelegate;

- (void) checkSportsUpdates;
- (void) updateOrAddEvent:(SportEvent *)newE;

@end
