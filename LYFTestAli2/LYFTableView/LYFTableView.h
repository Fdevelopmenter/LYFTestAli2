//
//  LYFTableView.h
//  LYFTestAli2
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 Test-LYFTestAli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LYFTableViewAction)(CGFloat contentOffsetY);

@interface LYFTableView : UITableView

/// tableView的偏移量
@property (nonatomic, copy) LYFTableViewAction contentOffsetAction;
/// 总行数(可以视为数据源)
@property (nonatomic, assign) NSInteger rowNumber;

@end
