//
//  TableViewController_nav.m
//  RACDemo
//
//  Created by lym on 2018/8/30.
//

#import "TableViewController_nav.h"

@interface TableViewController_nav ()

@end

@implementation TableViewController_nav

- (void)viewDidLoad {
    [super viewDidLoad];


    // 1.直接使用 hidesBarsOnSwipe
    self.navigationController.hidesBarsOnSwipe = YES;
}

// 2.使用UIScrollViewDelegate一个代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;

    if (velocity <- 5) {
        //向上拖动，隐藏导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else if (velocity > 5) {
        //向下拖动，显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else if(velocity == 0){
        //停止拖拽
    }
}

// 3.使用UIScrollViewDelegate另一个代理方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y > 0.0) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else if (velocity.y < 0.0){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
