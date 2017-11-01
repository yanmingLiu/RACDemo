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

    [[[YMLocationManager shareManager] autoLocationSignal] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        NSLog(@"%@", [x addressDictionary]);
        self.addressLabel.text = [x addressDictionary][@"Name"];
    }];
    
    
}



@end
