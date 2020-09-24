//
//  InputPwdController.h
//  RACDemo
//
//  Created by lym on 2020/9/12.
//

#import <UIKit/UIKit.h>
#import "InputBoxView.h"

NS_ASSUME_NONNULL_BEGIN

@interface InputPwdController : UIViewController

@property (nonatomic, copy) void (^ __nullable completion)(BOOL succ);

- (void)show;

- (void)dismiss;


@end

NS_ASSUME_NONNULL_END
