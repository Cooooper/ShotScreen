//
//  ViewController.m
//  ShotScreen
//
//  Created by Han Yahui on 15/3/20.
//  Copyright (c) 2015年 Han Yahui. All rights reserved.
//

#import "shotScreenModel.h"

@implementation shotScreenModel

- (UIImage*)shotImageFromView:(UIView*)theView withDelegate:(id<shotScreenDelegate>)delegate;
{
    
    self.delegate = delegate;
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.delegate shotScreenDidFinished:theImage];
    return theImage;
    
}

- (UIImage*)shotImageFromView:(UIView *)theView atFrame:(CGRect)r withDelegate:(id<shotScreenDelegate>)delegate;
{
    self.delegate = delegate;
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  [self.delegate shotScreenDidFinished:theImage];
    return  theImage;
}

@end


