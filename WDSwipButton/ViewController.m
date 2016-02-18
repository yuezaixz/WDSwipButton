//
//  ViewController.m
//  WDSwipButton
//
//  Created by 吴迪玮 on 16/2/17.
//  Copyright © 2016年 DNT. All rights reserved.
//

#import "ViewController.h"

#define TIME_INTERVAL 0.1

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSTimeInterval time;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WDSwipButton *btn = [[WDSwipButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-100/2, 100, 80, 80)];
    btn.normalTitle = @"下拉暂停";
    btn.swipOutTitle = @"点击继续";
    btn.delegate = self;
    [self.view addSubview:btn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 创建
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL
                                                    target:self
                                                  selector:@selector(updateTime)
                                                  userInfo:nil
                                                   repeats:YES];

}

- (void)updateTime {
    self.time += TIME_INTERVAL;
    self.timeLabel.text = [NSString stringWithFormat:@"%d",(int)self.time];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swipOut{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)swipBack{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL
                                             target:self
                                           selector:@selector(updateTime)
                                           userInfo:nil
                                            repeats:YES];
}

@end
