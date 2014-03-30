//
//  PitchIndicatorView.m
//  ios_camera_test
//
//  Created by mothule on 2014/03/30.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import "PitchIndicatorView.h"

@implementation PitchIndicatorView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    const CGFloat lineWidth = 10.0;
    const CGFloat heightHalf = rect.size.height / 2.0;
    const CGFloat offset = rect.origin.y + heightHalf;

    // 色の設定
    [[UIColor colorWithRed:1
                     green:0
                      blue:0
                     alpha:1] setStroke];

    //
    CGFloat s = offset;

    CGFloat e = heightHalf / 90.0 * (RadToDeg(self.targetAngle) - RadToDeg(self.currentAngle));
    CGRect bezierRect = CGRectMake(lineWidth/2.0, s, 0.0, e);

    // 描画
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:bezierRect];
    [path setLineWidth:lineWidth];
    path.flatness = 0.6f;
    [path stroke];
}

@end
