//
//  ViewController.m
//  XCAmazingLoadingView
//
//  Created by 刘智民 on 24/12/2015.
//  Copyright © 2015 刘智民. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#define theApp ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define RGBColor(r, g, b) ([UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0])

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    [[XCAmazingLoadingView shareLoadingview] startLoadingWithMessage:@"   " inView:self.view];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [[XCAmazingLoadingView shareLoadingview] stopLoading];
    //    });
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    //    [self.view addGestureRecognizer:tapGesture];
    //    
    //    UIButton *btn_test = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
    //    [btn_test setTitle:@"Test" forState:UIControlStateNormal];
    //    [btn_test setTintColor:[UIColor blackColor]];
    //    [btn_test addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    //    
    //    [self.view addSubview:btn_test];
    
    [[XCAmazingLoadingView shareLoadingview] startLoadingWithMessage:nil inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XCAmazingLoadingView shareLoadingview] stopLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[XCAmazingLoadingView shareLoadingview] setShowMode:fullScreenMode];
            [[XCAmazingLoadingView shareLoadingview] setLoadingBkColor:RGBColor(15, 126, 211)];
            [[XCAmazingLoadingView shareLoadingview] setBubbleSize:CGSizeMake(8, 8)];
            [[XCAmazingLoadingView shareLoadingview] setAnimationDuration:2.5f];
            [[XCAmazingLoadingView shareLoadingview] setLoadingRadius:16];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                for (int i = 0; i < 101; i++) {
                    usleep(10000);
                    [[XCAmazingLoadingView shareLoadingview] startLoadingWithMessage:[NSString stringWithFormat:@"加载: %d%%",i] inView:self.view];
                    if (i == 100) {
                        [[XCAmazingLoadingView shareLoadingview] startLoadingWithMessage:@"加载结束" inView:self.view];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[XCAmazingLoadingView shareLoadingview] stopLoading];
                        });
                    }
                }
            });
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test {
    NSLog(@"Just for test");
}

- (void)onTap:(UIGestureRecognizer *)tapGestureRecognizer
{
    if([[XCAmazingLoadingView shareLoadingview] isLoading]) {
        [[XCAmazingLoadingView shareLoadingview] stopLoading];
    } else {
        [[XCAmazingLoadingView shareLoadingview] startLoadingWithMessage:[NSString stringWithFormat:@"我就是想测试一下%ld",random() % 500] inView:self.view];
    }
}
@end
