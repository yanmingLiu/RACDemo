//
//  UIAlertController+Blocks.m
//  WishKit
//
//  Created by Melo Chale on 04/12/2016.
//  Copyright © 2017 HShare. All rights reserved.
//

#import "UIAlertController+Blocks.h"

static NSInteger const UIAlertControllerBlocksCancelButtonIndex = 0;
static NSInteger const UIAlertControllerBlocksDestructiveButtonIndex = 1;
static NSInteger const UIAlertControllerBlocksFirstOtherButtonIndex = 2;

const NSInteger UIAlertControllerCancelButtonIndex =  UIAlertControllerBlocksCancelButtonIndex;
const NSInteger UIAlertControllerDestructiveButtonIndex = UIAlertControllerBlocksDestructiveButtonIndex;
const NSInteger UIAlertControllerFirtOtherButtonIndex = UIAlertControllerBlocksFirstOtherButtonIndex;
const NSInteger UIAlertControllerConfirmButtonIndex = UIAlertControllerBlocksFirstOtherButtonIndex;
const NSInteger UIAlertControllerPlaintTextFieldIndex = 0;
const NSInteger UIAlertControllerSecureTextFieldIndex = 1;

@interface UIViewController (UACB_Topmost)

- (UIViewController *)uacb_topmost;

@end

@implementation UIAlertController (Blocks)

+ (instancetype)showInViewController:(UIViewController *)viewController
                           withTitle:(NSString *)title
                             message:(NSString *)message
                      preferredStyle:(UIAlertControllerStyle)preferredStyle
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
#if TARGET_OS_IOS
  popoverPresentationControllerBlock:(void(^)(UIPopoverPresentationController *popover))popoverPresentationControllerBlock
#endif
                            tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    UIAlertController *strongController = [self alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:preferredStyle];
    
    __weak UIAlertController *controller = strongController;
    
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 if (tapBlock)
                                                                 {
                                                                     tapBlock(controller, action, UIAlertControllerBlocksCancelButtonIndex);
                                                                 }
                                                             }];
        [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
        [controller addAction:cancelAction];
    }
    
    for (NSUInteger i = 0; i < otherButtonTitles.count; i++) {
        NSString *otherButtonTitle = otherButtonTitles[i];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action){
                                                                if (tapBlock)
                                                                {
                                                                    tapBlock(controller, action, UIAlertControllerBlocksFirstOtherButtonIndex + i);
                                                                }
                                                            }];
        [controller addAction:otherAction];
    }
    
    if (destructiveButtonTitle) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction *action){
                                                                      if (tapBlock)
                                                                      {
                                                                          tapBlock(controller, action, UIAlertControllerBlocksDestructiveButtonIndex);
                                                                      }
                                                                  }];
        [controller addAction:destructiveAction];
        if (@available(iOS 9.0, *)) {
            controller.preferredAction = destructiveAction;
        }        
    }
    
#if TARGET_OS_IOS
    if (popoverPresentationControllerBlock) {
        popoverPresentationControllerBlock(controller.popoverPresentationController);
    }
    if (!controller.popoverPresentationController.sourceView)
    {
        controller.popoverPresentationController.sourceView = viewController.uacb_topmost.view;
    }
#endif
    
    [viewController.uacb_topmost presentViewController:controller animated:YES completion:nil];
    
    return controller;
}

+ (instancetype)showAlertInViewController:(UIViewController *)viewController
                                withTitle:(NSString *)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                        otherButtonTitles:(NSArray *)otherButtonTitles
                                 tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    return [self showInViewController:viewController
                            withTitle:title
                              message:message
                       preferredStyle:UIAlertControllerStyleAlert
                    cancelButtonTitle:cancelButtonTitle
               destructiveButtonTitle:destructiveButtonTitle
                    otherButtonTitles:otherButtonTitles
#if TARGET_OS_IOS
            popoverPresentationControllerBlock:nil
#endif
                             tapBlock:tapBlock];
}

+ (instancetype)showActionSheetInViewController:(UIViewController *)viewController
                                      withTitle:(NSString *)title
                                        message:(NSString *)message
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                              otherButtonTitles:(NSArray *)otherButtonTitles
#if TARGET_OS_IOS
             popoverPresentationControllerBlock:(void(^)(UIPopoverPresentationController *popover))popoverPresentationControllerBlock
#endif
                                       tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    return [self showInViewController:viewController
                            withTitle:title
                              message:message
                       preferredStyle:UIAlertControllerStyleActionSheet
                    cancelButtonTitle:cancelButtonTitle
               destructiveButtonTitle:destructiveButtonTitle
                    otherButtonTitles:otherButtonTitles
#if TARGET_OS_IOS
            popoverPresentationControllerBlock:popoverPresentationControllerBlock
#endif
                             tapBlock:tapBlock];
}

+ (instancetype)showInputAlertInViewController:(UIViewController *)viewController
                                     withTitle:(NSString *)title
                                       message:(NSString *)message
                    plaintTextFieldPlaceholder:(NSString *)plaintPlaceholder
                    secureTextfieldPlaceHolder:(NSString *)securePlacholder
                             cancelButtonTitle:(NSString *)cancelButtonTitle
                            confirmButtonTitle:(NSString *)confirmButtonTitle
#if TARGET_OS_IOS
            popoverPresentationControllerBlock:(void(^)(UIPopoverPresentationController *popover))popoverPresentationControllerBlock
