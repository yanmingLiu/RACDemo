//
//  YMBaseTableViewController.m
//  Example
//
//  Created by lym on 2017/11/29.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "YMBaseTableViewController.h"

@interface YMBaseTableViewController ()

@end

@implementation YMBaseTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - kTabBarMargin);
}

// MARK: - 初始化tableview

- (void)setupTableView {
    return [self setupTableViewWithStyle:UITableViewStylePlain];
}

- (void)setupTableViewWithStyle:(UITableViewStyle)tableViewStyle{

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:tableViewStyle];
    _tableView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];

    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.separatorColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];

    // 空白页代理
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;


    // 去掉Grouped 第一个分区多余的头部
    if (tableViewStyle == UITableViewStyleGrouped) {
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    // 去掉多余分割线
    _tableView.tableFooterView = [[UIView alloc] init];

    // 预估高度
    // 问题1.不设置为0的时候  可能会出现高度过高 刷新有跳动
    // 问题2.设置了的时候，如果是UITableViewStyleGrouped 直接写sectionHeaderHeight=10 第一个分区没有头部，必须在代理返回高度
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedRowHeight = 0;

    [self.view addSubview:self.tableView];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - DZNEmptyDataSetSource

- (void)setBlankPageStyle:(YMBlankPageStyle)blankPageStyle {
    _blankPageStyle = blankPageStyle;

    [self.tableView reloadEmptyDataSet];
}

/// 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [YMBlankPageStyleHelper imageForEmptyDataSet:self.blankPageStyle];
}

/// 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [YMBlankPageStyleHelper descriptionForEmptyDataSet:self.blankPageStyle];
}

/// 空白页按钮
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [YMBlankPageStyleHelper buttonTitleForEmptyDataSet:self.blankPageStyle];
}

/// 偏移量y
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    CGFloat y = self.scrollView.centerY;
//    NSLog(@"%f", y);
//    return y;
//}


/// 图片动画
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    return [YMBlankPageStyleHelper imageAnimationForEmptyDataSet];
}

// 设置空白页面的背景色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return RGBA(240, 242, 245, 1);
}

#pragma mark - DZNEmptyDataSetDelegate

// 向代理请求图像视图动画权限。 默认值为NO。
// 确保从 imageAnimationForEmptyDataSet 返回有效的CAAnimation对象：
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    if (self.blankPageStyle == YMBlankPageStyleLoading) {
        return YES;
    }
    return NO;
}

/// 按钮点击
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {


}



@end
