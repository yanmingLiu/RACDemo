//
//  NSString+YMString.m
//  CategoryDemo
//
//  Created by liuyanming on 17/2/28.
//  Copyright © 2017年 yons. All rights reserved.
//

#import "NSString+YMString.h"
#import "sys/sysctl.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (YMString)

+ (NSString *)positiveFormat:(NSString *)text{
    if(!text || [text floatValue] == 0){
        return @"0.00";
    }
    if (text.floatValue < 1000) {
        return  [NSString stringWithFormat:@"%.2f",text.floatValue];
    };
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###.00;"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
}


+ (NSString *)positiveFormatWithOutDot:(NSString *)text{
    if(!text || [text floatValue] == 0){
        return @"0";
    }
    if ( text.floatValue > -1000 && text.floatValue < 1000) {
        return  [NSString stringWithFormat:@"%.f",text.floatValue];
    };
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###;"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
}

/**
 调整数字最后两位数字的大小
 
 @param string 要修改的字符串
 @param size   修改字体大小
 */
+ (NSMutableAttributedString *)addFontAttribute:(NSString*)string withSize:(CGFloat) size number:(NSInteger)number{
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:string];
    [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size]range:NSMakeRange(string.length-number,number)];
    return aString;
}

/**
 * MD5
 **/
