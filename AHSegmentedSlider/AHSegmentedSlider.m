//
//  AHSegmentedSlider.m
//  AHSegmentedSlider
//
//  Created by Andyy Hope on 31/03/2014.
//  Copyright (c) 2014 Andyy Hope. All rights reserved.
//

#import "AHSegmentedSlider.h"
#define const int kANIMATION_SPEED 0.2;

@interface AHSegmentedSlider () <AHSegmentedSliderDelegate, UIGestureRecognizerDelegate>
{
    UILongPressGestureRecognizer *_gestureRecognizer;
    BOOL firstTimeOnly;
    UIBezierPath *_drawPath;
    CGContextRef _context;
    UIImageView *_thumbImageView;
    NSMutableArray *_nodePoints;
    float _spaceBetweenPoints;
    
}

@end

@implementation AHSegmentedSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minValue = 0;
        _maxValue = 100;
        
        _thumbImageView = [[UIImageView alloc] init];
        _nodePoints = [NSMutableArray new];
        _marginInset = 0;
        _visibleNodes = NO;
        [self setNumberOfPoints:2];

        _gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        _gestureRecognizer.delegate = self;
        _gestureRecognizer.minimumPressDuration = 0.0;
        _gestureRecognizer.numberOfTouchesRequired = 1;
        
        UIImage *sliderImage = [UIImage imageNamed:@"SliderImage"];
        
        _thumbImageView = [UIImageView new];
        [_thumbImageView setImage:sliderImage];
        [_thumbImageView setFrame:CGRectMake(_marginInset, 0, sliderImage.size.width, sliderImage.size.height)];
        [_thumbImageView setUserInteractionEnabled:YES];
        [_thumbImageView addGestureRecognizer:_gestureRecognizer];
        [self addSubview:_thumbImageView];
        
        [self drawEachNode];
        
    }
    return self;
}





- (void)drawRect:(CGRect)rect
{
    
    // Draw Baseline
    
    CGContextRef barLineContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(barLineContext, _barColor.CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(barLineContext, _baseLineWidth);
    CGContextMoveToPoint(barLineContext ,_marginInset, (self.bounds.size.height / 2)); //start at this point
    CGContextAddLineToPoint(barLineContext, self.frame.size.width - _marginInset, (self.bounds.size.height / 2)); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(barLineContext);
    

    // Draw Left Line
    CGContextRef baseLineContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(baseLineContext, _baseColor.CGColor);
    
    CGContextSetLineWidth(baseLineContext, _barLineWidth);
    CGContextMoveToPoint(baseLineContext ,_marginInset, (self.bounds.size.height / 2)); //start at this point
    CGContextAddLineToPoint(baseLineContext, _thumbImageView.center.x, (self.bounds.size.height / 2));
    
    CGContextStrokePath(baseLineContext);
    
    [self drawEachNode];
    
}

- (void)drawEachNode
{
    if (_visibleNodes)
    {
        for (int i = 0; i < _numberOfPoints; i++) {
            
            float newRadius;
            UIColor *newColor;
            
            if (i <= _currentIndex) {
                newRadius = _barNodeRadius;
                newColor = _barNodeColor;
            } else
            {
                newRadius = _baseNodeRadius;
                newColor = _baseNodeColor;
            }
            
            CGPoint centerPoint = [_nodePoints[i] CGPointValue];
            
            centerPoint = CGPointMake(_marginInset + (_spaceBetweenPoints) * i, (self.bounds.size.height / 2));
            
            CGContextRef circleContext = UIGraphicsGetCurrentContext();
            
            CGContextAddEllipseInRect(circleContext, CGRectMake(-newRadius + centerPoint.x,
                                                                -newRadius + centerPoint.y ,
                                                                newRadius * 2, newRadius * 2));
            
            CGContextSetFillColorWithColor(circleContext, newColor.CGColor);
            
            CGContextFillPath(circleContext);
            
        }
    }

}

#pragma METHODS

- (void)moveToIndex:(int)index
{
    [UIView animateWithDuration:0.2 animations:^{
        _thumbImageView.center = CGPointMake((index * _spaceBetweenPoints) + _marginInset, _thumbImageView.center.y);
    } completion:^(BOOL finished) {
        [self updateValue];
        [self updateIndex];
        [self drawEachNode];
        [self setNeedsDisplay];
        
    }];
}



- (void)updateValue
{
    float xBounds = self.frame.size.width - (2 * _marginInset);
    float percent = (_thumbImageView.center.x - _marginInset) / xBounds * 100;
    float value = ((_maxValue - _minValue) * (percent / 100));
    
    
    [_delegate respondsToSelector:@selector(segmentedSliderIsAtPercent:)];
    [_delegate respondsToSelector:@selector(segmentedSliderIsAtValue:)];
    [_delegate segmentedSliderIsAtPercent:percent];
    [_delegate segmentedSliderIsAtPercent:value];
    
}




#pragma GETTERS

- (CGPoint)positionForPointAtIndex:(int)index {
    return [_nodePoints[index] CGPointValue];
}

- (NSInteger)getCurrentIndex
{
    return _currentIndex;
}



#pragma GESTURE
- (void)handleGesture:(UIGestureRecognizer *)gesture
{
    CGPoint touchLocation = [gesture locationInView:self];

    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Began");
    } else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        [self moveSliderToXPoint:touchLocation.x];
        
        
    } else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self moveToNearestNode];
        
    }
    
    [self updateValue];
    
}

