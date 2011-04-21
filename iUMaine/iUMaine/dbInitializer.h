//
//  dbInitializer.h
//  iUMaine
//
//  Created by RKing on 4/20/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBInitializer : NSObject {
    
    NSManagedObjectContext* managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

- (void) initializeDatabase;
- (void) initLotsOfType:(NSString*) permitType withFile:(NSString*) filePath;
- (void) initBuildingsWithFile:(NSString*) filePath;

@end
