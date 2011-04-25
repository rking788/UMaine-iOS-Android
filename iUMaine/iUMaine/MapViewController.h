//
//  MapViewController.h
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>


@interface MapViewController : UIViewController <MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{

    MKMapView *mapView;
    NSMutableArray* mapPOIAnnotations;
    
    NSManagedObjectContext *managedObjectContext;
    UINavigationBar *navBar;
    UIPickerView *pickerView;
    UINavigationItem *titleView;
    UISearchBar *searchBar;
    
    UIActionSheet* actSheet;
    
    // Titles for picker view
    NSArray* permitTitles;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) UIActionSheet* actSheet;
@property (nonatomic, retain) NSArray* permitTitles;

@property (nonatomic, retain) NSMutableArray* mapPOIAnnotations;

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

- (IBAction)valchange:(id)sender;

- (void) showPickerview;
- (void) addCommuterAnnotations;
- (void) dismissActionSheet;

@end
