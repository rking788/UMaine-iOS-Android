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
    
    NSUserDefaults* uDefaults;
    
    NSString* curPermit;
    NSString* prevPermit;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) UIActionSheet* actSheet;
@property (nonatomic, strong) NSArray* permitTitles;
@property (nonatomic, strong) NSUserDefaults* uDefaults;
@property (nonatomic, strong) NSString* curPermit;
@property (nonatomic, strong) NSString* prevPermit;

@property (nonatomic, strong) POIAnnotation* mapSelBuildingAnnotation;
@property (nonatomic, strong) NSMutableArray* mapPOIAnnotations;

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

- (IBAction)valchange:(id)sender;

- (void) showPickerview;
- (void) addParkingAnnotationsOfType:(NSString*) permitType;
- (void) dismissActionSheet;

@end
