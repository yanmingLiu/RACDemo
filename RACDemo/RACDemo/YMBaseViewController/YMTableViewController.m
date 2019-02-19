//
//  YMTableViewController.m
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import "YMTableViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface YMTableViewController ()

@end

@implementation YMTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (instancetype)init {
    return [self initWithTableViewStyle:(UITableViewStylePlain)];
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = RGB(245, 245, 245);
        _tableView.separatorColor = RGB(238, 238, 238);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;

        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

    [self initData];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.tableView.frame = self.view.bounds;
}

// MARK: - setupUI

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
}

- (void)setupMJRefresh {
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadData];
    }];

    self.tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self loadData];
    }];
}


// MARK: - setupData

- (void)initData {
    self.dataArray = [NSMutableArray array];
    self.page = 1;
    self.pageSize = 10;
}

// MARK: - loadData

- (void)loadData {

}


#pragma mark - DZNEmptyDataSetSource

- (void)setEmptyStyle:(YMEmptyHelperStyle)emptyStyle {
    _emptyStyle = emptyStyle;

    self.tableView.mj_footer.hidden = (emptyStyle == YMEmptyHelperStyleLoading) ? YES : NO;

    [self.tableView reloadEmptyDataSet];
}

/// 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [YMEmptyHelper imageForEmptyDataSet:self.emptyStyle];
}

/// 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [YMEmptyHelper descriptionForEmptyDataSet:self.emptyStyle];
}

/// 空白页按钮
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [YMEmptyHelper buttonTitleForEmptyDataSet:self.emptyStyle];
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//
//    return 0;
//}

/// 图片动画
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    return [YMEmptyHelper imageAnimation];
}

// 设置空白页面的背景色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return RGB(240, 240, 240);
}

#pragma mark - DZNEmptyDataSetDelegate

// 向代理请求图像视图动画权限。 默认值为NO。
// 确保从 imageAnimationForEmptyDataSet 返回有效的CAAnimation对象：
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    if (self.emptyStyle == YMEmptyHelperStyleLoading) {
        return YES;
    }
    return NO;
}

/// 按钮点击
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {


}


@end
