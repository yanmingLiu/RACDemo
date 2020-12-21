//
//  AvatarsOverlapView.h
//  RACDemo
//
//  Created by lym on 2020/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvatarsOverlapView : UIView

@property (nonatomic, assign) IBInspectable CGSize avatarSize;

- (instancetype)initWithAvatarSize:(CGSize)avatarSize;

- (void)fillDatas:(NSArray<NSString *> *)avatars;

@end



NS_ASSUME_NONNULL_END
