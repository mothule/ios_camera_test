//
//  Position.h
//  ios_camera_test
//
//  Created by 川上 基樹 on 2014/03/28.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  位置データ
 *  X軸は使わないので宣言しない.
 */
@interface Position : NSObject
@property (nonatomic, assign) float z; // 対象物との距離
@property (nonatomic, assign) float y; // 撮影時の高さ

/**
 *  初期化
 */
- (instancetype)initWithAxisZ:(float)z axisY:(float)y;

/**
 *  対象Position間との差分
 *
 *  @param position 対象位置
 *
 *  @return 差分
 */
- (Position*)differenceBetweenPosition:(Position*)position;

@end
