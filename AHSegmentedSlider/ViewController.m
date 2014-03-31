//
//  ViewController.m
//  AHSegmentedSlider
//
//  Created by Andyy Hope on 31/03/2014.
//  Copyright (c) 2014 Andyy Hope. All rights reserved.
//

#import "ViewController.h"
#import "AHSegmentedSlider.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	AHSegmentedSlider *slider = [[AHSegmentedSlider alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
    [slider setNumberOfPoints:6];
    [slider setLeftColor:[UIColor greenColor]];
    [slider setRightColor:[UIColor redColor]];
    [slider setLineColor:[UIColor blackColor]];
    
    [slider setBackgroundColor:[UIColor darkGrayColor]];
    [slider setMarginInset:20];
    [slider setLineWidth:2];
    [slider setCircleRadius:10];
    
    [self.view addSubview:slider];
    
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
