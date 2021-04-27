//
//  AppLanguage.h
//  多语言
//
//  Created by lym on 2021/4/26.
//

#import <Foundation/Foundation.h>

#define kLocalizedStr(key, tbl) \
    NSLocalizedStringFromTable(key, tbl, @"")

/// 可根据app模块划分
typedef NSString *KAppLanguageTable NS_STRING_ENUM;

FOUNDATION_EXPORT KAppLanguageTable const _Nonnull KAppLanguageTableCommon;
FOUNDATION_EXPORT KAppLanguageTable const _Nonnull KAppLanguageTableMe;


NS_ASSUME_NONNULL_BEGIN

@interface AppLanguage : NSObject

+ (instancetype)shared;

- (void)initLanguage;

/// 首选语言，如果设置了就用该语言，不设则取当前系统语言。
@property (copy, nonatomic) NSString *preferredLanguage;

/// 语言bundle，preferredLanguage变化时languageBundle会变化
/// 可通过手动设置bundle，让选择器支持新的的语言（需要在设置preferredLanguage后设置languageBundle）
@property (strong, nonatomic) NSBundle *languageBundle;

/// 当前语言
- (NSString *)currentLanguage;

@end



NS_ASSUME_NONNULL_END
