//
//  PitchIndicatorView.h
//  ios_camera_test
//
//  Created by mothule on 2014/03/30.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PitchIndicatorView : UIView

@property (nonatomic, assign) double targetAngle; // 目標角度
@property (nonatomic, assign) double currentAngle; // 現在角度

@end
