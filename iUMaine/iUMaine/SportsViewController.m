//
//  SportsViewController.m
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "SportsViewController.h"
#import "iUMaineAppDelegate.h"
#import "EventRecapViewController.h"
#import "SportEvent.h"
#import "TBXML.h"
#import "CustomSectionHeader.h"

@implementation SportsViewController

@synthesize tableV;
@synthesize currentEventCell;
@synthesize otherEventCell;
@synthesize appDel;
@synthesize sportsAbbrDict;
@synthesize eventsDict;
@synthesize eventsSubSetDict;
@synthesize firstView;
@synthesize curSport;
@synthesize actSheet;

// Constant for the abbreviations dictionary name
NSString* const ABBRSDICTNAME2 = @"sportsAbbrsDict.txt";

#pragma mark - TODO: Should probably display loading indicator until the new information is done downloading from the server some communication will be involved between iUMaineAppDelegate and this class
#pragma mark - TODO: Allow filtering of the events by year range or current year or something

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get an instance of the application delegate
    self.appDel = [iUMaineAppDelegate sharedAppDelegate];

    // Initialize the sports abbreviations dictionary
    NSString* abbrsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: ABBRSDICTNAME2];
    self.sportsAbbrDict = [[NSDictionary alloc] initWithContentsOfFile: abbrsPath];
    
    self.firstView = YES;

    [self.navigationItem setTitle: @"All Sports"];
    
    UIBarButtonItem* sportSelectBtn = [[UIBarButtonItem alloc] initWithTitle: @"Sports" style: UIBarButtonItemStyleBordered target:self action: @selector(selectSportBtnClicked)];
    self.navigationItem.leftBarButtonItem = sportSelectBtn;
    
    [self.navigationController.navigationBar setTintColor: [UIColor colorWithRed: (3.0/255.0) 
                                                                    green: (32.0/255.0) 
                                                                    blue: (62.0/255.0) 
                                                                    alpha:1.0]];
    
    // Load Sports Events
    [self loadSportsEvents];

    // This should probably be loaded from user defaults (the last viewed sport)
    [self setCurSport: @"All"];
    
    // Fill in the subset dictionary
    [self showEventsForSport: self.curSport];
}

- (void) viewDidAppear:(BOOL)animated
{  
  //  self.appDel.gettingSports = YES;
  //  if([self.appDel isGettingSports]){
        // If still getting updates from the server then display the 
        // loading view with activity indicator
  //      [self showLoadingView];
  //  }

    [self scrollToCurrentOrFutureEvents: NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [self setCurrentEventCell:nil];
    [self setOtherEventCell:nil];
    [self setTableV:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setAppDel: nil];
    [self setSportsAbbrDict: nil];
    [self setEventsDict: nil];
    [self setEventsSubSetDict: nil];
}


- (void)dealloc
{
    [appDel release];
    [sportsAbbrDict release];
    [eventsDict release];
    [eventsSubSetDict release];
    [currentEventCell release];
    [otherEventCell release];
    [tableV release];
    [super dealloc];
}

- (void) showLoadingView
{
    CGRect rootRect = self.tableV.frame;
    UIView* rootView = [[[UIView alloc] initWithFrame: rootRect] autorelease];
    
    UIColor* darkBlue = [UIColor colorWithRed: 0.0 green: (33.0/255) blue: (68.0 / 255) alpha: 1.0];
    
    rootView.backgroundColor = darkBlue;
    
    UIFont* loadingFont = [UIFont boldSystemFontOfSize: 17.0];
    CGSize loadingSize = [@"Loading..." sizeWithFont: loadingFont];
    
    UIActivityIndicatorView* actInd = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
    
    // Find the height and width needed for the inner view
    CGFloat totW = loadingSize.width + 5.0 + actInd.bounds.size.width;
    CGFloat totH = (loadingSize.height > actInd.bounds.size.height) ? loadingSize.height : actInd.bounds.size.height;
    
    UILabel* loadingLbl = [[UILabel alloc] initWithFrame: CGRectMake( 0, 0, loadingSize.width, loadingSize.height)];
    [loadingLbl setText: @"Loading..."];
    loadingLbl.textColor = [UIColor whiteColor];
    loadingLbl.backgroundColor = darkBlue;
    
    UIView* innerView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, totW, totH)] autorelease];
    [innerView addSubview: loadingLbl];
    [innerView addSubview: actInd];
    
    [rootView addSubview: innerView];
    
    innerView.center = rootView.center;
    
    CGPoint loadingCenter = CGPointMake( loadingLbl.center.x, innerView.bounds.size.height/2);
    loadingLbl.center = loadingCenter;
    
    CGRect actIndFrame = CGRectMake(loadingLbl.bounds.size.width + 5.0, 0, actInd.frame.size.width, actInd.frame.size.height);
    actInd.frame = actIndFrame;
    [actInd startAnimating];
    
    [self.view addSubview: rootView];
}