#pragma SLIDER MOVEMENT
- (void)moveSliderToXPoint:(float)xPoint
{
    if (xPoint >= _marginInset && xPoint <= self.bounds.size.width - _marginInset) {
        _thumbImageView.center = CGPointMake(xPoint, _thumbImageView.center.y);
        [self updateIndex];
        [self setNeedsDisplay];
        NSLog(@"Move slider to point");
    }
}

- (void)updateIndex
{
    int nextIndex = (int)((_thumbImageView.center.x - _marginInset) / _spaceBetweenPoints);
    if (nextIndex != _currentIndex) {
        _currentIndex = nextIndex;
    }
    
}

- (void)moveToNearestNode
{

    float currentNodeXpos = (_currentIndex * _spaceBetweenPoints);
    float currentNodeMinArea = currentNodeXpos - (_spaceBetweenPoints / 2);
    float currentNodeMaxArea = currentNodeXpos + (_spaceBetweenPoints / 2);
 
    if ((_thumbImageView.center.x - _marginInset) < currentNodeMinArea) {
        _currentIndex--;
    } else if ((_thumbImageView.center.x - _marginInset) > currentNodeMaxArea)
    {
        _currentIndex++;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _thumbImageView.center = CGPointMake((_currentIndex * _spaceBetweenPoints) + _marginInset, _thumbImageView.center.y);
        NSLog(@"%f %f", _thumbImageView.center.x, _thumbImageView.center.y);
        [self setNeedsDisplay];
    }];
    
    
    
}

#pragma SETTERS

- (void)setMarginInset:(float)marginInset
{
    _marginInset = marginInset;
    _thumbImageView.center = CGPointMake(_marginInset, self.bounds.size.height / 2);
    
    [self setNeedsDisplay];
}

- (void)setNumberOfPoints:(NSInteger)numberOfPoints
{
    if (numberOfPoints < 2) {
        _numberOfPoints = 2;
    } else
    {
        _numberOfPoints = numberOfPoints;
    }
    

    _spaceBetweenPoints = (self.frame.size.width - (_marginInset * 2)) / (_numberOfPoints - 1);
    CGPoint centerPoint;
    NSLog(@"%f", _spaceBetweenPoints);
    
    [_nodePoints removeAllObjects];
    
    for (int i = 0; i < _numberOfPoints; i++) {
        
        centerPoint = CGPointMake(_marginInset + (_spaceBetweenPoints) * i, (self.bounds.size.height / 2));

        [_nodePoints addObject:[NSValue valueWithCGPoint:centerPoint]];
        NSLog(@"%f, %f", centerPoint.x, centerPoint.y);
    }
    
    CGPoint startingPoint = [_nodePoints[0] CGPointValue];
    [_thumbImageView setCenter:startingPoint];
    
    [self setNeedsDisplay];
}

- (void)setBarLineWidth:(float)lineWidth
{
    if (lineWidth < 1) {
        _barLineWidth = 1;
    } else
    {
        _barLineWidth = lineWidth;
    }
    
    [self setNeedsDisplay];
}

- (void)setBaseLineWidth:(float)lineWidth
{
    if (lineWidth < 1) {
        _baseLineWidth = 1;
    } else
    {
        _baseLineWidth = lineWidth;
    }
    
    [self setNeedsDisplay];
}

- (void)setBarColor:(UIColor *)leftColor
{
    _barColor = leftColor;
    
    [self setNeedsDisplay];
}

- (void)setBaseColor:(UIColor *)rightColor
{
    _baseColor = rightColor;
    
    [self setNeedsDisplay];
}

- (void)setBaseNodeColor:(UIColor *)nodeColor
{
    _baseNodeColor = nodeColor;
    
    [self setNeedsDisplay];
}

- (void)setBarNodeColor:(UIColor *)nodeColor
{
    _barNodeColor = nodeColor;
    
    [self setNeedsDisplay];
}

- (void)setBaseNodeRadius:(float)baseNodeRadius
{
    _baseNodeRadius = baseNodeRadius;
    
    [self setNeedsDisplay];
}

- (void)setBarNodeRadius:(float)barNodeRadius
{
    _barNodeRadius = barNodeRadius;
    
    [self setNeedsDisplay];
}
@end
