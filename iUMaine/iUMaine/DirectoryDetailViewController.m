//
//  DirectoryDetailViewController.m
//  iUMaine
//
//  Created by Robert King on 8/6/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import "DirectoryDetailViewController.h"
#import "Employee.h"

@implementation DirectoryDetailViewController
@synthesize nameLbl;
@synthesize titleLbl;
@synthesize infoTableView;
@synthesize employee;
@synthesize empDict;

#pragma mark - TODO CRITICAL: Really need to figure out how to display this contact information

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Set the name label
    NSString* nameStr = [NSString stringWithFormat: @"%@, %@ %@", [self.employee valueForKey: @"lname"], 
                         [self.employee valueForKey: @"fname"],
                         [self.employee valueForKey: @"mname"]];
    [self.nameLbl setText: nameStr];
    [self.titleLbl setText: [self.employee title]];

    // Fill employee information dictionary (should do it this way instead of just accessing
    // the Employee object directly in case there is missing information just makes it easier i think)
    [self fillEmployeeDict: self.employee];
}

- (void)viewDidUnload
{
    [self setNameLbl:nil];
    [self setTitleLbl:nil];
    [self setInfoTableView:nil];
    [self setEmployee: nil];
    [self setEmpDict: nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) fillEmployeeDict:(Employee *)emp
{
    self.empDict = [[NSMutableDictionary alloc] init];
    
    // TODO: STill need to figure out how to set the order of these sections in the table view, 
    // Also need to change the section titles most are too long
    
    // Department
    if([self.employee department])
        [self.empDict setObject: [self.employee department] forKey: @"Department"];
    
    // Department URL
    if([self.employee deptURL])
        [self.empDict setObject: [self.employee deptURL] forKey: @"Department Website"];
    
    // Office
    if([self.employee office])
        [self.empDict setObject: [self.employee office] forKey: @"Office"];

    // Phone
    if(![[self.employee valueForKey: @"phone"] isEqualToString: @"NULL"])
        if([self.employee valueForKey: @"phone"])
            [self.empDict setObject: [self.employee valueForKey: @"phone"] forKey: @"Phone"];
    
    // Email
    if(![[self.employee valueForKey: @"email"] isEqualToString: @"NULL"])
        [self.empDict setObject: [self.employee valueForKey: @"email"] forKey: @"EMail"];
}

#pragma mark - Table view data source delegate methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.empDict allKeys] count];
}
                                     
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EmployeeInfoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    UILabel* lbl = [cell textLabel];

    NSString* sectionHeader = [self tableView: tableView titleForHeaderInSection: indexPath.section];
    NSString* contentStr = [self.empDict objectForKey: sectionHeader];
    
    if([sectionHeader isEqualToString: @"Phone"]){
        NSRange phoneR;
        if([contentStr length] == 7){
            phoneR = NSMakeRange(0, 3);
            NSString* first3 = [contentStr substringWithRange: phoneR];
            phoneR = NSMakeRange(3, 4);
            NSString* last4 = [contentStr substringWithRange: phoneR];
        
            contentStr = [NSString stringWithFormat: @"%@-%@", first3, last4];
        }
        else if([contentStr length] == 10){
            phoneR = NSMakeRange(0, 3);
            NSString* first3 = [contentStr substringWithRange: phoneR];
            phoneR = NSMakeRange(3, 3);
            NSString* second3 = [contentStr substringWithRange: phoneR];
            phoneR = NSMakeRange(6, 4);
            NSString* last4 = [contentStr substringWithRange: phoneR];
            
            contentStr = [NSString stringWithFormat: @"(%@) %@-%@", first3, second3, last4];
        }
    }
    
    if([sectionHeader isEqualToString: @"Phone"] || [sectionHeader isEqualToString: @"EMail"] || [sectionHeader isEqualToString: @"Department Website"])
        [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    
    [lbl setText: contentStr];

    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* retStr = @"";
    
    switch (section) {
        case 0:
            retStr = @"Office";
            break;
        case 1:
            retStr = @"Phone";
            if(![self.empDict objectForKey: @"Phone"])
                retStr = @"EMail";
            break;
        case 2:
            retStr = @"EMail";
            if(![self.empDict objectForKey: @"Phone"])
                retStr = @"Department";
            break;
        case 3:
            retStr = @"Department";
            if(![self.empDict objectForKey: @"Phone"])
                retStr = @"Department Website";
            break;
        case 4:
            retStr = @"Department Website";
            break;
        default:
            break;
    }
    
    return retStr;
}

#pragma mark - Table view delegate methods
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSString* sectHeader = [self tableView: self.infoTableView titleForHeaderInSection: indexPath.section];
    
    if((![sectHeader isEqualToString: @"Phone"]) && (![sectHeader isEqualToString: @"EMail"]) && (![sectHeader isEqualToString: @"Department Website"]))
        return;
    
    NSString* actSheetBtnTitle = nil;
    
    if([sectHeader isEqualToString: @"Phone"]){
        // Display the address in maps best we can
        actSheetBtnTitle = @"Call";
    }
    else if([sectHeader isEqualToString: @"EMail"]){
        // Display call in actionsheet
        actSheetBtnTitle = @"EMail";
    }
    else if([sectHeader isEqualToString: @"Department Website"]){
        // Open the browser
        actSheetBtnTitle = @"Open in Safari";
    }
    
    // Clicked a section without an associated action
    if(!actSheetBtnTitle)
        return;
    
    NSString* titleStr = [[[tableView cellForRowAtIndexPath: indexPath] textLabel] text];
    UIActionSheet* actSheet = [[UIActionSheet alloc] initWithTitle: titleStr delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil otherButtonTitles: actSheetBtnTitle, nil];
    actSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actSheet showFromTabBar: self.tabBarController.tabBar];

}

#pragma mark - UIActionSheetDelegate Method
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* urlStr = nil;
    NSString* btnTitle = [actionSheet buttonTitleAtIndex: buttonIndex];
    
    if([btnTitle isEqualToString: @"Call"]){
        urlStr = [NSString stringWithFormat: @"tel:%@", actionSheet.title];
    }
    else if([btnTitle isEqualToString: @"EMail"]){
        urlStr = [NSString stringWithFormat: @"mailto:%@", actionSheet.title];
    }
    else if([btnTitle isEqualToString: @"Open in Safari"]){
        urlStr = actionSheet.title;
    }
    
    NSURL* url = [NSURL URLWithString: urlStr];
    [[UIApplication sharedApplication] openURL: url];
}


@end
