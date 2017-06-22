//
//  IndianaHeaderTableViewCell.m
//
//
//  Created by lixiangdong on 15/12/10.
//  Copyright © 2015年 myself. All rights reserved.
//

#import "IndianaHeaderTableViewCell.h"
//#import "UIImageView+AFNetworking.h"

#define GOODS_WIDTH          150.0
#define GOODS_HEIGHT         168.0

#define MAX_SHOW_GOODS       10//最大展示商品数目
#define MAX_REUSABILITY_GOOD 5 //最大重用商品view数目

@interface IndianaHeaderTableViewCell()<UIScrollViewDelegate>
{
    NSArray                   *_dataArr;//数据源数组
    
    float                      _currOffset;//当前偏移量。
    
    
    NSMutableArray             *_goodsViewArr;//重用商品视图数组(小于等于5个)
}
@property (nonatomic,strong)ShowGoodBlock complete;
@end

static int maxCount;//实际最大展示商品数目
static int reusabilityCount;//重用商品view的数目
BOOL             isNeedCreateGoodView;//是否需要重新创建view

@implementation IndianaHeaderTableViewCell

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
                            maxSubViewCount:(int)count
{
    
    //NSLog(@"******dataCount:%d***********",count);
    
    if(count >= MAX_SHOW_GOODS)
        maxCount = MAX_SHOW_GOODS;
    else
        maxCount = count;
    
    if(maxCount >= MAX_REUSABILITY_GOOD)
        reusabilityCount = MAX_REUSABILITY_GOOD;
    else
        reusabilityCount = maxCount;
    
    
    
    
    //如果下拉刷新，需要重新创建GoodsView
    if(!theCell)
    {
        isNeedCreateGoodView = YES;
    }
    else
    {
        isNeedCreateGoodView = NO;
    }
    
    theCell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if(!theCell)
    {
        [tableView registerNib:[UINib nibWithNibName:cellClass bundle:nil] forCellReuseIdentifier:idStr];
        theCell = [tableView dequeueReusableCellWithIdentifier:idStr];
    }
    
    return theCell;
}

