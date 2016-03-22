//
//  OverlayPresentationController.m
//  CustomModalTransition
//
//  Created by Daniel on 16/3/15.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "OverlayPresentationController.h"

@interface OverlayPresentationController ()
@property (nonatomic, strong) UIView *dimmingView;
@end

@implementation OverlayPresentationController {
    CGFloat detailViewHeight;
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController detailViewHeight:(CGFloat)height {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        detailViewHeight = height;
    }
    return self;
}

- (UIView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [UIView new];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissClick:)];
        
        CGFloat dimmingViewInitailWidth = self.containerView.frame.size.width;
        CGFloat dimmingViewInitailHeight = self.containerView.frame.size.width;
        
        _dimmingView.center = self.containerView.center;
        _dimmingView.bounds = CGRectMake(0, 0, dimmingViewInitailWidth, dimmingViewInitailHeight);
        
        [_dimmingView addGestureRecognizer:tap];
        _dimmingView.userInteractionEnabled = YES;
        
    }
    return _dimmingView;
}

- (void)dismissClick:(UITapGestureRecognizer *)tap {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentationTransitionWillBegin {
    [self.containerView addSubview:self.dimmingView];
}

- (void)dismissalTransitionWillBegin {
    [[self.presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0.f;
    } completion:nil];
}

- (void)containerViewWillLayoutSubviews {
    self.dimmingView.center = self.containerView.center;
    self.dimmingView.bounds = self.containerView.bounds;
    
    CGFloat width = self.containerView.frame.size.width;
    CGFloat height = detailViewHeight;
    
    self.presentedView.center = self.containerView.center;
    self.presentedView.frame = CGRectMake(0, self.containerView.frame.size.height-height, width, height);
}


@end
