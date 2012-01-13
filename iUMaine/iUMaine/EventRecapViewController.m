//
//  EventRecapViewController.m
//  iUMaine
//
//  Created by Robert King on 9/11/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import "EventRecapViewController.h"
#import "CampusSpecifics.h"


@implementation EventRecapViewController

@synthesize webView;
@synthesize loadingView;
@synthesize actIndicator;
@synthesize loadingErrLbl;
@synthesize recapURLStr;


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
    
    [self.navigationItem setTitle: @"Recap"];
    
    self.webView.scalesPageToFit = YES;
    
    [self.loadingView setBackgroundColor: [CampusSpecifics getSportsLoadingBackgroundColor]];
    
    NSURL* url = [NSURL URLWithString: self.recapURLStr];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: url];
    [self.webView loadRequest: request];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setRecapURLStr: nil];
    [self setLoadingView:nil];
    [self setActIndicator:nil];
    [self setLoadingErrLbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.actIndicator startAnimating];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationPortrait) ||
            (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}


#pragma mark - WebView Delegate methods
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.actIndicator stopAnimating];
    [self.loadingView setHidden: YES];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.loadingErrLbl setText: @"Error occurred"];
}

@end
