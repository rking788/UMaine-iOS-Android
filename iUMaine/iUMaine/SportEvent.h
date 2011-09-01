//
//  SportEvent.h
//  iUMaine
//
//  Created by Robert King on 8/30/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SportEvent : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * resultStr;
@property (nonatomic, retain) NSString * teamB;
@property (nonatomic, retain) NSString * recapLink;
@property (nonatomic, retain) NSString * sport;
@property (nonatomic, retain) NSNumber * home;
@property (nonatomic, retain) NSString * teamA;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * year;

@end
