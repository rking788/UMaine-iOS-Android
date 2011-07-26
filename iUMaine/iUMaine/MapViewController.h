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
#import "POIAnnotation.h"
#import "BuildingSelectView.h"


@interface MapViewController : UIViewController <MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, BuildingSelectDelegate>{

    MKMapView *mapView;
    POIAnnotation* mapSelBuildingAnnotation;
    NSMutableArray* mapPOIAnnotations;
    
    NSManagedObjectContext *managedObjectContext;
    UINavigationBar *navBar;
    UIPickerView *pickerView;
    UINavigationItem *titleView;
    
    UIActionSheet* actSheet;
    
    // Titles for picker view
    NSArray* permitTitles;
    
    NSString* curPermit;
    NSString* prevPermit;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) UIActionSheet* actSheet;
@property (nonatomic, retain) NSArray* permitTitles;
@property (nonatomic, retain) NSString* curPermit;
@property (nonatomic, retain) NSString* prevPermit;

@property (nonatomic, retain) POIAnnotation* mapSelBuildingAnnotation;
@property (nonatomic, retain) NSMutableArray* mapPOIAnnotations;

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

- (IBAction)valchange:(id)sender;

- (void) showPickerview;
- (void) addParkingAnnotationsOfType:(NSString*) permitType;
- (void) dismissActionSheet;

@end
