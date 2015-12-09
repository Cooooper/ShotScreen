//
//  UIView+UIShortcuts.h
//  WorkingCenterDemo
//
//  Created by Duke on 13-9-26.
//  Copyright (c) 2013年 Duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIShortcuts)

- (id)addViewWithFrame:(CGRect)frame;

- (id)addViewWithFrame:(CGRect)frame
                 backgroundColor:(UIColor *)backgroundColor;

- (id)addViewWithFrame:(CGRect)frame
                           class:(Class)viewClass;

- (id)addViewWithFrame:(CGRect)frame
                           class:(Class)viewClass
                 backgroundColor:(UIColor *)backgroundColor;

#pragma mark -
- (UIButton *)addButtonWithFrame:(CGRect)frame;

- (UIButton *)addButtonWithFrame:(CGRect)frame
                          action:(SEL)action; // target is self

- (UIButton *)addButtonWithFrame:(CGRect)frame
                          target:(id)target
                          action:(SEL)action;

- (UIButton *)addButtonWithFrame:(CGRect)frame
                           title:(NSString *)title
                 backgroundImage:(UIImage *)backgroundImage; // no target, no action

- (UIButton *)addButtonWithFrame:(CGRect)frame
                           title:(NSString *)title
                 backgroundImage:(UIImage *)backgroundImage
                          action:(SEL)action; // target is self

- (UIButton *)addButtonWithFrame:(CGRect)frame
                           title:(NSString *)title
                 backgroundImage:(UIImage *)backgroundImage
                          target:(id)target
                          action:(SEL)action;

- (UIButton *)addButtonWithFrame:(CGRect)frame
                           image:(UIImage *)image;

- (UIButton *)addButtonWithFrame:(CGRect)frame
                           image:(UIImage *)image
                          target:(id)target
                          action:(SEL)action;

#pragma mark -

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text;

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                     textColor:(UIColor *)textColor;

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                          font:(UIFont *)font;

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font;

#pragma mark -

- (UIImageView *)addImage:(UIImage *)image withFrame:(CGRect)frame;
- (UIImageView *)addImage:(UIImage *)image atOrigin:(CGPoint)origin;

#pragma mark -

typedef NS_ENUM(NSInteger, UIScrollViewScrollDirection) {
  UIScrollViewScrollDirectionNone,
  UIScrollViewScrollDirectionVertical,
  UIScrollViewScrollDirectionHorizontal
};

- (UIScrollView *)addScrollviewWithFrame:(CGRect)frame;

- (UIScrollView *)addScrollviewWithFrame:(CGRect)frame
                             contentSize:(CGSize)contentSize;

- (UIScrollView *)addScrollviewWithFrame:(CGRect)frame
                           numberOfPages:(NSInteger)numberOfPages
                         scrollDirection:(UIScrollViewScrollDirection)scrollDirection;

#pragma mark -

- (UIPageControl *)addPageControlWithNumberOfPages:(NSInteger)numberOfPages;
- (UIPageControl *)addPageControlWithNumberOfPages:(NSInteger)numberOfPages
                            pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                     currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor;

#pragma mark -
#pragma mark Border
- (void)addBorder;
- (void)addBorderWithColor:(UIColor *)color;
- (void)addBorderWithColor:(UIColor *)color width:(CGFloat)width;

@end
