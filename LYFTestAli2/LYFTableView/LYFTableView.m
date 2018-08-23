//
//  LYFTableView.m
//  LYFTestAli2
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 Test-LYFTestAli. All rights reserved.
//

#import "LYFTableView.h"
#import "LYFHeaderView.h"
#import "UIView+Frame.h"
#import "MJRefresh.h"

#define kRowHeight 50.f
#define kHeaderHeight 100.f

@interface LYFTableView() <UITableViewDataSource, UITableViewDelegate>

/// 列表头部按钮视图
@property (nonatomic, strong) LYFHeaderView *payView;
/// 列表头部
@property (nonatomic, strong) UIView *headerView;

@end

static NSString *cellId = @"cell";

@implementation LYFTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    }
    
    return self;
}

#pragma mark - Set方法
-(void)setRowNumber:(NSInteger)rowNumber {
    _rowNumber = rowNumber;
    
    // 设置头部视图
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.lyf_width, kHeaderHeight)];
    // 将支付的视图添加在头部视图上面
    [self.headerView addSubview:self.payView];
    
    self.tableHeaderView = self.headerView;
    
    [self reloadData];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowNumber;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    cell.textLabel.text = [NSString stringWithFormat:@"demo2 这是第%li行", indexPath.row + 1];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (self.contentOffsetAction) {
        self.contentOffsetAction(contentOffsetY);
    }
    
    if (contentOffsetY <= 0) {
        // 当偏移量小于0时，头部视图的Y值跟随偏移量上移
        self.payView.lyf_y = contentOffsetY;
    } else {
        // 头部视图滚动差的效果
        self.payView.lyf_y = contentOffsetY/2;
    }
    
    self.payView.contentOffsetY = contentOffsetY;
    
    // 当contentOffsetY大于零时，打开裁剪功能。而小于零时，关闭裁剪
    // 大家如果想知道不这样做的结果，就试着注释一下下面的代码试一试😜。
    self.headerView.layer.masksToBounds = contentOffsetY > 0;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    if (contentOffsetY < -kHeaderHeight / 2) {
        // 当结束滑动的偏移量小于-kHeaderHeight / 2，就开始刷新tableView
        [self.mj_header beginRefreshing];
    } else if (contentOffsetY > 0 && contentOffsetY < kHeaderHeight / 2) {
        // 当偏移量大于0并且小于kHeaderHeight / 2，就把偏移量设置在CGPointMake(0, 0)
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (contentOffsetY > kHeaderHeight / 2 && contentOffsetY < kHeaderHeight) {
        // 当偏移量大于kHeaderHeight / 2并且小于kHeaderHeight，就把偏移量设置在CGPointMake(0, kHeaderHeight)
        [self setContentOffset:CGPointMake(0, kHeaderHeight) animated:YES];
    }
}

#pragma mark - Get方法
-(LYFHeaderView *)payView {
    if (!_payView) {
        _payView = [[LYFHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.lyf_width, kHeaderHeight)];
    }
    
    return _payView;
}

@end
