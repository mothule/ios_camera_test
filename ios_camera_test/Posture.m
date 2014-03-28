//
//  Posture.m
//  ios_camera_test
//
//  Created by mothule on 2014/03/27.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import "Posture.h"

@implementation Posture

/**
 *  初期化
 */
- (instancetype)initWithRotation:(Rotation*)rot Position:(Position*)pos
{
    if (self = [super init]) {
        self.rotation = rot;
        self.position = pos;
    }
    return self;
}

/**
 *  渡された姿勢との差分姿勢を返す
 *
 *  @param posture 対象姿勢オブジェクト
 *
 *  @return 差分姿勢
 */
- (Posture*)differenceBetweenPosture:(Posture*)posture
{
    Position* diffPos = [self.position differenceBetweenPosition:posture.position];
    Rotation* diffRot = [self.rotation differenceBetweenRotation:posture.rotation];
    return [[Posture alloc] initWithRotation:diffRot
                                    Position:diffPos];
}

@end