#endif
                                      tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:title
                                                                              message:message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    if (plaintPlaceholder)
    {
        [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = plaintPlaceholder;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
    }

    if (securePlacholder)
    {
        [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = securePlacholder;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.secureTextEntry = YES;
        }];
    }
    
    if (cancelButtonTitle)
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 if (tapBlock)
                                                                 {
                                                                     tapBlock(controller, action, UIAlertControllerBlocksCancelButtonIndex);
                                                                 }
                                                             }];
        [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
        [controller addAction:cancelAction];
    }
    
    if (confirmButtonTitle)
    {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  if (tapBlock)
                                                                  {
                                                                      tapBlock(controller, action, UIAlertControllerConfirmButtonIndex);
                                                                  }
                                                              }];
        [controller addAction:confirmAction];
        if (@available(iOS 9.0, *)) {
            controller.preferredAction = confirmAction;
        }
    }
    
#if TARGET_OS_IOS
    if (popoverPresentationControllerBlock) {
        popoverPresentationControllerBlock(controller.popoverPresentationController);
    }
    if (!controller.popoverPresentationController.sourceView)
    {
        controller.popoverPresentationController.sourceView = viewController.uacb_topmost.view;
    }
#endif
    
    [viewController.uacb_topmost presentViewController:controller animated:YES completion:nil];
    
    return controller;
}


+ (instancetype)showInputAlertInViewController:(UIViewController *)viewController
                                     withTitle:(NSString *)title
                                       message:(NSString *)message
                           passwordPlaceholder:(NSString *)passwordPlaceholder
                    confirmPassowrdPlaceHolder:(NSString *)confirmPasswordPlacholder
                             cancelButtonTitle:(NSString *)cancelButtonTitle
                            confirmButtonTitle:(NSString *)confirmButtonTitle
#if TARGET_OS_IOS
            popoverPresentationControllerBlock:(void(^)(UIPopoverPresentationController *popover))popoverPresentationControllerBlock
#endif
                                      tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:title
                                                                         message:message
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    if (passwordPlaceholder)
    {
        [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = passwordPlaceholder;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.secureTextEntry = YES;
        }];
    }
    
    if (confirmPasswordPlacholder)
    {
        [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = confirmPasswordPlacholder;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.secureTextEntry = YES;
        }];
    }
    
    if (cancelButtonTitle)
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 if (tapBlock)
                                                                 {
                                                                     tapBlock(controller, action, UIAlertControllerBlocksCancelButtonIndex);
                                                                 }
                                                             }];
        [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
        [controller addAction:cancelAction];
    }
    
    if (confirmButtonTitle)
    {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  if (tapBlock)
                                                                  {
                                                                      tapBlock(controller, action, UIAlertControllerConfirmButtonIndex);
                                                                  }
                                                              }];
        [controller addAction:confirmAction];
        if (@available(iOS 9.0, *)) {
            controller.preferredAction = confirmAction;
        }
    }
    
#if TARGET_OS_IOS
    if (popoverPresentationControllerBlock) {
        popoverPresentationControllerBlock(controller.popoverPresentationController);
    }
    if (!controller.popoverPresentationController.sourceView)
    {
        controller.popoverPresentationController.sourceView = viewController.uacb_topmost.view;
    }
#endif
    
    [viewController.uacb_topmost presentViewController:controller animated:YES completion:nil];
    
    return controller;
}

+ (nonnull instancetype)showInputAlertInViewController:(nonnull UIViewController *)vc
                                             withTitle:(nullable NSString *)title
                                               message:(nullable NSString *)message
                                           placeHolder:(nullable NSString *)placeHolder
                                          keyboradType:(UIKeyboardType)keyboradType
                                     cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    confirmButtonTitle:(nullable NSString *)confirmButtonTitle
                                              tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock
{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:title
                                                                         message:message
                                                                  preferredStyle:UIAlertControllerStyleAlert];

    if (placeHolder) {
        [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = placeHolder;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType = keyboradType;
        }];
    }

    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            if (tapBlock) {
                tapBlock(controller, action, UIAlertControllerBlocksCancelButtonIndex);
            }
        }];
        [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
        [controller addAction:cancelAction];
    }

    if (confirmButtonTitle)
    {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (tapBlock) {
                tapBlock(controller, action, UIAlertControllerConfirmButtonIndex);
            }
        }];
        [controller addAction:confirmAction];
        if (@available(iOS 9.0, *)) {
            controller.preferredAction = confirmAction;
        }
    }

    [vc.uacb_topmost presentViewController:controller animated:YES completion:nil];

    return controller;
}

#pragma mark

- (BOOL)visible
{
    return self.view.superview != nil;
}

- (NSInteger)cancelButtonIndex
{
    return UIAlertControllerBlocksCancelButtonIndex;
}

- (NSInteger)firstOtherButtonIndex
{
    return UIAlertControllerBlocksFirstOtherButtonIndex;
}

- (NSInteger)destructiveButtonIndex
{
    return UIAlertControllerBlocksDestructiveButtonIndex;
}

@end

@implementation UIViewController (UACB_Topmost)

- (UIViewController *)uacb_topmost
{
    UIViewController *topmost = self;
    
    UIViewController *above;
    while ((above = topmost.presentedViewController)) {
        topmost = above;
    }
    
    return topmost;
}

@end
