
#import "UIApplication+Extension.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation UIApplication (Extension)

- (void)callPhone:(NSString *)phone
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    if (carrier.isoCountryCode) {
        NSString *urlStr = [NSString stringWithFormat:@"tel://%@", phone];
        if ([UIDevice currentDevice].systemVersion.floatValue > 10.0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            });
        }else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self openURL:[NSURL URLWithString:urlStr]];
            });
        }
    } else {
        [MBProgressHUD bwm_showTitle:@"该手机未安装SIM卡" toView:[UIApplication sharedApplication].keyWindow hideAfter:MBHiddenTime];
    }
}

@end
