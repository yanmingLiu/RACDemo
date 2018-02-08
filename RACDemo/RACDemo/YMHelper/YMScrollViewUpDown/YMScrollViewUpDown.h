//
//  YMScrollViewUpDown.h
//  上下循环滚动View
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMScrollViewUpDown;

@protocol YMScrollViewUpDownDelegate <NSObject>

@required

- (NSInteger)numberOfContentViewsInLoopScrollView:(YMScrollViewUpDown *)loopScrollView;

- (UIView *)loopScrollView:(YMScrollViewUpDown *)loopScrollView contentViewAtIndex:(NSInteger)index;

@optional

- (void)loopScrollView:(YMScrollViewUpDown *)loopScrollView currentContentViewAtIndex:(NSInteger)index;

- (void)loopScrollView:(YMScrollViewUpDown *)loopScrollView didSelectContentViewAtIndex:(NSInteger)index;

@end

@interface YMScrollViewUpDown : UIView

@property (nonatomic,assign) id<YMScrollViewUpDownDelegate> delegate;

// 当duration<=0时，默认不自动滚动
- (id)initWithFrame:(CGRect)frame animationScrollDuration:(NSTimeInterval)duration;

- (void)reloadData;

@end
