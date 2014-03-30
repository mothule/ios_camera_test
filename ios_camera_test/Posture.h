//
//  Posture.h
//  ios_camera_test
//
//  Created by mothule on 2014/03/27.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rotation.h"
#import "Position.h"
#import "PostureDisplayDto.h"

/**
*  撮影時の姿勢.
*/
@interface Posture : NSObject
@property (nonatomic, strong) Rotation* rotation; // Yaw Pitch Roll
@property (nonatomic, strong) Position* position; // カメラと対象物との位置

/**
 *  初期化
 */
- (instancetype)initWithRotation:(Rotation*)rot Position:(Position*)pos;

/**
 *  渡された姿勢との差分姿勢を返す
 *
 *  @param posture 対象姿勢オブジェクト
 *
 *  @return 差分姿勢
 */
- (Posture*)differenceBetweenPosture:(Posture*)posture;

@end
