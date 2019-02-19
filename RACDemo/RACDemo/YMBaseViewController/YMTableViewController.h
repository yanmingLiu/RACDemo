//
//  YMTableViewController.h
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "YMEmptyHelper.h"
#import "TopNewView.h"


NS_ASSUME_NONNULL_BEGIN

@interface YMTableViewController : UIViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, assign) YMEmptyHelperStyle emptyStyle;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style;

- (void)setupMJRefresh;

- (void)loadData;

@end

NS_ASSUME_NONNULL_END
