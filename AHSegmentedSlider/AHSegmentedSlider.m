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
        _thumbImageView = [[UIImageView alloc] init];
        
        
        
        _nodePoints = [NSMutableArray new];
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{

    // Draw Baseline
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, _lineWidth);
    
    CGContextMoveToPoint(context ,_marginInset, (self.bounds.size.height / 2) + (_lineWidth / 2)); //start at this point
    
    CGContextAddLineToPoint(context, self.frame.size.width - _marginInset, (self.bounds.size.height / 2)); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
    
    // Draw Nodes
    _spaceBetweenPoints = (self.frame.size.width - (_marginInset * 2)) / (_numberOfPoints - 1);
    CGPoint centerPoint;
    NSLog(@"%f", _spaceBetweenPoints);
    for (int i = 0; i < _numberOfPoints; i++) {
        
        centerPoint = CGPointMake(_marginInset + (_spaceBetweenPoints) * i, (self.bounds.size.height / 2));
        
        CGContextRef circleContext = UIGraphicsGetCurrentContext();
        
        CGContextAddEllipseInRect(circleContext, CGRectMake(-_circleRadius + centerPoint.x,
                                                            -_circleRadius + centerPoint.y ,
                                                            _circleRadius * 2, _circleRadius * 2));
        
        CGContextSetFillColor(circleContext, CGColorGetComponents([[UIColor redColor] CGColor]));
        
        CGContextFillPath(circleContext);
        
        [_nodePoints addObject:[NSValue valueWithCGPoint:centerPoint]];
        NSLog(@"%f, %f", centerPoint.x, centerPoint.y);
    }
    
    [self updateSlider];
    
}



#pragma METHODS

- (void)moveToIndex:(int)index
{
    
}

- (void)updateSlider
{

    NSLog(@"Not instant ");
    UIImage *sliderImage = [UIImage imageNamed:@"SliderImage"];
    _thumbImageView = [UIImageView new];
    [_thumbImageView setImage:sliderImage];
    [_thumbImageView setFrame:CGRectMake(0, 0, sliderImage.size.width, sliderImage.size.height)];
    CGPoint thumbPoint = [_nodePoints[0] CGPointValue];
    
    [_thumbImageView setCenter:CGPointMake(thumbPoint.x , thumbPoint.y)];
    NSLog(@"IMAGE VIEW");
    NSLog(@"%f %f", _thumbImageView.frame.origin.x, _thumbImageView.frame.origin.y);
    NSLog(@"%f %f", thumbPoint.x, thumbPoint.y);

    [self addSubview:_thumbImageView];
    
    _thumbImageView.userInteractionEnabled = YES;

    
    _gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    _gestureRecognizer.delegate = self;
    _gestureRecognizer.minimumPressDuration = 0.0;
    _gestureRecognizer.numberOfTouchesRequired = 1;

    
    [_thumbImageView addGestureRecognizer:_gestureRecognizer];

    
    
}


#pragma GETTERS

- (CGPoint)positionForPointAtIndex:(int)index {
    return [_nodePoints[index] CGPointValue];
}

#pragma SETTERS

- (void)setMarginInset:(float)marginInset
{
    _marginInset = marginInset;
    
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
    
    [self setNeedsDisplay];
}

- (void)setLineWidth:(float)lineWidth
{
    if (lineWidth < 1) {
        _lineWidth = 1;
    } else
    {
        _lineWidth = lineWidth;
    }
    
    [self setNeedsDisplay];
}

- (void)setLeftColor:(UIColor *)leftColor
{
    _leftColor = leftColor;
    
    [self setNeedsDisplay];
}

- (void)setRightColor:(UIColor *)rightColor
{
    _rightColor = rightColor;
    
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    
    [self setNeedsDisplay];
}

- (void)setNodeColor:(UIColor *)nodeColor
{
    _nodeColor = nodeColor;
    
    [self setNeedsDisplay];
}

#pragma GESTURE
- (void)handleGesture:(UIGestureRecognizer *)gesture
{
    CGPoint touchLocation = [gesture locationInView:self];

    if (gesture.state == UIGestureRecognizerStateBegan) {
        
    } else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        [self moveSliderToXPoint:touchLocation.x];
    } else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self moveToNearestNode];
    }
    
    
}

#pragma SLIDER MOVEMENT
- (void)moveSliderToXPoint:(float)xPoint
{
    if (xPoint >= _marginInset && xPoint <= self.bounds.size.width - _marginInset) {
        _thumbImageView.center = CGPointMake(xPoint, _thumbImageView.center.y);
        [self updateIndex];
    }
}

- (void)updateIndex
{
    int nextIndex = (int)((_thumbImageView.center.x - _marginInset) / _spaceBetweenPoints);
    if (nextIndex != _currentIndex) {
        _currentIndex = nextIndex;
        NSLog(@"CURRENT INDEX: %i", _currentIndex);
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
    }];
    
    
    
}

- (void)shiftToNode:(int)node
{
    
}

@end
