//
//  PlaceSimulateViewController.m
//  ios_camera_test
//
//  Created by 川上 基樹 on 2014/03/27.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import "PlaceSimulateViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Posture.h"
#import <CoreMotion/CoreMotion.h>
#import "RollIndicatorView.h"
#import "PitchIndicatorView.h"

@interface PlaceSimulateViewController () {
    __weak IBOutlet UIView* _previewView;
    __weak IBOutlet UIImageView* _combineSourceImageView;
    __weak IBOutlet UILabel* _postureLabel;
    CMMotionManager* _motionManager;
    Posture* _currentPosture;
    __weak IBOutlet RollIndicatorView* _rollIndicatorView;
    __weak IBOutlet PitchIndicatorView* _pitchIndicatorView;
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

    _currentPosture = [[Posture alloc] init];

    // 合成イメージを表示
    [_combineSourceImageView setImage:_combineImage];

    // 撮影開始
    [self setupAVCapture];

    // TODO : Device Motionで回転データを取得できるようにする
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = 1.0 / 10.0; // 1Hzサンプリング

    // TODO : 回転データ受け取ったら差分をラベルに表示できるようにする
}

int i = 0;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 姿勢変更通知の登録
    [_currentPosture addObserver:self
                      forKeyPath:@"rotation"
                         options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                         context:nil];

    // ジャイロデータ取得開始
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [_motionManager startDeviceMotionUpdatesToQueue:queue
                                        withHandler:^(CMDeviceMotion* motion, NSError* error) {
                                            CMAttitude* attr = motion.attitude;
                                            
                                            // main thread で 更新する
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                _currentPosture.rotation = [[Rotation alloc] initWithYaw:attr.yaw pitch:attr.pitch roll:attr.roll];
                                            });
                                        }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [_currentPosture removeObserver:self
                         forKeyPath:@"rotation"];

    [_motionManager stopDeviceMotionUpdates];
}

/**
*  KVOを受信
*
*  @param keyPath
*  @param object
*  @param change
*  @param context
*/
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (object == _currentPosture) {
        Posture* diff = [self.targetPosture differenceBetweenPosture:_currentPosture];
        _postureLabel.text = [diff description];

        _rollIndicatorView.targetAngle = self.targetPosture.rotation.roll;
        _rollIndicatorView.currentAngle = _currentPosture.rotation.roll;
        [_rollIndicatorView setNeedsDisplay];

        _pitchIndicatorView.targetAngle = self.targetPosture.rotation.pitch;
        _pitchIndicatorView.currentAngle = _currentPosture.rotation.pitch;
        [_pitchIndicatorView setNeedsDisplay];
    }
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
