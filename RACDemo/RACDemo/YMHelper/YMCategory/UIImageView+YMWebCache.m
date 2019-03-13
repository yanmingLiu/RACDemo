//
//  UIImageView+YMWebCache.h
//  YMTextView
//
//  Created by yons on 15/2/13.
//  Copyright © 2015年 lym. All rights reserved.
//

#import "UIImageView+YMWebCache.h"

#import "UIImageView+WebCache.h"

#import "UIImage+YMImg.h"

@implementation UIImageView (YMWebCache)

- (void)setCircleimageViewWithURL:(NSString *)imageUrl placeholderImage:(NSString *)placeholderImage {
    
//    //占位图片，当URL上下载的图片为空，就显示该图片
//    
//    UIImage *placeholder = [[UIImage imageNamed:placeholderImage] circleImageWithSize:self.bounds.size];
//    
//    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//        self.image = image ? [image circleImageWithSize:self.bounds.size] : placeholder;
//    }];
    
    [self setCircleimageViewWithURL:imageUrl placeholderImage:placeholderImage borderColor:nil borderWidth:0];
}

- (void)setCircleimageViewWithURL:(NSString *)imageUrl placeholderImage:(NSString *)placeholderImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    
    UIImage *placeholder = [[UIImage imageNamed:placeholderImage] circleImageWithSize:self.bounds.size borderColor:borderColor borderWidth:borderWidth];
    
    NSString *url = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [image cornerImageWithSize:self.bounds.size fillColor:borderColor completion:^(UIImage *image) {
                self.image = image; 
            }];
        }
        else {
            self.image = placeholder;
        }
    }];
    
}

@end
