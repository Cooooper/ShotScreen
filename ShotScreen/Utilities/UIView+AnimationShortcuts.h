//
//  UIView+AnimationShortcuts.h
//  WorkingCenter
//
//  Created by Duke on 13-10-11.
//  Copyright (c) 2013年 Duke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIViewReloadAnimationDirection) {
  UIViewReloadAnimationDirectionNone,
  UIViewReloadAnimationDirectionTop,
  UIViewReloadAnimationDirectionBottom,
  UIViewReloadAnimationDirectionLeft,
  UIViewReloadAnimationDirectionRight
};

@interface UIView (AnimationShortcuts)

- (void)moveX:(CGFloat)x animated:(BOOL)animated;
- (void)moveY:(CGFloat)y animated:(BOOL)animated;
- (void)moveX:(CGFloat)x animated:(BOOL)animated completion:(void (^)())completion;
- (void)moveY:(CGFloat)y animated:(BOOL)animated completion:(void (^)())completion;

- (void)setXOffset:(CGFloat)offset; // Without animation
- (void)setYOffset:(CGFloat)offset; // Without animation

- (void)fadeout:(void (^)())completion;
- (void)fadein:(void (^)())completion;

- (void)fadeout:(BOOL)animated completion:(void (^)())completion;
- (void)fadein:(BOOL)animated completion:(void (^)())completion;
- (void)changeToFrame:(CGRect)frame
             animated:(BOOL)animated
           completion:(void (^)())completion;

- (void)reloadWithAnimationDirection:(UIViewReloadAnimationDirection)animationDirection
                     reloadDataBlock:(void (^)())reloadDataBlock
                          completion:(void (^)())completion;

- (void)reloadWithAnimationDirection:(UIViewReloadAnimationDirection)animationDirection
                              offset:(CGFloat)offset
                     reloadDataBlock:(void (^)())reloadDataBlock
                          completion:(void (^)())completion;


@end
