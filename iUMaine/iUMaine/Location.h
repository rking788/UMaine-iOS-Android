//
//  Location.h
//  iUMaine
//
//  Created by Robert King on 11/13/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;

@end
