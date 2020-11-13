//
//  NOView.m
//  RACDemo
//
//  Created by lym on 2020/11/13.
//

#import "NOView.h"

@interface NOView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

static NSString *const cellID  = @"cell";

@implementation NOView

- (instancetype)initWithDelegate:(id<NOViewDelegate>)delegate {
    self.delegate = delegate;
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    NSAssert(NO, @"init(coder:) has not been implemented");
    return nil;
}

- (void)setupUI {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, safeAreaInsets_bottom(), 0));
    }];
    
    [self addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

// MARK: - public

- (void)reloadData:(NSArray *)datas {
    if (self.indicatorView.isAnimating) {
        [self.indicatorView stopAnimating];
    }
    self.dataArray = datas;
    [self.tableView reloadData];
    [self endRefreshing];
}

- (void)beginHeaderRefreshing {
    [self.tableView.mj_header beginRefreshing];
}

- (void)beginFooterRefreshing {
    [self.tableView.mj_footer beginRefreshing];
}

- (void)endRefreshing {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

// MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.delegate numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self.delegate numberOfRowsInSection:section];
    self.tableView.mj_footer.hidden = !count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%zd", NSStringFromClass(self.class), indexPath.row];
    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didSelectRowAtIndexPath:indexPath];
}

// MARK: - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        // 去掉多余分割线
        _tableView.tableFooterView = [[UIView alloc] init];
        // 预估高度
        // 问题1.不设置为0的时候  可能会出现高度过高 刷新有跳动
        // 问题2.设置了的时候，如果是UITableViewStyleGrouped 直接写sectionHeaderHeight=10 第一个分区没有头部，必须在代理返回高度
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
            [weakSelf.delegate headerWithRefreshing];
        }];

        _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
            [weakSelf.delegate footerWithRefreshing];
        }];
    }
    return _tableView;
}


- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}

@end


