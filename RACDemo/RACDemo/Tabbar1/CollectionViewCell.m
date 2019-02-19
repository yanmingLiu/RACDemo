//
//  CollectionViewCell.m
//  collection
//
//  Created by lym on 2018/11/15.
//  Copyright © 2018 lym. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell


+ (NSString *)cellId {
    return @"CollectionViewCell";
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath {

    CollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:[CollectionViewCell cellId]
                                              forIndexPath:indexPath];

    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor orangeColor];

        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"cell-1";
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
