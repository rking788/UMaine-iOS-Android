//
//  CampusSelectionViewController.h
//  iUMaine
//
//  Created by Robert King on 12/8/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCampusDelegate <NSObject>

- (void) campusSelected: (NSString*) campusStr;

@end

@interface CampusSelectionViewController : UITableViewController{
    NSDictionary* campusSelDict;
    NSUInteger selIndex;
    
    NSString* currentCampus;
    
    id<SelectCampusDelegate> scD;
}

@property (strong, nonatomic) NSDictionary* campusSelDict;
@property (nonatomic) NSUInteger selIndex;

@property (strong, nonatomic) NSString* currentCampus;

@property (strong, nonatomic) id<SelectCampusDelegate> scD;

- (void) cancel;
- (void) save;

@end
