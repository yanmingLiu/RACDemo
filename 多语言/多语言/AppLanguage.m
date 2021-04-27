//
//  AppLanguage.m
//  多语言
//
//  Created by lym on 2021/4/26.
//

#import "AppLanguage.h"
#import "NSBundle+Language.h"

NSString * const KAppLanguageTableCommon = @"Localizable";
NSString * const KAppLanguageTableMe = @"Me";

// 缓存key
static NSString * const AppLanguageKey = @"AppLanguageKey";

@implementation AppLanguage

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static AppLanguage *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[AppLanguage alloc] init];
    });
    return instance;
}

- (void)initLanguage {
    NSString *language = [self currentLanguage];
    if (language.length) {
        self.preferredLanguage = language;
    }else{
        self.preferredLanguage = [NSLocale preferredLanguages].firstObject;
    }
}
 
- (NSString *)currentLanguage
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:AppLanguageKey];
}
 
- (void)saveLanguage:(NSString *)language {
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:AppLanguageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
 
- (void)setPreferredLanguage:(NSString *)preferredLanguage {
    _preferredLanguage = preferredLanguage;
    
    if (!preferredLanguage || !preferredLanguage.length) {
        preferredLanguage = [NSLocale preferredLanguages].firstObject;
    }
    if ([preferredLanguage rangeOfString:@"zh-Hans"].location != NSNotFound) {
        preferredLanguage = @"zh-Hans";
        
    } else if ([preferredLanguage rangeOfString:@"zh-Hant"].location != NSNotFound) {
        preferredLanguage = @"zh-Hant";
        
    } else if ([preferredLanguage rangeOfString:@"en"].location != NSNotFound) {
        preferredLanguage = @"en";
        
    } else if ([preferredLanguage rangeOfString:@"ko"].location != NSNotFound) {
        preferredLanguage = @"ko";
        
    } else if ([preferredLanguage rangeOfString:@"ja"].location != NSNotFound) {
        preferredLanguage = @"ja";

    } else if ([preferredLanguage rangeOfString:@"ar"].location != NSNotFound) {
        preferredLanguage = @"ar";
        
    }else {
        preferredLanguage = @"en";
    }
    
    _languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:preferredLanguage ofType:@"lproj"]];
    
    [NSBundle setLanguage:preferredLanguage];
    
    [self saveLanguage:preferredLanguage];

    NSLog(@"设置语言:%@",preferredLanguage);
    NSLog(@"设置语言_languageBundle:%@",_languageBundle);
}


@end
