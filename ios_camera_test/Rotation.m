//
//  Rotation.m
//  ios_camera_test
//
//  Created by 川上 基樹 on 2014/03/28.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import "Rotation.h"

@implementation Rotation

/**
 *  初期化
 */
- (instancetype)initWithYaw:(double)yaw pitch:(double)pitch roll:(double)roll
{
    if (self = [super init]) {
        self.yaw = yaw;
        self.pitch = pitch;
        self.roll = roll;
    }
    return self;
}

- (double)degreeYaw
{
    return self.yaw * 180.0 / M_PI;
}

/**
 *  対象Rotationとの差分
 *
 *  @param rotation 対象Rotation
 *
 *  @return 差分
 */
- (Rotation*)differenceBetweenRotation:(Rotation*)rotation
{
    return [[Rotation alloc] initWithYaw:self.yaw - rotation.yaw
                                   pitch:self.pitch - rotation.pitch
                                    roll:self.roll - rotation.roll];
}

@end
