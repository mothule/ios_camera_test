//
//  ImageExtractViewController.m
//  ios_camera_test
//
//  Created by 川上 基樹 on 2014/03/26.
//  Copyright (c) 2014年 mothule. All rights reserved.
//

#import "ImageExtractViewController.h"

@interface ImageExtractViewController () {
    CGPoint _beginPoint;
    CGPoint _endPoint;
    BOOL _isDragging;
}

@end

@implementation ImageExtractViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"ImageExtractViewController::initWithNibName");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  タッチ開始
 *
 *  @param touches
 *  @param event
 */
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint p = [[touches anyObject] locationInView:self.view];
    NSLog(@"Start:x:%.1f y:%.1f", p.x, p.y);
    _beginPoint = p;
    _isDragging = YES;
}
/**
 *  タッチ終了
 *
 *  @param touches
 *  @param event   
 */
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint p = [[touches anyObject] locationInView:self.view];
    NSLog(@"Goal:x:%.1f y:%.1f", p.x, p.y);
    _endPoint = p;
    _isDragging = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
