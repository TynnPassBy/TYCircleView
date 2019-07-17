//
//  TYCircleView.m
//  TYAnnulus
//
//  Created by Tynn丶 on 2019/7/8.
//  Copyright © 2019 Tynn丶. All rights reserved.
//

#import "TYCircleView.h"

#define TYColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 屏幕尺寸
#define TYScreenW [UIScreen mainScreen].bounds.size.width

#define TYScreenH [UIScreen mainScreen].bounds.size.height

@interface TYDrawCircleView ()

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) TYCircleViewConfigure *configure;

@end

@implementation TYDrawCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = [UIColor clearColor];
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor orangeColor].CGColor;
    //默认颜色分布方向
    _configure.startPoint = CGPointMake(self.frame.size.width / 2, 0);
    _configure.endPoint = CGPointMake(self.frame.size.width / 2 , self.frame.size.height);
    //默认渐变色
    _configure.colorArr = @[[UIColor grayColor],[UIColor lightGrayColor]];
    _configure.circleLineWidth = 12;
}

- (void)drawRect:(CGRect)rect {
    
    // 1. 还是添加一个圆弧路径
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置线的宽度
    CGContextSetLineWidth(ctx, _configure.circleLineWidth);
    //设置圆环线条的两个端点做圆滑处理
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //设置画笔颜色
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    //设置圆心
    CGFloat originX = rect.size.width / 2;
    CGFloat originY = rect.size.height / 2;
    //计算半径
    CGFloat radius = MIN(originX, originY) - _configure.circleLineWidth/2.0;
    //建立一个最小初始弧度制,避免进度progress为0或1时圆环消失
    CGFloat minAngle = M_PI/90 - self.progress * M_PI/80;
    //逆时针画一个圆弧
    if (self.configure.isClockwise) {

        CGContextAddArc(ctx, rect.size.width / 2, rect.size.height / 2, radius, -M_PI_2, -M_PI_2 + minAngle + (2 * M_PI)*self.progress, NO);
    }else{
        
        CGContextAddArc(ctx, rect.size.width / 2, rect.size.height / 2, radius, -M_PI_2, -M_PI_2 - minAngle + (2 * M_PI)*(1-self.progress), YES);
    }
    
    //2. 创建一个渐变色
    CGFloat locations[_configure.colorSize.count];
    for (NSInteger index = 0; index < _configure.colorSize.count; index++) {
        locations[index] = [_configure.colorSize[index] floatValue];
    }
    
    //创建RGB色彩空间，创建这个以后，context里面用的颜色都是用RGB表示
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,(__bridge CFArrayRef _Nonnull)_configure.colorArr, _configure.colorSize.count==0?NULL:locations);

    //释放色彩空间
    CGColorSpaceRelease(colorSpace);
    colorSpace = NULL;
    
    //3.画出圆环路径
    CGContextReplacePathWithStrokedPath(ctx);
    //剪裁路径
    CGContextClip(ctx);
    
    //4.用渐变色填充,修改填充色的方向,_startPoint和_endPoint两个点的连线,就是颜色的分布方向
    CGContextDrawLinearGradient(ctx, gradient, _configure.startPoint, _configure.endPoint, 1);
    
    //释放渐变色
    CGGradientRelease(gradient);
    
}

@end

/******************** TYCircleView ************************/

@implementation TYCircleView {
    
    TYDrawCircleView *_circleView;
    TYCircleViewConfigure *_configure;
}

- (instancetype)initWithFrame:(CGRect)frame configure:(TYCircleViewConfigure *)configure
{
    self = [super initWithFrame:frame];
    if (self) {
        //保存配置
        _configure = configure;
        //绘制背景圆
        [self drawBackCircleView];
        //添加圆环
        [self addTYDrawCircleView];
        
    }
    return self;
}

- (void)addTYDrawCircleView {
    
    TYDrawCircleView *circleView = [[TYDrawCircleView alloc]initWithFrame:self.bounds];
    _circleView = circleView;
    _circleView.configure = _configure;
    [self addSubview:circleView];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _circleView.progress = progress;
    
    [_circleView setNeedsDisplay];
}

//绘制背景圆
- (void)drawBackCircleView {
    
    //1.UIBezierPath创建一个圆环路径
    //圆心
    CGPoint arcCenter = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    //半径 , circleLineWidth = 圆环线条宽度
    CGFloat radius = (self.frame.size.width - _configure.circleLineWidth)/2.0;
    //开始弧度:-M_PI_2,竖直向上; 结束弧度:-M_PI_2 + M_PI*2,一圈 clockwise:YES逆时针 NO顺时针
    //clockwise = NO时,若结束弧度 = -M_PI_2 + M_PI*2, 则圆环消失归零
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius  startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI*2 clockwise:YES];
    
    //2.创建一个ShapeLayer
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    bgLayer.fillColor = [UIColor clearColor].CGColor;//圆环路径填充颜色
    bgLayer.lineWidth = _configure.circleLineWidth;//圆环宽度
    bgLayer.strokeColor = _configure.lineColor.CGColor;//路径颜色
    bgLayer.strokeStart = 0.f;//路径开始位置
    bgLayer.strokeEnd = 1.f;//路径结束位置
    bgLayer.path = circle.CGPath;
    
    //3.把路径设置到layer上,换出背景圆环
    [self.layer addSublayer:bgLayer];
    
}

@end



@implementation TYCircleViewConfigure

@end
