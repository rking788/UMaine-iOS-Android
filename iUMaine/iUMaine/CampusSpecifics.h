//
//  CampusSpecifics.h
//  iUMaine
//
//  Created by Rob King on 1/9/12.
//  Copyright (c) 2012 University of Maine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CampusSpecifics : NSObject{
    NSString* campusShortName;
}

@property (strong, nonatomic) NSString* campusShortName;

- (id) initWithCampusName: (NSString*) campus;
- (void) fillSpecifics;

+ (NSDictionary*) getSportsDict;
+ (NSDictionary*) getPermitTitles;
+ (UIColor*) getNavBarColor;
+ (UIColor*) getSegmentControlColor;
+ (UIColor*) getDDNameTextColor;
+ (UIColor*) getSportsGradTopColor;
+ (UIColor*) getSportsGradBottomColor;
+ (UIColor*) getSportsLineColor;
+ (UIColor*) getSportsLoadingBackgroundColor;

@end
