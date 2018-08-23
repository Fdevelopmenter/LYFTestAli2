//
//  ViewController.m
//  LYFTestAli2
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 Test-LYFTestAli. All rights reserved.
//

#import "ViewController.h"
#import "LYFTableView.h"
#import "UIView+Frame.h"
#import "MJRefresh.h"
#import "LYFNavigationView.h"

#define kHeaderHeight 100.f

@interface ViewController ()

/// 列表
@property (nonatomic, strong) LYFTableView *tableView;
/// navigation视图
@property (nonatomic, strong) LYFNavigationView *navigationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewController];
}

-(void)setupViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52.0 / 255.0 green:104.0 / 255.0 blue:206.0 / 255.0 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.navigationView];
    
    self.navigationItem.leftBarButtonItem = item;
    
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    // 设定tableView的行数
    self.tableView.rowNumber = 20;
    
    __weak __typeof(self)weakSelf = self;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = -kHeaderHeight;
    self.tableView.contentOffsetAction = ^(CGFloat contentOffsetY) {
        weakSelf.navigationView.hidden = contentOffsetY < 50;
        if (contentOffsetY > 100) {
            weakSelf.navigationView.alpha = 1;
        } else if (contentOffsetY > 50) {
            weakSelf.navigationView.alpha = 1 - (100 - contentOffsetY) / 50.f;
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 网络请求
- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - Get方法
-(LYFTableView *)tableView {
    if (!_tableView) {
        _tableView = [[LYFTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.lyf_width, self.view.lyf_height - self.navigationController.navigationBar.frame.size.height - 20.f) style:UITableViewStylePlain];
        
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

-(LYFNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[LYFNavigationView alloc] initWithFrame:CGRectMake(0, 0, 120.f, 40.f)];
        _navigationView.hidden = YES;
    }
    
    return _navigationView;
}

@end
