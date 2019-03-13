//
//  UIAlertController+Blocks.h
//  WishKit
//
//  Created by Melo Chale on 04/12/2016.
//  Copyright © 2017 HShare. All rights reserved.
//


#import <UIKit/UIKit.h>

#if TARGET_OS_IOS
typedef void (^UIAlertControllerPopoverPresentationControllerBlock) (UIPopoverPresentationController * __nonnull popover);
#endif
typedef void (^UIAlertControllerCompletionBlock) (UIAlertController * __nonnull controller, UIAlertAction * __nonnull action, NSInteger buttonIndex);

FOUNDATION_EXTERN const NSInteger UIAlertControllerCancelButtonIndex;
FOUNDATION_EXTERN const NSInteger UIAlertControllerDestructiveButtonIndex;
FOUNDATION_EXTERN const NSInteger UIAlertControllerFirtOtherButtonIndex;
FOUNDATION_EXTERN const NSInteger UIAlertControllerConfirmButtonIndex;
FOUNDATION_EXTERN const NSInteger UIAlertControllerPlaintTextFieldIndex;
FOUNDATION_EXTERN const NSInteger UIAlertControllerSecureTextFieldIndex;

@interface UIAlertController (Blocks)

+ (nonnull instancetype)showInViewController:(nonnull UIViewController *)viewController
                                   withTitle:(nullable NSString *)title
                                     message:(nullable NSString *)message
                              preferredStyle:(UIAlertControllerStyle)preferredStyle
                           cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                           otherButtonTitles:(nullable NSArray *)otherButtonTitles
#if TARGET_OS_IOS
          popoverPresentationControllerBlock:(nullable UIAlertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
#endif
                                    tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;

+ (nonnull instancetype)showAlertInViewController:(nonnull UIViewController *)viewController
                                        withTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                         tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;


+ (nonnull instancetype)showActionSheetInViewController:(nonnull UIViewController *)viewController
                                              withTitle:(nullable NSString *)title
                                                message:(nullable NSString *)message
                                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                      otherButtonTitles:(nullable NSArray *)otherButtonTitles
#if TARGET_OS_IOS
                     popoverPresentationControllerBlock:(nullable UIAlertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
#endif
                                               tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;

+ (nonnull instancetype)showInputAlertInViewController:(nonnull UIViewController *)viewController
                                     withTitle:(nullable NSString *)title
                                       message:(nullable NSString *)message
                    plaintTextFieldPlaceholder:(nullable NSString *)plaintPlaceholder
                    secureTextfieldPlaceHolder:(nullable NSString *)securePlacholder
                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                            confirmButtonTitle:(nullable NSString *)confirmButtonTitle
#if TARGET_OS_IOS
            popoverPresentationControllerBlock:(nullable UIAlertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
#endif
                                      tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;

+ (nonnull instancetype)showInputAlertInViewController:(nonnull UIViewController *)viewController
                                             withTitle:(nullable nullable NSString *)title
                                               message:(nullable NSString *)message
                                   passwordPlaceholder:(nullable NSString *)passwordPlaceholder
                            confirmPassowrdPlaceHolder:(nullable NSString *)confirmPasswordPlacholder
                                     cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    confirmButtonTitle:(nullable NSString *)confirmButtonTitle
#if TARGET_OS_IOS
                    popoverPresentationControllerBlock:(nullable UIAlertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
#endif
                                              tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;


+ (nonnull instancetype)showInputAlertInViewController:(nonnull UIViewController *)vc
                                             withTitle:(nullable NSString *)title
                                               message:(nullable NSString *)message
                                           placeHolder:(nullable NSString *)placeHolder
                                          keyboradType:(UIKeyboardType)keyboradType
                                     cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    confirmButtonTitle:(nullable NSString *)confirmButtonTitle
                                              tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;

@property (readonly, nonatomic) BOOL visible;
@property (readonly, nonatomic) NSInteger cancelButtonIndex;
@property (readonly, nonatomic) NSInteger firstOtherButtonIndex;
@property (readonly, nonatomic) NSInteger destructiveButtonIndex;

@end
