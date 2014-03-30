//
//  MathUtils.h
//  ios_camera_test
//
//  Created by mothule on 2014/03/30.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef RadToDeg
#define RadToDeg(Radian) (Radian * 180.0 / M_PI)
#endif

#ifndef DegToRad
#define DegToRad(Degree) (Degree* M_PI / 180.0)
#endif

@interface MathUtils : NSObject

@end
