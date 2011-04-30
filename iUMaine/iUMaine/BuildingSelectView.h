//
//  BuildingSelectView.h
//  iUMaine
//
//  Created by RKing on 4/26/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@protocol BuildingSelectDelegate <NSObject>

- (void) selectBuildingLocation: (NSString*) buildingName;

@end


@interface BuildingSelectView : UITableViewController {
    
    UISearchBar *searchBar;
    UITableView *tblView;
    NSMutableArray* listContents;
    NSMutableArray* listSubContents;
    NSMutableArray* searchListContents;
    NSManagedObjectContext* managedObjectContext;
    BOOL searching;
}
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tblView;

@property (nonatomic, retain) NSMutableArray* listContents;
@property (nonatomic, retain) NSMutableArray* listSubContents;
@property (nonatomic, retain) NSMutableArray* searchListContents;
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, getter = isSearching) BOOL searching;

// Delegate used when an item is selected from the table view 
@property (nonatomic, retain) id<BuildingSelectDelegate> selectDelegate;

- (void) populateListContents;
- (void) cancelClicked: (id) sender;
- (void) searchTable;

@end