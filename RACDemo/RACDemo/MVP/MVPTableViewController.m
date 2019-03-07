//
//  MVPTableViewController.m
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import "MVPTableViewController.h"
#import "MVPPresent.h"


@interface MVPTableViewController ()

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MVPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = RGB(245, 245, 245);
    _tableView.separatorColor = RGB(238, 238, 238);
    _tableView.tableFooterView = [[UIView alloc] init];

    [self.view addSubview:_tableView];
}


@end
