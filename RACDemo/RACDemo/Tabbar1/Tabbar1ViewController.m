//
//  Tabbar1ViewController.m
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import "Tabbar1ViewController.h"


@interface Tabbar1ViewController ()

@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation Tabbar1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = @[@{@"text" : @"tableview加载", @"vc" : @"TestTabelViewController"},
                   @{@"text" : @"CollectionView加载", @"vc" : @"TestCollectionViewController"},
                   @{@"text" : @"导航栏滑动隐藏显示", @"vc" : @"TableViewController_nav"},
                   @{@"text" : @"YMTextView", @"vc" : @"TextViewController"},
                   @{@"text" : @"上下循环滚动View", @"vc" : @"ScrollViewController"},
                   @{@"text" : @"相册拍照拍视频", @"vc" : @"YMImagePickerViewController"},
                   @{@"text" : @"微信群头像生成", @"vc" : @"GroupIconViewController"},

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

