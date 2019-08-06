
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (YMAdd)

/// 随机字符串
+ (NSString *)ym_randomStringWithLength:(NSInteger)len;

/// 验证是否为空 nil NULL = YES
+ (BOOL)ym_checkNillString:(NSString *)str;

/// 格式化手机号 131****1234
+ (NSString *)ym_formatPhone:(NSString *)phone;

/// 验证邮箱
+ (BOOL)ym_checkEmail:(NSString *)email;

///以字母开头，只能包含“字母”，“数字”，“下划线”，长度6~18
+ (BOOL)ym_checkPassword:(NSString *)password;

///  验证电话号码
+ (BOOL)ym_checkMobileNum:(NSString *)mobileNum;

///  身份证号码(数字、字母x结尾) 18位
+ (BOOL)ym_checkIDCard:(NSString *)idCard;


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

/// 正则匹配
+ (BOOL)ym_predicateWithFormat:(NSString *)fm str:(NSString *)str;


#pragma makr ----

/// 验证手机号
+ (BOOL)ym_checkPhone:(NSString *)phone;

/// 格式化银行卡号
+ (NSString *)ym_formatBankNumber:(NSString *)number;

/// 是否是url
+ (BOOL)ym_checkUrl:(NSString *)urlStr;

#pragma makr ----

/// 编码url
- (NSURL *)ym_encodingForURL;

/// 获得字符串的宽高
- (CGSize)ym_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

/// 去掉首尾空格
- (instancetype)ym_deleteHeaderFooterSpace;

#pragma makr - 金钱显示
/// 处理json float double 精度丢失问题
- (NSString *)ym_decimalNumber;

/// 金钱显示
- (NSString *)ym_formatDecimalNumber:(NSString *)string;

@end
