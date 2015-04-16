//
//  ViewController.m
//  MultiWaySwitch.git
//
//  Created by Zensis on 15/4/15.
//  Copyright (c) 2015 David. All rights reserved.
//

#import "ViewController.h"
#import "MultiWaySwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MultiWaySwitch* a = [[MultiWaySwitch alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width,40)];
    a.numberOfPoints = 5;
    [a setTrackColor: [UIColor redColor]];
    [a setTrackWidth:30];
    a.showGap = YES;
    [a setGapWidth:5];
    [a setThumbWidth:40];
    [a setThumbHeight:40];
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < a.numberOfPoints; i++) {
        [images addObject: [UIImage imageNamed: i%2==0?@"thumba.jpg": @"thumbb.jpg"]];
    }
    
    a.thumbImages = images;
    a.delegate = self;
    [self.view addSubview:a];
}

- (void)switchedTo:(int) index{
    NSLog(@"switchedTo %d", index);
}
- (void)stopedAt:(int)index{
    NSLog(@"stopedAt %d", index);
}

@end
