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

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* subtitle;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

-(id) initWithLat:(double) initLat withLong:(double) initLongitude;

@end
