//
//  Location.m
//  iUMaine
//
//  Created by Robert King on 11/13/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import "Location.h"


@implementation Location

@dynamic title;
@dynamic longitude;
@dynamic latitude;

- (id)valueForUndefinedKey:(NSString *)key
{
    return @"";
}

@end
