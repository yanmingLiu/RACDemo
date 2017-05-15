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
    
    
    //takeUntil会接收一个signal,当signal触发后会把之前的信号释放掉
    
    // 如果不加takeUntil:cell.rac_prepareForReuseSignal，那么每次Cell被重用时，该button都会被addTarget:selector。
    [[cell rac_signalForSelector:@selector(cellBtnAuction:)] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    [[[cell.cellBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [[[cell rac_signalForSelector:@selector(cellBtnAuction:)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    /***/
    
    [[[cell.cellCancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    
    [[cell rac_signalForSelector:@selector(cellCancelBtnAuction:)] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
