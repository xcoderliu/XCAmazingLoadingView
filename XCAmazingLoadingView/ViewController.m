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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[theApp xcloadingView] startLoadingWithMessage:@"   " inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[theApp xcloadingView] stopLoading];
    });
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UIButton *btn_test = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
    [btn_test setTitle:@"Test" forState:UIControlStateNormal];
    [btn_test setTintColor:[UIColor blackColor]];
    [btn_test addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn_test];
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
    if([[theApp xcloadingView] isLoading]) {
        [[theApp xcloadingView] stopLoading];
    } else {
        [[theApp xcloadingView] startLoadingWithMessage:[NSString stringWithFormat:@"我就是想测试一下%ld",random() % 500] inView:self.view];
    }
}
@end
