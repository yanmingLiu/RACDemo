//
//  YMBottomPopView.h
//  ykxB
//
//  Created by lym on 2017/11/21.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWShareItemButton : UIButton
@end

typedef void (^selectItemBlock)(NSInteger tag, NSString *title);

@interface YMBottomPopView : UIView

/**
 *  show
 */
- (void)showItems:(NSArray *)items title:(NSString *)title tips:(NSString *)tips rowCount:(NSInteger)rowCount selectedHandle:(selectItemBlock)selectedHandle;

- (void)hidden;

@end
