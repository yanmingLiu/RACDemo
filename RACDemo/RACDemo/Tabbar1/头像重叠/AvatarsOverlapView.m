//
//  AvatarsOverlapView.m
//  RACDemo
//
//  Created by lym on 2020/12/21.
//

#import "AvatarsOverlapView.h"

@interface AvatarsOverlapView ()


@end

@implementation AvatarsOverlapView

- (instancetype)initWithAvatarSize:(CGSize)avatarSize {
    self.avatarSize = avatarSize;
    return [super initWithFrame:CGRectZero];
}


- (void)fillDatas:(NSArray<NSString *> *)avatars {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < avatars.count; i++) {
        UIImageView *imgv = [[UIImageView alloc] init];
        imgv.clipsToBounds = YES;
        imgv.backgroundColor = RandomColor;
        [self addSubview:imgv];
    }
    
    CGFloat w = self.avatarSize.width;
    CGFloat h = self.avatarSize.height;

    UIImageView *last;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIImageView *imgv = self.subviews[i];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(h);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            if (i == 0) {
                make.right.equalTo(self);
            } else {
                make.right.equalTo(last.mas_centerX);
            }
            if (i == (self.subviews.count - 1)) {
                make.left.equalTo(self);
            }
        }];
        imgv.layer.cornerRadius = h / 2;
        
        last = imgv;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end






