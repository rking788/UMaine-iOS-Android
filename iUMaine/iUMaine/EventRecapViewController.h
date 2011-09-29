//
//  EventRecapViewController.h
//  iUMaine
//
//  Created by Robert King on 9/11/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventRecapViewController : UIViewController <UIWebViewDelegate>{
    
    NSString* recapURLStr;
    UIWebView *webView;
    UIView *loadingView;
    UIActivityIndicatorView *actIndicator;
    UILabel *loadingErrLbl;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actIndicator;
@property (nonatomic, retain) IBOutlet UILabel *loadingErrLbl;
@property (nonatomic, retain) NSString* recapURLStr;

@end
