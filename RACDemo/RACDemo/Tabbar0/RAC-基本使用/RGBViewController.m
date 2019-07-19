//
//  RGBViewController.m
//  RACDemo
//
//  Created by lym on 2017/10/28.
//

#import "RGBViewController.h"
#import "ReactiveObjC.h"

@interface RGBViewController ()

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

@property (weak, nonatomic) IBOutlet UITextField *redTextField;
@property (weak, nonatomic) IBOutlet UITextField *greenTextField;
@property (weak, nonatomic) IBOutlet UITextField *blueTextField;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation RGBViewController

- (instancetype)init
{
    return ViewControllerFromSB(@"Main", @"RGBViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    RACSignal *redSignal = [self blindSlider:self.redSlider textField:self.redTextField];
    RACSignal *greenSignal = [self blindSlider:self.greenSlider textField:self.greenTextField];
    RACSignal *blueSignal = [self blindSlider:self.blueSlider textField:self.blueTextField];
    
    RACSignal *resultSignal = [[RACSignal combineLatest:@[redSignal,greenSignal,blueSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] 
                               green:[value[1] floatValue]
                               blue:[value[2] floatValue]
                               alpha:1];
    }];
    
    RAC(self.bgView, backgroundColor) = resultSignal;
    
}

/// 绑定信号
- (RACSignal *)blindSlider:(UISlider *)slider textField:(UITextField *)textField {
    
    // 只订阅一次，确保第一的时候监听到所有的signal
    RACSignal *textSignal = [[textField rac_textSignal] take:1];
    
    RACChannelTerminal *sliderSignal = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *textFieldSignal = [textField rac_newTextChannel];
    
    [textFieldSignal subscribe:sliderSignal];
    [[sliderSignal map:^id (id value) {
        return [NSString stringWithFormat:@"%.2f", [value floatValue]];
    }] subscribe:textFieldSignal];
    
    return [[sliderSignal merge:textFieldSignal] merge:textSignal];
    
}





@end
