//
//  CustomSectionHeader.m
//  iUMaine
//
//  Created by Robert King on 9/28/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import "CustomSectionHeader.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomSectionHeader

@synthesize topColor, bottomColor, lineColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set the colors to something heinous so if you forget you can know immediately
        if ([self topColor] == nil) topColor = [UIColor blackColor];
        if ([self bottomColor] == nil) bottomColor = [UIColor yellowColor];
        if ([self lineColor] == nil) lineColor = [UIColor blueColor];        
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
    //[super drawRect:rect];
    
    //add a gradient:
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    [gradientLayer setBounds:[self bounds]];
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height -1);
    [gradientLayer setFrame:newRect];
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil]];
    [[self layer] insertSublayer:gradientLayer atIndex:0];
    
    //draw line
    CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    CGContextBeginPath(ctx);
    // This gets the RGB Float values from the color initialized for lineColor
    const float* colors = CGColorGetComponents( lineColor.CGColor );
    CGContextSetRGBStrokeColor(ctx, colors[0], colors[1], colors[2], 1);    
    //CGContextSetGrayStrokeColor(ctx, 0, 1);
    CGContextMoveToPoint(ctx, 0, rect.size.height-1);
    CGContextAddLineToPoint( ctx, rect.size.width, rect.size.height-1);
    CGContextStrokePath(ctx);
}


@end
