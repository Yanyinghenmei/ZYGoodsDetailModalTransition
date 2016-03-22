//
//  ZYShowDetailModalTransitionDelegate.h
//  ZYGoodsDetailModalTransition
//
//  Created by Daniel on 16/3/22.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZYShowDetailModalTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

- (instancetype)initWithPresentedViewHeight:(CGFloat)height;

@end
