//
//  EventRecapViewController.h
//  iUMaine
//
//  Created by Robert King on 9/11/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventRecapViewController : UIViewController{
    
    NSString* recapURLStr;
    UIWebView *webView;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString* recapURLStr;

@end
