//
//  MapViewController.m
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "MapViewController.h"
#import "BuildingSelectView.h"
#import "iUMaineAppDelegate.h"
#import "CampusSpecifics.h"
#import "constants.h"

@implementation MapViewController

@synthesize appDel;
@synthesize navBar;
@synthesize segmentControl;
@synthesize actSheet;
@synthesize uDefaults;
@synthesize curPermit, prevPermit;
@synthesize mapView, mapPOIAnnotations, mapSelBuildingAnnotation, permitTitles;
@synthesize sortedPermitTitles;
@synthesize smaller;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDel = (iUMaineAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.appDel setMvcInst: self];
    
    if(self.appDel.gettingSports){
        [self shrinkMapView];
    }
    
    // Set up the array of annotations
    self.mapPOIAnnotations = [[NSMutableArray alloc] initWithCapacity: 1];
    
    [self setUDefaults: [NSUserDefaults standardUserDefaults]];
    NSString* startingPermit = [self.uDefaults objectForKey: DEFS_PARKINGPERMIT];
    if(startingPermit){
        [self addParkingAnnotationsOfType: startingPermit];
        self.curPermit = startingPermit;
    }
    else{
        self.curPermit = nil;
    }
    
    self.prevPermit = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    if(self.appDel.gettingSports){
        [self shrinkMapView];
    }
    
    [self.navBar setTintColor: [CampusSpecifics getNavBarColor]];
    [self.segmentControl setTintColor: [CampusSpecifics getSegmentControlColor]];
    
    // Initialize the titles for the parking permits
    self.permitTitles = [CampusSpecifics getPermitTitles];
    self.sortedPermitTitles = [[self.permitTitles allValues]
                               sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
    
    // Set the center of campus
    MKCoordinateRegion region;
    
    NSArray* centerCoords = [self findCenterOfCampus];
    region.center.latitude = [[centerCoords objectAtIndex: 0] doubleValue];
    region.center.longitude = [[centerCoords objectAtIndex: 1] doubleValue];
    
    region.span.latitudeDelta = 0.008;
    region.span.longitudeDelta = 0.008;
    [self.mapView setRegion:region animated:false];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.appDel setMvcInst: nil]; 
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationPortrait) ||
            (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
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
        
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:bsView];
        [navigationController.navigationBar setBarStyle: UIBarStyleBlack];
        [self presentModalViewController:navigationController animated:YES];
    }

}

- (void) showPickerview{
    self.actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]; 

    
    NSInteger nCur = [self.sortedPermitTitles indexOfObject: [self.permitTitles objectForKey: self.curPermit]];
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
    
    UISegmentedControl* closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Done", nil]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    [self.actSheet addSubview:closeButton];
    
    [self.actSheet showInView: self.view.window];
    
    [self.actSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
}

- (void) dismissActionSheet{
    [self.actSheet dismissWithClickedButtonIndex:0 animated:YES];
    UIPickerView* picker = (UIPickerView*) [self.actSheet viewWithTag:150];
    [self setActSheet:nil];
    
    if(curPermit != nil)
        self.prevPermit = self.curPermit;
    
    NSString* readablePermitTitle = [self.sortedPermitTitles objectAtIndex: [picker selectedRowInComponent: 0]];
    self.curPermit = [[self.permitTitles allKeysForObject: readablePermitTitle] objectAtIndex: 0];
    
    if(!self.curPermit){
        self.curPermit = [[self.permitTitles allKeysForObject: [self.sortedPermitTitles objectAtIndex: 0]]
                          objectAtIndex: 0];
    }
    
    // Draw the correct permit overlays
    if((!self.prevPermit) || (![self.prevPermit isEqualToString: self.curPermit])){
        [self addParkingAnnotationsOfType: self.curPermit]; 
    }
}

