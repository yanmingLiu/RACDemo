//
//  NSString+YMString.h
//  CategoryDemo
//
//  Created by liuyanming on 17/2/28.
//  Copyright © 2017年 yons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// MD5加密
#import <CommonCrypto/CommonDigest.h>

@interface NSString (YMString)

/**
 给金钱添加千分符和.00
 @return 10,002.00
 */
+ (NSString *)positiveFormat:(NSString *)text;

/**
 调整数字最后两位数字的大小
 */
+ (NSString *)positiveFormatWithOutDot:(NSString *)text;
+ (NSMutableAttributedString *)addFontAttribute:(NSString*)string withSize:(CGFloat) size number:(NSInteger)number;

/**
 // MD5加密
 */
+ (NSString*)md5String:(NSString*)str;

/**
 获得字符串的宽高
 */
- (CGSize)sizeWithFontSize:(UIFont *)font;

#pragma mark - 验证

/**
 验证是否为空 nil NULL = YES
 */
- (BOOL)isNill;

/**
 * 验证6-16位密码,字母、数字、特殊符号两两组合
 **/
+ (BOOL)toolValidatePassword:(NSString *)password;

/**
 * 验证数字
 **/
+ (BOOL)toolValidateNumber:(NSString *)number;

/**
 * 验证邮箱
 **/
+ (BOOL)toolValidateEmail:(NSString *)email;

/**
 * 验证手机号
 **/
+ (BOOL)toolValidatePhone:(NSString *)phone;

/**
 * 验证身份证号
 **/
+ (BOOL)toolValidateIDCard:(NSString *)idCard;

/**
 通过手机号和验证码按算法生成签名 11位手机号 4位code
 */
+ (NSString *)securityCodeWithPhone:(NSString *)phone code:(NSString *)code;

/**
 验证电话号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 格式化手机号 131****1234
 */
+ (NSString *)formatPhoneNum:(NSString *)phoneNum;

/**
 处理json float double 精度丢失问题
 */
- (NSString *)decimalNumber;

@end
