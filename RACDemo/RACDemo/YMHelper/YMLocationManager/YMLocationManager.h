//
//  YMLocationManager.h
//  RACDemo
//
//  Created by lym on 2017/11/1.
//  RAC-CLLocationManager 定位功能

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ReactiveObjC.h"

@interface YMLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * manager;

@property (nonatomic, strong) CLGeocoder * geocoder; 

+ (YMLocationManager *)shareManager;

/// 自动定位到当前位置
- (RACSignal *)autoLocationSignal;

@end