- (NSArray*) findCenterOfCampus
{
    NSManagedObjectContext* moc = [[iUMaineAppDelegate sharedAppDelegate] managedObjectContext];
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"ParkingLot" inManagedObjectContext: moc];
    [fetchrequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"permittype == %@", @"centerofcampus"];
    [fetchrequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest: fetchrequest error: &error];
    double latitude = 0.0;
    double longitude = 0.0;
    if (array != nil) {
        
        for(NSManagedObject* manObj in array){
            
            latitude = [[manObj valueForKey:@"latitude"] doubleValue]/1000000.0;
            longitude = [[manObj valueForKey:@"longitude"] doubleValue]/1000000.0;
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching lots");
    }

    NSNumber* latNum = [NSNumber numberWithDouble: latitude];
    NSNumber* longNum = [NSNumber numberWithDouble: longitude];
    
    return [NSArray arrayWithObjects: latNum, longNum, nil];
}

- (void) addParkingAnnotationsOfType:(NSString*) permitType{
    
    if(!permitType)
        return;
    
    // Set the last used parking permit in the user defaults
    // For right now set the default parking permit as the last permit displayed (this might not be right)
    // Maybe have the default permit be set in a settings tab or something 
    [self.uDefaults setObject: permitType forKey: DEFS_PARKINGPERMIT];
    
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
    
    NSManagedObjectContext* moc = [[iUMaineAppDelegate sharedAppDelegate] managedObjectContext];
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ParkingLot" inManagedObjectContext: moc];
    [fetchrequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"permittype == %@", searchString];
    [fetchrequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:fetchrequest error:&error];
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
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching lots");
    }

    
    // Add the annotation to the mapview
    [self.mapView addAnnotations:self.mapPOIAnnotations];
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
    
    if([annotation isKindOfClass: [POIAnnotation class]] && (annotation == self.mapSelBuildingAnnotation)){
        static NSString* POIAnnotationID = @"poiAnnotationIdentifier";
        MKAnnotationView* pinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier: POIAnnotationID];
        
        if (!pinView){
            
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: POIAnnotationID];
            
            [customPinView setPinColor: MKPinAnnotationColorPurple];
            [customPinView setCanShowCallout: YES];
            [customPinView setDraggable: NO];
            
            return customPinView;
        }
        else{
            pinView.annotation = annotation;
        }
        
        return pinView;

    }
    else if ([annotation isKindOfClass:[POIAnnotation class]]){
        
        // try to dequeue an existing pin view first
        static NSString* POIAnnotationID = @"permitAnnotationIdentifier";
        MKAnnotationView* pinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier: POIAnnotationID];

        if (!pinView){

            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: POIAnnotationID];
            
            [pinView setCanShowCallout: YES];
            [pinView setDraggable: NO];
        }
        else{
            pinView.annotation = annotation;
        }

        NSString* markerType = [self.curPermit stringByReplacingOccurrencesOfString: @" " withString: @""];
        NSString* imgFileName = [NSString stringWithFormat: @"%@_marker_%@.png", markerType, [iUMaineAppDelegate getSelCampus]];
        [pinView setImage: [UIImage imageNamed: imgFileName]];
        
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

#pragma mark - UIPickerView delegate and datasource methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.permitTitles count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.sortedPermitTitles objectAtIndex: row];
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
    [self.appDel setMvcInst: nil];
    [self setMapView:nil];
    [self setMapPOIAnnotations:nil];
    [self setMapView:nil];
    [self setNavBar:nil];
    [self setMapSelBuildingAnnotation: nil];
    [self setUDefaults: nil];
    [self setSegmentControl:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) shrinkMapView
{
    if(!self.isSmaller){
        self.smaller = YES;
        
        CGRect newFrame = self.mapView.frame;
        newFrame.size.height = newFrame.size.height - self.appDel.progressView.frame.size.height;
        [self.mapView setFrame: newFrame];
    }
}

- (void) growMapView
{
    if(self.isSmaller){
        self.smaller = NO;
        
        CGRect newFrame = self.mapView.frame;
        newFrame.size.height = newFrame.size.height + self.appDel.progressView.frame.size.height;
        [self.mapView setFrame: newFrame];
    }
}

@end
