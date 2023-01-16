//
//  CustomSlider.m
//  RACDemo
//
//  Created by lym on 2020/10/14.
//

#import "CustomSlider.h"

@interface CustomSlider ()

@property (nonatomic, assign) CGRect lastBounds;

@end

#define thumbBound_x 10
#define thumbBound_y 20

@implementation CustomSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self setThumbImage:[UIImage imageNamed:@"cr_slider_thumb"] forState:UIControlStateNormal];
    self.minimumValue = 0;
    self.maximumValue = 100;
    self.minimumTrackTintColor = [UIColor orangeColor];
    self.maximumTrackTintColor = [UIColor lightGrayColor];
}

// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds = [super trackRectForBounds:bounds];
    self.layer.cornerRadius = 2.5;
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 6);
}

// 改变滑块的触摸范围
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.x = rect.origin.x;
    rect.size.width = rect.size.width ;
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    self.lastBounds = result;
    return result;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *result = [super hitTest:point withEvent:event];
    if (point.x < 0 || point.x > self.bounds.size.width){
        return result;
    }
    if ((point.y >= -thumbBound_y) && (point.y < self.lastBounds.size.height + thumbBound_y)) {
        float value = 0.0;
        value = point.x - self.bounds.origin.x;
        value = value/self.bounds.size.width;

        value = value < 0? 0 : value;
        value = value > 1? 1: value;

        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
        [self setValue:value animated:YES];
    }
    return result;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    if (!result && point.y > -10) {
        if ((point.x >= self.lastBounds.origin.x - thumbBound_x) && (point.x <= (self.lastBounds.origin.x + self.lastBounds.size.width + thumbBound_x)) && (point.y < (self.lastBounds.size.height + thumbBound_y))) {
            result = YES;
        }
    }
    return result;
}
@end
