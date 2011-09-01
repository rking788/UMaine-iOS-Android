//
//  SportsViewController.m
//  iUMaine
//
//  Created by RKing on 4/17/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import "SportsViewController.h"
#import "iUMaineAppDelegate.h"
#import "TBXML.h"

@implementation SportsViewController

@synthesize appDel;
@synthesize sportsAbbrDict;

// Constant for the abbreviations dictionary name
NSString* const ABBRSDICTNAME2 = @"sportsAbbrsDict.txt";


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get an instance of the application delegate
    self.appDel = [iUMaineAppDelegate sharedAppDelegate];
    
    // Initialize the sports abbreviations dictionary
    NSString* abbrsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: ABBRSDICTNAME2];
    self.sportsAbbrDict = [[NSDictionary alloc] initWithContentsOfFile: abbrsPath];
    
    // TODO: Don't think we need these anymore
   // [self.appDel addSportYear: @"2010-11"];
   // [self.appDel addSportYear: @"2011-12"];
    
    // Parse the first sport from the RSS feed
    //[self parseSport: [[self.sportsAbbrDict allKeys] objectAtIndex: 0] forYear: @"2010-11"];
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
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setAppDel: nil];
    [self setSportsAbbrDict: nil];
}


- (void)dealloc
{
    [appDel release];
    [sportsAbbrDict release];
    [super dealloc];
}

#pragma mark - UITablewViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: This should be changed to whatever the final thing is and only be set to 90 when 
    // the section is equal to the "current events" section
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CurrentSportEventCell";
    static NSString *CellNib = @"CurrentEventCellView";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        id firstObject = (UITableViewCell *)[topLevelObjects objectAtIndex:0];
        if ( [ firstObject isKindOfClass:[UITableViewCell class]] )
            cell = firstObject;     
        else cell = [topLevelObjects objectAtIndex:1];
    }
    
    // perform additional custom work...

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

@end
