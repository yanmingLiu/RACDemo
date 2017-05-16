//
//  YMUploadParam.h
//  YKXB
//
//  Created by 刘彦铭 on 2017/5/16.
//  Copyright © 2017年 YouKeXue. All rights reserved.
//  图片上传参数模型

#import <Foundation/Foundation.h>
// MD5加密
#import <CommonCrypto/CommonDigest.h>

@interface YMUploadParam : NSObject

/**
 *  上传文件的二进制数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  上传的参数名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  上传到服务器的文件名称
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  上传文件的类型
 */
@property (nonatomic, copy) NSString *mimeType;

@end
