//
//  GoodsInfo.h
//  ScrollViewShow
//
//  Created by lixiangdong on 2017/6/20.
//  Copyright © 2017年 myself. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsInfo : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *picUrl;
@property (nonatomic, copy, readonly) NSString *strOfClassView;

- (instancetype)initTitle:(NSString*)title withPicUrl:(NSString*)picUrl NS_DESIGNATED_INITIALIZER;

@end
