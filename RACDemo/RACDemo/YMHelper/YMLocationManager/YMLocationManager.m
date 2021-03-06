//
//  YMLocationManager.m
//  RACDemo
//
//  Created by lym on 2017/11/1.
//

#import "YMLocationManager.h"

@implementation YMLocationManager

#pragma mark - lzay

- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


static id _instance;

+ (YMLocationManager *)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


/// 定位
- (RACSignal *)autoLocationSignal {
    
#if TARGET_IPHONE_SIMULATOR  //模拟器
    NSLog(@"模拟器不使用定位");
    return [RACSignal empty];

#elif TARGET_OS_IPHONE      //真机
    return [[[self authorizationSignal] filter:^BOOL(id  _Nullable value) {
        return [value boolValue];
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [[[[[[[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(RACTuple * _Nullable value) {
            return value[1];
        }] merge:[[self rac_signalForSelector:@selector(locationManager:didFailWithError:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(RACTuple * _Nullable value) {
            return [RACSignal error:value[1]];
        }]] take:1] initially:^{  // initially是信号量开始时候调用的block，
            [self.manager startUpdatingLocation];
        }]  finally:^{ // finally则是信号量结束了调用的block。
            [self.manager stopUpdatingLocation];
        }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {

            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

                CLLocation *c = [value firstObject];
                [self.geocoder reverseGeocodeLocation:c completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                    if (error) {
                        [subscriber sendError:error];
                    }
                    else {
                        [subscriber sendNext:[placemarks firstObject]];
                        [subscriber sendCompleted];
                    }
                }];
                return [RACDisposable disposableWithBlock:^{
                }];
            }];
        }];
    }];

#endif
}

/// 根据地址得到经纬度
- (RACSignal *)geocodeSignal:(NSString *)address {
    return [[[self authorizationSignal] filter:^BOOL(id  _Nullable value) {
        return [value boolValue];
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (error) {
                    [subscriber sendError:error];
                }
                else {
                    if ([placemarks count] > 0) {  
                        [subscriber sendNext:[placemarks firstObject]];
                    } 
                    [subscriber sendCompleted];
                }
            }];
            return [RACDisposable disposableWithBlock:^{
            }];
        }]; 
        
    }];
}

/// 认证信号-是否授权位置访问
- (RACSignal *)authorizationSignal {

    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestAlwaysAuthorization];
        
        return [[self rac_signalForSelector:@selector(locationManager:didChangeAuthorizationStatus:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(RACTuple * _Nullable value) {
            NSInteger authState = [value[1] integerValue];
            return @(authState == kCLAuthorizationStatusAuthorizedAlways || authState == kCLAuthorizationStatusAuthorizedWhenInUse);
        }];    
    }
    return [RACSignal return:@([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)];
}

/*
    // 定位服务授权状态是用户没有决定是否使用定位服务。
    kCLAuthorizationStatusNotDetermined = 0, 
    
    //定位服务授权状态是受限制的。可能是由于活动限制定位服务，用户不能改变。这个状态可能不是用户拒绝的定位服务。
    kCLAuthorizationStatusRestricted,  
    
    // 被用户明确禁止，或者在设置里的定位服务中关闭。
    kCLAuthorizationStatusDenied,
    
    // 已经被用户允许在任何状态下获取位置信息。包括监测区域、访问区域、或者在有显著的位置变化的时候。
    kCLAuthorizationStatusAuthorizedAlways NS_ENUM_AVAILABLE(10_12, 8_0),
    
    // 仅被允许在使用应用程序的时候。
    kCLAuthorizationStatusAuthorizedWhenInUse NS_ENUM_AVAILABLE(NA, 8_0),

*/



@end
