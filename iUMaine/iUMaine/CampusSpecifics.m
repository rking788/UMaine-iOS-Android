//
//  CampusSpecifics.m
//  iUMaine
//
//  Created by Rob King on 1/9/12.
//  Copyright (c) 2012 University of Maine. All rights reserved.
//

#import "CampusSpecifics.h"

#pragma mark - TODO: Make the key strings for the plist dictionary constants in the 'constants' file

@implementation CampusSpecifics

@synthesize campusShortName;

static NSDictionary* sportsDict;
static NSDictionary* navbarColor;
static NSDictionary* segmentControlColor;
static NSDictionary* directorynameTextColor;
static NSDictionary* sportsGradTopColor;
static NSDictionary* sportsGradBottomColor;
static NSDictionary* sportsLineColor;

-(id) initWithCampusName: (NSString*) campus{
    self = [super init];
    
    if(self){
        self.campusShortName = campus;
        [self fillSpecifics];
    }
    
    return self;
}

- (void) fillSpecifics
{
    NSString* specFileName = [NSString stringWithFormat: @"%@Specifics", self.campusShortName];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:specFileName ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile: filePath];   

    NSLog(@"Specifics file contents %@", dict);

    sportsDict = [dict objectForKey: @"Sports"];
    navbarColor = [dict valueForKey: @"NavBarColor"];
    segmentControlColor = [dict valueForKey: @"SegmentControlColor"];
    directorynameTextColor = [dict valueForKey: @"DirectoryNameTextColor"];
    sportsGradTopColor = [dict valueForKey: @"SportsGradTopColor"];
    sportsGradBottomColor = [dict valueForKey: @"SportsGradBottomColor"];
    sportsLineColor = [dict valueForKey: @"SportsLineColor"];
}

// Static Accessors
+ (NSDictionary*) getSportsDict
{
    return sportsDict;
}

+ (UIColor*) getNavBarColor
{
    return 
    [UIColor colorWithRed: ([[navbarColor valueForKey: @"red"] floatValue] / 255.0)
                    green: ([[navbarColor valueForKey: @"green"] floatValue] / 255.0)
                     blue: ([[navbarColor valueForKey: @"blue"] floatValue] / 255.0)
                    alpha: ([[navbarColor valueForKey: @"alpha"] floatValue])];
}

+ (UIColor*) getSegmentControlColor
{
    return 
    [UIColor colorWithRed: ([[segmentControlColor valueForKey: @"red"] floatValue] / 255.0)
                    green: ([[segmentControlColor valueForKey: @"green"] floatValue] / 255.0)
                     blue: ([[segmentControlColor valueForKey: @"blue"] floatValue] / 255.0)
                    alpha: ([[segmentControlColor valueForKey: @"alpha"] floatValue])];
}

+ (UIColor*) getDDNameTextColor
{
    return
    [UIColor colorWithRed: ([[directorynameTextColor valueForKey: @"red"] floatValue] / 255.0)
                    green: ([[directorynameTextColor valueForKey: @"green"] floatValue] / 255.0)
                     blue: ([[directorynameTextColor valueForKey: @"blue"] floatValue] / 255.0)
                    alpha: ([[directorynameTextColor valueForKey: @"alpha"] floatValue])];

}

+ (UIColor*) getSportsGradTopColor
{
    return 
    [UIColor colorWithRed: ([[sportsGradTopColor valueForKey: @"red"] floatValue] / 255.0)
                    green: ([[sportsGradTopColor valueForKey: @"green"] floatValue] / 255.0)
                     blue: ([[sportsGradTopColor valueForKey: @"blue"] floatValue] / 255.0)
                    alpha: ([[sportsGradTopColor valueForKey: @"alpha"] floatValue])];

}

+ (UIColor*) getSportsGradBottomColor
{
    return 
    [UIColor colorWithRed: ([[sportsGradBottomColor valueForKey: @"red"] floatValue] / 255.0)
                    green: ([[sportsGradBottomColor valueForKey: @"green"] floatValue] / 255.0)
                     blue: ([[sportsGradBottomColor valueForKey: @"blue"] floatValue] / 255.0)
                    alpha: ([[sportsGradBottomColor valueForKey: @"alpha"] floatValue])];

}

+ (UIColor*) getSportsLineColor
{
    return 
    [UIColor colorWithRed: ([[sportsLineColor valueForKey: @"red"] floatValue] / 255.0)
                    green: ([[sportsLineColor valueForKey: @"green"] floatValue] / 255.0)
                     blue: ([[sportsLineColor valueForKey: @"blue"] floatValue] / 255.0)
                    alpha: ([[sportsLineColor valueForKey: @"alpha"] floatValue])];    
}

+ (UIColor*) getSportsLoadingBackgroundColor
{
    // The loading background is the same as the nav bar color
    return [CampusSpecifics getNavBarColor];
}

@end
