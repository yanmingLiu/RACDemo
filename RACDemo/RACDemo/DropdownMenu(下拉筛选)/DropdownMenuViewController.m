//
//  DropdownMenuViewController.m
//  RACDemo
//
//  Created by lym on 2018/2/8.
//

#import "DropdownMenuViewController.h"
#import "DropdownMenu.h"
#import "DropdownMenuViewController2.h"


@interface DropdownMenuViewController ()<DropdownMenuDelegate>

@property (nonatomic, strong) DropdownMenu *dropdownMenu;


@end

@implementation DropdownMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一个" style:(UIBarButtonItemStylePlain) target:self action:@selector(xxx)];
    
    [self setupDropdownMenu];
}


- (void)xxx {
    DropdownMenuViewController2 *vc2 = [[DropdownMenuViewController2 alloc] init];
    [self.navigationController pushViewController:vc2 animated:YES];
}


- (void)setupDropdownMenu {
    
    self.title = @"下拉菜单";
    self.view.backgroundColor = [UIColor yellowColor];
    
    NSArray *leftItem1 = @[@"全部",@"易车生活洗车",@"店面代金券",@"人工普洗",@"人工精洗",@"电脑普洗",@"电脑精洗"];
    NSArray *leftItem2 = @[@"全部",@"通用品牌",@"现代专用"];
    NSArray *leftItem3 = @[@"全部",@"通用品牌",@"索菲玛"];
    NSArray *leftItem4 = @[@"全部",@"车仆",@"标榜",@"3M",@"通用品牌"];
    NSArray *leftItem5 = @[@"全部",@"清洗节气门",@"清洗三元催化器",@"清洗喷油嘴",@"清洗进气道"];
    NSArray *leftItem6 = @[@"全部",@"通用品牌"];
    NSArray *leftItem7 = @[@"全部",@"通用品牌",@"清洗节气门",@"清洗三元催化器"];
    
    NSArray *lRightItem = @[leftItem1,leftItem2,leftItem3,leftItem4,leftItem5,leftItem6,leftItem7];
    NSArray *leftItems = [[NSArray alloc] initWithObjects:leftItem1,lRightItem, nil];

    NSArray *centerItem1 = @[@"默认排序",@"价格最低",@"距离最近",@"成交最多",@"评分最高",@"优惠最大"];
    NSArray *centerItems = [[NSArray alloc] initWithObjects:centerItem1, nil];
    
    NSArray *rightItem1 = @[@"全部",@"夜间营业",@"推荐商家"];
    NSArray *rightItems = [[NSArray alloc] initWithObjects:rightItem1, nil];
    
    NSArray *titles = @[@"人工普洗",@"智能排序",@"筛选",@"其它"];
    
    NSArray *menuItems = @[leftItems,centerItems,rightItems,rightItems];
    
    CGRect frame = CGRectMake(0, 100, self.view.bounds.size.width, 40);
    _dropdownMenu = [[DropdownMenu alloc] initDropdownMenuWithFrame:frame Menutitles:titles MenuLists:menuItems];
    _dropdownMenu.delegate = self;
    [self.view addSubview:_dropdownMenu.view];
}

// MARK: - DropdownMenuDelegate
- (void)dropdownSelectedBtnIndex:(NSInteger)btnIndex leftIndex:(NSInteger)left rightIndex:(NSInteger)right text:(NSString *)text {
    NSLog(@"%zd --%zd, %zd, %@", btnIndex, left, right, text);
}




@end
