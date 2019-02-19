//
//  TestCollectionViewController.m
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import "TestCollectionViewController.h"
#import "CollectionViewCell.h"
#import "SectionHeaderView.h"
#import "SectionFooterView.h"

@interface TestCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

static NSString * const reuseIdentifier = @"Cell";


@implementation TestCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupMJRefresh];

    [self setupCollectionView];


    self.emptyStyle = YMEmptyHelperStyleLoading;
    [self loadData];
}


- (void)loadData {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (self.page == 1) {
            [self.dataArray removeAllObjects];
            [self.collectionView.mj_header endRefreshing];
            [TopNewView showInView:self.collectionView content:@"您有5条新消息"];
        }

        for (int i = 0; i < 5; i++) {
            [self.dataArray addObject:@(i+1)];
        }

        [self.collectionView.mj_footer endRefreshing];

        self.emptyStyle = YMEmptyHelperStyleSuccess;
        [self.collectionView reloadData];

    });

}



#pragma mark setupCollectionView

- (void)setupCollectionView {


    self.automaticallyAdjustsScrollViewInsets = NO;

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    // Register cell classes
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:[CollectionViewCell cellId]];

    // Register header footer
    [self.collectionView registerClass:[SectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[SectionHeaderView headerId]];

    [self.collectionView registerClass:[SectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[SectionFooterView footerId]];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.dataArray.count;
    self.collectionView.mj_footer.hidden = !count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CollectionViewCell *cell = [CollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.textLabel.text = @"我是第一个cell";
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SectionHeaderView *header = [SectionHeaderView headerWithCollectionView:collectionView forIndexPath:indexPath];
        header.textLabel.text = [NSString stringWithFormat:@"- 我是头部-%zd -", indexPath.section];
        return header;
    }

    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        SectionFooterView *footer = [SectionFooterView footerWithCollectionView:collectionView forIndexPath:indexPath];
        footer.textLabel.text = [NSString stringWithFormat:@"- 我是尾部-%zd -", indexPath.section];
        return footer;
    }
    return nil;
}


#pragma mark <UICollectionViewDelegate>

// 每个item的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat w = CGRectGetWidth(collectionView.bounds);

    if (indexPath.row == 0) {
        return CGSizeMake(w-20, 120);
    }

    CGFloat itemWH = (w - 30) * 0.5;
    return CGSizeMake(itemWH,itemWH);
}

//【整体】边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);//分别为上、左、下、右
}


//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// Header大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat w = CGRectGetWidth(collectionView.bounds);
    return CGSizeMake(w, 50);
}

// Footer大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGFloat w = CGRectGetWidth(collectionView.bounds);
    return CGSizeMake(w, 50);
}

@end
