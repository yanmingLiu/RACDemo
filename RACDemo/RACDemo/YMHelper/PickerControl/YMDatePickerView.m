//
//  YMDatePickerView.m
//  ykxB
//
//  Created by lym on 2017/8/29.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "YMDatePickerView.h"
#import "AppDelegate.h"
#import "Defines.h"

@interface YMDatePickerView () <UIPickerViewDataSource,UIPickerViewDelegate>{
    NSArray *dataSource;
    UIView *contentView;
    void(^backBlock)(NSString *);
    NSString *restr;
    NSInteger columns;
    NSArray *columns_two_dataSource;
}

@end

@implementation YMDatePickerView

- (instancetype)initWithType:(NSInteger)type columuns:(NSInteger)col WithDataSource:(NSArray *)sources response:(void (^)(NSString *))block {
    if (self = [super init]) {
        columns = col;
        self.frame = [UIScreen mainScreen].bounds;
        [self setViewInterface];
        if (block) {
            backBlock = block;
        }
        if (sources) {
            dataSource = [sources copy];
        }
        if (type == 0) {
            [self pickerView];
        }else {
            [self dataPicker];
        }
    }
    return self;
}
#pragma mark View初始配置
- (void)setViewInterface {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tapGesture];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 250)];
    [self addSubview:contentView];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];//设置背景颜色为黑色，并有0.4的透明度
    //添加白色view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    
    // 圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = whiteView.bounds;
    maskLayer.path = maskPath.CGPath;
    whiteView.layer.mask = maskLayer;
    whiteView.clipsToBounds = YES;
    
    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 0, 60, 50)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
        [button setTitleColor:i == 0 ? RGB(102, 102, 102) : RGB(8, 179, 129) forState:UIControlStateNormal];
        [whiteView addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
    }
}
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    }else {
        backBlock(restr);
        [self dismiss];
    }
}
#pragma mark dataPicker
- (void)dataPicker{
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.bounds), 200)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    datePicker.backgroundColor = RGB(238, 238, 238);
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:datePicker];
    restr = [self changeToStringWithDate:[NSDate date]];//给一个最初值防止没滑动就直接确定
}
#pragma mark date 值改变方法
- (void)dateChange:(UIDatePicker *)datePicker {
    restr = [self changeToStringWithDate:datePicker.date];
}
- (NSString *)changeToStringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
#pragma mark pickerView
- (void)pickerView {
    for (id obj in dataSource) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            columns_two_dataSource = [dataSource[0] allValues][0];
            restr = columns_two_dataSource[0];
        }else{
            restr = dataSource[0];
        }
        break;
    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.bounds), 200)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = RGB(250, 250, 250);
    [contentView addSubview:pickerView];
}
#pragma mark 出现
- (void)show {
    [Keywindow addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y - contentView.frame.size.height);
    }];
}
#pragma mark 消失
- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y + contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark UIPickerViewDataSource UIPickerViewDelegate
//返回有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return columns;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return dataSource.count;
    }
    else {
        return columns_two_dataSource.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        if (columns_two_dataSource) {
            return [dataSource[row]allKeys][0];
        }else{
            return dataSource[row];
        }
        
    }else {
        return columns_two_dataSource[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        if (columns_two_dataSource) {
            columns_two_dataSource = [dataSource[row] allValues][0];
            restr = columns_two_dataSource[0];
            [pickerView reloadComponent:1];
        }else{
            restr = dataSource[row];
        }
        
    }else {
        restr = columns_two_dataSource[row];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
