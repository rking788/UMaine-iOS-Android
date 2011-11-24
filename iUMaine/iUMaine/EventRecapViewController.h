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
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *actIndicator;
@property (nonatomic, strong) IBOutlet UILabel *loadingErrLbl;
@property (nonatomic, strong) NSString* recapURLStr;

@end
