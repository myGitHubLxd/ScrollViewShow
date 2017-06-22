//
//  GoodsView.m
//
//
//  Created by lixiangdong on 15/12/10.
//  Copyright © 2015年 myself. All rights reserved.
//

#import "GoodsView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define IMAGE_HEIGHT 88.0

@interface GoodsView()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView   *dataInfoView;
@property (nonatomic, strong) UIButton *clickBtn;
@property (nonatomic, copy) BtnClickBlock btnblock;

@end

@implementation GoodsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initSubViews];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)initSubViews
{
    if(!_imgView){
        _imgView = [[UIImageView alloc] init];
        [_imgView setBackgroundColor:[UIColor clearColor]];
        [_imgView setContentMode:UIViewContentModeScaleAspectFit];
        _clickBtn = [[UIButton alloc] init];
        [_clickBtn addTarget:self action:@selector(clickGoods:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(!_dataInfoView){
        _dataInfoView = [[UIView alloc] init];
        _dataInfoView.backgroundColor = [UIColor clearColor];
    }
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor lightGrayColor];
    }
    
    [self addSubview:_imgView];
    
    [_dataInfoView addSubview:_nameLabel];
    [self addSubview:_dataInfoView];
    
    [self addSubview:_clickBtn];
    [self bringSubviewToFront:_clickBtn];
    
    __weak typeof(self) weakSelf = self;
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(0);
        make.right.equalTo(weakSelf.mas_right).with.offset(-10);
        make.top.equalTo(weakSelf.mas_top).with.offset(0);
        make.height.mas_equalTo(IMAGE_HEIGHT);
    }];
    
    CGFloat dataInfoHeight = self.frame.size.height - IMAGE_HEIGHT;
    [_dataInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(0);
        make.right.equalTo(weakSelf.mas_right).with.offset(-10);
        make.top.equalTo(_imgView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(dataInfoHeight);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dataInfoView.mas_left).with.offset(0);
        make.right.equalTo(_dataInfoView.mas_right).with.offset(0);
        make.top.equalTo(_dataInfoView.mas_top).with.offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_imgView);
        make.center.equalTo(_imgView);
    }];
    
}

#pragma mark -
#pragma mark - 点击事件

- (void)clickGoods:(UIButton*)sender
{
    _btnblock ? _btnblock() : nil;
}

#pragma mark -
#pragma mark - ShowGoodsProtocol

+ (CGSize)getShowGoodsViewSize{
    return CGSizeMake(150.0, 168.0);
}


- (void)showWithTitle:(NSString *)name
             imageUrl:(NSString *)imgUrlStr
                block:(BtnClickBlock)comple
{
    self.nameLabel.text = name;
    [self.imgView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:imgUrlStr]];
    
    _btnblock = comple;
}


@end
