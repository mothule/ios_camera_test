//
//  PlaceSimulateViewController.m
//  ios_camera_test
//
//  Created by 川上 基樹 on 2014/03/27.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import "PlaceSimulateViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PlaceSimulateViewController () {
    __weak IBOutlet UIView* _previewView;
    __weak IBOutlet UIImageView* _combineSourceImageView;
}

@property (strong, nonatomic) AVCaptureDeviceInput* videoInput;
@property (strong, nonatomic) AVCaptureStillImageOutput* stillImageOutput;
@property (strong, nonatomic) AVCaptureSession* session;

@end

@implementation PlaceSimulateViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  ビューロード直後
 */
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 合成イメージを表示
    [_combineSourceImageView setImage:_combineImage];

    // 撮影開始
    [self setupAVCapture];
}
/**
 *  メモリ不足
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAVCapture
{
    NSError* error = nil;

    // 入力と出力からキャプチャーセッションを作成
    self.session = [[AVCaptureSession alloc] init];

    // 正面に配置されているカメラを取得
    AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    // カメラからの入力を作成し、セッションに追加
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera
                                                             error:&error];
    [self.session addInput:self.videoInput];

    // 画像への出力を作成し、セッションに追加
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.session addOutput:self.stillImageOutput];

    // キャプチャーセッションから入力のプレビュー表示を作成
    AVCaptureVideoPreviewLayer* captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.frame = self.view.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    // レイヤーをViewに設定
    CALayer* previewLayer = _previewView.layer;
    previewLayer.masksToBounds = YES;
    [previewLayer addSublayer:captureVideoPreviewLayer];

    // セッション開始
    [self.session startRunning];
}

- (IBAction)takePhoto:(id)sender
{
    // ビデオ入力のAVCaptureConnectionを取得
    AVCaptureConnection* videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];

    if (videoConnection == nil) {
        return;
    }

    // ビデオ入力から画像を非同期で取得。ブロックで定義されている処理が呼び出され、画像データを引数から取得する
    [self.stillImageOutput
        captureStillImageAsynchronouslyFromConnection:videoConnection
                                    completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError* error) {
         if (imageDataSampleBuffer == NULL) {
             return;
         }
         
         // 入力された画像データからJPEGフォーマットとしてデータを取得
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         
         // JPEGデータからUIImageを作成
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         // アルバムに画像を保存
         UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
                                    }];
}
- (IBAction)touchCancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
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
