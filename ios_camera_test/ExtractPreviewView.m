//
//  ExtractPreviewView.m
//  ios_camera_test
//
//  Created by 川上 基樹 on 2014/03/26.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import "ExtractPreviewView.h"

@implementation ExtractPreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath* circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.begin.x, self.begin.y, self.end.x-self.begin.x, self.end.y-self.begin.y)];
    [[UIColor greenColor] setStroke];

    circle.lineWidth = 1;
    [circle stroke];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
