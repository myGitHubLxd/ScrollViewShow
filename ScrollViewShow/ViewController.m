//
//  ViewController.m
//  ScrollViewShow
//
//  Created by lixiangdong on 2017/6/19.
//  Copyright © 2017年 myself. All rights reserved.
//

#import "ViewController.h"
#import "ScrollviewHorView.h"
#import "GlobalCommon.h"
#import "GoodsInfo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self scrollviewShowTest];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollviewShowTest{

    NSMutableArray *dataArr = @[].mutableCopy;
    for (int i = 1; i <= 21; i++) {
        GoodsInfo *info = [[GoodsInfo alloc] initTitle:[NSString stringWithFormat:@"xxx_%d",i] withPicUrl:[NSString stringWithFormat:@"%d.jpg",i]];
        [dataArr addObject:info];
    }
    
    ScrollviewHorView *scrollHorView = [[ScrollviewHorView alloc] initWithFrame:CGRectMake(10, 150, UI_IOS_WINDOW_WIDTH - 10 * 2, 120)];
    [self.view addSubview:scrollHorView];
    [scrollHorView showGoodsInfo:dataArr block:^(GoodsInfo *obj) {
        NSLog(@"***** 点击了%@ *****",obj.title);
    }];
}

@end
