//
//  YMScrollViewUpDown.m
//  上下循环滚动View
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YMScrollViewUpDown.h"
#import "UIView+forYMScrollView.h"
#import "NSTimer+forYMScrollerView.h"

#define kWidth     (self.frame.size.width)
#define kHeight    (self.frame.size.height)

@interface YMScrollViewUpDown () <UIScrollViewDelegate>

{
    UIScrollView   * _scrollView;
    
    NSInteger        _totalPageCount;
    NSInteger        _currentPageIndex;
    
    NSTimer        * _animationTimer;
    NSTimeInterval   _animationDuration;
}

@end

@implementation YMScrollViewUpDown

- (id)initWithFrame:(CGRect)frame animationScrollDuration:(NSTimeInterval)duration{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        
        [self initAnimationScrollTimerWithDuration:duration];
        
        [self buildScrollView];
    }
    
    return self;
}

#pragma mark - Init

- (void)initData{
    _animationTimer    = nil;
    _animationDuration = 0;
}

- (void)initAnimationScrollTimerWithDuration:(NSTimeInterval)duration{
    
    _animationDuration = duration;
    
    if (duration > 0) {
        
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                           target:self
                                                         selector:@selector(startScroll:)
                                                         userInfo:nil
                                                          repeats:YES];
        
        NSRunLoop *main = [NSRunLoop currentRunLoop];
        [main addTimer:_animationTimer forMode:NSRunLoopCommonModes];
        
        [_animationTimer pause];
        
    }else{
        /*
         注意： 当 duration <= 0 时，_animationTimer为nil，由于在NSTimer扩展的方法中进行了空对象判断，所以本页代码中都没有进行空判断，也就是说此时对_animationTimer的操作都无效
         */
    }
}

- (void)buildScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _scrollView.delegate         = self;
    _scrollView.contentSize      = CGSizeMake(0, kHeight*3);
    _scrollView.contentOffset    = CGPointMake(0, kHeight);
    _scrollView.pagingEnabled    = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator   = NO;
    [self addSubview:_scrollView];
}

#pragma mark - Set

- (void)setDelegate:(id<YMScrollViewUpDownDelegate>)delegate{
    _delegate = delegate;
    
    [self reloadData];
}

#pragma mark - ReloadData

- (void)reloadData{
    _currentPageIndex  = 0;
    _totalPageCount    = 0;
    
    if ([self.delegate respondsToSelector:@selector(numberOfContentViewsInLoopScrollView:)]) {
        _totalPageCount = [self.delegate numberOfContentViewsInLoopScrollView:self];
    }else{
        NSAssert(NO, @"请实现numberOfContentViewsInLoopScrollView:代理函数");
    }
    
    [self resetContentViews];
    [_animationTimer restartAfterTimeInterval:_animationDuration];
}

#pragma mark - Action
- (void)startScroll:(NSTimer *)timer{
    //    CGFloat contentOffsetX = ( (int)(_scrollView.contentOffset.x +kWidth) / (int)kWidth ) * kWidth;
    //    CGPoint newOffset = CGPointMake(contentOffsetX, 0);
    
    CGFloat contentOffsetY = ( (int)(_scrollView.contentOffset.y +kHeight) / (int)kHeight ) * kHeight;
    CGPoint newOffset = CGPointMake(0, contentOffsetY);
    [_scrollView setContentOffset:newOffset animated:YES];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 当手动滑动时 暂停定时器
    [_animationTimer pause];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // 当手动滑动结束时 开启定时器
    [_animationTimer restartAfterTimeInterval:_animationDuration];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsetY = scrollView.contentOffset.y;
    
    if(contentOffsetY >= (2 * kHeight)) {
        _currentPageIndex = [self getNextPageIndexWithCurrentPageIndex:_currentPageIndex];
        
        // 调用代理函数 当前页面序号
        if (self.delegate && [self.delegate respondsToSelector:@selector(loopScrollView:currentContentViewAtIndex:)]) {
            [self.delegate loopScrollView:self currentContentViewAtIndex:_currentPageIndex];
        }
        [self resetContentViews];
    }
    
    
    if(contentOffsetY <= 0) {
        _currentPageIndex = [self getPreviousPageIndexWithCurrentPageIndex:_currentPageIndex];
        
        // 调用代理函数 当前页面序号
        if (self.delegate && [self.delegate respondsToSelector:@selector(loopScrollView:currentContentViewAtIndex:)]) {
            [self.delegate loopScrollView:self currentContentViewAtIndex:_currentPageIndex];
        }
        [self resetContentViews];
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [scrollView setContentOffset:CGPointMake(0, kHeight) animated:YES];
}

#pragma mark - Methods
- (void)resetContentViews{
    // 移除scrollView上的所有子视图
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger previousPageIndex = [self getPreviousPageIndexWithCurrentPageIndex:_currentPageIndex];
    NSInteger currentPageIndex  = _currentPageIndex;
    NSInteger nextPageIndex     = [self getNextPageIndexWithCurrentPageIndex:_currentPageIndex];
    
    UIView * previousContentView;
    UIView * currentContentView;
    UIView * nextContentView;
    
    if ([self.delegate respondsToSelector:@selector(loopScrollView:contentViewAtIndex:)]) {
        
        previousContentView = [self.delegate loopScrollView:self contentViewAtIndex:previousPageIndex];
        currentContentView  = [self.delegate loopScrollView:self contentViewAtIndex:currentPageIndex];
        nextContentView     = [self.delegate loopScrollView:self contentViewAtIndex:nextPageIndex];
        
        NSArray * viewsArr = @[[previousContentView copyView],[currentContentView copyView],[nextContentView copyView]]; // copy操作主要是为了只有两张内容视图的情况
        
        for (int i = 0; i < viewsArr.count; i++) {
            UIView * contentView = viewsArr[i];
            
            [contentView setFrame:CGRectMake(0, kHeight*i, contentView.frame.size.width, contentView.frame.size.height)];
            contentView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
            [contentView addGestureRecognizer:tapGesture];
            
            [_scrollView addSubview:contentView];
        }
        
        [_scrollView setContentOffset:CGPointMake(0, kHeight)];
        
    }else{
        //        NSAssert(NO, @"请实现loopScrollView:contentViewAtIndex:代理函数");
    }
}

// 获取当前页上一页的序号
- (NSInteger)getPreviousPageIndexWithCurrentPageIndex:(NSInteger)currentIndex{
    if (currentIndex == 0) {
        return _totalPageCount -1;
    }else{
        return currentIndex -1;
    }
}

// 获取当前页下一页的序号
- (NSInteger)getNextPageIndexWithCurrentPageIndex:(NSInteger)currentIndex{
    if (currentIndex == _totalPageCount -1) {
        return 0;
    }else{
        return currentIndex +1;
    }
}


#pragma mark - TapAction
- (void)tapContentView:(UITapGestureRecognizer *)gesture{
    
    if ([self.delegate respondsToSelector:@selector(loopScrollView:didSelectContentViewAtIndex:)]) {
        [self.delegate loopScrollView:self didSelectContentViewAtIndex:_currentPageIndex];
    }
}


- (void)invalidate {
    
    [_animationTimer invalidate];
    _animationTimer = nil;
}

- (void)dealloc {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
