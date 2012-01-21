//
//  DirectoryDetailViewController.m
//  iUMaine
//
//  Created by Robert King on 8/6/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import "DirectoryDetailViewController.h"
#import "Employee.h"
#import "CampusSpecifics.h"

@implementation DirectoryDetailViewController
@synthesize nameLbl;
@synthesize titleLbl;
@synthesize infoTableView;
@synthesize employee;
@synthesize empDict;
@synthesize sectionHeaders;

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
    [self.nameLbl setTextColor: [CampusSpecifics getDDNameTextColor]];
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
    [self setSectionHeaders: nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationPortrait) ||
            (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}


- (void) fillEmployeeDict:(Employee *)emp
{
    BOOL hasDept = NO;
    BOOL hasDeptURL = NO;
    BOOL hasOffice = NO;
    BOOL hasPhone = NO;
    BOOL hasEmail = NO;
    
    self.empDict = [[NSMutableDictionary alloc] init];
    if(!self.sectionHeaders){
        self.sectionHeaders = [[NSMutableDictionary alloc] init];
    }
    else{
        [self.sectionHeaders removeAllObjects];
    }
    
    // Department
    if([self.employee department]){
        [self.empDict setObject: [self.employee department] forKey: @"Department"];
        hasDept = YES;
    }
        
    // Department URL
    if([self.employee deptURL]){
        [self.empDict setObject: [self.employee deptURL] forKey: @"Department Website"];
        hasDeptURL = YES;
    }
        
    // Office
    if(([self.employee office]) && (self.employee.office.length != 0)){
        [self.empDict setObject: [self.employee office] forKey: @"Office"];
        hasOffice = YES;
    }
    
    // Phone
    NSString* phoneN = [self.employee valueForKey: @"phone"];
    if(phoneN){
        if(([phoneN length] != 0) && (![phoneN isEqualToString: @"NULL"])){
            [self.empDict setObject: [self.employee valueForKey: @"phone"] forKey: @"Phone"];
            hasPhone = YES;
        }
    }
    
    // Email
    if(![[self.employee valueForKey: @"email"] isEqualToString: @"NULL"]){
        [self.empDict setObject: [self.employee valueForKey: @"email"] forKey: @"Email"];
        hasEmail = YES;
    }
    
    // Set the section headers depending on what data is actually available and what is missing
    NSInteger curSect = 0;
    if(hasOffice){
        [self.sectionHeaders setObject: @"Office" forKey: [NSNumber numberWithInteger: curSect]];
        ++curSect;
    }
    
    if(hasPhone){
        [self.sectionHeaders setObject: @"Phone" forKey: [NSNumber numberWithInteger: curSect]];
        ++curSect;
    }
    
    if(hasEmail){
        [self.sectionHeaders setObject: @"Email" forKey: [NSNumber numberWithInteger: curSect]];
        ++curSect;
    }
    
    if(hasDept){
        [self.sectionHeaders setObject: @"Department" forKey: [NSNumber numberWithInteger: curSect]];
        ++curSect;
    }
    
    if(hasDeptURL){
        [self.sectionHeaders setObject: @"Department Website" forKey: [NSNumber numberWithInteger: curSect]];
        ++curSect;
    }
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
    
    if([sectionHeader isEqualToString: @"Phone"] || [sectionHeader isEqualToString: @"Email"] || [sectionHeader isEqualToString: @"Department Website"]){
        [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
    }
    else{
        [cell setAccessoryType: UITableViewCellAccessoryNone];
        [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    }
    
    [lbl setText: contentStr];

    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* retStr = @"";
    
    NSNumber* sectionNum = [NSNumber numberWithInteger: section];
    retStr = [self.sectionHeaders objectForKey: sectionNum];
    
    return retStr;
}

#pragma mark - Table view delegate methods
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSString* sectHeader = [self tableView: self.infoTableView titleForHeaderInSection: indexPath.section];
    
    if((![sectHeader isEqualToString: @"Phone"]) && (![sectHeader isEqualToString: @"Email"]) && (![sectHeader isEqualToString: @"Department Website"]))
        return;
    
    NSString* actSheetBtnTitle = nil;
    
    if([sectHeader isEqualToString: @"Phone"]){
        // Display the address in maps best we can
        actSheetBtnTitle = @"Call";
    }
    else if([sectHeader isEqualToString: @"Email"]){
        // Display call in actionsheet
        actSheetBtnTitle = @"Email";
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
        urlStr = [NSString stringWithFormat: @"tel:%@", [self.employee valueForKey: @"phone"]];
    }
    else if([btnTitle isEqualToString: @"Email"]){
        urlStr = [NSString stringWithFormat: @"mailto:%@", actionSheet.title];
    }
    else if([btnTitle isEqualToString: @"Open in Safari"]){
        urlStr = actionSheet.title;
    }
    
    NSURL* url = [NSURL URLWithString: urlStr];
    [[UIApplication sharedApplication] openURL: url];
}


@end
