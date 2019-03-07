//
//  Tabbar1ViewController.m
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import "Tabbar1ViewController.h"


@interface Tabbar1ViewController ()

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation Tabbar1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [NSMutableArray arrayWithObjects:@"TestTabelViewController",
                  @"MVPTableViewController",
                  nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *str = self.dataArray[indexPath.row];
    Class cls = NSClassFromString(str);
    UIViewController *vc = [[cls alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

