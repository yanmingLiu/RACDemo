//
//  Tabbar1ViewController.m
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import "Tabbar1ViewController.h"
#import "InputPwdController.h"
#import "AvatarsViewController.h"

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
                   @{@"text" : @"日期转换", @"vc" : @"DateTableViewController"},
                   @{@"text" : @"金钱显示", @"vc" : @"PriceViewController"},
                   @{@"text" : @"水波纹动画", @"vc" : @"RippleAnimatViewController"},
                   @{@"text" : @"密码输入弹窗", @"vc" : @"InputPwdController"},
                   @{@"text" : @"自定义UISlider", @"vc" : @"CustomSliderViewController"},
                   @{@"text" : @"渐变字体label", @"vc" : @"GradientLabelViewController"},
                   @{@"text" : @"水平滚动textView-跑马灯", @"vc" : @"ScrollTextViewController"},
                   @{@"text" : @"MVVM模式，vc的view彻底分离", @"vc" : @"NOViewController"},
                   @{@"text" : @"监听键盘高度", @"vc" : @"KeyboardViewController"},
                   @{@"text" : @"礼物选择", @"vc" : @"GiftPopViewController"},
                   @{@"text" : @"头像重叠", @"vc" : @"AvatarsViewController"},
                   @{@"text" : @"渐变色圆形进度条", @"vc" : @"CircleProgressViewController"},
                   @{@"text" : @"Lottie", @"vc" : @"LottieViewController"},
                   
                   
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

    UINavigationBar *bar = self.navigationController.navigationBar;
    NSLog(@"bar : %@", NSStringFromCGRect(bar.frame));

    
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *str = dic[@"vc"];
    
    if ([str isEqualToString:@"InputPwdController"]) {
        InputPwdController *vc = [[InputPwdController alloc] init];
        [vc show];
        return;
    }
    
    Class cls = NSClassFromString(str);
    UIViewController *vc = [[cls alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = dic[@"text"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

