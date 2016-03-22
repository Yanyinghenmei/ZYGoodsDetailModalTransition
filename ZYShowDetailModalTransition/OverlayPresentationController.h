//
//  OverlayPresentationController.h
//  CustomModalTransition
//
//  Created by Daniel on 16/3/15.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayPresentationController : UIPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController detailViewHeight:(CGFloat)height;

@end
