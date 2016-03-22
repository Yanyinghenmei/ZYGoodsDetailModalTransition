//
//  OverlayAnimationController.m
//  CustomModalTransition
//
//  Created by Daniel on 16/3/15.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "OverlayAnimationController.h"

@implementation OverlayAnimationController {
    CGFloat detailViewHeight;
}

- (instancetype)initWithDetailViewHeight:(CGFloat)height {
    if (self = [super init]) {
        detailViewHeight = height;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (![transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]||
        ![transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]) {
        return;
    }
    
    if (![transitionContext containerView]) {
        return;
    }
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGFloat toViewWidth = containerView.frame.size.width;
    CGFloat toViewHeight = containerView.frame.size.height* 2/3;
    
    if (toVC.isBeingPresented) {
        [containerView addSubview:toView];
        // 层级设置
        fromView.layer.zPosition = -100;
        toView.layer.zPosition = 100;
        
        toView.frame = CGRectMake(0, containerView.frame.size.height, toViewWidth, toViewHeight);
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                toView.frame = CGRectMake(0, 0, toViewWidth, toViewHeight);
                [self presentAnimationWithView:fromView aniDuration:duration];
            } completion:^(BOOL finished) {
                BOOL isCancelled = [transitionContext transitionWasCancelled];
                [transitionContext completeTransition:!isCancelled];
            }];
        } else {
            UIView *dimmingView = [UIView new];
            [containerView insertSubview:dimmingView belowSubview:toView];
            
            dimmingView.backgroundColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.5];
            dimmingView.backgroundColor =[UIColor redColor];
            dimmingView.center = containerView.center;
            dimmingView.bounds = CGRectMake(0, 0, toViewWidth, toViewHeight);
            
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                dimmingView.bounds = containerView.bounds;
                toView.frame = CGRectMake(0, 0, toViewWidth, toViewHeight);
                [self presentAnimationWithView:fromView aniDuration:duration];

            } completion:^(BOOL finished) {
                BOOL isCancelled = [transitionContext transitionWasCancelled];
                [transitionContext completeTransition:!isCancelled];
            }];
        }
    }
    
    if (fromVC.isBeingDismissed) {
        [UIView animateWithDuration:duration animations:^{
            fromView.frame = CGRectMake(0, containerView.frame.size.height, toViewWidth, toViewHeight);
            [self dismissAnimationWithView:toView aniDuration:duration];
        } completion:^(BOOL finished) {
            BOOL isCancelled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!isCancelled];
        }];
    }
}

- (void)presentAnimationWithView:(UIView *)view aniDuration:(NSTimeInterval)duration {
    
    [view.layer addAnimation:[self animationGroupForward:YES WithView:view animationDuration:duration]
                      forKey:@"pushedBackAnimation"];
}

- (void)dismissAnimationWithView:(UIView *)view aniDuration:(NSTimeInterval)duration {
    
    [view.layer addAnimation:[self animationGroupForward:NO WithView:view animationDuration:duration]
                      forKey:@"bringForwardAnimation"];
}

- (CAAnimationGroup*)animationGroupForward:(BOOL)_forward WithView:(UIView *)view animationDuration:(NSTimeInterval)aniDuration {
    
    // Create animation keys, forwards and backwards
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // The rotation angle is minor as the view is nearer
        t1 = CATransform3DRotate(t1, 7.5f*M_PI/180.0f, 1, 0, 0);
    } else {
        t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    }
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    double yScale = 0.8f;
    double xScale = 0.9f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // Minor shift to mantai perspective
        t2 = CATransform3DTranslate(t2, 0, view.frame.size.height*-0.04, 0);
        t2 = CATransform3DScale(t2, xScale, yScale, 1);
    } else {
        t2 = CATransform3DTranslate(t2, 0, view.frame.size.height*-0.08, 0);
        t2 = CATransform3DScale(t2, xScale, yScale, 1);
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
    CFTimeInterval duration = aniDuration;
    animation.duration = duration/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}

@end
