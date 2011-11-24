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

@property (nonatomic, strong) NSString * deptURL;
@property (nonatomic, strong) NSString * personalURL;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * department;
@property (nonatomic, strong) NSString * office;

@end
