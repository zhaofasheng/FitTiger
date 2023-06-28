//
//  NoticeViewModel.m
//  NoticeXi
//
//  Created by li lei on 2019/1/31.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeViewModel.h"

@implementation NoticeViewModel

+ (void)getLiuXingDonghue:(UIImageView *)imageView{
    CAEmitterLayer *rainEmitter = [CAEmitterLayer layer];
    [rainEmitter setEmitterPosition:CGPointMake(-DR_SCREEN_WIDTH, 0)];
    [rainEmitter setEmitterSize:CGSizeMake(4000, 0)];
    [rainEmitter setEmitterMode:kCAEmitterLayerCuboid];//模式
    [rainEmitter setEmitterShape:kCAEmitterLayerLine];//形状
    [rainEmitter setRenderMode:kCAEmitterLayerAdditive];
    
    CAEmitterCell *rainFlake = [CAEmitterCell emitterCell];
    [rainFlake setBirthRate:2];
    [rainFlake setVelocity:300.0];//速度范围
    [rainFlake setVelocityRange:DR_SCREEN_WIDTH];
    [rainFlake setYAcceleration:0];
    [rainFlake setScale:0.3];
    [rainFlake setLifetime:18];
    [rainFlake setScaleSpeed:0.1];
    
    [rainFlake setEmissionLongitude:-0.625*M_PI];
    [rainFlake setContents:(id)[UIImageNamed(@"Image_liuxing") CGImage]];
    [rainFlake setColor:[[UIColor colorWithHexString:WHITEMAINCOLOR] CGColor]];
    
    [rainEmitter setEmitterDepth:10];
    rainEmitter.shadowOpacity = 0;
    rainEmitter.shadowRadius = 0;
    rainEmitter.emitterCells = [NSArray arrayWithObject:rainFlake];
    [imageView.layer addSublayer:rainEmitter];
}
@end
