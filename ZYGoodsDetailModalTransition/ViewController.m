//
//  ViewController.m
//  ZYGoodsDetailModalTransition
//
//  Created by Daniel on 16/3/22.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ViewController.h"
#import "ZYShowDetailModalTransitionDelegate.h"

@interface ViewController ()

@end

@implementation ViewController {
    ZYShowDetailModalTransitionDelegate *modalTransitionDelegate;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    modalTransitionDelegate = [[ZYShowDetailModalTransitionDelegate alloc] initWithPresentedViewHeight:self.view.frame.size.height * 2/3];
    
    self.view.window.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self.view addGestureRecognizer:dismissTap];
    self.view.userInteractionEnabled = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UIView *view in self.view.subviews) {
        [view resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController *next = segue.destinationViewController;
    next.transitioningDelegate = modalTransitionDelegate;
    next.modalPresentationStyle = UIModalPresentationCustom;
    
    [super prepareForSegue:segue sender:sender];
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
