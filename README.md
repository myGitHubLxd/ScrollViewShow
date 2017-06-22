# ScrollViewShow
简介：
    ScrollViewShow中实现了重用滑动展示多个商品。达到了滑动时不用再创建新的view的目的。（当然可以用UICollectionView替代）。可以自定义展示内容视图。
ScrollviewHorView：
    它是实现重用的ScrollView.只需指定它的frame，就可展示。它可指定最大展示数目（可自行修改）。算法很简单：它是利用ScrollView的contentOffSet的偏
移量来计算将要展示几个商品，然后将看不见的商品视图移动到将要展示的位置。商品视图可自定义，指定展示数据时给出展示商品视图的类字符串就行。
ShowGoodsProtocol：
    它指定了2个方法，getShowGoodsViewSize返回展示商品的Size, showWithTitle:imageUrl:block是展示这个商品。自定义展示商品视图必须实现这2个协议
就好。
eg:
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
