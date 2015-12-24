//
//  XCAmazingLoadingView.m
//  ForLearning
//
//  Created by 刘智民 on 22/12/2015.
//  Copyright © 2015 刘智民. All rights reserved.
//

#import "XCAmazingLoadingView.h"

static NSString * const kSkypeCurveAnimationKey = @"kSkypeCurveAnimationKey";
static NSString * const kSkypeScaleAnimationKey = @"kSkypeScaleAnimationKey";

static const int klab_load_space = 16;
static const int kbottomSpace = 16;
static const int ktopSpace = 8;
static const int kdefaultRadius = 12;

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
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UILabel *textMessage;
@property (nonatomic, strong) XCCoverView *coverView;
@end

@implementation XCAmazingLoadingView
- (instancetype)init
{
    if(self = [super init]) {
        [self _commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self _commonInit];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _commonInit];
}

- (void)_commonInit
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.6, 100);
    self.coverView = [[XCCoverView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.1;
    self.numberOfBubbles = 5;
    self.animationDuration = 1.5f;
    self.bubbleSize = CGSizeMake(6, 6);
    self.bubbleColor = [UIColor whiteColor];
    self.loadingRadius = kdefaultRadius;
    self.loadingCenter = CGPointMake(self.center.x, kdefaultRadius + self.bubbleSize.width + ktopSpace);
    self.textColor = [UIColor whiteColor];
    self.textMessage = [UILabel new];
    self.textMessage.textAlignment = NSTextAlignmentCenter;
    self.textMessage.textColor = self.textColor;
    [self addSubview:self.textMessage];
    self.textMessage.hidden = YES;
    self.textColor = [UIColor whiteColor];
    self.textMessage.numberOfLines = 0;
    self.textMessage.lineBreakMode = NSLineBreakByWordWrapping;
    self.backgroundColor = [UIColor colorWithRed:22 / 225.f green:180 / 255.f blue:250 / 255.f alpha:1];
    [self.layer setCornerRadius:8.0f];
    self.hidden = YES;
}

#pragma mark - XCSkypeActivityIndicatorViewProtocol

- (void)startLoadingWithMessage:(NSString*)message inView:(UIView*)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.transform = CGAffineTransformIdentity;
        
        if(self.isLoading || !self.isHidden) {
            return;
        }
        
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
        [view addSubview:self];
        [view bringSubviewToFront:self];
        [view insertSubview:self.coverView belowSubview:self];
        [self.coverView setCenter:view.center];
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.6, 100);
        
        self.loadingCenter = CGPointMake(self.center.x, kdefaultRadius + self.bubbleSize.width + ktopSpace);
        
        self.textMessage.hidden = message ? NO : YES;
        
        CGRect newFrame = self.frame;
        
        if ([[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
            NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:message];
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
            CGSize lab_Size = [self.textMessage sizeThatFits:CGSizeMake(self.bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            
            CGFloat resetHeight = self.loadingCenter.y + self.loadingRadius + klab_load_space + lab_Size.height + kbottomSpace;
            newFrame.size.height = resetHeight;
            self.frame = newFrame;
            [self addSubview:self.textMessage];
            self.textMessage.frame = CGRectMake(0, self.loadingCenter.y + self.loadingRadius + klab_load_space, self.frame.size.width, lab_Size.height);
        } else {
            self.textMessage = nil;
            newFrame = CGRectMake(0, 0, 100, 100);
            self.frame = newFrame;
            self.loadingCenter = self.center;
        }
        
        self.center = view.center;
        
        self.isLoading = YES;
        self.hidden = NO;
        self.alpha = 1.0;
        self.coverView.alpha = 0.1;
        self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
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
    });
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
        
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
            self.alpha = 0.0;
            self.coverView.alpha = 0.0;
        } completion:^(BOOL finished) {
            for(UIView *bubble in self.subviews) {
                [UIView animateWithDuration:0.8f animations:^{
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
    });
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

@end
