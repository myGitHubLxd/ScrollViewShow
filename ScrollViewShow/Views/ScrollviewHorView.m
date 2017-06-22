//
//  ScrollviewHorView.m
//  ScrollViewShow
//
//  Created by lixiangdong on 2017/6/20.
//  Copyright © 2017年 myself. All rights reserved.
//

#import "ScrollviewHorView.h"
#import "GoodsInfo.h"
#import "GlobalCommon.h"
#import "Masonry.h"
#import "ShowGoodsProtocol.h"



#define MAX_SHOW_GOODS       100//最大展示商品数目
#define MAX_REUSABILITY_GOOD 5 //最大重用商品view数目


static int maxCount;//实际最大展示商品数目
static int reusabilityCount;//重用商品view的数目

@interface ScrollviewHorView()<UIScrollViewDelegate>{
    NSArray                    *_dataArr;//数据源数组
    float                      _currOffset;//当前偏移量。
    
    NSMutableArray             *_goodsViewArr;//重用商品视图数组(小于等于5个)
    CGSize                     _goodsSize;
}
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, copy) ShowGoodBlock complete;
@end

@implementation ScrollviewHorView

#pragma mrak -
#pragma mark - 初始化

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        _scrollview = [[UIScrollView alloc] initWithFrame:frame];
        _scrollview.delegate = self;
        [self addSubview:self.scrollview];
        UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
        [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(edge);
        }];
    }
    return self;
}

#pragma mrak -
#pragma mark - 展示数据信息

- (void)showGoodsInfo:(NSArray*)dataArr block:(ShowGoodBlock)comple
{
    if(dataArr.count > 0){
        //超过最大展示数将不展示后面超过的部分
        maxCount = (dataArr.count >= MAX_SHOW_GOODS) ? MAX_SHOW_GOODS : ((int)dataArr.count);
        reusabilityCount = (maxCount >= MAX_REUSABILITY_GOOD) ? MAX_REUSABILITY_GOOD : maxCount;
        NSString *strClassView = ((GoodsInfo*)[dataArr objectAtIndex:0]).strOfClassView;
        _goodsSize = [NSClassFromString(strClassView) getShowGoodsViewSize];
        
        _scrollview.contentOffset = CGPointMake(0, 0);
        _scrollview.contentSize = CGSizeMake(_goodsSize.width * maxCount, 0);
        _dataArr = dataArr;
        _currOffset = 0.0;
        _complete = comple;
        
        if(!_goodsViewArr)
            _goodsViewArr = @[].mutableCopy;
        
        [_goodsViewArr removeAllObjects];
        [[_scrollview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for(int i = 0; i < reusabilityCount; i++){
            
            UIView<ShowGoodsProtocol> *goodView = [[NSClassFromString(strClassView) alloc] initWithFrame:CGRectMake(i * _goodsSize.width, 0, _goodsSize.width, _goodsSize.height)];
            [_goodsViewArr addObject:goodView];
            [_scrollview addSubview:goodView];
        }
        
        
        @synchronized(self) {
            for(int i = 0; i < reusabilityCount; i++){
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
    GoodsInfo *info;
    if(dataIndex <= _dataArr.count - 1)
        info = [_dataArr objectAtIndex:dataIndex];
    UIView<ShowGoodsProtocol> *goodview = [self findGoodViewByData:theViewIndex];
    
    if(goodview && info){
        
        [goodview showWithTitle:info.title imageUrl:info.picUrl block:^{
            NSLog(@"******click :%@******",info.title);
            comple(info);
        }];
    }
}


/**
 * 根据index找到重用的view
 * @param index --- 数据index
 */
- (UIView<ShowGoodsProtocol> *__nullable)findGoodViewByData:(int)index
{
    //从数组返回
    return [_goodsViewArr objectAtIndex:index];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

/**
 * 滑动scrollView时根据滑动位置重用view实现滑动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x > 0 || (scrollView.contentOffset.x < (_goodsSize.width * maxCount - UI_IOS_WINDOW_WIDTH))){
        
        if(scrollView.contentOffset.x > _currOffset){
            //左滑
            _currOffset = scrollView.contentOffset.x;
            CGFloat rightLocal = UI_IOS_WINDOW_WIDTH - _scrollview.frame.origin.x + scrollView.contentOffset.x;//屏幕展示的最右边在scrollview中位置
            
            if(rightLocal > _scrollview.contentSize.width){
                return;
            }
            
            UIView *lastView = [_goodsViewArr lastObject];
            //如果屏幕最右侧大于最后一个view位置
            if(rightLocal > (lastView.frame.origin.x + _goodsSize.width)){
                
                CGFloat instance = rightLocal - lastView.frame.origin.x - _goodsSize.width;
                float coltempCount = instance / _goodsSize.width;
                int addViewCount = [self getAddCount:coltempCount];
                int nextDataIndex;
                CGFloat newDataX;
                
                //将数组前面看不见的视图移动到数组后面
                for(int i = 0; i < addViewCount; i++){
                    
                    UIView *firstView= [_goodsViewArr firstObject];
                    lastView = [_goodsViewArr lastObject];
                    newDataX = lastView.frame.origin.x + _goodsSize.width;
                    firstView.frame = CGRectMake(newDataX, 0, _goodsSize.width, _goodsSize.height);
                    nextDataIndex = newDataX / _goodsSize.width;
                    [_goodsViewArr removeObjectAtIndex:0];
                    [_goodsViewArr addObject:firstView];
                    [self showDataByIndex:nextDataIndex viewIndex:(reusabilityCount - 1) block:_complete];
                }
            }
        }else if(scrollView.contentOffset.x < _currOffset){
            //右滑
            _currOffset = scrollView.contentOffset.x;
            CGFloat leftLocal = scrollView.contentOffset.x - _scrollview.frame.origin.x;//屏幕展示的最左边在scrollview中位置
            
            if(leftLocal <= 0){
                return;
            }
            
            UIView *firstView = [_goodsViewArr firstObject];
            //如果屏幕最左边小于第一个view位置
            if(leftLocal < firstView.frame.origin.x){
                
                CGFloat instance = firstView.frame.origin.x - leftLocal;
                float coltempCount = instance / _goodsSize.width;
                int addViewCount = [self getAddCount:coltempCount];
                int preDataIndex;
                CGFloat newDataX;
                
                //将数组后面看不见的视图移动到数组前面
                for(int i = 0; i < addViewCount; i++){
                    
                    UIView *lastView= [_goodsViewArr lastObject];
                    firstView = [_goodsViewArr firstObject];
                    newDataX = firstView.frame.origin.x - _goodsSize.width;
                    lastView.frame = CGRectMake(newDataX, 0, _goodsSize.width, _goodsSize.height);
                    preDataIndex = newDataX / _goodsSize.width;
                    [_goodsViewArr removeLastObject];
                    [_goodsViewArr insertObject:lastView atIndex:0];
                    [self showDataByIndex:preDataIndex viewIndex:0 block:_complete];
                }
            }
        }
    }
    
    //  NSLog(@"********x:%.2f*********",scrollView.contentOffset.x);
}

/**
 * 根据超出view数目（float），返回准确超出数目
 */
-(int)getAddCount:(float)addCount
{
    int resultRow = (int)addCount;
    if(addCount > resultRow){
        return resultRow += 1;
    }
    else
        return resultRow;
}



@end