- (void)awakeFromNib {
    // Initialization code
    _scrollview.delegate = self;
//    _scrollview.directionalLockEnabled = YES;
//    _scrollview.alwaysBounceVertical = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showGoodsInfo:(NSArray*)dataArr block:(ShowGoodBlock)comple
{
    if(isNeedCreateGoodView)
    {
        if(!_goodsViewArr)
            _goodsViewArr = [[NSMutableArray alloc] init];
        
        
        [_goodsViewArr removeAllObjects];
        [[_scrollview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for(int i = 0;i < reusabilityCount; i++)
        {
            GoodsView *gooview = [[GoodsView alloc] initWithFrame:CGRectMake(i * GOODS_WIDTH, 0, GOODS_WIDTH, GOODS_HEIGHT)];
            [_goodsViewArr addObject:gooview];
            [_scrollview addSubview:gooview];
        }
        _scrollview.contentOffset = CGPointMake(0, 0);
        
        
        
        _scrollview.contentSize = CGSizeMake(GOODS_WIDTH * maxCount, 0);
        _dataArr = dataArr;
        _currOffset = 0.0;
        _complete = comple;
        
        @synchronized(self) {
            
            for(int i = 0; i < reusabilityCount; i++)
            {
                [self showDataByIndex:i viewIndex:i block:comple];
            }
        }
    }
}

/**
 * 把数据源中第i个数据展示在重用view中（_goodsViewArr中第j个view）
 * @param dataIndex -- 数据源位置
 * @param theViewIndex --- 重用视图位置
 */
- (void)showDataByIndex:(int)dataIndex viewIndex:(int)theViewIndex block:(ShowGoodBlock)comple
{
    id info;
    if(dataIndex <= _dataArr.count - 1)
        info = [_dataArr objectAtIndex:dataIndex];
    GoodsView *goodview = [self findGoodViewByData:theViewIndex];
    
    if(goodview && info)
    {
        float money = [info.money floatValue];
        NSString *remark = [NSString stringWithFormat:@"投资%.2f万免费得",money/10000.0];
        [goodview showWithTitle:info.title brief:remark imageUrl:info.urlPic block:^{
            
          //  NSLog(@"******click :%lld******",info.treasureId);
            
            comple(info);
            
        }];
    }
}


/**
 * 根据index找到重用的view
 * @param index --- 数据index
 */
- (GoodsView *__nullable)findGoodViewByData:(int)index
{
    //用tag找
//    GoodsView *goodView;
//    UIView *tmpView;
//    for(int i = 0; i < _scrollview.subviews.count; i++)
//    {
//        tmpView = [_scrollview.subviews objectAtIndex:i];
//        if([tmpView isKindOfClass:[GoodsView class]])
//        {
//            if(tmpView.tag == index)
//            {
//                goodView = (GoodsView*)tmpView;
//                break;
//            }
//            else
//                continue;
//        }
//    }
//    
//    return goodView;
    
    
    //从数组返回
    return [_goodsViewArr objectAtIndex:index];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x > 0 || (scrollView.contentOffset.x < (GOODS_WIDTH * maxCount - UI_IOS_WINDOW_WIDTH)))
    {
        if(scrollView.contentOffset.x > _currOffset)//左滑
        {
            _currOffset = scrollView.contentOffset.x;
            CGFloat rightLocal = UI_IOS_WINDOW_WIDTH - _scrollview.frame.origin.x + scrollView.contentOffset.x;//屏幕展示的最右边在scrollview中位置
            
            if(rightLocal > _scrollview.contentSize.width)
                return;
            
            GoodsView *lastView = [_goodsViewArr lastObject];
            //如果屏幕最右侧大于最后一个view位置
            if(rightLocal > (lastView.frame.origin.x + GOODS_WIDTH))
            {
                CGFloat instance = rightLocal - lastView.frame.origin.x - GOODS_WIDTH;
                float coltempCount = instance / GOODS_WIDTH;
                int addViewCount = [self getCol:coltempCount];
                int nextDataIndex;
                CGFloat newDataX;
                
                for(int i = 0; i < addViewCount; i++)
                {
                    GoodsView *firstView= [_goodsViewArr firstObject];
                    lastView = [_goodsViewArr lastObject];
                    newDataX = lastView.frame.origin.x + GOODS_WIDTH;
                    firstView.frame = CGRectMake(newDataX, 0, GOODS_WIDTH, GOODS_HEIGHT);
                    nextDataIndex = newDataX / GOODS_WIDTH;
                    [_goodsViewArr removeObjectAtIndex:0];
                    [_goodsViewArr addObject:firstView];
                    [self showDataByIndex:nextDataIndex viewIndex:(reusabilityCount - 1) block:_complete];
                }
            }
        }
        else if(scrollView.contentOffset.x < _currOffset)//右滑
        {
            _currOffset = scrollView.contentOffset.x;
            CGFloat leftLocal = scrollView.contentOffset.x - _scrollview.frame.origin.x;//屏幕展示的最左边在scrollview中位置
            
            if(leftLocal <= 0)
                return;
            
            GoodsView *firstView = [_goodsViewArr firstObject];
            //如果屏幕最左边小于第一个view位置
            if(leftLocal < firstView.frame.origin.x)
            {
                CGFloat instance = firstView.frame.origin.x - leftLocal;
                float coltempCount = instance / GOODS_WIDTH;
                int addViewCount = [self getCol:coltempCount];
                int preDataIndex;
                CGFloat newDataX;
                
                for(int i = 0; i < addViewCount; i++)
                {
                    GoodsView *lastView= [_goodsViewArr lastObject];
                    firstView = [_goodsViewArr firstObject];
                    newDataX = firstView.frame.origin.x - GOODS_WIDTH;
                    lastView.frame = CGRectMake(newDataX, 0, GOODS_WIDTH, GOODS_HEIGHT);
                    preDataIndex = newDataX / GOODS_WIDTH;
                    [_goodsViewArr removeLastObject];
                    [_goodsViewArr insertObject:lastView atIndex:0];
                    [self showDataByIndex:preDataIndex viewIndex:0 block:_complete];
                }
            }
        }
    }
    
  //  NSLog(@"********x:%.2f*********",scrollView.contentOffset.x);
}

-(int)getCol:(float)willcol
{
    int resultRow = (int)willcol;
    if(willcol > resultRow)
    {
        return resultRow += 1;
    }
    else
        return resultRow;
}

@end
