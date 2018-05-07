//
//  LoactionViewController.m
//  RACDemo
//
//  Created by lym on 2017/11/1.
//

#import "LoactionViewController.h"

#import "YMLocationManager.h"


@interface LoactionViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;



@end

@implementation LoactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addressLabel.text = @"定位中";

    [[YMLocationManager shareManager].autoLocationSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        NSLog(@"%@", [x addressDictionary]);
        CLPlacemark *place = (CLPlacemark *)x;
        CLLocation *location = place.location;
        NSLog(@"%@--%@",place.name,[x addressDictionary][@"FormattedAddressLines"]);
        NSLog(@"经纬度：%f---%f", location.coordinate.latitude, location.coordinate.longitude);
        self.addressLabel.text = [x addressDictionary][@"Name"];
    }];
    
    
    [[[YMLocationManager shareManager] geocodeSignal:@"四川省成都市武侯区晋阳路五大花园"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", [x addressDictionary]);
        CLPlacemark *firstPlacemark = (CLPlacemark *)x;
        
        CLLocation *location =  firstPlacemark.location;
        NSLog(@"Longitude = %f", location.coordinate.longitude);  
        NSLog(@"Latitude = %f", location.coordinate.latitude);  
        NSLog(@"loction = %@", location);
    }];
    
}



@end
