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


@interface MapViewController : UIViewController <MKMapViewDelegate>{

    MKMapView *mapView;
    NSMutableArray* mapPOIAnnotations;
    
    NSManagedObjectContext *managedObjectContext;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) NSMutableArray* mapPOIAnnotations;

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

@end
