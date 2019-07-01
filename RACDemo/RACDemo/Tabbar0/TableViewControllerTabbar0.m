//
//  TableViewControllerTabbar0.m
//  RACDemo
//
//  Created by lym on 2019/4/9.
//

#import "TableViewControllerTabbar0.h"

@interface TableViewControllerTabbar0 ()

@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation TableViewControllerTabbar0

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = @[@{@"text" : @"RAC-基本使用", @"vc" : @"ViewController"},
                   @{@"text" : @"RAC-cell事件传递", @"vc" : @"TableViewController"},
                   @{@"text" : @"RAC-数据绑定", @"vc" : @"RGBViewController"},
                   @{@"text" : @"RAC-mvvm", @"vc" : @"LoginViewController"},
                   @{@"text" : @"RAC-定位封装", @"vc" : @"LoactionViewController"},
                   @{@"text" : @"RAC-多个请求顺序执行", @"vc" : @"CombiningViewController"},

                   ];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.textLabel.text = dic[@"text"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *str = dic[@"vc"];
    Class cls = NSClassFromString(str);
    UIViewController *vc = [[cls alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
