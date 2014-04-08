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
- (void)segmentedSliderIsAtPercent:(float)percent;
- (void)segmentedSliderIsAtValue:(float)value;

@end

@interface AHSegmentedSlider : UIView
@property (nonatomic, assign) id<AHSegmentedSliderDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger numberOfPoints;
@property (nonatomic, assign) float marginInset;
@property (nonatomic, readonly) float xDistance;

@property (nonatomic, assign) float nodePoint;
@property (nonatomic, assign) float barLineWidth;
@property (nonatomic, assign) float baseLineWidth;
@property (nonatomic, assign) float baseNodeRadius;
@property (nonatomic, assign) float barNodeRadius;
@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;

@property (nonatomic, assign) UIColor *barColor;
@property (nonatomic, assign) UIColor *baseColor;
@property (nonatomic, assign) UIColor *barNodeColor;
@property (nonatomic, assign) UIColor *baseNodeColor;
@property (nonatomic, assign) BOOL visibleNodes;
@property (nonatomic, assign) BOOL touchEnabled;

- (void)moveToIndex:(int)index;
@end
