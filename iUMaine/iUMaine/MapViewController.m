//
//  MapViewController.m
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "MapViewController.h"
#import "POIAnnotation.h"

@implementation MapViewController
@synthesize searchBar;
@synthesize navBar;
@synthesize pickerView;
@synthesize actSheet;
@synthesize mapView, mapPOIAnnotations, managedObjectContext, permitTitles;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set the center to barrows or something
    MKCoordinateRegion region;
    region.center.latitude = 44.901006;
    region.center.longitude = -68.669536;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [mapView setRegion:region animated:false];
    
    // Set up the array of annotations
    self.mapPOIAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    
    POIAnnotation* poiAnnot = [[POIAnnotation alloc] init];
    [poiAnnot setTitle:@"Barrows Hall"];
    [poiAnnot setSubtitle:@"This is where I work."];
    
    [self.mapPOIAnnotations insertObject:poiAnnot atIndex:0];
    [poiAnnot release];
    
    poiAnnot = [[POIAnnotation alloc] initWithLat:44.901006 withLong:-68.669536];
    [poiAnnot setTitle:@"Center Title"];
    [poiAnnot setSubtitle:@"Center Subtitle"];
    
    [self.mapPOIAnnotations insertObject:poiAnnot atIndex:1];
    [poiAnnot release];
    
    // Add the annotation to the mapview
    [self.mapView addAnnotation:[self.mapPOIAnnotations objectAtIndex:0]];
    [self.mapView addAnnotation:[self.mapPOIAnnotations objectAtIndex:1]];

    // As a test lets add all of the commuter annotations
    [self addCommuterAnnotations];
    
    // Hide the search bar and permit picker initially
    [[self searchBar] setHidden:YES];
    [[self pickerView] setHidden:YES];
    
    // Initialize the titles for the parking permits
    self.permitTitles = [[NSArray alloc] initWithObjects:@"Staff / Faculty", @"Resident", @"Commuter", @"Visitor", nil];
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
            [[self mapView] setMapType:MKMapTypeStandard];
        }
        else{
            [segControl setTitle:@"Map" forSegmentAtIndex:0];
            [[self mapView] setMapType:MKMapTypeSatellite];   
        }
    }
    else if(nSel == 1){
        [self showPickerview];
    }
    else if(nSel == 2){
        // TODO: Actually do something when search bar is presented 
        [[self searchBar] setHidden:NO];
        [[self searchBar] becomeFirstResponder];
    }

}

- (void) showPickerview{
    self.actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]; 
    
    [actSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);

    UIPickerView* pickView = [[UIPickerView alloc] initWithFrame: pickerFrame];
    pickView.showsSelectionIndicator = YES;
    pickView.dataSource = self;
    pickView.delegate = self;
    [actSheet addSubview: pickView];
    
    UISegmentedControl* closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Done", @"Cancel", nil]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(210, 7.0f, 100.0f, 30.0f);
    closeButton.tag = 120;
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blueColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    [(UIButton*)[closeButton.subviews objectAtIndex: 0] setEnabled: NO];
    [(UIButton*)[closeButton.subviews objectAtIndex: 0] setAlpha: 0.5f];
    
    [actSheet addSubview:closeButton];
    [closeButton release];
    
    [actSheet showInView: self.view.window];
    
    [actSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
}

- (void) dismissActionSheet{
    [self.actSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self setActSheet:nil];
}

- (void) addCommuterAnnotations{
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ParkingLot" inManagedObjectContext:self.managedObjectContext];
    [fetchrequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"permittype == %@", @"commuter"];
    [fetchrequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchrequest error:&error];
    if (array != nil) {
        NSManagedObject* manObj = nil;
        NSString* title = nil;
        double latitude = 0.0;
        double longitude = 0.0;
        NSUInteger i = 0;
        NSUInteger arrcount = [array count]; // May be 0 if the object has been deleted.
        NSLog(@"Size of array: %d", arrcount);
        
        for(i = 0; i < arrcount; i++){
            manObj = [array objectAtIndex: i];
            title = [manObj title];
            
            latitude = [[manObj latitude]doubleValue]/1000000.0;
            longitude = [[manObj longitude] doubleValue]/1000000.0;
            
            POIAnnotation* poiAnnot = [[POIAnnotation alloc] initWithLat:latitude withLong:longitude];
            [poiAnnot setTitle: title];
            [poiAnnot setSubtitle:@"Commuter Lot"];
            
            [self.mapPOIAnnotations insertObject:poiAnnot atIndex: i];
            [poiAnnot release];
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching lots lots");
    }
    
    // Add the annotation to the mapview
    [self.mapView addAnnotations:self.mapPOIAnnotations];
    [fetchrequest release];
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
        static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier] autorelease];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
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

// UIPickerView delegate and datasource methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [permitTitles count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [permitTitles objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"Selected %@. at index: %i", [permitTitles objectAtIndex:row], row);
    
    UISegmentedControl* segcontrol = (UISegmentedControl*)[actSheet viewWithTag: 120];
    
    UIButton* butn1 =  (UIButton*)[segcontrol.subviews objectAtIndex: 0];
    [butn1 setEnabled:YES];
    [(UIButton*) [[[actSheet viewWithTag: 120] subviews] objectAtIndex: 0] setAlpha:1.0f];
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
    [self setRightBarButtonItem:nil];
    [self setRightBarButtonItem:nil];
    [self setNavBar:nil];
    [self setSearchBar:nil];
    [self setPickerView:nil];
    [self permitTitles:nil];
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
    [searchBar release];
    [pickerView release];
    [permitTitles release];
    [super dealloc];
}


@end
