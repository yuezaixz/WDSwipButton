//
//  ViewController.m
//  WDSwipButton
//
//  Created by 吴迪玮 on 16/2/17.
//  Copyright © 2016年 DNT. All rights reserved.
//

#import "ViewController.h"
#import "WDSwipButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WDSwipButton *btn = [[WDSwipButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.normalTitle = @"下拉暂停";
    btn.swipOutTitle = @"点击继续";
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
