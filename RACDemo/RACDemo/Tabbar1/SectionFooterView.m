//
//  SectionFooterView.m
//  collection
//
//  Created by lym on 2018/11/16.
//  Copyright © 2018 lym. All rights reserved.
//

#import "SectionFooterView.h"

@implementation SectionFooterView

+ (NSString *)footerId {
    return @"SectionFooterView";
}

+ (instancetype)footerWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    SectionFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[SectionFooterView footerId] forIndexPath:indexPath];
    return footer;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor blueColor];

        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"我是尾部";
        [self addSubview:label];
        self.textLabel = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.frame = self.bounds;

}

@end
