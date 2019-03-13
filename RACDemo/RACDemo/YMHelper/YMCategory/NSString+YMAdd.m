
#import "NSString+YMAdd.h"

@implementation NSString (YMAdd)

/// 随机字符串
+ (NSString *)ym_randomStringWithLength:(NSInteger)len {
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:len];
    for (int i = 0; i < len; i++)
        {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
        }
    return result;
}


/// 验证是否为空 nil NULL = YES
+ (BOOL)ym_checkNillString:(NSString *)str {
    if (!str)   return YES;
    if (!str.length) return YES;
    if ([str isKindOfClass:[NSNull class]])  return YES;
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [str stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) return YES;
    return NO;
}

/// 验证手机号
+ (BOOL)ym_checkPhone:(NSString *)phone {
    NSString * regex = @"^[1][3-8]\\d{9}$";
    return [self ym_predicateWithFormat:regex str:phone];
}

/// 验证邮箱
+ (BOOL)ym_checkEmail:(NSString *)email {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self ym_predicateWithFormat:regex str:email];
}

///以字母开头，只能包含“字母”，“数字”，“下划线”，长度6~18
+ (BOOL)ym_checkPassword:(NSString *)password {
    NSString *regex = @"^([a-zA-Z]|[a-zA-Z0-9_]|[0-9]){6,18}$";
    return [self ym_predicateWithFormat:regex str:password];
}

///  验证电话号码
+ (BOOL)ym_checkMobileNum:(NSString *)mobileNum {
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\\\d|705)\\\\d{7}$";
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\\\d|709)\\\\d{7}$";
    NSString * CT = @"^1((33|53|8[09])\\\\d|349|700)\\\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\\\d{3})\\\\d{7,8}$";

    if (([self ym_predicateWithFormat:CM str:mobileNum])
        || ([self ym_predicateWithFormat:CU str:mobileNum] )
        || ([self ym_predicateWithFormat:CT str:mobileNum])
        || ([self ym_predicateWithFormat:PHS str:mobileNum])) {
        return YES;
    }else {
        return NO;
    }
}

///  身份证号码(数字、字母x结尾) 18位
+ (BOOL)ym_checkIDCard:(NSString *)idCard {
    NSString * regex = @"^((\\d{18})|([0-9x]{18})|([0-9X]{18}))$";
    return [self ym_predicateWithFormat:regex str:idCard];
}

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
+ (BOOL)ym_checkStr:(NSString *)str
           minLenth:(NSInteger)minLenth
           maxLenth:(NSInteger)maxLenth
     containChinese:(BOOL)containChinese
      containDigtal:(BOOL)containDigtal
      containLetter:(BOOL)containLetter
containOtherCharacter:(NSString *)containOtherCharacter
firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;
{
    NSString *hanzi = containChinese ? @"\\u4e00-\\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? @"(?=(.*\\\\d.*){1})" : @"";
    NSString *letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];

    return [self ym_predicateWithFormat:regex str:str];
}

/// 正则匹配
+ (BOOL)ym_predicateWithFormat:(NSString *)fm str:(NSString *)str {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", fm];
    BOOL flag = [predicate evaluateWithObject:str];
    return flag;
}

#pragma makr ----

/// 格式化手机号 131****1234
+ (NSString *)ym_formatPhone:(NSString *)phone {
    if (phone.length != 11) return @"";
    NSString *numberString = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return numberString;
}

/// 格式化银行卡号
+ (NSString *)ym_formatBankNumber:(NSString *)number {
    if ([NSString ym_checkNillString:number]) {
        return @"";
    }
    if (number.length > 6) {
        NSInteger length = number.length - 6;
        NSRange rage = NSMakeRange(3, length);

        NSMutableString *replaceStr = [[NSMutableString alloc] initWithString:@"*"];
        for (int i = 0; i < length; i++) {
            [replaceStr appendString:@"*"];
        }

        NSString *numberString = [number stringByReplacingCharactersInRange:rage withString:replaceStr];
        return numberString;
    }
    return number;
}


#pragma makr ----

/// 编码url
- (NSURL *)ym_encodingForURL {
    NSURL *url = [NSURL URLWithString:[self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    return url;
}

/// 获得字符串的宽高 
- (CGSize)ym_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    CGSize size = CGSizeMake(maxWidth, MAXFLOAT);

    NSDictionary *attributeDic = @{NSFontAttributeName: font};
    CGRect frame = [self boundingRectWithSize:size
                                      options: NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributeDic
                                      context:nil];
    return frame.size;
}

/// 去掉首尾空格
- (instancetype)ym_deleteHeaderFooterSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma makr - 金钱显示

/// 处理json float double 精度丢失问题
- (NSString *)ym_decimalNumber {
    NSString *doubleString  = [NSString stringWithFormat:@"%f", self.doubleValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

/// 金钱显示
- (NSString *)ym_formatDecimalNumber:(NSString *)string {
    if (!string || string.length == 0) {
        return string;
    }

    NSNumber *number = @([string doubleValue]);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.positiveFormat = @"###,##0.00";

    NSString *amountString = [formatter stringFromNumber:number];
    return amountString;
}
@end
