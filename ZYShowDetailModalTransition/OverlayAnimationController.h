//
//  OverlayAnimationController.h
//  CustomModalTransition
//
//  Created by Daniel on 16/3/15.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OverlayAnimationController : NSObject<UIViewControllerAnimatedTransitioning>


- (instancetype)initWithDetailViewHeight:(CGFloat)height;

@end
