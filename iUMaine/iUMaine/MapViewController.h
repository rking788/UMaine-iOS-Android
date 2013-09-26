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

@class iUMaineAppDelegate;


@interface MapViewController : UIViewController <MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, BuildingSelectDelegate>{

    iUMaineAppDelegate* appDel;
    
    MKMapView *mapView;
    POIAnnotation* mapSelBuildingAnnotation;
    NSMutableArray* mapPOIAnnotations;
    
//    NSManagedObjectContext *managedObjectContext;
    UINavigationBar *navBar;
    UIPickerView *pickerView;
    UINavigationItem *titleView;
    
    UIActionSheet* actSheet;
    
    // Titles for picker view
    NSDictionary* permitTitles;
    NSArray* sortedPermitTitles;
    
    NSUserDefaults* uDefaults;
    
    NSString* curPermit;
    NSString* prevPermit;

    BOOL smaller;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (unsafe_unretained, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, strong) iUMaineAppDelegate* appDel;
@property (nonatomic, strong) UIActionSheet* actSheet;
@property (nonatomic, strong) NSDictionary* permitTitles;
@property (strong, nonatomic) NSArray* sortedPermitTitles;
@property (nonatomic, strong) NSUserDefaults* uDefaults;
@property (nonatomic, strong) NSString* curPermit;
@property (nonatomic, strong) NSString* prevPermit;
@property (nonatomic, assign) NSUInteger activeUSMCampus;

@property (nonatomic, strong) POIAnnotation* mapSelBuildingAnnotation;
@property (nonatomic, strong) NSMutableArray* mapPOIAnnotations;

//@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@property (atomic, assign, getter = isSmaller) BOOL smaller; 

- (IBAction)valchange:(id)sender;

- (void) showPickerview;
- (NSArray*) findCenterOfCampus; 
- (void) addParkingAnnotationsOfType:(NSString*) permitType;
- (void) dismissActionSheet;
- (void) shrinkMapView;
- (void) growMapView;

@end
