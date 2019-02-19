//
//  Tabbar1ViewController.m
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import "Tabbar1ViewController.h"
#import "TestTabelViewController.h"
#import "TestCollectionViewController.h"


@interface Tabbar1ViewController ()

@end

@implementation Tabbar1ViewController


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:
            [self pushTable];
            break;
        case 1:
            [self pushCollection];
            break;

        default:
            break;
    }

}

- (void)pushTable {
    TestTabelViewController *vc = [[TestTabelViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushCollection {
    TestCollectionViewController *vc = [[TestCollectionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
