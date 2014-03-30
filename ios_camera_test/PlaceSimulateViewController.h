//
//  PlaceSimulateViewController.h
//  ios_camera_test
//
//  Created by 川上 基樹 on 2014/03/27.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Posture;
@interface PlaceSimulateViewController : UIViewController

@property (nonatomic, strong) UIImage* combineImage;
@property (nonatomic, weak) Posture* targetPosture;

@end