+ (NSString*)md5String:(NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    // 先转MD5，再转大写
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 获得字符串的宽高
 */
- (CGSize)sizeWithFontSize:(UIFont *)font;
{
    //1,设置内容大小  其中高度一定要与item一致,宽度度尽量设置大值
    CGSize size = CGSizeMake(375, 44);
    //2,设置计算方式
    //3,设置字体大小属性   字体大小必须要与label设置的字体大小一致
    NSDictionary *attributeDic = @{NSFontAttributeName: font};
    CGRect frame = [self boundingRectWithSize:size 
                                      options: NSStringDrawingUsesLineFragmentOrigin 
                                   attributes:attributeDic 
                                      context:nil];
    
    return frame.size;
    //return [self sizeWithAttributes:@{NSFontAttributeName: font}];
}

#pragma mark - 验证

/// 验证是否为空 nil NULL = YES
- (BOOL)isNill {
    if (!self) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!self.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [self stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

/**
 * 验证6-16位密码,字母、数字、特殊符号(@_#&)两两组合
 **/
+ (BOOL)toolValidatePassword:(NSString *)password
{
    NSString *passWordRegex = @"^((?=.*\\d)(?=.*[a-zA-Z])|(?=.*\\d)(?=.*[_@#!])|(?=.*[_@#!])(?=.*[a-zA-Z]))[\\da-zA-Z_@#!]{6,16}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    return [passWordPredicate evaluateWithObject:password];
}

/**
 * 验证数字
 **/
+ (BOOL)toolValidateNumber:(NSString *)number
{
    NSString *passWordRegex = @"^[0-9]*$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    return [passWordPredicate evaluateWithObject:number];
}

/**
 * 验证邮箱
 **/
+ (BOOL)toolValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 * 验证手机号
 **/
+ (BOOL)toolValidatePhone:(NSString *)phone
{
    
    NSString * tel = @"^[1][3-8]\\d{9}$";
    NSPredicate *phonepredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",tel];
    return [phonepredicate evaluateWithObject:phone];
}

/**
 * 验证身份证号
 **/
+ (BOOL)toolValidateIDCard:(NSString *)idCard
{
    NSString * reg = @"^(\\d{6})(18|19|20)?(\\d{2})([01]\\d)([0123]\\d)(\\d{3})(\\d|X|x)?$";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [predicate evaluateWithObject:idCard];
}

/**
 格式化手机号 131****1234
 */
+ (NSString *)formatPhoneNum:(NSString *)phoneNum {
    if (phoneNum.length != 11) {
        return @"";
    }
    NSString *numberString = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return numberString;
}


+ (NSString *)securityCodeWithPhone:(NSString *)phone code:(NSString *)code {
    
    if (phone.length != 11 && code.length != 4) {
        return @"";
    }
    
    NSString *temp = nil;
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    NSMutableArray *arr3 = [NSMutableArray array];
    NSMutableArray *arr4 = [NSMutableArray array];
    
    for(int i =0; i < [phone length]; i++)
    {
        temp = [phone substringWithRange:NSMakeRange(i, 1)];
        //NSLog(@"第%d个字是:%@",i,temp);
        if (i<3) {
            [arr1 addObject:temp];
        }
        else if (i>=3 && i<6) {
            [arr2 addObject:temp];
        }else if (i>=6 && i<9)  {
            [arr3 addObject:temp];
        }else {
            [arr4 addObject:temp];
        }
    }
    //NSLog(@"%@--%@--%@--%@", arr1,arr2,arr3,arr4);
    
    // 倒叙数组
    arr1 = (NSMutableArray *)[[arr1 reverseObjectEnumerator] allObjects];
    arr2 = (NSMutableArray *)[[arr2 reverseObjectEnumerator] allObjects];
    arr3 = (NSMutableArray *)[[arr3 reverseObjectEnumerator] allObjects];
    arr4 = (NSMutableArray *)[[arr4 reverseObjectEnumerator] allObjects];
    
    //NSLog(@"%@--%@--%@--%@", arr1,arr2,arr3,arr4);
    
    NSString *tempCode = @"";
    for(int i = 0; i < [code length]; i++)
    {
        tempCode = [code substringWithRange:NSMakeRange(i, 1)];
        //NSLog(@"第%d个字是:%@",i,tempCode);
        if (i == 0) {
            [arr1 addObject:tempCode];
        }
        else if (i == 1) {
            [arr2 addObject:tempCode];
        }else if (i == 2)  {
            [arr3 addObject:tempCode];
        }else {
            [arr4 addObject:tempCode];
        }
    }
    //NSLog(@"%@--%@--%@--%@", arr1,arr2,arr3,arr4);
    
    // 数组转字符串
    NSString *str1 = [arr1 componentsJoinedByString:@""];
    NSString *str2 = [arr2 componentsJoinedByString:@""];
    NSString *str3 = [arr3 componentsJoinedByString:@""];
    NSString *str4 = [arr4 componentsJoinedByString:@""];
    
    NSString *str5 = [[[str1 stringByAppendingString:str2] stringByAppendingString:str3] stringByAppendingString:str4];
    
    NSString *str6 = [@"1" stringByAppendingString:str5];
    
    //NSLog(@"%@", resultStr);
    
    // 计算
    NSInteger one = [str6 integerValue];
    NSInteger two = pow([code integerValue], 2); // code平方
    NSInteger three = one - two;
    
    //NSLog(@"%ld", three);
    NSString *resultStr = [NSString stringWithFormat:@"%ld", three];
    //NSLog(@"%@", resultStr);
    
    return resultStr;
}


/**
 验证电话号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /*
    固定电话+手机号码正则表达式
    区号+座机号码+分机号码：regexp="^(0[0-9]{2,3}/-)?([2-9][0-9]{6,7})+(/-[0-9]{1,4})?$"
    
    手机(中国移动手机号码)：regexp="^((/(/d{3}/))|(/d{3}/-))?13[456789]/d{8}|15[89]/d{8}"
    
    所有手机号码：regexp="^((/(/d{3}/))|(/d{3}/-))?13[0-9]/d{8}|15[89]/d{8}"(新添加了158,159两个号段)
     
    ((/d{11})|^((/d{7,8})|(/d{4}|/d{3})-(/d{7,8})|(/d{4}|/d{3})-(/d{7,8})-(/d{4}|/d{3}|/d{2}|/d{1})|(/d{7,8})-(/d{4}|/d{3}|/d{2}|/d{1}))$)
    
     */
    
    NSString * tel = @"^(0?(13[0-9]|15[012356789]|17[013678]|18[0-9]|14[57])[0-9]{8})|(400|800)([0-9\\-]{7,10})|(([0-9]{4}|[0-9]{3})(-| )?)?([0-9]{7,8})((-| |转)*([0-9]{1,4}))?$";
//    NSString * tel = @"((/d{11})|^((/d{7,8})|(/d{4}|/d{3})-(/d{7,8})|(/d{4}|/d{3})-(/d{7,8})-(/d{4}|/d{3}|/d{2}|/d{1})|(/d{7,8})-(/d{4}|/d{3}|/d{2}|/d{1}))$)";
    NSPredicate *phonepredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",tel];
    return [phonepredicate evaluateWithObject:mobileNum];
}

/**
 处理json float double 精度丢失问题
 */
- (NSString *)decimalNumber {
    NSString *doubleString  = [NSString stringWithFormat:@"%lf", self.doubleValue]; 
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}


@end
