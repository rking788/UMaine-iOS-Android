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

- (void) selectBuildingLocation: (NSString*) buildingName withLatitude: (double) dLatitude withLongitude: (double) dLongitude;

@end


@interface BuildingSelectView : UITableViewController {
    
    UISearchBar *searchBar;
    UITableView *tblView;
    NSMutableArray* listContents;
    NSMutableArray* listSubContents;
    NSMutableArray* listLocations;
    NSMutableArray* searchListContents;
    NSMutableArray* searchListSubContents;
    NSMutableArray* searchListLocations;
    BOOL searching;
}
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *tblView;

@property (nonatomic, strong) NSMutableArray* listContents;
@property (nonatomic, strong) NSMutableArray* listSubContents;
@property (nonatomic, strong) NSMutableArray* listLocations;
@property (nonatomic, strong) NSMutableArray* searchListContents;
@property (nonatomic, strong) NSMutableArray* searchListSubContents;
@property (nonatomic, strong) NSMutableArray* searchListLocations;

@property (nonatomic, getter = isSearching) BOOL searching;

// Delegate used when an item is selected from the table view 
@property (nonatomic, strong) id<BuildingSelectDelegate> selectDelegate;

- (void) populateListContents;
- (void) cancelClicked: (id) sender;
- (void) searchTable;

@end