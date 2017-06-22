//
//  ShowGoodsProtocol.h
//  ScrollViewShow
//
//  Created by lixiangdong on 2017/6/22.
//  Copyright © 2017年 myself. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BtnClickBlock)(void);

@protocol ShowGoodsProtocol <NSObject>

+ (CGSize)getShowGoodsViewSize;

- (void)showWithTitle:(NSString *)name
             imageUrl:(NSString *)imgUrlStr
                block:(BtnClickBlock)comple;

@end
