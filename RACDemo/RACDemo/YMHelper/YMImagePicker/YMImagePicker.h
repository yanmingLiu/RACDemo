//
//  YMImagePicker.h
//  takePhoto
//
//  Created by lym on 2019/7/1.
//  Copyright © 2019 lym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
//#import <UIKit/UIImagePickerController.h>
#import <Photos/Photos.h>


NS_ASSUME_NONNULL_BEGIN

#define YMImagePicker_Image_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_YMImagePicker/image/"]


typedef NS_ENUM(NSUInteger, YMImagePickerType) {
    YMImagePickerTypeSelectPhoto, // 选择相片
    YMImagePickerTypeTakePicture, // 拍照
    YMImagePickerTypeTakeVideo,   // 拍视频
};


@interface YMImagePicker : NSObject  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController * picker;

@property (nonatomic, assign) YMImagePickerType type;

@property (nonatomic, copy) void(^callback)(BOOL isVideo, NSString * _Nullable path, UIImage * _Nullable image);

- (void)actionFromController:(UIViewController *)controller;

@end


NS_ASSUME_NONNULL_END
