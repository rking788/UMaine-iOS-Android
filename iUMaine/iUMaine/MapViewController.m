//
//  MapViewController.m
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "MapViewController.h"
#import "BuildingSelectView.h"

@implementation MapViewController

@synthesize navBar;
@synthesize actSheet;
@synthesize uDefaults;
@synthesize curPermit, prevPermit;
@synthesize mapView, mapPOIAnnotations, mapSelBuildingAnnotation, managedObjectContext, permitTitles;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set the center to barrows or something
    MKCoordinateRegion region;
    region.center.latitude = 44.901006;
    region.center.longitude = -68.667536;
    //0.013
    region.span.latitudeDelta = 0.006;
    region.span.longitudeDelta = 0.006;
    [self.mapView setRegion:region animated:false];
    
    // Set up the array of annotations
    self.mapPOIAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    
    // Initialize the titles for the parking permits
    self.permitTitles = [[NSArray alloc] initWithObjects: @"None", @"Staff / Faculty", @"Resident", @"Commuter", @"Visitor", nil];
    
    // TODO: Check to see if there is a selected permit already stored in persistent storage
    [self setUDefaults: [NSUserDefaults standardUserDefaults]];
    NSString* startingPermit = [self.uDefaults objectForKey: @"ParkingPermit"];
    if(startingPermit){
        [self addParkingAnnotationsOfType: startingPermit];
    }
    
    self.prevPermit = nil;
    self.curPermit = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)valchange:(id)sender {
    UISegmentedControl* segControl = (UISegmentedControl*) sender;
    
    NSInteger nSel = [segControl selectedSegmentIndex];
    if(nSel == 0){
        if([[segControl titleForSegmentAtIndex:nSel] isEqualToString:@"Map"]){
            [segControl setTitle:@"Satellite" forSegmentAtIndex:0];
            [self.mapView setMapType:MKMapTypeStandard];
        }
        else{
            [segControl setTitle:@"Map" forSegmentAtIndex:0];
            [self.mapView setMapType:MKMapTypeSatellite];   
        }
    }
    else if(nSel == 1){
        [self showPickerview];
    }
    else if(nSel == 2){
        BuildingSelectView* bsView = [[BuildingSelectView alloc] initWithNibName:@"BuildingSelectView" bundle:nil];
        
        bsView.selectDelegate = self;
        [bsView setManagedObjectContext:self.managedObjectContext];
        
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:bsView];
        [navigationController.navigationBar setBarStyle: UIBarStyleBlack];
        [self presentModalViewController:navigationController animated:YES];
        [bsView release];
    }

}

- (void) showPickerview{
    self.actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]; 

    NSInteger nCur = [self.permitTitles indexOfObject:[self curPermit]];
    if(nCur == NSNotFound)
        nCur = 0;
    
    [self.actSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);

    UIPickerView* pickView = [[UIPickerView alloc] initWithFrame: pickerFrame];
    pickView.showsSelectionIndicator = YES;
    pickView.dataSource = self;
    pickView.delegate = self;
    pickView.tag = 150;
    [pickView selectRow: nCur inComponent: 0 animated: NO];
    [actSheet addSubview: pickView];
    
    // TODO: Do not hard code these size values if possible
    UISegmentedControl* closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Done", nil]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    [self.actSheet addSubview:closeButton];
    [closeButton release];
    
    [self.actSheet showInView: self.view.window];
    
    [self.actSheet setBounds:CGRectMake(0, 0, 320, 485)];
    [self.actSheet autorelease];
    
}

- (void) dismissActionSheet{
    [self.actSheet dismissWithClickedButtonIndex:0 animated:YES];
    UIPickerView* picker = (UIPickerView*) [self.actSheet viewWithTag:150];
    [self setActSheet:nil];
    
    if(curPermit != nil)
        self.prevPermit = self.curPermit;
    
    self.curPermit = [self.permitTitles objectAtIndex:[picker selectedRowInComponent:0]];
    
    if(!self.curPermit){
        self.curPermit = [self.permitTitles objectAtIndex: 0];
    }
    
    // Draw the correct permit overlays
    if((!self.prevPermit) || (![self.prevPermit isEqualToString: self.curPermit])){
        [self addParkingAnnotationsOfType: self.curPermit]; 
    }
}