- (void) loadSportsEvents
{
    NSMutableDictionary* tempEventDict = [[NSMutableDictionary alloc] init];
    [tempEventDict setObject: [[NSMutableArray alloc] init] forKey: PREV_KEY];
    [tempEventDict setObject: [[NSMutableArray alloc] init] forKey: CUR_KEY];
    [tempEventDict setObject: [[NSMutableArray alloc] init] forKey: FUT_KEY];
    
    NSManagedObjectContext* MOC = [self.appDel managedObjectContext];
    NSFetchRequest* fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SportEvent" inManagedObjectContext: MOC];
    [fetchrequest setEntity:entity];
    
    NSSortDescriptor* sortDescript = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray* sdArr = [[NSArray alloc] initWithObjects: sortDescript, nil];
    [fetchrequest setSortDescriptors: sdArr];
    
    NSError *error = nil;
    NSArray *array = [MOC executeFetchRequest:fetchrequest error:&error];
    if (array != nil) {
        
        for(SportEvent* SE in array){
            NSMutableArray* tmpArr;
            
            if([self pastPresentFutureDate: SE.date] < 0)
                tmpArr = [tempEventDict objectForKey: PREV_KEY];
            else if([self pastPresentFutureDate: SE.date] > 0)
                tmpArr = [tempEventDict objectForKey: FUT_KEY];
            else
                tmpArr = [tempEventDict objectForKey: CUR_KEY];
            
            [tmpArr addObject: SE];
        }
        
    }
    else {
        // Deal with error.
        NSLog(@"Error fetching lots");
    }
    
    // Assign the temporary mutable dictionary to the instance immutable dictionary
    self.eventsDict = [NSDictionary dictionaryWithDictionary: (NSDictionary*) tempEventDict];
    
    [tempEventDict release];
    [fetchrequest release];
}

- (NSInteger) pastPresentFutureDate:(NSDate *)date
{
    // This function returns 0 if it is the current day
    // 1 if the date passed is in the future
    // and -1 if the date passed is in the past
    NSInteger ret = 1;
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSUInteger calUnits = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSDateComponents* dcToday = [cal components: calUnits fromDate: [NSDate date]];
    NSDateComponents* dcPassed = [cal components: calUnits fromDate: date];
    
    if([dcToday year] > [dcPassed year]){
        ret = -1;
    }
    else if([dcToday year] == [dcPassed year]){
        if([dcToday month] > [dcPassed month]){
            ret = -1;
        }
        else if([dcToday month] == [dcPassed month]){
            if([dcToday day] > [dcPassed day]){
                ret = -1;
            }
            else if([dcToday day] == [dcPassed day]){
                ret = 0;
            }
            else{
                ret = 1;
            }
        }
        else{
            ret = 1;
        }
    }
    else{
        ret = 1;
    }
    
    return ret;
}

