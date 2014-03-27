//
//  Posture.h
//  ios_camera_test
//
//  Created by mothule on 2014/03/27.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
*  撮影時の姿勢.
*/
@interface Posture : NSObject
@property (nonatomic, assign) float yaw;
@property (nonatomic, assign) float pitch;
@property (nonatomic, assign) float roll;
@property (nonatomic, assign) float distance; // 対象物との距離
@property (nonatomic, assign) float height; // 撮影時の高さ
@end
