//
//  CustomSectionHeader.h
//  iUMaine
//
//  Created by Robert King on 9/28/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSectionHeader : UIView{
    UIColor *topColor;
    UIColor *bottomColor;
    UIColor *lineColor;
}
@property(nonatomic, retain) UIColor *topColor, *bottomColor, *lineColor;
@end