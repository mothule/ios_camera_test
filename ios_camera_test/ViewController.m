//
//  ViewController.m
//  ios_camera_test
//
//  Created by 川上 基樹 on 2014/03/26.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import "ViewController.h"
#import "ImageExtractViewController.h"
#import "PlaceSimulateViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <MessageUI/MessageUI.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate> {
    BOOL _isShooting;
    BOOL _isSelectImage;
    __weak IBOutlet UIImageView* _previewImageView;

    CMMotionManager* _motionManager;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = 1.0 / 1.0; // 1Hzサンプリング
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [_motionManager stopDeviceMotionUpdates];
}
/**
 *  撮影ボタン押下
 *
 *  @param sender
 */
- (IBAction)onTouchShootingButton:(id)sender
{
    // ジャイロデータ取得開始
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [_motionManager startDeviceMotionUpdatesToQueue:queue
                                        withHandler:^(CMDeviceMotion* motion, NSError* error) {
                                            double pitchDegree = motion.attitude.pitch * 180.0 / M_PI;
                                            double rollDegree = motion.attitude.roll * 180.0 / M_PI;
                                            double yawDegree = motion.attitude.yaw * 180.0 / M_PI;
                                            NSLog(@"Yaw %03.1f Pitch:%03.1f Roll:%03.1f", yawDegree, pitchDegree, rollDegree);
                                        }];

    [self showUIImagePicker];
}

/**
 *  画像選択ボタン押下
 *
 *  @param sender 
 */
- (IBAction)onTouchPickImageButton:(id)sender
{
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    _isShooting = NO;
    _isSelectImage = YES;

    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                         NSLog(@"Complete presentViewController of UIImagePickerController");
                     }];
}
/**
 *  画像編集ボタン押下
 *
 *  @param sender 
 */
- (IBAction)onTouchEditImageButton:(id)sender
{
    //    ImageExtractViewController* ctrl = [[ImageExtractViewController alloc] init];
    //    ctrl.editTargetImage = _previewImageView.image;
    //
    //    NSLog(@"画像編集画面の表示");
    //    [self presentViewController:ctrl
    //                       animated:YES
    //                     completion:nil];
}

/**
*  送信ボタンを押下
*
*  @param sender
*/
- (IBAction)touchSendButton:(id)sender
{
    MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;

    [mailer setSubject:@"家具設置シミュレータによるメール"]; // 件名
    NSData* pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation(_previewImageView.image)];
    [mailer addAttachmentData:pngData
                     mimeType:@"image/png"
                     fileName:@"image"];
    [mailer setMessageBody:@"添付の画像を保存して、下記のURLを押してアプリを開いてください。app_name://mothule.jp/posture"
                    isHTML:YES];
    [self presentViewController:mailer
                       animated:YES
                     completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result) {
    case MFMailComposeResultCancelled:
        break;
    case MFMailComposeResultSaved:
        break;
    case MFMailComposeResultSent:
        break;
    case MFMailComposeResultFailed:
        break;

    default:
        break;
    }

    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

/**
 *  カメラからのImagePicker表示
 */
- (void)showUIImagePicker
{
    // カメラが使用可能かどうか判定する
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }

    // UIImagePickerControllerのインスタンスを生成
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];

    // デリゲートを設定
    imagePickerController.delegate = self;

    // 画像の取得先をカメラに設定
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

    // 画像取得後に編集するかどうか（デフォルトはNO）
    imagePickerController.allowsEditing = YES;

    _isShooting = YES;
    _isSelectImage = NO;

    // 撮影画面をモーダルビューとして表示する
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:nil];
}

// 画像が選択された時に呼ばれるデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController*)picker
        didFinishPickingImage:(UIImage*)image
                  editingInfo:(NSDictionary*)editingInfo
{
    // モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES
                             completion:nil];

    if (_isShooting) {
        // 渡されてきた画像をフォトアルバムに保存
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(targetImage:
                                                        didFinishSavingWithError:
                                                                     contextInfo:),
                                       NULL);
    }
    if (_isSelectImage) {
        [_previewImageView setImage:image];
    }
}

// 画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    // モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES
                             completion:nil];

    // キャンセルされたときの処理を記述・・・
}

// 画像の保存完了時に呼ばれるメソッド
- (void)targetImage:(UIImage*)image
    didFinishSavingWithError:(NSError*)error
                 contextInfo:(void*)context
{
    if (error) {
        // 保存失敗時の処理
    } else {
        // 保存成功時の処理
    }
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    NSLog(@"Segue Name is %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"edit"]) {
        ImageExtractViewController* ctrl = [segue destinationViewController];
        ctrl.editTargetImage = _previewImageView.image;

    } else if ([segue.identifier isEqualToString:@"simulate"]) {
        PlaceSimulateViewController* ctrl = [segue destinationViewController];
        ctrl.combineImage = _previewImageView.image;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
