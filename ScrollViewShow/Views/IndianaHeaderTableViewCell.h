//
//  IndianaHeaderTableViewCell.h
//
//
//  Created by lixiangdong on 15/12/10.
//  Copyright © 2015年 myself. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsView.h"

typedef void (^ShowGoodBlock)(id*);

@interface IndianaHeaderTableViewCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UIScrollView *scrollview;


/**
 * 创建cell
 * @param idStr --- 重用标签
 * @param cellClass --- cell的类名
 * @param theCell --- 指向cell的指针
 * @param tableView --- 表
 * @param count --- 商品数目
 */
+ (__kindof UITableViewCell*)createCellById:(NSString *)idStr
                               cellClassStr:(NSString*)cellClass
                                       cell:(UITableViewCell*)theCell
                                        tab:(UITableView*)tableView
                            maxSubViewCount:(int)count;


- (void)showGoodsInfo:(NSArray*)dataArr block:(ShowGoodBlock)comple;

@end
