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

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray* contentArr;
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, strong) NSString* savedSearchTerm;
@property (nonatomic, strong) NSMutableArray* searchResults;
@property (nonatomic, strong) id<CourseDetailSelectionDelegate> delegate;

- (void) cancel;
- (void) handleSearchForTerm: (NSString*) term;

@end
