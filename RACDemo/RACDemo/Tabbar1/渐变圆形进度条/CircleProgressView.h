//
//  CircleProgressView.h
//  RACDemo
//
//  Created by lym on 2020/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleProgressView : UIView


/// default 4
@property (nonatomic, assign) CGFloat lineWidth;

@property(nonatomic, strong) NSArray<UIColor*> *colors;

@property(nonatomic, assign) CGFloat progress;

@end

NS_ASSUME_NONNULL_END
