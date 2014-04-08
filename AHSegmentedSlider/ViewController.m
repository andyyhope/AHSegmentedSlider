//
//  ViewController.m
//  AHSegmentedSlider
//
//  Created by Andyy Hope on 31/03/2014.
//  Copyright (c) 2014 Andyy Hope. All rights reserved.
//

#import "ViewController.h"
#import "AHSegmentedSlider.h"
@interface ViewController () <AHSegmentedSliderDelegate>
{
    AHSegmentedSlider *slider;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	slider = [[AHSegmentedSlider alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
    [slider setDelegate:self];
    [slider setMinValue:200];
    [slider setMaxValue:4000];
    [slider setNumberOfPoints:10];
    [slider setBaseLineWidth:4];
    [slider setBarLineWidth:6];
    [slider setBarColor:[UIColor blueColor]];
    [slider setBaseColor:[UIColor redColor]];

    [slider setVisibleNodes:YES];
    
    [slider setBaseNodeColor:[UIColor blueColor]];
    [slider setBarNodeColor:[UIColor orangeColor]];
    
    [slider setBaseNodeRadius:6];
    [slider setBarNodeRadius:10];
     
    
    [slider setBackgroundColor:[UIColor darkGrayColor]];
    [slider setMarginInset:16];
    
    [self.view addSubview:slider];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(0, 0, 100, 100)];
    [button setTitle:@"Press me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moveSlider) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)moveSlider
{
    [slider moveToIndex:4];
}
- (void)segmentedSliderIsAtPercent:(float)percent
{
        NSLog(@"%f, ", percent);
}
- (void)segmentedSliderIsAtValue:(float)value
{
    NSLog(@"%f, ", value);
}
@end
