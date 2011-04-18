//
//  POIAnnotation.h
//  iUMaine
//
//  Created by RKing on 4/14/11.
//  Copyright 2011 UMaineIRL. All rights reserved.
//

#import<MapKit/MapKit.h>

@interface POIAnnotation : NSObject <MKAnnotation> {
    NSString* title;
    NSString* subtitle;
    
    UIImage* image;
    NSNumber* latitude;
    NSNumber* longitude;
}

@property (retain, nonatomic) NSString* title;
@property (retain, nonatomic) NSString* subtitle;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@end
