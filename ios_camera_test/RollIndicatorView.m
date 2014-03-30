//
//  RollIndicatorView.m
//  ios_camera_test
//
//  Created by mothule on 2014/03/29.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import "RollIndicatorView.h"


@implementation RollIndicatorView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGPoint center = CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.5);
    CGFloat lineWidth = 10.0;
    CGFloat min = MIN(rect.size.height, rect.size.width);
    CGFloat radius = (min * 0.5) - (lineWidth * 0.5);

    // 円弧を描く。
    const CGFloat deltaArc1 = RadToDeg(self.targetAngle) - RadToDeg(self.currentAngle);
    const CGFloat offset = 270.0;
    const CGFloat intervalAngle = deltaArc1 / 20.0;

//    NSString* text = [NSString stringWithFormat:@"Target:%f\nCurrent:%f\nDelta:%f", RadToDeg(self.targetAngle), RadToDeg(self.currentAngle), deltaArc1];
//    [text drawInRect:CGRectMake(rect.size.width / 2, rect.size.height / 2, rect.size.width / 2, rect.size.height / 2)
//        withAttributes:nil];

    for (int i = 0; i < 20; i++) {
        // 色の設定
        CGFloat red = 255.0 / (CGFloat)i;
        [[UIColor colorWithRed:red
                         green:0.0f
                          blue:0.0f
                         alpha:1.0f] setStroke];

        //
        CGFloat rs = offset + (CGFloat)(i + 0) * intervalAngle;
        CGFloat re = offset + (CGFloat)(i + 1) * intervalAngle;

        CGFloat start = MIN(rs, re);
        CGFloat end = MAX(rs, re);

        UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:center
                                                             radius:radius
                                                         startAngle:DegToRad(start)
                                                           endAngle:DegToRad(end)
                                                          clockwise:YES];
        aPath.flatness = 0.6f;
        [aPath setLineWidth:lineWidth];
        [aPath stroke];
    }
}

@end