- (void) addParkingAnnotationsOfType:(NSString*) permitType{
    
    if(!permitType)
        return;
    
    // Set the last used parking permit in the user defaults
    // For right now set the default parking permit as the last permit displayed (this might not be right)
    // Maybe have the default permit be set in a settings tab or something 
    [self.uDefaults setObject: permitType forKey: @"ParkingPermit"];
    
    //If there are already annotations on the map then remove them 
    if([self.mapPOIAnnotations count] != 1){
        [self.mapView removeAnnotations: self.mapPOIAnnotations];
        [[self mapPOIAnnotations] removeAllObjects];
    }
    
    //If 'None' was selected then just leave the annotations blank
    if([permitType isEqualToString:@"None"]){
        return;
    }
    
    /* Handle a special case where if the permit selected was staff/faculty
        we only want to search for faculty in the database */
    NSString* searchString;
    if([permitType isEqualToString:@"Staff / Faculty"]){
        searchString = @"faculty";
    }
    else{
        searchString = [permitType lowercaseString];
    }
    
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ParkingLot" inManagedObjectContext:self.managedObjectContext];
    [fetchrequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"permittype == %@", searchString];
    [fetchrequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchrequest error:&error];
    if (array != nil) {
        double latitude = 0.0;
        double longitude = 0.0;
        
        for(NSManagedObject* manObj in array){
            
            latitude = [[manObj valueForKey:@"latitude"] doubleValue]/1000000.0;
            longitude = [[manObj valueForKey:@"longitude"] doubleValue]/1000000.0;
            
            POIAnnotation* poiAnnot = [[POIAnnotation alloc] initWithLat:latitude withLong:longitude];
            [poiAnnot setTitle: [manObj valueForKey:@"title"]];
            [poiAnnot setSubtitle: [NSString stringWithFormat: @"%@ Lot", permitType]];
            
            [self.mapPOIAnnotations insertObject:poiAnnot atIndex: 0];
            [poiAnnot release];
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching lots");
    }

    
    // Add the annotation to the mapview
    [self.mapView addAnnotations:self.mapPOIAnnotations];
    [fetchrequest release];
}

// MapView animation method
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views { 
    MKAnnotationView *aV; 
    for (aV in views) {
        CGRect endFrame = aV.frame;
        
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [aV setFrame:endFrame];
        [UIView commitAnimations];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[POIAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* POIAnnotationID = @"poiAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:POIAnnotationID];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:POIAnnotationID] autorelease];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = NO;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            //UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //[rightButton addTarget:self
            //                action:@selector(showDetails:)
            //      forControlEvents:UIControlEventTouchUpInside];
            //customPinView.rightCalloutAccessoryView = rightButton;
            
            // TODO: it would be cool if these custom views animated into the map
           // MKAnnotationView* customPinView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: POIAnnotationID] autorelease];
            
           // [customPinView setCanShowCallout: NO];
           // [customPinView setDraggable: YES];
           // NSLog(@"Draggable: %@", ([customPinView isDraggable] ? @"YES" : @"NO"));
            
           // [customPinView setImage: [UIImage imageNamed:@"bear-paw-r_24.png"]];
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    NSLog(@"Changing Drag State");
    if(newState == MKAnnotationViewDragStateEnding){
        POIAnnotation* annot = annotationView.annotation;
        NSNumber* num1 = annot.latitude;
        NSNumber* num2 = annot.longitude;
        NSLog(@"New Lat: %@, New Long: %@", num1, num2);
    }
    else if(newState == MKAnnotationViewDragStateStarting){
        POIAnnotation* annot = annotationView.annotation;
        NSNumber* num1 = annot.latitude;
        NSNumber* num2 = annot.longitude;
        NSLog(@"Starting Lat: %@, Starting Long: %@", num1, num2);
    }
}

// UIPickerView delegate and datasource methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.permitTitles count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.permitTitles objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
}

#pragma mark BuildingSelectProtocol implementation

- (void) selectBuildingLocation: (NSString*) buildingName withLatitude:(double)dLatitude withLongitude:(double)dLongitude
{    
    if(!buildingName){
        [self dismissModalViewControllerAnimated: YES];
        return;
    }
    
    if (mapSelBuildingAnnotation) {
        [self.mapView removeAnnotation: mapSelBuildingAnnotation];
        [mapSelBuildingAnnotation release];
        [self setMapSelBuildingAnnotation: nil];
    }
    
    self.mapSelBuildingAnnotation = [[POIAnnotation alloc] initWithLat:dLatitude withLong:dLongitude];
    [mapSelBuildingAnnotation setTitle: buildingName];
    
    [self.mapView addAnnotation: mapSelBuildingAnnotation];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setMapPOIAnnotations:nil];
    [self setMapView:nil];
    [self setNavBar:nil];
    [self setMapSelBuildingAnnotation: nil];
    [self setUDefaults: nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [mapView release];
    [mapPOIAnnotations release];
    [managedObjectContext release];
    [mapView release];
    [navBar release];
    [permitTitles release];
    [mapSelBuildingAnnotation release];
    [uDefaults release];
    [super dealloc];
}


@end
