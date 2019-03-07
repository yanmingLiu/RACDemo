//
//  TestTabelViewController.m
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import "TestTabelViewController.h"
#import "TopNewView.h"

@interface TestTabelViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray * dataArray;


@end

@implementation TestTabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableViewWithStyle:(UITableViewStyleGrouped)];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self setupMJRefresh];

    self.automaticallyAdjustsScrollViewInsets = NO;


    self.page = 1;
    self.dataArray = [NSMutableArray array];
    self.blankPageStyle = YMBlankPageStyleLoading;
    [self loadData];
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



- (void)loadData {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (self.page == 1) {
            [self.dataArray removeAllObjects];
            [self.tableView.mj_header endRefreshing];
            [TopNewView showInView:self.tableView content:@"您有5条新消息"];
        }

        for (int i = 0; i < 5; i++) {
            [self.dataArray addObject:@(i+1)];
        }

        [self.tableView.mj_footer endRefreshing];

        self.blankPageStyle = YMBlankPageStyleSuccess;
        [self.tableView reloadData];

    });

}



// MARK: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.dataArray.count;
    self.tableView.mj_footer.hidden = !count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%zd", NSStringFromClass(self.class), indexPath.row];

    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


}


@end
