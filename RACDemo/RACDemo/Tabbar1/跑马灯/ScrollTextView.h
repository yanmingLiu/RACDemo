//
//  ScrollTextView.h
//  RACDemo
//
//  Created by lym on 2020/10/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollTextView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                         tont:(UIFont *)font
                        color:(UIColor *)color;

- (void)updateText:(NSString *)text
              font:(UIFont *)font
             color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
