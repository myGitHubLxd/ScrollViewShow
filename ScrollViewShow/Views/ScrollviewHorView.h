//
//  ScrollviewHorView.h
//  ScrollViewShow
//
//  Created by lixiangdong on 2017/6/20.
//  Copyright © 2017年 myself. All rights reserved.
//  自定义

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ShowGoodBlock)(id);

@interface ScrollviewHorView : UIView


- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

- (void)showGoodsInfo:(NSArray*)dataArr block:(ShowGoodBlock)comple;

@end
