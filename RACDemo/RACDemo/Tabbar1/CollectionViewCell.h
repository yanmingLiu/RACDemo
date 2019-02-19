//
//  CollectionViewCell.h
//  collection
//
//  Created by lym on 2018/11/15.
//  Copyright © 2018 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *textLabel;


+ (NSString *)cellId;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
