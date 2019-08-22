//
//  PriceViewController.m
//  RACDemo
//
//  Created by lym on 2019/8/22.
//

#import "PriceViewController.h"
#import "NSString+YMAdd.h"

@interface PriceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *labe3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@end

@implementation PriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _label1.text = [@"3.9999999" ym_decimalNumber];
    _label1.textColor = [UIColor redColor];

    _label2.text = [NSString ym_formatDecimalNumber:@"10000.00"];
    _label2.textColor = [UIColor redColor];

    _labe3.attributedText = [NSString ym_priceString:@"100.00" textColor:[UIColor redColor] smallFont:[UIFont boldSystemFontOfSize:15] bigFont:[UIFont boldSystemFontOfSize:21] symbol:@"￥"];

    _label4.attributedText = [NSString ym_strikethroughString:@"100.00" textColor:[UIColor redColor] font:[UIFont boldSystemFontOfSize:15] symbol:@"￥"];


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
