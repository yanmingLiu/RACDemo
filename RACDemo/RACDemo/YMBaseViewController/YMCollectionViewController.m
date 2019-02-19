//
//  YMCollectionViewController.m
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import "YMCollectionViewController.h"

@interface YMCollectionViewController ()

@end

@implementation YMCollectionViewController


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

    self.collectionView.frame = self.view.bounds;
}

// MARK: - setupUI

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.collectionView];
}

- (void)setupMJRefresh {
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadData];
    }];

    self.collectionView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
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

    self.collectionView.mj_footer.hidden = (emptyStyle == YMEmptyHelperStyleLoading) ? YES : NO;

    [self.collectionView reloadEmptyDataSet];
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


// MARK: - setter getter

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        [_flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];

        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;

        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
    }
    return _collectionView;
}


@end
