//
//  ScrollTextView.m
//  RACDemo
//
//  Created by lym on 2020/10/20.
//

#import "ScrollTextView.h"

#define  kColor(a, b, c, d) [UIColor colorWithRed:(a) / 255. green:(b) / 255. blue:(c) / 255. alpha:(d)]

#define defaultColor kColor(81, 81, 81, 1)
#define defaultFont  [UIFont systemFontOfSize:14]

#define labelMargin  20

@interface ScrollTextView ()

@property (weak, nonatomic) UILabel *lableFirst;
@property (weak, nonatomic) UILabel *lableSecond;
@property (weak, nonatomic) UIView *containerView;

@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *titleColor;

@end

@implementation ScrollTextView

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                         tont:(UIFont *)font
                        color:(UIColor *)color
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = NO;

        [self setupChildViewFrame:frame Text:text andTitleFont:font andTitleColor:color];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self beReadyToAnimateFrame:self.bounds];
}

- (void)updateText:(NSString *)text
              font:(UIFont *)font
             color:(UIColor *)color
{
    self.titleFont = font ? font : self.titleFont;
    self.titleColor = color ? color : self.titleColor;
    _lableSecond.text = text;
    _lableFirst.text = text;

    _lableFirst.textColor = color;
    _lableSecond.textColor = color;
    _lableSecond.font = font;
    _lableFirst.font = font;
    [self layoutSubviews];
}

- (void)setupChildViewFrame:(CGRect)frame Text:(NSString *)text andTitleFont:(UIFont *)font andTitleColor:(UIColor *)color {
    self.frame = frame;

    [_containerView.layer removeAnimationForKey:@"containerView animation"];

    font = font ? font : defaultFont;
    color = color ? color : defaultColor;

    self.titleFont = font;
    self.titleColor = color;

    UIView *containerView = [[UIView alloc]initWithFrame:self.bounds];
    containerView.backgroundColor = [UIColor clearColor];
    _containerView = containerView;
    [self addSubview:containerView];

    UILabel *labelFirst = [[UILabel alloc]init];
    labelFirst.textAlignment = NSTextAlignmentCenter;
    labelFirst.font = font;
    labelFirst.textColor = color;
    labelFirst.text = text;
    _lableFirst = labelFirst;
    [_containerView addSubview:labelFirst];

    UILabel *labelSecond = [[UILabel alloc]init];
    labelSecond.textAlignment = NSTextAlignmentCenter;
    labelSecond.font = font;
    labelSecond.text = text;
    labelSecond.textColor = color;
    _lableSecond = labelSecond;
    [_containerView addSubview:labelSecond];
}

- (void)beReadyToAnimateFrame:(CGRect)frame {
    CGRect rect = [self.lableFirst.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: self.lableFirst.font } context:nil];

    if (rect.size.width <= frame.size.width) {
        _lableFirst.frame = frame;
        _lableSecond.hidden = YES;
        [_containerView.layer removeAnimationForKey:@"containerView animation"];
    } else {
        _lableSecond.hidden = NO;
        _lableFirst.frame = CGRectMake(0, 0, rect.size.width, self.frame.size.height);
        _lableSecond.frame = CGRectMake(rect.size.width + labelMargin, 0, rect.size.width, self.frame.size.height);
        [self startToAnimate];
    }
}

- (void)startToAnimate {
    //move 20pt/s
    CGFloat speed = 20.0;
    CABasicAnimation *animate = [CABasicAnimation animation];
    animate.fromValue = @(0);
    animate.beginTime = CACurrentMediaTime() + 1; //1 seconds delay
    animate.toValue = @(-self.lableFirst.frame.size.width - labelMargin);
    animate.keyPath = @"transform.translation.x";
    animate.duration = (_lableFirst.frame.size.width + labelMargin) / speed;
    animate.removedOnCompletion = YES;
    animate.repeatCount = HUGE;
    [_containerView.layer addAnimation:animate forKey:@"containerView animation"];
}

@end
