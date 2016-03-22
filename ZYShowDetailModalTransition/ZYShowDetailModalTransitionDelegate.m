//
//  ZYShowDetailModalTransitionDelegate.m
//  ZYGoodsDetailModalTransition
//
//  Created by Daniel on 16/3/22.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYShowDetailModalTransitionDelegate.h"
#import "OverlayAnimationController.h"
#import "OverlayPresentationController.h"

@implementation ZYShowDetailModalTransitionDelegate {
    CGFloat detailViewHeight;
}

- (instancetype)initWithPresentedViewHeight:(CGFloat)height {
    if (self = [super init]) {
        detailViewHeight = height;
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[OverlayAnimationController alloc] initWithDetailViewHeight:detailViewHeight];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[OverlayAnimationController alloc] initWithDetailViewHeight:detailViewHeight];
}

// 转场监听(转场前/后...)
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[OverlayPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting detailViewHeight:detailViewHeight];
}

@end
