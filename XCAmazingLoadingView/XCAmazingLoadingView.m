//
//  XCAmazingLoadingView.m
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

#import "XCAmazingLoadingView.h"
#import <math.h>

static NSString * const kSkypeCurveAnimationKey = @"kSkypeCurveAnimationKey";
static NSString * const kSkypeScaleAnimationKey = @"kSkypeScaleAnimationKey";

static const int klab_load_space = 18;
static const int kbottomSpace = 18;
static const int ktopSpace = 14;
static const int kdefaultRadius = 12;
static const CGFloat kViewWidthScale = 0.6;
static const CGFloat kFullModeViewWidthScale = 0.8;
static XCAmazingLoadingView *_theLoadingview;

@interface XCCoverView : UIView<UIGestureRecognizerDelegate>

@end

@implementation XCCoverView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEstimatedPropertiesUpdated:(NSSet *)touches {
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

@end

@interface XCSkypeActivityIndicatorBubbleView : UIView

@property (nonatomic, strong) UIColor *color;

@end

@implementation XCSkypeActivityIndicatorBubbleView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextAddEllipseInRect(context, self.bounds);
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillPath(context);
}

@end

@interface XCAmazingLoadingView ()
{
    NSString *_lastMessage;
    UIView *_lastView;
    CGPoint _lastLoadingCenter;
}
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UILabel *textMessage;
@property (nonatomic, strong) XCCoverView *coverView;

@end

@implementation XCAmazingLoadingView

+ (instancetype)shareLoadingview {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theLoadingview = [[self alloc] init];
        [_theLoadingview _commonInit];
    });
    return _theLoadingview;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theLoadingview = [super allocWithZone:zone];
    });
    return _theLoadingview;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _theLoadingview;
}

- (void)_commonInit
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * kViewWidthScale, 100);
    self.coverView = [[XCCoverView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.1;
    self.showMode = normalMode;
    self.textColor = [UIColor whiteColor];
    self.textMessage = [UILabel new];
    self.textMessage.textAlignment = NSTextAlignmentCenter;
    self.textMessage.textColor = self.textColor;
    self.textMessage.hidden = YES;
    self.textColor = [UIColor whiteColor];
    self.textMessage.numberOfLines = 0;
    self.textMessage.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:self.textMessage];
    self.loadingBkColor = [UIColor colorWithRed:22 / 225.f green:180 / 255.f blue:250 / 255.f alpha:1];
    [self.layer setCornerRadius:8.0f];
    self.hidden = YES;
    self.animationDuration = 1.5f;
    
    //SkypeAnimation
    
    self.animationType = skypeAnimation;
    self.numberOfBubbles = 5;
    self.bubbleSize = CGSizeMake(6, 6);
    self.bubbleColor = [UIColor whiteColor];
    self.loadingRadius = kdefaultRadius;
    self.loadingCenter = CGPointMake(self.center.x, kdefaultRadius + self.bubbleSize.width + ktopSpace);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecomeActive)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - XCSkypeActivityIndicatorViewProtocol

- (void)startLoadingWithMessage:(NSString*)message inView:(UIView*)view
{
    _lastMessage = message;
    _lastView = view;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.backgroundColor = self.loadingBkColor;
        
        self.transform = CGAffineTransformIdentity;
        
        self.layer.cornerRadius = self.showMode == normalMode ? 8.0f : 0.0f;
        
        if(self.isLoading || !self.isHidden) {
            if (self.isLoading && ![_lastMessage isEqualToString:self.textMessage.text]) {
                [self resetLayoutBytextChange];
                if (fabs(_lastLoadingCenter.x - self.loadingCenter.x) >= 8 || fabs(_lastLoadingCenter.y - self.loadingCenter.y) >= 8) {
                    if (self.textMessage.text != nil || self.showMode != fullScreenMode) {
                        [self resumeLoading];
                        _lastLoadingCenter = self.loadingCenter;
                    }
                }
            }
            return;
        }
        
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
        [view addSubview:self];
        [view bringSubviewToFront:self];
        [view insertSubview:self.coverView belowSubview:self];
        [self.coverView setCenter:view.center];
        
        [self resetLayoutBytextChange];
        _lastLoadingCenter = self.loadingCenter;
        
        self.isLoading = YES;
        self.hidden = NO;
        self.alpha = 1.0;
        self.coverView.alpha = 0.1;
        self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
        
        if (self.animationType == skypeAnimation) {
            [self skypeAnimationStart];
        }
    });
}

