//
//  ViewController.m
//  TYAnnulus
//
//  Created by 刘庆贺 on 2019/7/17.
//  Copyright © 2019 Tynn丶. All rights reserved.
//

#import "ViewController.h"
#import "TYCircleView.h"

#define TYColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()

@end

@implementation ViewController {
    
    TYCircleView *_circleView;
    UILabel *_showLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat width = 180;
    CGFloat x = (self.view.bounds.size.width - width)/2.0;
    CGFloat y = (self.view.bounds.size.height - width)/2.0;
    
    //1.创建圆环
    TYCircleViewConfigure *configure = [[TYCircleViewConfigure alloc]init];
    //圆环背景色
    configure.lineColor = [UIColor lightGrayColor];
    //圆环宽度
    configure.circleLineWidth = 10;
    //设置顺时针方向画圆
    configure.isClockwise = YES;
    //渐变色分布方向
    configure.startPoint = CGPointMake(width / 2, 0);
    configure.endPoint   = CGPointMake(width / 2 , width);
    //渐变色的颜色
    configure.colorArr = @[
                           (id)TYColorFromRGB(0x349CF7).CGColor,//浅蓝色
                           (id)TYColorFromRGB(0xFE5858).CGColor,//深橙色
                           (id)TYColorFromRGB(0x72DC4F).CGColor //浅绿色
                           ];
    //颜色数组中,每个颜色在"渐变色方向"上[0,1]中的起始位置
    configure.colorSize = @[@0,@0.3,@0.8];
    
    TYCircleView *circleView = [[TYCircleView alloc]initWithFrame:CGRectMake(x , y, width, width) configure:configure];
    _circleView = circleView;
    
    [self.view addSubview:circleView];
    
    //2.创建slider
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(circleView.frame) + 50, self.view.bounds.size.width - 30 * 2, 50)];
    [slider addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    //3.显示label
    UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake((width - 100)/2, (width - 50)/2, 100, 50)];
    _showLabel = showLabel;
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.font = [UIFont systemFontOfSize:25];
    showLabel.text = @"0.0%";
    [circleView addSubview:showLabel];
}

- (void)sliderValueChangedAction:(UISlider *)slider {
    
    NSLog(@"%f",slider.value);
    _circleView.progress = slider.value;
    _showLabel.text = [NSString stringWithFormat:@"%.1f%%",slider.value * 100];
}


@end
