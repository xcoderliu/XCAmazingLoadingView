//
//  XCAmazingLoadingView.h
//  ForLearning
//
//  Created by 刘智民 on 22/12/2015.
//  Copyright © 2015 刘智民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XCAmazingLoadingView : UIView<UIGestureRecognizerDelegate>

/**
 *
 *  @return return the loading view
 */
+ (instancetype)shareLoadingview;

/**
 *  loadingBkColor 背景颜色
 */
@property (nonatomic, strong) UIColor *loadingBkColor;

/**
 *  loadingview 点点的个数
 */
@property (nonatomic, assign) NSUInteger numberOfBubbles;

/**
 *  loadingview 点点的颜色
 */
@property (nonatomic, strong) UIColor *bubbleColor;

/**
 *  loadingview 点点的大小
 */
@property (nonatomic, assign) CGSize bubbleSize;

/**
 *  loading 一次load的时长
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**
 *  loading 路径的半径
 */
@property (nonatomic, assign) CGFloat loadingRadius;

/**
 *  loading 的中心点
 */
@property (nonatomic, assign) CGPoint loadingCenter;

/**
 *  文本字体颜色
 */
@property (nonatomic, assign) UIColor *textColor;

/**
 *  加载loading动画
 *
 *  @param message 文本显示信息
 *  @param view    显示的父视图
 */
- (void)startLoadingWithMessage:(NSString*)message inView:(UIView*)view;

/**
 *  stop loading animation
 */
- (void)stopLoading;

/**
 *
 *  @return is loading
 */
- (BOOL)isLoading;
@end
