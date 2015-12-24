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


@property (nonatomic, assign) UIColor *textColor;

/**
 *  start loading animation
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