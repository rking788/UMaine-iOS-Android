//
//  POIAnnotation.m
//  iUMaine
//
//  Created by RKing on 4/14/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "POIAnnotation.h"


@implementation POIAnnotation


@synthesize title;
@synthesize subtitle;
@synthesize image, latitude, longitude;


- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = 44.902517;
    theCoordinate.longitude = -68.667400;
    return theCoordinate; 
}

- (void)dealloc
{
    [title release];
    [subtitle release];
    [super dealloc];
}

- (NSString *)title
{
    return title;
}

// optional
- (NSString *)subtitle
{
    return subtitle;
}


@end
