//
//  ImageExtractViewController.m
//  ios_camera_test
//
//  Created by 川上 基樹 on 2014/03/26.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import "ImageExtractViewController.h"
#import "ExtractPreviewView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageExtractViewController () {
    CGPoint _beginPoint;
    CGPoint _endPoint;
    BOOL _isDragging;
    __weak IBOutlet UIImageView* _targetImageView;

    __weak IBOutlet ExtractPreviewView* _extractPreviewView;
}

@end

@implementation ImageExtractViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"ImageExtractViewController::initWithNibName");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 呼び出し元から受け取った画像を表示
    [_targetImageView setImage:self.editTargetImage];
}

/**
 *  タッチ開始
 *
 *  @param touches
 *  @param event
 */
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint p = [[touches anyObject] locationInView:self.view];
    NSLog(@"Start:x:%.1f y:%.1f", p.x, p.y);
    _beginPoint = p;
    _isDragging = YES;
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint p = [[touches anyObject] locationInView:self.view];
    _endPoint = p;

    [self displayPreview];
}
/**
 *  タッチ終了
 *
 *  @param touches
 *  @param event   
 */
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint p = [[touches anyObject] locationInView:self.view];
    NSLog(@"Goal:x:%.1f y:%.1f", p.x, p.y);
    _endPoint = p;
    _isDragging = NO;

    [self displayPreview];
}

- (IBAction)touchCircleButton:(id)sender
{
}

- (IBAction)touchRectButton:(id)sender
{
}
- (IBAction)touchEraserButton:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)touchDoneButton:(id)sender
{
    UIGraphicsBeginImageContextWithOptions(_targetImageView.bounds.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();

    // 背景を白で塗りつぶし
    CGContextSetFillColorWithColor(c, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(c, _extractPreviewView.bounds);

    // 中央に黒円を塗りつぶし描画
    CGContextSetFillColorWithColor(c, [[UIColor blackColor] CGColor]);
    CGContextFillEllipseInRect(c, CGRectMake(_extractPreviewView.begin.x, _extractPreviewView.begin.y, _extractPreviewView.end.x - _extractPreviewView.begin.x, _extractPreviewView.end.y - _extractPreviewView.begin.y));

    // サーフェイスをUIImage
    UIImage* maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGImageRef m = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(m), CGImageGetHeight(m), CGImageGetBitsPerComponent(m), CGImageGetBitsPerPixel(m), CGImageGetBytesPerRow(m), CGImageGetDataProvider(m), NULL, false);
    CGImageRef masked = CGImageCreateWithMask(self.editTargetImage.CGImage, mask);
    UIImage* maskedImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(mask);
    CGImageRelease(masked);

    //    self.editTargetImage = image;

    // iOS7だと透過バグがあるためImageViewに貼り付け直し再生成することで対応する.
    UIImageView* imageView = [[UIImageView alloc] initWithImage:maskedImage];
    imageView.backgroundColor = [UIColor clearColor];
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // マスク適用後のイメージを表示
    [_targetImageView setImage:maskedImage];

    // マスク適用後のイメージを保存
    NSData* pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation(maskedImage)];
    ALAssetsLibrary* al = [[ALAssetsLibrary alloc] init];
    [al writeImageDataToSavedPhotosAlbum:pngData
                                metadata:nil
                         completionBlock:^(NSURL* assetURL, NSError* error) {
                             NSLog(@"Complete保存処理");
                         }];

    // iOS7だとマスク処理したイメージを保存しても透過処理が入らない不具合がある.
    // マスク適合済みUIImageをアルバムに保存
    //    UIImageWriteToSavedPhotosAlbum(maskedImage, self, @selector(savingImageIsFinished:
    //                                                             didFinishSavingWithError:
    //                                                                          contextInfo:),
    //                                   nil);
}

// 保存が完了したら呼ばれるメソッド
- (void)savingImageIsFinished:(UIImage*)image
     didFinishSavingWithError:(NSError*)error
                  contextInfo:(void*)contextInfo
{
}

- (void)displayPreview
{
    _extractPreviewView.begin = _beginPoint;
    _extractPreviewView.end = _endPoint;

    [_extractPreviewView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
