//
//  YMBaseCollectionViewController.m
//  RACDemo
//
//  Created by lym on 2019/3/11.
//

#import "YMBaseCollectionViewController.h"

@interface YMBaseCollectionViewController ()

@end

@implementation YMBaseCollectionViewController

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

    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];


}


// MARK: - 初始化collectionView

- (void)setupFlowLayoutCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];

    [self setupCollectionViewWithLayout:layout];
}

- (void)setupCollectionViewWithLayout:(UICollectionViewLayout *)layout {
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;

    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;

    [self.view addSubview:_collectionView];
}


#pragma mark - DZNEmptyDataSetSource

- (void)setBlankPageStyle:(YMBlankPageStyle)blankPageStyle {
    _blankPageStyle = blankPageStyle;

    [self.collectionView reloadEmptyDataSet];
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

// MARK: - getter

// MARK: - dealloc

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
