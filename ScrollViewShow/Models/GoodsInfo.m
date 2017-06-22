//
//  GoodsInfo.m
//  ScrollViewShow
//
//  Created by lixiangdong on 2017/6/20.
//  Copyright © 2017年 myself. All rights reserved.
//

#import "GoodsInfo.h"

@interface GoodsInfo()
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *picUrl;
@property (nonatomic, copy, readwrite) NSString *strOfClassView;
@end

@implementation GoodsInfo

- (instancetype)initTitle:(NSString*)title withPicUrl:(NSString*)picUrl{
    self = [super init];
    if(self){
        _title = title;
        _picUrl = picUrl;
        _strOfClassView = @"GoodsView";//默认的，可在外部设置
    }
    return self;
}

- (instancetype)init{
    return [self initTitle:@"" withPicUrl:@""];
}

@end
