//
//  TestTabelViewController.m
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import "TestTabelViewController.h"
#import "TopNewView.h"

@interface TestTabelViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation TestTabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupMJRefresh];

    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.emptyStyle = YMEmptyHelperStyleLoading;
    [self loadData];
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

        self.emptyStyle = YMEmptyHelperStyleSuccess;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
