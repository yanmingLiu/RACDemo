//
//  PriceViewController.m
//  RACDemo
//
//  Created by lym on 2019/8/22.
//

#import "PriceViewController.h"
#import "NSString+YMAdd.h"

@interface PriceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *vaule1;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *labe3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;

@end

@implementation PriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *str1 = @"19.989999900000017";
    _vaule1.text = str1;
    _label1.text = [str1 ym_decimalNumber];
    _label1.textColor = [UIColor redColor];

    _label2.text = [NSString ym_formatDecimalNumber:@"10000.00"];
    _label2.textColor = [UIColor redColor];

    _labe3.attributedText = [NSString ym_priceString:@"100.00" textColor:[UIColor redColor] smallFont:[UIFont boldSystemFontOfSize:15] bigFont:[UIFont boldSystemFontOfSize:21] symbol:@"￥"];

    _label4.attributedText = [NSString ym_strikethroughString:@"100.00" textColor:[UIColor redColor] font:[UIFont boldSystemFontOfSize:15] symbol:@"￥"];

    [self test];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test];
}

- (void)test {
    double num = 12455;
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:num] decimalValue]];

    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];

    NSDecimalNumber *dm_1 = [NSDecimalNumber decimalNumberWithString:@"1"];
    NSDecimalNumber *dm_1000 = [NSDecimalNumber decimalNumberWithString:@"1000"];
    NSDecimalNumber *dm_1000000 = [NSDecimalNumber decimalNumberWithString:@"1000000"];

    NSString *s;
    if (num < 1000) {
        s = [[num1 decimalNumberByDividingBy:dm_1 withBehavior:handel] stringValue];
    } else if (num >= 1000 && num < 1000000) {
        NSString *res = [[num1 decimalNumberByDividingBy:dm_1000 withBehavior:handel] stringValue];
        s = [NSString stringWithFormat:@"%@ k", res];
    } else if (num > 1000000) {
        NSString *res = [[num1 decimalNumberByDividingBy:dm_1000000 withBehavior:handel] stringValue];
        s = [NSString stringWithFormat:@"%@ M", res];
    }

    _label5.text = s;
    NSLog(@"%@", s);
}

@end
