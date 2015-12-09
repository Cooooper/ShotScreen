//
//  ViewController.m
//  ShotScreen
//
//  Created by Han Yahui on 15/3/20.
//  Copyright (c) 2015年 Han Yahui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@protocol shotScreenDelegate <NSObject>

- (void)shotScreenDidFinished:(UIImage *)image;
@end

@interface shotScreenModel : NSObject
@property (weak,nonatomic)id<shotScreenDelegate>delegate;

//获取整个屏幕的截图
- (UIImage*)shotImageFromView:(UIView*)theView withDelegate:(id<shotScreenDelegate>)delegate;
//获取屏幕某一块的截图
- (UIImage*)shotImageFromView:(UIView *)theView atFrame:(CGRect)r withDelegate:(id<shotScreenDelegate>)delegate;

@end