- (void) selectSportBtnClicked
{
    NSMutableArray* sportList = [NSMutableArray arrayWithArray: [self.sportsAbbrDict allValues]];
    [sportList insertObject: @"All" atIndex: 0];
    
    self.actSheet = [[UIActionSheet alloc] initWithTitle:@"Select a sport" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]; 
    
    NSInteger nCur = [sportList indexOfObject: [self curSport]];
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
    [self.actSheet addSubview: closeButton];
    [closeButton release];
    
    [self.actSheet showInView: self.view.window];
    
    [self.actSheet setBounds:CGRectMake(0, 0, 320, 485)];
    [self.actSheet autorelease];
}

- (void) dismissActionSheet 
{
    NSMutableArray* sportList = [NSMutableArray arrayWithArray: [self.sportsAbbrDict allValues]];
    [sportList insertObject: @"All" atIndex: 0];
    
    [self.actSheet dismissWithClickedButtonIndex:0 animated:YES];
    UIPickerView* picker = (UIPickerView*) [self.actSheet viewWithTag:150];
    [self setActSheet:nil];
    
    if([self.curSport isEqualToString: [sportList objectAtIndex: [picker selectedRowInComponent: 0]]])
        return;
    
    self.curSport = [sportList objectAtIndex: [picker selectedRowInComponent:0]];
    
    if(!self.curSport){
        self.curSport = [sportList objectAtIndex: 0];
    }
    
    // Draw the correct permit overlays
    [self showEventsForSport: self.curSport];
}

