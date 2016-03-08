//
//  XCAmazingLoadingView.h
//
// Copyright (c) 2015 XCAmazingLoadingView 刘智民. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    skypeAnimation = 0
}loadAnimations;

typedef enum {
    normalMode = 0,
    fullScreenMode = 1
}loadMode;

@interface XCAmazingLoadingView : UIView<UIGestureRecognizerDelegate>

/**
 *
 *  动画类型 待扩展
 */
@property (assign,nonatomic) loadAnimations animationType;

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
 *  文本字体颜色
 */
@property (nonatomic, assign) UIColor *textColor;

/**
 *
 *  显示的模式
 */
@property (nonatomic, assign) loadMode showMode;

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

#pragma mark - SkypeAnimation
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
@end
