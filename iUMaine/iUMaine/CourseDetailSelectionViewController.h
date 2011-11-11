//
//  CourseDetailSelectionViewController.h
//  iUMaine
//
//  Created by Robert King on 11/9/11.
//  Copyright (c) 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseDetailSelectionDelegate <NSObject>
// recipe == nil on cancel
- (void) detailSelection:(NSString*) selectionStr ForSection: (NSUInteger) rowSelected;
@end

@interface CourseDetailSelectionViewController : UITableViewController{
    
    NSArray* contentArr;
    NSUInteger row;
    
    id<CourseDetailSelectionDelegate> delegate;
}

@property (nonatomic, retain) NSArray* contentArr;
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, retain) id<CourseDetailSelectionDelegate> delegate;

-(void) cancel;

@end