#pragma mark - UIPickerViewDelegate and datasource methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSMutableArray* sportList = [NSMutableArray arrayWithArray: [self.sportsAbbrDict allValues]];
    [sportList insertObject: @"All" atIndex: 0];

    return [sportList count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableArray* sportList = [NSMutableArray arrayWithArray: [self.sportsAbbrDict allValues]];
    [sportList insertObject: @"All" atIndex: 0];
    
    return [sportList objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

- (void) showEventsForSport:(NSString *)sport
{
    [self.navigationItem setTitle: sport];
    
    // If we want all courses then don't do any filtering just assign the complete
    // dictionary to the subset dictionary
    if([sport isEqualToString: @"All"]){
        self.eventsSubSetDict = [NSDictionary dictionaryWithDictionary: self.eventsDict];
        return;
    }
    
    NSString* shortSport = [[self.sportsAbbrDict allKeysForObject: sport] objectAtIndex: 0];
    NSMutableArray* prevEvents = [NSMutableArray arrayWithArray: [self.eventsDict objectForKey: PREV_KEY]];
    NSMutableArray* curEvents = [NSMutableArray arrayWithArray: [self.eventsDict objectForKey: CUR_KEY]];
    NSMutableArray* futEvents = [NSMutableArray arrayWithArray: [self.eventsDict objectForKey: FUT_KEY]];
    
    NSPredicate* pred = [NSPredicate predicateWithFormat: @"(SELF.sport contains[c] %@)", shortSport];
    [prevEvents filterUsingPredicate: pred];
    [curEvents filterUsingPredicate: pred];
    [futEvents filterUsingPredicate: pred];
    
    self.eventsSubSetDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: prevEvents, PREV_KEY, curEvents, CUR_KEY, futEvents, FUT_KEY, nil];
    
    [self.tableV reloadData];
    [self scrollToCurrentOrFutureEvents: YES];
}

- (void) scrollToCurrentOrFutureEvents: (BOOL) force
{
    // Scroll to today's games (if any), force is used when we are refreshing the list of events
    if([self isFirstView] || force){
        if([[self.eventsSubSetDict objectForKey: CUR_KEY] count] > 0){
            NSIndexPath* indPath = [NSIndexPath indexPathForRow: 0 inSection: 1];
            [self.tableV scrollToRowAtIndexPath: indPath atScrollPosition: UITableViewScrollPositionTop animated: NO];
        }
        else if([[self.eventsSubSetDict objectForKey: FUT_KEY] count] > 0){
            NSIndexPath* indPath = [NSIndexPath indexPathForRow: 0 inSection: 2];
            [self.tableV scrollToRowAtIndexPath: indPath atScrollPosition: UITableViewScrollPositionTop animated: NO];
        }
        
        self.firstView = NO;
    }
}

#pragma mark - UITablewViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    
    if(section == 0)
        num = [[self.eventsSubSetDict objectForKey: PREV_KEY] count];
    else if(section == 1)
        num = [[self.eventsSubSetDict objectForKey: CUR_KEY] count];
    else
        num = [[self.eventsSubSetDict objectForKey: FUT_KEY] count];
    
    return num;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 65;
    
    // The rows for the current games are taller than the others
    if(indexPath.section == 1)
        height = 90;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CurrentCellIdentifier = @"CurrentSportEventCell";
    static NSString* OtherCellIdentifier = @"OtherSportEventCell";
    static NSString *CellNib = @"CurrentEventCellView";
    NSString* CellIdentifier;
    if(indexPath.section == 1)
        CellIdentifier = CurrentCellIdentifier;
    else
        CellIdentifier = OtherCellIdentifier;
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        /*NSArray *topLevelObjects = */
        // Don't really need the assign, connections are made to the outlets when the nib is loaded
        [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
    
        if(indexPath.section == 1)
            cell = self.currentEventCell;
        else
            cell = self.otherEventCell;
    }
    
    if(indexPath.section == 0){
        // Other game cell
        UILabel* sportLbl = (UILabel*)[cell viewWithTag: 39];
        UILabel* teamsLbl = (UILabel*)[cell viewWithTag: 40];
        UILabel* timeLbl = (UILabel*)[cell viewWithTag: 42];
        
        SportEvent* SE = [[self.eventsSubSetDict objectForKey: PREV_KEY] objectAtIndex: indexPath.row];
        [sportLbl setText: [self.sportsAbbrDict objectForKey: SE.sport]];
        
        NSString* teamStr;
        if([SE.home boolValue]){
            teamStr = [NSString stringWithFormat: @"%@ %@ %@", SE.teamB, @"vs.", SE.teamA];
        }
        else{
            teamStr = [NSString stringWithFormat: @"%@ %@ %@", SE.teamA, @"at", SE.teamB];
        }
        
        [teamsLbl setText: teamStr];
        
        // For todays game the time should probably be the result
        if(SE.resultStr)
            [timeLbl setText: SE.resultStr];
        else
            [timeLbl setText: @""];
        
        if(SE.recapLink && ([SE.recapLink length] != 0)){
            [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
        }
        else{
            [cell setAccessoryType: UITableViewCellAccessoryNone];
        }
    }
    else if(indexPath.section == 1){
        // Current Game cell
        UILabel* sportLbl = (UILabel*)[cell viewWithTag: 39];
        UILabel* teamsLbl = (UILabel*)[cell viewWithTag: 40];
        //UILabel* locLbl = (UILabel*)[cell viewWithTag: 41];
        UILabel* timeLbl = (UILabel*)[cell viewWithTag: 42];
        UIImageView* teamAImgView = (UIImageView*)[cell viewWithTag: 43];
        UIImageView* teamBImgView = (UIImageView*)[cell viewWithTag: 44];
        
        SportEvent* SE = [[self.eventsSubSetDict objectForKey: CUR_KEY] objectAtIndex: indexPath.row];
        [sportLbl setText: [self.sportsAbbrDict objectForKey: SE.sport]];
        
        NSString* teamStr;
        if([SE.home boolValue]){
            teamStr = [NSString stringWithFormat: @"%@ %@ %@", SE.teamB, @"vs.", SE.teamA];
        }
        else{
            teamStr = [NSString stringWithFormat: @"%@ %@ %@", SE.teamA, @"at", SE.teamB];
        }
        
        [teamsLbl setText: teamStr];
        
        // For todays game the time should probably be the result
        if(SE.resultStr){
            [timeLbl setText: SE.resultStr];
        }
        else{ 
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MMM d h:mm a"];
            
            [timeLbl setText: [format stringFromDate: SE.date]];
        }
        
        // I think this location label was in here because sometimes games were "Home" games but not played
        // at the teams home campus (like playoff games). should probably be implemented in the future
        //[locLbl setText: @""];
        
        // TODO Critical: This should not be a constant it should depend on the team they are playing (obviously)
        UIImage* teamAImg = [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", SE.teamA]];
        if(!teamAImg)
            teamAImg = [UIImage imageNamed: @"teamPlaceholder.png"];
        [teamBImgView setImage: teamAImg];
        
        // TODO Critical: This should not be a constant it should depend on the team they are playing (obviously)
        UIImage* teamBImg = [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", SE.teamB]];
        if(!teamBImg)
            teamBImg = [UIImage imageNamed: @"teamPlaceholder.png"];
        [teamBImgView setImage: teamBImg];
        
        
        if(SE.recapLink && ([SE.recapLink length] != 0)){
            [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
        }
        else{
            [cell setAccessoryType: UITableViewCellAccessoryNone];
        }
    }
    else{
        // Other game cell
        UILabel* sportLbl = (UILabel*)[cell viewWithTag: 39];
        UILabel* teamsLbl = (UILabel*)[cell viewWithTag: 40];
        UILabel* timeLbl = (UILabel*)[cell viewWithTag: 42];
        
        SportEvent* SE = [[self.eventsSubSetDict objectForKey: FUT_KEY] objectAtIndex: indexPath.row];
        [sportLbl setText: [self.sportsAbbrDict objectForKey: SE.sport]];
        
        NSString* teamStr;
        if([SE.home boolValue]){
            teamStr = [NSString stringWithFormat: @"%@ %@ %@", SE.teamB, @"vs.", SE.teamA];
        }
        else{
            teamStr = [NSString stringWithFormat: @"%@ %@ %@", SE.teamA, @"at", SE.teamB];
        }
        
        [teamsLbl setText: teamStr];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMM d h:mm a"];
        
        [timeLbl setText: [format stringFromDate: SE.date]];
        
        // Need to do this because arrows will show up if the cell is reused
        [cell setAccessoryType: UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* retStr = @"";
    
    if(section == 0)
        retStr = @"Past Games";
    else if(section == 1)
        retStr = @"Todays Games";
    else
        retStr = @"Future Games";
    
    return retStr;
}

- (NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // Use P for Past C for Current and F for Future games
    return [NSArray arrayWithObjects: @"P", @"C", @"F", nil];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return 25.0;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }

    // create the parent view that will hold header Label
    CustomSectionHeader* customView = [[[CustomSectionHeader alloc] initWithFrame:CGRectMake(0.0, 0.0, 360.0, 25.0)] autorelease];
    [customView setTopColor: [UIColor colorWithRed: (3.0/255.0) green: (32.0/255.0) blue: (62.0/255.0) alpha:1.0]];
    [customView setBottomColor: [UIColor colorWithRed: (52.0/255.0) green: (160.0/255.0) blue: (206.0/255.0) alpha:1.0]];
    [customView setLineColor: [UIColor blueColor]];
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(10, 0, 300, 25);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    [customView addSubview: label];
    
    return customView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSString* recapStr;
    if(indexPath.section == 0){
       recapStr = [(SportEvent*) [[self.eventsSubSetDict objectForKey: PREV_KEY] objectAtIndex: indexPath.row] recapLink];
    }
    else if(indexPath.section == 1){
        recapStr = [(SportEvent*) [[self.eventsSubSetDict objectForKey: CUR_KEY] objectAtIndex: indexPath.row] recapLink];
    }
    else{
        recapStr = [(SportEvent*) [[self.eventsSubSetDict objectForKey: FUT_KEY] objectAtIndex: indexPath.row] recapLink];
    }
    
    if (!recapStr || [recapStr isEqualToString: @""]) {
        return;
    }
    
    EventRecapViewController* ervc = [[EventRecapViewController alloc] initWithNibName:@"EventRecapView" bundle:nil];
    
    [ervc setRecapURLStr: recapStr];
    
    [self.navigationController pushViewController: ervc animated: YES];
    [ervc release];
}

@end
