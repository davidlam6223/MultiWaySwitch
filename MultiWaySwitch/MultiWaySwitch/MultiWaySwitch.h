//
//  MultiWaySwitch.h
//  MultiWaySwitch.git
//
//  Created by Zensis on 15/4/15.
//  Copyright (c) 2015 David. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MultiWaySwitchDelegate <NSObject>

@optional
- (void)switchedTo:(int) index;
- (void)stopedAt:(int) index;

@end

@interface MultiWaySwitch : UIControl

@property int numberOfPoints;
@property NSArray* thumbImages;
@property float trackWidth;
@property UIColor* trackColor;
@property Boolean showGap;
@property float gapWidth;
@property NSInteger thumbHeight;
@property NSInteger thumbWidth;
@property (nonatomic, weak) id<MultiWaySwitchDelegate> delegate;

@end
