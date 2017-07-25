//
//  TableViewController.m
//  RACDemo
//
//  Created by 刘彦铭 on 2017/5/11.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

#import "ReactiveObjC.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.cellBtn.tag = indexPath.row;
    cell.cellCancelBtn.tag = indexPath.row;
    
    /// 1.替换代理
    //takeUntil会接收一个signal,当signal触发后会把之前的信号释放掉
    
    // 如果不加takeUntil:cell.rac_prepareForReuseSignal，那么每次Cell被重用时，该button都会被addTarget:selector。
    [[cell rac_signalForSelector:@selector(cellBtnAuction:)] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    [[[cell.cellBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [[[cell rac_signalForSelector:@selector(cellBtnAuction:)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    /// 2.监听事件
    [[[cell.cellCancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    
    [[cell rac_signalForSelector:@selector(cellCancelBtnAuction:)] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    return cell;
}



@end
