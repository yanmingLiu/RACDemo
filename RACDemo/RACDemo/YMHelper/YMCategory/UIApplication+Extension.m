
#import "UIApplication+Extension.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "YMMacro.h"

@implementation UIApplication (Extension)

- (void)callPhone:(NSString *)phone
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    if (carrier.isoCountryCode) {
        NSString *urlStr = [NSString stringWithFormat:@"tel://%@", phone];
        
        dispatch_main_async_safe(^{
            [self openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:^(BOOL success) {

            }];
        });
    } else {
        NSLog(@"该手机未安装SIM卡");
    }
}

@end
