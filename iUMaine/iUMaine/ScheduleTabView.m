//
//  ScheduleTabView.m
//  iUMaine
//
//  Created by Robert King on 10/1/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import "ScheduleTabView.h"

#define NUMTABS 6

@implementation ScheduleTabView

@synthesize actTag;

- (id)initWithFrame:(CGRect)frame
{
    // This method is called when created programatically
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}
 
- (id) initWithCoder:(NSCoder *)aDecoder
{
    // This method is called when created in a NIB file
    self = [super initWithCoder: aDecoder];
    if (self){
        
    }
 
    NSInteger tabTags[] = {kMONTAG, kTUETAG, kWEDTAG, kTHUTAG, kFRITAG, kWEEKTAG};
    for(int i = 0; i < NUMTABS; i++){
        UIButton* tab = (UIButton*) [self viewWithTag: tabTags[i]];
        [tab addTarget:self action:@selector(tabPressed:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    self.actTag = kMONTAG;
    
    return self;
}

- (void) tabPressed: (id) sender
{
    NSInteger newTag = [(UIButton*) sender tag];
    NSString* newImgName = nil;
    NSString* oldImgName = nil;
    
    // If they preseed the same button, don't do anything
    if (newTag == self.actTag)
        return;
    
    // Find the new active tab
    switch(newTag){
        case kMONTAG:
            newImgName = @"monTabAct.png";
            break;
        case kTUETAG:
            newImgName = @"tueTabAct.png";
            break;
        case kWEDTAG:
            newImgName = @"wedTabAct.png";
            break;
        case kTHUTAG:
            newImgName = @"thuTabAct.png";
            break;
        case kFRITAG:
            newImgName = @"friTabAct.png";
            break;
        case kWEEKTAG:
            newImgName = @"weekTabAct.png";
            break;
        default:
            break;
    }
    
    // Find the previous active tab
    switch(self.actTag){
        case kMONTAG:
            oldImgName = @"monTabInact.png";
            break;
        case kTUETAG:
            oldImgName = @"tueTabInact.png";
            break;
        case kWEDTAG:
            oldImgName = @"wedTabInact.png";
            break;
        case kTHUTAG:
            oldImgName = @"thuTabInact.png";
            break;
        case kFRITAG:
            oldImgName = @"friTabInact.png";
            break;
        case kWEEKTAG:
            oldImgName = @"weekTabInact.png";
            break;
        default:
            break;
    }
    
    if(newImgName && oldImgName){
        [(UIButton*) sender setImage: [UIImage imageNamed: newImgName] forState: UIControlStateNormal];
        [(UIButton*)[self viewWithTag: self.actTag] setImage: [UIImage imageNamed: oldImgName] forState: UIControlStateNormal];
    }
    
    self.actTag = newTag;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
