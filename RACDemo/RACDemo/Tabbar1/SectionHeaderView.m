//
//  SectionHeaderView.m
//  collection
//
//  Created by lym on 2018/11/16.
//  Copyright © 2018 lym. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView


+ (NSString *)headerId {
    return @"SectionHeaderView";
}

+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    SectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[SectionHeaderView headerId] forIndexPath:indexPath];
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor greenColor];

        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"我是头部";
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
