//
//  CourseDetailSelectionViewController.h
//  iUMaine
//
//  Created by Robert King on 11/9/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseDetailSelectionDelegate <NSObject>
// recipe == nil on cancel
- (void) detailSelection:(NSString*) selectionStr ForSection: (NSUInteger) rowSelected;
@end

@interface CourseDetailSelectionViewController : UITableViewController <UISearchDisplayDelegate>{
    
    NSArray* contentArr;
    NSUInteger row;
    
    NSString* savedSearchTerm;
    NSMutableArray* searchResults; 
    
    id<CourseDetailSelectionDelegate> delegate;
}

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSArray* contentArr;
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, retain) NSString* savedSearchTerm;
@property (nonatomic, retain) NSMutableArray* searchResults;
@property (nonatomic, retain) id<CourseDetailSelectionDelegate> delegate;

- (void) cancel;
- (void) handleSearchForTerm: (NSString*) term;

@end