- (void)resetLayoutBytextChange {
    self.textMessage.hidden = _lastMessage ? NO : YES;
    
    self.frame = self.showMode == normalMode ? CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * kViewWidthScale, 100) : CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    CGRect newFrame = self.frame;
    
    self.loadingCenter = self.showMode == fullScreenMode ?  CGPointMake(self.center.x,[UIScreen mainScreen].bounds.size.height / 2 - self.loadingRadius - self.bubbleSize.width - ktopSpace): CGPointMake(self.center.x, self.loadingRadius + self.bubbleSize.width + ktopSpace);
    
    if ([[_lastMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:_lastMessage];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:7];
        [style setAlignment:NSTextAlignmentCenter];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        [attrString addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, attrString.length)];
        
        self.textMessage.attributedText = attrString;
        self.textMessage.textColor = self.textColor;
        self.textMessage.alpha = 1.0;
        CGSize lab_Size = [self.textMessage sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width * (self.showMode == fullScreenMode ? kFullModeViewWidthScale : kViewWidthScale), [UIScreen mainScreen].bounds.size.height)];
        if (self.showMode != fullScreenMode) {
            CGFloat resetHeight = self.loadingCenter.y + self.loadingRadius + klab_load_space + lab_Size.height + kbottomSpace;
            newFrame.size.height = resetHeight;
            self.frame = newFrame;
        }
        [self addSubview:self.textMessage];
        self.textMessage.frame = CGRectMake(0, self.loadingCenter.y + self.loadingRadius + klab_load_space, self.frame.size.width, lab_Size.height);
    } else {
        self.textMessage.text = nil;
        if (self.showMode != fullScreenMode) {
            newFrame = CGRectMake(0, 0, 100, 100);
            self.frame = newFrame;
        }
        self.loadingCenter = self.center;
    }
    self.center = _lastView.center;
}

- (void)stopLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.isLoading) {
            return;
        }
        
        self.isLoading = NO;
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0;
        self.coverView.alpha = 0.1;
        
        if (_animationType == skypeAnimation) {
            [self skypeAnimationStop];
        }
    });
}

- (void)resumeLoading {
    if (self.isLoading) {
        [self stopLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startLoadingWithMessage:_lastMessage inView:_lastView];
        });
    }
}

- (void)appBecomeActive {
    [self performSelectorOnMainThread:@selector(resumeLoading) withObject:nil waitUntilDone:YES];
}

- (XCSkypeActivityIndicatorBubbleView *)bubbleWithTimingFunction:(CAMediaTimingFunction *)timingFunction initialScale:(CGFloat)initialScale finalScale:(CGFloat)finalScale
{
    XCSkypeActivityIndicatorBubbleView *bubbleView = [[XCSkypeActivityIndicatorBubbleView alloc] initWithFrame:CGRectMake(0, 0, self.bubbleSize.width, self.bubbleSize.height)];
    [bubbleView setColor:self.bubbleColor];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = self.animationDuration;
    pathAnimation.repeatCount = CGFLOAT_MAX;
    pathAnimation.timingFunction = timingFunction;
    pathAnimation.path = [UIBezierPath bezierPathWithArcCenter:self.loadingCenter radius:self.loadingRadius
                                                    startAngle:3 * M_PI / 2
                                                      endAngle:3 * M_PI / 2 + 2 * M_PI
                                                     clockwise:YES].CGPath;
    
    [bubbleView.layer addAnimation:pathAnimation forKey:kSkypeCurveAnimationKey];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = self.animationDuration;
    scaleAnimation.repeatCount = CGFLOAT_MAX;
    scaleAnimation.fromValue = @(initialScale);
    scaleAnimation.toValue = @(finalScale);
    
    if(initialScale > finalScale) {
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    } else {
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    
    [bubbleView.layer addAnimation:scaleAnimation forKey:kSkypeScaleAnimationKey];
    
    return bubbleView;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

- (void)skypeAnimationStart {
    [UIView animateWithDuration:0.1 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    for(NSUInteger i = 0; i < self.numberOfBubbles; i++) {
        CGFloat x = i * (1.0f / self.numberOfBubbles);
        XCSkypeActivityIndicatorBubbleView *bubbleView = [self bubbleWithTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.5f :(0.1f + x) :0.25f :1.0f] initialScale:1.0f - x finalScale:0.2f + x];
        [bubbleView setAlpha:0.0f];
        [self addSubview:bubbleView];
        [UIView animateWithDuration:0.8f animations:^{
            [bubbleView setAlpha:1.0f];
        }];
    }
}

- (void)skypeAnimationStop {
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
        self.alpha = 0.0;
        self.coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        for(UIView *bubble in self.subviews) {
            [UIView animateWithDuration:0.1f animations:^{
                if ([[bubble class] isSubclassOfClass:[UILabel class]]) {
                    return ;
                }
                [bubble setAlpha:0.0f];
            } completion:^(BOOL finished) {
                if ([[bubble class] isSubclassOfClass:[UILabel class]]) {
                    return ;
                }
                [bubble.layer removeAllAnimations];
                [bubble removeFromSuperview];
            }];
        }
        self.hidden = YES;
        [self.coverView removeFromSuperview];
    }];
}

@end
