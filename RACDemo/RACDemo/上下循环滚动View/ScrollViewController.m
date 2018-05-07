//
//  ScrollViewController.m
//  RACDemo
//
//  Created by lym on 2018/2/8.
//

#import "ScrollViewController.h"
#import "YMScrollViewUpDown.h"


@interface ScrollViewController ()<YMScrollViewUpDownDelegate>


@property (nonatomic, strong) NSArray * news; 

@property (nonatomic, strong) YMScrollViewUpDown * scrollLabelView; 

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _news = @[@"外交部证实：中国驻朝使馆派员出席朝鲜建军节阅兵式",@"外交部证实：中国驻朝使馆派员出席朝鲜建军节阅兵式",@"外交部证实：中国驻朝使馆派员出席朝鲜建军节阅兵式",@"外交部证实：中国驻朝使馆派员出席朝鲜建军节阅兵式"];
    
    CGRect scrollViewFrame = CGRectMake(50, 100, 250, 35);
    YMScrollViewUpDown * scrollLabelView = [[YMScrollViewUpDown alloc] initWithFrame:scrollViewFrame animationScrollDuration:2];
    scrollLabelView.delegate        = self;
    scrollLabelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollLabelView];
    _scrollLabelView = scrollLabelView;
}


#pragma mark - YMScrollViewUpDownDelegate 

- (NSInteger)numberOfContentViewsInLoopScrollView:(YMScrollViewUpDown *)loopScrollView{
    return self.news.count;
}

- (UIView *)loopScrollView:(YMScrollViewUpDown *)loopScrollView contentViewAtIndex:(NSInteger)index{
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:loopScrollView.bounds];
    tempLabel.textAlignment   = NSTextAlignmentLeft;
    tempLabel.text            = self.news.count ? self.news[index] : @"";
    tempLabel.font            = [UIFont systemFontOfSize:14];
    tempLabel.numberOfLines   = 2;
    tempLabel.textColor       = RGBA(56, 56, 56, 1);
    return tempLabel;
}

- (void)loopScrollView:(YMScrollViewUpDown *)loopScrollView didSelectContentViewAtIndex:(NSInteger)index{
    //NSLog(@"----点击-----%ld",index);

    
}


- (void)dealloc {
    [_scrollLabelView invalidate];
}

@end
