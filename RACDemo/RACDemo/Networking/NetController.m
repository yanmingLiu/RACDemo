//
//  NetController.m
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

#import "NetController.h"
#import "YMNetworkHelper.h"

@interface NetController ()

@end

@implementation NetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)get:(UIButton *)sender {
    
    [YMNetworkHelper getKeywordsResponseCache:^(id  _Nonnull responseCache) {
        
    } Success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}


- (IBAction)post:(id)sender {
    
    
}



@end
