//
//  Employee.h
//  iUMaine
//
//  Created by Robert King on 7/28/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employee : NSManagedObject

@property (nonatomic, retain) NSString * deptURL;
@property (nonatomic, retain) NSString * personalURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * office;

@end
