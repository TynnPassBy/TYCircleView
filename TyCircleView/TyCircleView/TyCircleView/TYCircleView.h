//
//  TYCircleView.h
//  TYAnnulus
//
//  Created by Tynn丶 on 2019/7/8.
//  Copyright © 2019 Tynn丶. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//背景圆环
/*********************  TYCircleBackView ************************/
@class TYCircleViewConfigure;
@interface TYCircleView : UIView

/**
 创建含有圆环的实例View

 @param frame 尺寸
 @param configure 配置属性
 @return 圆环所在的View
 */
- (instancetype)initWithFrame:(CGRect)frame configure:(TYCircleViewConfigure *)configure;

/** 百分比 */
@property (nonatomic, assign) CGFloat progress;

@end

//动态圆环
/*********************  TYCircleView ************************/

@interface TYDrawCircleView : UIView


@end

//配置属性
/*********************  TYCircleViewConfigure ************************/

@interface TYCircleViewConfigure : NSObject

/** 圆环线条宽度 */
@property (nonatomic, assign) CGFloat circleLineWidth;
/** 圆环的颜色 */
@property (nonatomic, strong) UIColor *lineColor;
/** 是否是顺时针 默认是NO:逆时针 */
@property (nonatomic, assign) BOOL isClockwise;
/** 渐变色方向 起始坐标 */
@property (nonatomic, assign) CGPoint startPoint;
/** 渐变色方向 结束坐标 */
@property (nonatomic, assign) CGPoint endPoint;
/** 渐变色的颜色数组 */
@property (nonatomic, strong) NSArray *colorArr;
/** 每个颜色的起始位置数组 注:每个元素 0 <= item < 1 */
@property (nonatomic, strong) NSArray *colorSize;

//注意: colorArr.count 和 colorSize.count 必须相等
//不相等时,渐变色最终显示出来的样子和期望的会有差异

@end

NS_ASSUME_NONNULL_END
