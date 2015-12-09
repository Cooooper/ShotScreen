//
//  ViewController.m
//  ShotScreen
//
//  Created by Han Yahui on 15/3/20.
//  Copyright (c) 2015年 Han Yahui. All rights reserved.
//


#import "ViewController.h"
#import "shotScreenModel.h"
#import "UIView+FrameShortcuts.h"

#import <MessageUI/MFMailComposeViewController.h>


#define kSelfViewWidth   self.view.frame.size.width
#define kSelfViewHeight  self.view.frame.size.height
#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height

#define kWebDefualtFrame CGRectMake(0, 64, kSelfViewWidth, kSelfViewHeight - 64)
#define kViewDefaultFrame [UIScreen mainScreen].bounds


#define kUrl @"http://www.qq.com"

NS_INLINE NSString *DocumentsDirectory() {
  return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

@interface ViewController () <UIActionSheetDelegate,UIAlertViewDelegate,UIWebViewDelegate,UIScrollViewDelegate,MFMailComposeViewControllerDelegate>
{
  UIView  *_rectView;//手势矩形
  UIImage *_shotImage;
  BOOL    _isWebPage;
  UIWebView *_webView;
  CGSize _currentContentSize;
  
}
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Shot Screen";
    NSLog(@"DocumentsDirectory:\n %@",DocumentsDirectory());
    _isWebPage = YES;

  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self test1];
  

}

- (void)test1
{
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage.png"]];
  
  
  UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(shotScreen)];
  self.navigationItem.rightBarButtonItem = rightItem;
  
  
  
  UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
  leftBtn.frame = CGRectMake(0, 0, 85, 40);
  [leftBtn setTitle:@"Web Page" forState:UIControlStateNormal];
  leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
  [leftBtn addTarget:self action:@selector(displayWebView:) forControlEvents:UIControlEventTouchUpInside];
  
  UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
  self.navigationItem.leftBarButtonItem = leftItem;
  

}

#pragma mark - displayWebView


- (void)displayWebView:(UIButton *)sender
{
  
  if (_isWebPage) {
    [sender setTitle:@"Image Page" forState:UIControlStateNormal];
    _isWebPage = NO;
  }else
  {
    [sender setTitle:@"Web Page" forState:UIControlStateNormal];
    _isWebPage = YES;
  }
  
  if (_isWebPage) {
    [_webView removeFromSuperview];
    _webView = nil;
  }else
  {
    if (!_webView) {
      _webView = [[UIWebView alloc] initWithFrame:kWebDefualtFrame];
      _webView.backgroundColor = [UIColor lightGrayColor];
      _webView.scrollView.delegate = self;
      _webView.delegate = self;
      [self.view addSubview:_webView];
    }
    NSURL *url = [NSURL URLWithString:kUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
  }
  
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
  
  _currentContentSize = webView.scrollView.contentSize;
  
  NSLog(@"webvie scroll view contentsize %@",NSStringFromCGSize(webView.scrollView.contentSize));
  NSLog(@"webview frame %@",NSStringFromCGRect(webView.frame));
  NSLog(@"webview scroll view frame %@",NSStringFromCGRect(webView.scrollView.frame));
  NSLog(@"webview scroll view contentoffsize %@",NSStringFromCGPoint(webView.scrollView.contentOffset));

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
  NSLog(@"webvie scroll view contentsize %@",NSStringFromCGSize(scrollView.contentSize));


}


#pragma mark -

- (void)shotScreen
{
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:@"选择操作"
                                            otherButtonTitles:@"截取全部内容", @"截取当前区域",@"截取指定区域",nil];
  [sheet showInView:self.view];
}

#pragma mark action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  switch (buttonIndex) {
    case 1:
      [self shotAllContent];
      break;
    case 2:
      [self shotVisibleScreen];
    case 3:
      [self shotAreaScreen];
    default:
      break;
  }
}

- (void)shotVisibleScreen
{
  shotScreenModel *shotModel = [[shotScreenModel alloc]init];
  [shotModel shotImageFromView:self.view withDelegate:self];
  
}

- (void)shotAreaScreen
{
  //拖拽手势
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerTap:)];
  [self.view addGestureRecognizer:pan];
}

- (void)shotAllContent
{
  
//  self.view.frame = CGRectMake(0, 0, _currentContentSize.width, _currentContentSize.height);
//  _webView.frame = kWebDefualtFrame;
  self.view.height = _currentContentSize.height;
  _webView.height = self.view.height;

  shotScreenModel *model = [[shotScreenModel alloc] init];
  [model shotImageFromView:_webView atFrame:CGRectMake(0, 64, _currentContentSize.width, _currentContentSize.height)withDelegate:self];
  
}

