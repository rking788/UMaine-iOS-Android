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
@property (nonatomic, strong) NSString * resultStr;
@property (nonatomic, strong) NSString * teamB;
@property (nonatomic, strong) NSString * recapLink;
@property (nonatomic, strong) NSString * sport;
@property (nonatomic, strong) NSNumber * home;
@property (nonatomic, strong) NSString * teamA;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * yearRange;

@end
