//
//  YMBottomPopView.m
//  ykxB
//
//  Created by lym on 2017/11/21.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

//#define kShareItemNum 4

#define kBtnW 100
#define kBtnH 100
#define kMarginX 15
#define kMarginY 15
#define kFirst 20

#define kTitlePrecent 0.4
#define kImageViewWH 60


#import "YMBottomPopView.h"
#import "YMMacro.h"

static CGFloat titleH = 80;

@interface YMBottomPopView ()

@property (nonatomic, strong) NSArray *sharItems;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, copy) void(^btnBlock)(NSInteger tag, NSString *title);

@property (nonatomic, assign) CGFloat btnViewH;


@end

@implementation YMBottomPopView

- (void)showItems:(NSArray *)items title:(NSString *)title tips:(NSString *)tips  rowCount:(NSInteger)rowCount selectedHandle:(selectItemBlock)selectedHandle {
    if (items == nil || items.count < 1) return;
    self.backgroundColor = [UIColor whiteColor];
    [self addBackgroundView:KeyWindow];
    
    // 标题
    if (title.length) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFirst, 0, kScreenWidth-kFirst*2, titleH)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = FONT(14);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    
    // 按钮
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = obj[@"name"];
        NSString *icon = obj[@"icon"];
        JWShareItemButton *btn = [JWShareItemButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx;
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat marginX = (self.frame.size.width - rowCount * kBtnW) / (rowCount + 1);
        NSInteger col = idx % rowCount;
        NSInteger row = idx / rowCount;
        CGFloat btnX = marginX + (marginX + kBtnW) * col;
        CGFloat btnY = kFirst + (kMarginY + kBtnH) * row;
        
        if (title.length) {
            btnY += titleH;
        }
        btn.frame = CGRectMake(btnX, btnY, kBtnW, kBtnH);
        self.btnViewH = btnY + kBtnH;
        [self addSubview:btn];
    }];
    
    if (tips.length) {
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFirst*2, self.btnViewH, kScreenWidth-kFirst*4, titleH)];
        tipsLabel.text = title;
        tipsLabel.numberOfLines = 2;
        tipsLabel.textColor = RGB(204, 204, 204);
        tipsLabel.font = FONT(12);
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.text = tips;
        [self addSubview:tipsLabel];
    }
    
    
    //计算frame
    [KeyWindow addSubview:self];
    NSUInteger row = (items.count - 1) / rowCount;
    CGFloat height = kFirst + 50 + (row +1) * (kBtnH + kMarginY);
    
    if (title.length || tips.length) {
        height += titleH;
    };

    CGFloat originY = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, originY, 0, height);
    [UIView animateWithDuration:0.25 animations:^{
        CGRect sF = self.frame;
        sF.origin.y = [UIScreen mainScreen].bounds.size.height - sF.size.height;
        self.frame = sF;
    }];
    
    // 圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.clipsToBounds = YES;
    
    //取消
    UIButton *canleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    canleBtn.frame = CGRectMake(0, self.frame.size.height-44, self.frame.size.width, 50);
    [canleBtn setTitle:@"取消" forState:UIControlStateNormal];
    canleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [canleBtn setBackgroundColor:[UIColor whiteColor]];
    [canleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [canleBtn addTarget:self action:@selector(cancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:canleBtn];
    
    self.btnBlock = ^(NSInteger tag, NSString *title){
        if(selectedHandle) selectedHandle(tag, title);
    };
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(canleBtn.frame), kScreenWidth, 0.5)];
    line.backgroundColor = RGB(238, 238, 238);
    [self addSubview:line];
}

- (void)setFrame:(CGRect)frame{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    if (frame.size.height <= 0) {
        frame.size.height = 00;
    }
    frame.origin.x = 0;
    [super setFrame:frame];
}
- (void)addBackgroundView:(UIView *)view{
    _backgroundView = [[UIView alloc] initWithFrame:KeyWindow.bounds];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.4;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleButtonAction)];
    [_backgroundView addGestureRecognizer:tap];
    [view addSubview:_backgroundView];
}
- (void)cancleButtonAction{
    [_backgroundView removeFromSuperview];
    _backgroundView = nil;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect sf = self.frame;
        sf.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.frame = sf;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)btnClick:(UIButton *)sender {
    if(_btnBlock) _btnBlock(sender.tag, sender.titleLabel.text);
}

- (void)hidden {
    [self cancleButtonAction];
}

@end



@interface JWShareItemButton()

@end

@implementation JWShareItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        self.imageView.layer.cornerRadius = kImageViewWH * 0.5;
    }
    return self;
}
#pragma mark 调整文字的位置和尺寸
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height * kTitlePrecent;
    CGFloat titleX = 2;
    CGFloat titleY = self.frame.size.height * (1 - kTitlePrecent) + 7;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
#pragma mark 调整图片的位置和尺寸
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = kImageViewWH;
    CGFloat imageH = kImageViewWH;
    CGFloat imageX = (self.frame.size.width - kImageViewWH) * 0.5;
    CGFloat imageY = 2;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end