//拖拽手势
-(void)panGestureRecognizerTap:(UIPanGestureRecognizer *)pan
{
  static CGPoint firstPoint;
  if (pan.state == UIGestureRecognizerStateBegan) {//手势开始
    //        firstPoint = [pan translationInView:self.view];
    firstPoint = [pan locationInView:self.view];
    //        printf("firstPoint--> x:%f  y:%f\n",firstPoint.x,firstPoint.y);
  }
  if (pan.state == UIGestureRecognizerStateChanged) {//手势移动
    //        CGPoint lastPoint = [pan translationInView:self.view];
    CGPoint lastPoint = [pan locationInView:self.view];
    //        printf("lastPoint--> x:%f  y:%f\n",lastPoint.x,lastPoint.y);
    
    if (_rectView == nil) {
      _rectView = [[UIView alloc]init];
      _rectView.backgroundColor = [UIColor blackColor];
      _rectView.alpha = 0.5;
      [self.view addSubview:_rectView];
    }
    _rectView.frame = CGRectMake(firstPoint.x, firstPoint.y, abs(lastPoint.x - firstPoint.x), abs(lastPoint.y - firstPoint.y));
  }
  if (pan.state == UIGestureRecognizerStateEnded) {//手势结束
    //        printf("viewFram >>>  x:%f  y:%f  W:%f  H:%f\n",view.frame.origin.x,view.frame.origin.y,view.frame.size.width,view.frame.size.height);
    CGRect rect = _rectView.frame;
    printf("rect >>  x:%f  y:%f  W:%f  H:%f\n",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    [_rectView removeFromSuperview];
    _rectView = nil;
    
    //截屏
    shotScreenModel *shotModel = [[shotScreenModel alloc]init];
    [shotModel shotImageFromView:self.view atFrame:rect withDelegate:self];
    [self.view removeGestureRecognizer:pan];
  }
}
#pragma passImgDelegate
-(void)shotScreenDidFinished:(UIImage *)image
{
  _shotImage = image;
  [self showRemind:@"图片已经截取成功，请选择保存的位置"];
  self.view.height = kViewDefaultFrame.size.width;
  self.view.width = kViewDefaultFrame.size.height;
  _webView.width = self.view.width;
  _webView.height = self.view.height - 64;
  
}

#pragma mark -

- (void)showRemind:(NSString *)message
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存相册",@"保存本地",@"保存相册并发邮件",@"发送邮件",nil];
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (alertView.cancelButtonIndex == buttonIndex) {
    //取消
  }else if(alertView.firstOtherButtonIndex == buttonIndex)
  { // buttonindex  == 1
    //存到相册里
    [self saveImageFileToPhotoAlbum:_shotImage];
    
  }else if(buttonIndex == 2){
    // button index == 2
    
    //存到本地
    [self writeImageFileToSandbox:_shotImage];
  }else if(buttonIndex == 3)
  {
    //保存至相册并发送邮件
    [self saveImageFileToPhotoAlbum:_shotImage];
    NSData *data =  UIImagePNGRepresentation(_shotImage);
    [self sendEmail:data];
  }else if(buttonIndex == 4)
  {
    NSData *data =  UIImagePNGRepresentation(_shotImage);
    [self sendEMailCallSystemMail:data];
    
  }
}

#pragma mark - 保存截图到本地
- (void)writeImageFileToSandbox:(UIImage *)image
{
  if (!image) {
    return;
  }
  NSData *data = UIImagePNGRepresentation(image);
  NSString *imageName = [NSString stringWithFormat:@"/%u.png",arc4random()];
  NSString *path = [DocumentsDirectory() stringByAppendingString:imageName];
  NSLog(@"path  %@",path);
  [data writeToFile:path atomically:YES];
  [self showRemindReuslt:@"图片已成功保存至沙盒本地"];
}

#pragma mark - 保存截图至相册
- (void)saveImageFileToPhotoAlbum:(UIImage *)image
{
  if (!image) {
    return;
  }
  UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
  
}

#pragma mark - 保存截图至相册完成后的回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
  if (error == nil) {
    NSLog(@"图片成功保存到相册了！");
    [self showRemindReuslt:@"图片已成功保存至相册"];
//    NSData *data =  UIImagePNGRepresentation(image);
//    [self sendEmail:data];
  }
}

- (void)showRemindReuslt:(NSString *)message
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小提示" message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
  [alert show];
  
  
}

- (void)sendEMailCallSystemMail:(NSData *)data
{
  NSString *url = @"mailto:foo@example.com?cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!";
  
  //收件人 foo@example.com
  //抄送 cc
  //主题 subject
  //内容 body
  
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

}

- (void)sendEmail:(NSData *)data
{

  MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
  controller.mailComposeDelegate = self;
  [controller setToRecipients:@[@"969994158@qq.com",@"ydhan@ideabinder.com"]];
  [controller setCcRecipients:@[@"weihu@ideabinder.com"]];
  [controller setBccRecipients:@[@"xqjia@ideabinder.com"]];
  [controller setSubject:@"My Subject"];
  [controller setMessageBody:@"Hello there." isHTML:NO];
  [controller addAttachmentData:data mimeType:@"Image" fileName:@"han.png"];
  [self presentViewController:controller animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
  if (result == MFMailComposeResultSent) {
    NSLog(@"It's away!");
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)test
{
  
}



@end
