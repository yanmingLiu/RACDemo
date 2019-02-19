//
//  SectionFooterView.h
//  collection
//
//  Created by lym on 2018/11/16.
//  Copyright © 2018 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SectionFooterView : UICollectionReusableView

@property (weak, nonatomic) UILabel *textLabel;

+ (NSString *)footerId;

+ (instancetype)footerWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
