//
//  Rotation.h
//  ios_camera_test
//
//  Created by 川上 基樹 on 2014/03/28.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  回転データ.単位はラジアン
 */
@interface Rotation : NSObject
@property (nonatomic, assign) double yaw;
@property (nonatomic, assign) double pitch;
@property (nonatomic, assign) double roll;

/**
 *  初期化
 */
- (instancetype)initWithYaw:(double)yaw pitch:(double)pitch roll:(double)roll;

- (double)degreeYaw;

/**
 *  対象Rotationとの差分
 *
 *  @param rotation 対象Rotation
 *
 *  @return 差分
 */
-(Rotation*) differenceBetweenRotation:(Rotation*)rotation;


@end
