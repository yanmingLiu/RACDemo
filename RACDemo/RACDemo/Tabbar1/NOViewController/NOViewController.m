//
//  NOViewController.m
//  RACDemo
//
//  Created by lym on 2020/11/13.
//

#import "NOViewController.h"
#import "NOView.h"
#import "NOViewModel.h"

@interface NOViewController () <NOViewDelegate>

@property (nonatomic, strong) NOView *noView;

@property (nonatomic, strong) NOViewModel *viewModel;

@end

@implementation NOViewController

- (void)loadView {
    self.noView = [[NOView alloc] initWithDelegate:self];
    self.view = self.noView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    [self.viewModel loadNewData:^{
        [weakSelf refreshUI];
    }];
}

- (void)refreshUI {
    [self.noView reloadData:self.viewModel.dataArray];
}

// MARK: - NOViewDelegate

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (void)headerWithRefreshing {
    __weak typeof(self) weakSelf = self;

    [self.viewModel loadNewData:^{
        [weakSelf refreshUI];
    }];
}

- (void)footerWithRefreshing {
    __weak typeof(self) weakSelf = self;

    [self.viewModel loadMoreData:^{
        [weakSelf refreshUI];
    }];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath: %zd", indexPath.row);
}

// MARK: - lazy

- (NOViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[NOViewModel alloc] init];
    }
    return _viewModel;
}

@end
