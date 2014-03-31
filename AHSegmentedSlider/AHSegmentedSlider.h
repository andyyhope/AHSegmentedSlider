//
//  AHSegmentedSlider.h
//  AHSegmentedSlider
//
//  Created by Andyy Hope on 31/03/2014.
//  Copyright (c) 2014 Andyy Hope. All rights reserved.
//

#import <UIKit/UIKit.h>
@import QuartzCore;

@class AHSegmentedSlider;
@protocol AHSegmentedSliderDelegate <NSObject>
@optional
- (void)segmentedSlider:(AHSegmentedSlider *)segmentedSlider didSelectPointAtIndex:(NSInteger)index withGesture:(UIGestureRecognizer *)gesture;

@end

@interface AHSegmentedSlider : UIView
@property (nonatomic, assign) id<AHSegmentedSliderDelegate> delegate;
@property (nonatomic, assign) float marginInset;
@property (nonatomic, assign) NSInteger numberOfPoints;
@property (nonatomic, assign) float nodePoint;
@property (nonatomic, assign) float lineWidth;
@property (nonatomic, assign) BOOL touchEnabled;
@property (nonatomic, assign, readonly) int currentIndex;
@property (nonatomic, assign) float circleRadius;
@property (nonatomic, assign) UIColor *leftColor;
@property (nonatomic, assign) UIColor *rightColor;
@property (nonatomic, assign) UIColor *lineColor;
@property (nonatomic, assign) UIColor *nodeColor;

- (void)moveToIndex:(int)index;
- (void)positionOfIndex:(int)index;
@end
