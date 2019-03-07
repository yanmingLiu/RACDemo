//
//  YMBaseTableViewController.h
//  Example
//
//  Created by lym on 2017/11/29.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMBlankPageStyleHelper.h"
#import "UIScrollView+EmptyDataSet.h"

@interface YMBaseTableViewController : UIViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/// 初始化tableview
- (void)setupTableView;
- (void)setupTableViewWithStyle:(UITableViewStyle)tableViewStyle;


/** tableView */
@property (nonatomic, strong) UITableView * tableView;
/** 空白页样式 */
@property (nonatomic, assign) YMBlankPageStyle blankPageStyle;

@end

