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


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    }


    
    return cell;
}



@end
