//
//  Position.m
//  ios_camera_test
//
//  Created by 川上 基樹 on 2014/03/28.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import "Position.h"

@implementation Position

/**
 *  初期化
 */
- (instancetype)initWithAxisZ:(float)z axisY:(float)y
{
    if (self = [super init]) {
        self.z = z;
        self.y = y;
    }
    return self;
}

/**
 *  対象Position間との差分
 *
 *  @param position 対象位置
 *
 *  @return 差分
 */
- (Position*)differenceBetweenPosition:(Position*)position
{
    return [[Position alloc] initWithAxisZ:self.z - position.z
                                     axisY:self.y - position.y];
}

@end
