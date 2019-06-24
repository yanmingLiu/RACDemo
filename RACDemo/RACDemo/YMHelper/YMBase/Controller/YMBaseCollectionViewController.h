//
//  YMBaseCollectionViewController.h
//  RACDemo
//
//  Created by lym on 2019/3/11.
//

#import <UIKit/UIKit.h>
#import "YMBlankPageStyleHelper.h"
#import "UIScrollView+EmptyDataSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMBaseCollectionViewController : UIViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/// 初始化CollectionView
- (void)setupFlowLayoutCollectionView;
- (void)setupCollectionViewWithLayout:(UICollectionViewLayout *)layout;


/** collectionView */
@property (nonatomic, strong) UICollectionView * collectionView;


/** 空白页样式 */
@property (nonatomic, assign) YMBlankPageStyle blankPageStyle;

@end

NS_ASSUME_NONNULL_END
