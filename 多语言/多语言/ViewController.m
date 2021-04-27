//
//  ViewController.m
//  多语言
//
//  Created by lym on 2021/4/26.
//

#import "ViewController.h"
#import "AppLanguage.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;

    _titles = @[@"公用的多语言字符串",@"不同模块的多语言，多人开发避免冲突", @"App内切换语言"];

    _datas = @[@[@"previewCamera", @"previewCameraRecord", @"previewAlbum", @"previewCancel"],
               @[@"me"],
               @[@"中文简体", @"中文繁体", @"英语", @"韩语", @"日语", @"阿拉伯语"]
    ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datas[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *key = _datas[indexPath.section][indexPath.row];
    if (indexPath.section == 1) {
        cell.textLabel.text = kLocalizedStr(key, KAppLanguageTableMe);
    } else {
        cell.textLabel.text = kLocalizedStr(key, KAppLanguageTableCommon);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                [[AppLanguage shared] setPreferredLanguage:@"zh-Hans"];
                break;
            case 1:
                [[AppLanguage shared] setPreferredLanguage:@"zh-Hant"];
                break;
            case 2:
                [[AppLanguage shared] setPreferredLanguage:@"en"];
                break;
            case 3:
                [[AppLanguage shared] setPreferredLanguage:@"ko"];
                break;
            case 4:
                [[AppLanguage shared] setPreferredLanguage:@"ja"];
                break;
            case 5:
                [[AppLanguage shared] setPreferredLanguage:@"ar"];
                break;

            default:
                break;
        }
        [tableView reloadData];
    }
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _titles[section];
}


@end
