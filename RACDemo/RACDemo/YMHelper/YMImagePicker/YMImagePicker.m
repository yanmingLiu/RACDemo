//
//  YMImagePicker.m
//  takePhoto
//
//  Created by lym on 2019/7/1.
//  Copyright © 2019 lym. All rights reserved.
//

#import "YMImagePicker.h"

@interface YMImagePicker ()

@property RACSubject *sendMediaSignal;

@end

@implementation YMImagePicker


- (instancetype)init {
    self = [super init];
    if (self) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;

        @weakify(self)
        _sendMediaSignal = [RACSubject subject];
        [[_sendMediaSignal throttle:1] subscribeNext:^(NSDictionary *info) {
            @strongify(self)
            NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

            if([mediaType isEqualToString:(NSString *)kUTTypeImage]) {

                UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                UIImageOrientation imageOrientation =  image.imageOrientation;

                NSString *imagePath = [info objectForKey:UIImagePickerControllerImageURL];
                NSLog(@"imagePath---%@",imagePath);

                if (imagePath) { // 选相片
                    !self.callback ? : self.callback(NO, imagePath, image);
                }
                else { // 拍照
                    if(imageOrientation != UIImageOrientationUp)
                        {
                        CGFloat aspectRatio = MIN ( 1920 / image.size.width, 1920 / image.size.height );
                        CGFloat aspectWidth = image.size.width * aspectRatio;
                        CGFloat aspectHeight = image.size.height * aspectRatio;

                        UIGraphicsBeginImageContext(CGSizeMake(aspectWidth, aspectHeight));
                        [image drawInRect:CGRectMake(0, 0, aspectWidth, aspectHeight)];
                        image = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        }

                    [self sendImageMessage:image];
                }
            }
            else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
                NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
                [self sendVideoMessage:url];
            }
        }];

    }
    return self;
}



- (void)actionFromController:(UIViewController *)controller {
    [controller presentViewController:self.picker animated:YES completion:nil];
}

- (void)sendImageMessage:(UIImage *)image;
{
    // 存沙盒
    /*
    NSData *data = UIImageJPEGRepresentation(image, 0.75);
    NSString *uuid = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *name = [NSString stringWithFormat:@"image_%u_%@", arc4random_uniform(255),uuid];
    NSString *path = [YMImagePicker_Image_Path stringByAppendingString:name];
    [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
     */

    // 存相册
    [self saveToPhotoLibrary:image completed:^(NSString * _Nullable imagePath) {
        !self.callback ? : self.callback(NO, imagePath, image);
    }];
}


- (void)sendVideoMessage:(NSURL *)url
{
    NSString * urlStr = [url path];
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
        //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
        UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}


// 保存图片到相册
- (void)saveToPhotoLibrary:(UIImage *)image completed:(void(^)( NSString * _Nullable imagePath))completed {

    // 1. 获取当前App的相册授权状态
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    // 2. 判断授权状态
    if (authorizationStatus == PHAuthorizationStatusAuthorized) {

        __block NSString *createdAssetId = nil;

        // 添加图片到【相机胶卷】
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        } error:nil];

        if (createdAssetId == nil) {
            !completed ? : completed(nil);
        }

        // 在保存完毕后取出图片信息
        PHFetchResult * result = [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
        PHAsset *asset = [result firstObject];

        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            NSString *fileName = [obj valueForKey:@"filename"];
            NSLog(@"%@", fileName); // 能得到名字 IMG_3301.JPG
        }];

        [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {

            NSLog(@"URL: %@",  contentEditingInput.fullSizeImageURL.absoluteString);
            NSString* path = [contentEditingInput.fullSizeImageURL.absoluteString substringFromIndex:7];//screw all the crap of file://
            NSLog(@"path: %@", path);
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL isExist = [fileManager fileExistsAtPath:path];
            if (isExist) {
                NSLog(@"oh yeah");
                !completed ? : completed(path);
            }
            else {
                NSLog(@"damn");
                !completed ? : completed(nil);
            }
        }];

    }
    else if (authorizationStatus == PHAuthorizationStatusNotDetermined) { // 如果没决定, 弹出指示框, 让用户选择
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // 如果用户选择授权, 则保存图片
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveToPhotoLibrary:image completed:completed];
            }
        }];
    } else {
        NSLog(@"请在设置界面, 授权访问相册");
        completed(nil);
    }
}


- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
        !self.callback ? : self.callback(YES, nil, nil);
    } else {
        NSLog(@"视频保存成功");
        //录制完后自动播放
        NSURL * url = [NSURL fileURLWithPath:videoPath];
        NSLog(@"%@", url);
        !self.callback ? : self.callback(YES, videoPath, nil);
    }
}



// MARK: - setter

- (void)setType:(YMImagePickerType)type {
    _type = type;

    switch (type) {
        case YMImagePickerTypeSelectPhoto: {
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        }
            
        case YMImagePickerTypeTakePicture: {
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            break;
        }

        case YMImagePickerTypeTakeVideo: {
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            _picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModeVideo;
            _picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            [_picker setVideoMaximumDuration:15];
            break;
        }

        default:
            break;
    }
}

// MARK: - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 快速点的时候会回调多次
    [_sendMediaSignal sendNext:info];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
