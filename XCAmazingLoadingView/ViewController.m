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
    [[theApp xcloadingView] startLoadingWithMessage:@"测试一下哈哈" inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[theApp xcloadingView] stopLoading];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
