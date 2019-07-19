//
//  TestCollectionViewController.m
//  RACDemo
//
//  Created by lym on 2019/3/11.
//

#import "TestCollectionViewController.h"
#import "TopNewView.h"


@interface TestCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation TestCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const headerId = @"headerId";
static CGFloat  const margin = 10;


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupFlowLayoutCollectionView];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];

    [self setupMJRefresh];

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.page = 1;
    self.dataArray = [NSMutableArray array];
    self.blankPageStyle = YMBlankPageStyleLoading;
    [self loadData];
}


- (void)setupMJRefresh {
    @weakify(self);
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self loadData];
    }];

    self.collectionView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.page += 1;
        [self loadData];
    }];
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

        self.blankPageStyle = YMBlankPageStyleSuccess;
        [self.collectionView reloadData];

    });
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.dataArray.count;
    self.collectionView.mj_footer.hidden = !count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.contentView.backgroundColor = RandomColor;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId forIndexPath:indexPath];

        header.backgroundColor = RandomColor;
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width = CGRectGetWidth(collectionView.frame);

    return CGSizeMake((width - margin * 3) * 0.5, (width - margin * 3) * 0.5 + 100);
}

//【整体】边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(margin, margin, 0, margin);
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return margin;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return margin;
}

// Header大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return CGSizeMake(kScreenWidth, 60);
}






@end
