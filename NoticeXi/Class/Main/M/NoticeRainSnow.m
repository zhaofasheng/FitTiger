//
//  NoticeRainSnow.m
//  NoticeXi
//
//  Created by li lei on 2019/3/6.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeRainSnow.h"

@implementation NoticeRainSnow

- (void)dissAllLayer{
    if (self.addLayer) {
        [self.addLayer removeFromSuperlayer];
    }
}

- (void)rainIn:(UIView *)layerView{
    if (self.addLayer) {
        [self.addLayer removeFromSuperlayer];
    }
    // 使用背板视图来作为载体
    UIView *rootWindow =  [UIApplication sharedApplication].keyWindow;
    // 创建粒子发射器图层
    CAEmitterLayer *rainEmitterLayer = [CAEmitterLayer layer];
    self.addLayer = rainEmitterLayer;
    // 设置属性
    // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
    rainEmitterLayer.emitterShape = kCAEmitterLayerLine;
    [rainEmitterLayer  setEmitterDepth:10];
    // 发射模式
    rainEmitterLayer.emitterMode = kCAEmitterLayerCuboid;
    // 发射源的size 据定了发射源的大小 (有倾斜度，我们需要加宽发射源)
    rainEmitterLayer.emitterSize = rootWindow.frame.size;
    // 发射源的位置 从屏幕上方往下发射
    rainEmitterLayer.emitterPosition = CGPointMake(rootWindow.frame.size.width*0.5, -150);
    // 渲染模式，暂不使用
    
    // 添加到目标视图的layer上
    [layerView.layer addSublayer:rainEmitterLayer];
    
    // 配置粒子Cell
    CAEmitterCell  *rainCell = [CAEmitterCell emitterCell];
    // 设置粒子图片
    rainCell.contents = (id)[[UIImage imageNamed:@"rain"]CGImage];
    
    // 组1
    // 设置粒子产生率
    rainCell.birthRate = 1.3f;
    // 设置粒子生命周期
    rainCell.lifetime =18.f;
    // 设置粒子持续时间，持续时间制约粒子生命周期
    rainCell.speed = 1.f;
    // 组2
    // 设置粒子速度
    rainCell.velocity = 3.f;
    // 设置粒子速度范围
    rainCell.velocityRange = DR_SCREEN_WIDTH;
    // 设置粒子下落加速度 Y轴
    rainCell.yAcceleration = 1200.f;
    rainCell.scaleSpeed = 0.1;
    /**
     ⭐️ 因为所谓“文艺下雨”的图片雨点是向右下方倾斜的，所以我们在调整Y轴加速度的同时也要修改 X轴 的加速度，让图片看着是往右下方前进的
     ⭐️ 修改了 X轴 的数据之后发现动画会缺失，嗯，因为发射器的平面从屏幕的长方体变成了平行四边形，所以，出现了缺失这时候我们需要把 emitterlayer的frame调整的更大，具体来说应该是更宽
     */
    //rainCell.xAcceleration = 300.f;
    
    // 组3 雨图片需要缩放统一大小 不能使用范围
    // 设置缩放比例
    rainCell.scale = 0.2f;
    
    // 设置粒子颜色 会附和图片修改图片颜色
    rainCell.color = [[UIColor whiteColor]CGColor];
    // 配置粒子Cell
    CAEmitterCell *rainCell1 = [CAEmitterCell emitterCell];
    // 设置粒子图片
    rainCell1.contents = (id)[[UIImage imageNamed:@"rain"]CGImage];
    
    // 组1
    // 设置粒子产生率
    rainCell1.birthRate = 2.0f;
    // 设置粒子生命周期
    rainCell1.lifetime =18.f;
    // 设置粒子持续时间，持续时间制约粒子生命周期
    rainCell1.speed = 1.f;
    // 组2
    // 设置粒子速度
    rainCell1.velocity = 1.f;
    // 设置粒子速度范围
    rainCell1.velocityRange = DR_SCREEN_WIDTH;
    // 设置粒子下落加速度 Y轴
    rainCell1.yAcceleration = 300.f;
    rainCell1.scaleSpeed = 0.05;
    /**
     ⭐️ 因为所谓“文艺下雨”的图片雨点是向右下方倾斜的，所以我们在调整Y轴加速度的同时也要修改 X轴 的加速度，让图片看着是往右下方前进的
     ⭐️ 修改了 X轴 的数据之后发现动画会缺失，嗯，因为发射器的平面从屏幕的长方体变成了平行四边形，所以，出现了缺失这时候我们需要把 emitterlayer的frame调整的更大，具体来说应该是更宽
     */
    //rainCell.xAcceleration = 300.f;
    
    // 组3 雨图片需要缩放统一大小 不能使用范围
    // 设置缩放比例
    rainCell1.scale = 0.2f;
    // 设置缩放范围
    rainCell1.scaleRange = 0.05f;
    // 设置粒子颜色 会附和图片修改图片颜色
    rainCell1.color = [[UIColor whiteColor]CGColor];
    
    // 添加到粒子发射器
    rainEmitterLayer.emitterCells = @[rainCell,rainCell1];
}

- (void)snowIn:(UIView *)layerView{
    // 使用背板视图来作为载体
    UIView *rootWindow =  [UIApplication sharedApplication].keyWindow;
    if (self.addLayer) {
        [self.addLayer removeFromSuperlayer];
    }
    // 设置发射器图层
    CAEmitterLayer* snowEmitterlayer = [CAEmitterLayer layer];
    // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
    snowEmitterlayer.emitterShape = kCAEmitterLayerCircle;
    // 发射模式
    snowEmitterlayer.emitterMode = kCAEmitterLayerVolume;
    // 发射源的size 据定了发射源的大小
    snowEmitterlayer.emitterSize = rootWindow.frame.size;
    snowEmitterlayer.preservesDepth = YES;
    // 发射源的位置 从屏幕上方往下发射
    snowEmitterlayer.emitterPosition = CGPointMake(rootWindow.frame.size.width*0.5, -20);
    // 渲染模式，暂不使用
    self.addLayer = snowEmitterlayer;
    [layerView.layer addSublayer:snowEmitterlayer];
    
    NSMutableArray *array = [NSMutableArray array];//CAEmitterCell数组，存放不同的CAEmitterCell，我这里准备了四张不同形态的叶子图片。
    for (int i = 0; i<2; i++) {
        NSString *imageName =  @"pappap";
        
        CAEmitterCell *leafCell = [CAEmitterCell emitterCell];
        leafCell.birthRate = 0.5;//粒子产生速度
        leafCell.lifetime = 50;//粒子存活时间
        
        leafCell.velocity = 2;//初始速度
        leafCell.velocityRange = 1;//初始速度的差值区间，所以初始速度为5~15，后面属性range算法相同
        
        leafCell.yAcceleration = 3;//y轴方向的加速度，落叶下飘只需要y轴正向加速度。
        
        leafCell.spin = 1.0;//粒子旋转速度
        leafCell.spinRange = 2.0;//粒子旋转速度范围
        
        leafCell.emissionRange = M_PI;//粒子发射角度范围
        
        leafCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];//粒子图片
        
        leafCell.scale = 0.2;//缩放比例
        leafCell.scaleRange = 0.01;//缩放比例
        
        
        [array addObject:leafCell];
    }
    // 添加到粒子发射器
    snowEmitterlayer.emitterCells = array;
}

- (void)backSnow:(UIView *)layerView{
    // 使用背板视图来作为载体
    UIView *rootWindow =  layerView;
    if (self.addLayer) {
        [self.addLayer removeFromSuperlayer];
    }
    // 设置发射器图层
    CAEmitterLayer* snowEmitterlayer = [CAEmitterLayer layer];
    // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
    snowEmitterlayer.emitterShape = kCAEmitterLayerLine;
    // 发射模式
    snowEmitterlayer.emitterMode =  kCAEmitterLayerSurface;
    // 发射源的size 据定了发射源的大小
    snowEmitterlayer.emitterSize = rootWindow.frame.size;
    // 发射源的位置 从屏幕上方往下发射
    snowEmitterlayer.emitterPosition = CGPointMake(rootWindow.frame.size.width*0.5, -5);
    // 渲染模式，暂不使用
    self.addLayer = snowEmitterlayer;
    [layerView.layer addSublayer:snowEmitterlayer];
    NSArray *xAction = @[@"-1",@"0",@"1",@"0",@"2",@"-2",@"1",@"0",@"0",@"1",@"0",@"1"];
    NSMutableArray *array = [NSMutableArray array];//CAEmitterCell数组，存放不同的CAEmitterCell，我这里准备了四张不同形态的叶子图片。
    for (int i = 0; i<4; i++) {
        NSString *imageName = [NoticeTools isWhiteTheme]? @"twosnow":@"twosnowy";
        
        CAEmitterCell *leafCell = [CAEmitterCell emitterCell];
        leafCell.birthRate = 0.5;//粒子产生速度
        leafCell.lifetime = 25;//粒子存活时间
        
        leafCell.velocity = 1;//初始速度
        leafCell.velocityRange = 2;//初始速度的差值区间，所以初始速度为5~15，后面属性range算法相同
        
        leafCell.yAcceleration = 6;//y轴方向的加速度，落叶下飘只需要y轴正向加速度。
        NSInteger tag = arc4random() % (xAction.count-1);
        leafCell.xAcceleration = [xAction[tag] intValue];
        leafCell.spin = 1.0;//粒子旋转速度
        leafCell.spinRange = 2.0;//粒子旋转速度范围
        
        leafCell.emissionRange = M_PI;//粒子发射角度范围
        
        leafCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];//粒子图片
        
        leafCell.scale = 0.3;//缩放比例
        leafCell.scaleRange = 0.2;//缩放比例
        leafCell.color = [[UIColor whiteColor] colorWithAlphaComponent:1].CGColor;
        leafCell.alphaSpeed = [NoticeTools isWhiteTheme]? -0.04:-0.12;
        [array addObject:leafCell];
    }
    // 添加到粒子发射器
    snowEmitterlayer.emitterCells = array;
}

- (void)backFlower:(UIView *)layerView{
    // 使用背板视图来作为载体
    if (self.addLayer) {
        [self.addLayer removeFromSuperlayer];
    }
    // 设置发射器图层
    CAEmitterLayer* snowEmitterlayer = [CAEmitterLayer layer];
    // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
    snowEmitterlayer.emitterShape = kCAEmitterLayerLine;
    // 发射模式
    snowEmitterlayer.emitterMode =  kCAEmitterLayerSurface;
    // 发射源的size 据定了发射源的大小
    snowEmitterlayer.emitterSize = CGSizeMake(layerView.frame.size.width, layerView.frame.size.height-([NoticeTools isWhiteTheme]?50:0));
    // 发射源的位置 从屏幕上方往下发射
    snowEmitterlayer.emitterPosition = CGPointMake(0,-10);
    // 渲染模式，暂不使用
    self.addLayer = snowEmitterlayer;
    [layerView.layer addSublayer:snowEmitterlayer];
    NSArray *xAction = @[@"-5",@"3",@"6",@"9",@"2",@"7",@"3",@"5",@"-1",@"6",@"13",@"8",@"4",@"11",@"6"];
    NSArray *imgArr = [NoticeTools isWhiteTheme]?@[@"flower0",@"flower1"]:@[@"flower0y",@"flower1y"];
    NSMutableArray *array = [NSMutableArray array];//CAEmitterCell数组，存放不同的CAEmitterCell，我这里准备了四张不同形态的叶子图片。
    for (int i = 0; i< ([NoticeTools isWhiteTheme]?7:4); i++) {
        NSString *imageName = imgArr[arc4random()%2];
        
        CAEmitterCell *leafCell = [CAEmitterCell emitterCell];
        leafCell.birthRate = 1;//粒子产生速度
        leafCell.lifetime = 25;//粒子存活时间
        
        leafCell.velocity = 1;//初始速度
        leafCell.velocityRange = 2;//初始速度的差值区间，所以初始速度为5~15，后面属性range算法相同
        
        
        NSInteger tag = arc4random() % (xAction.count-1);
        leafCell.xAcceleration = 20;
        leafCell.yAcceleration = [NoticeTools isWhiteTheme]? [xAction[tag] intValue]+3 : 10+(arc4random()%10);//y轴方向的加速度，落叶下飘只需要y轴正向加速度。
        leafCell.spin = 1.0;//粒子旋转速度
        leafCell.spinRange = 2.0;//粒子旋转速度范围
        
        leafCell.emissionRange = M_PI;//粒子发射角度范围
        
        leafCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];//粒子图片
        
        leafCell.scale = 0.2;//缩放比例
        leafCell.scaleRange = 0.2;//缩放比例
        leafCell.color = [[UIColor whiteColor] colorWithAlphaComponent:1].CGColor;
        leafCell.alphaSpeed = [NoticeTools isWhiteTheme]? -0.04:-0.1;
        [array addObject:leafCell];
    }
    // 添加到粒子发射器
    snowEmitterlayer.emitterCells = array;
}

- (void)backFengYe:(UIView *)layerView{
    if (![NoticeTools isWhiteTheme]) {
        // 使用背板视图来作为载体
        if (self.addLayer) {
            [self.addLayer removeFromSuperlayer];
        }
        // 设置发射器图层
        CAEmitterLayer* snowEmitterlayer = [CAEmitterLayer layer];
        // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
        snowEmitterlayer.emitterShape = kCAEmitterLayerLine;
        // 发射模式
        snowEmitterlayer.emitterMode =  kCAEmitterLayerSurface;
        // 发射源的size 据定了发射源的大小
        snowEmitterlayer.emitterSize = CGSizeMake(layerView.frame.size.width, layerView.frame.size.height-([NoticeTools isWhiteTheme]?50:0));
        // 发射源的位置 从屏幕上方往下发射
        snowEmitterlayer.emitterPosition = CGPointMake(0,-10);
        // 渲染模式，暂不使用
        self.addLayer = snowEmitterlayer;
        [layerView.layer addSublayer:snowEmitterlayer];
        NSArray *xAction = @[@"-5",@"3",@"6",@"9",@"2",@"7",@"3",@"5",@"-1",@"6",@"13",@"8",@"4",@"11",@"6"];
        NSMutableArray *array = [NSMutableArray array];//CAEmitterCell数组，存放不同的CAEmitterCell，我这里准备了四张不同形态的叶子图片。
        for (int i = 0; i< 3; i++) {
            NSString *imageName = @"fengyey";
            
            CAEmitterCell *leafCell = [CAEmitterCell emitterCell];
            leafCell.birthRate = 0.8;//粒子产生速度
            leafCell.lifetime = 25;//粒子存活时间
            
            leafCell.velocity = 1;//初始速度
            leafCell.velocityRange = 2;//初始速度的差值区间，所以初始速度为5~15，后面属性range算法相同
            
            
            NSInteger tag = arc4random() % (xAction.count-1);
            leafCell.xAcceleration = 15;
            leafCell.yAcceleration = [xAction[tag] intValue]+3;//y轴方向的加速度，落叶下飘只需要y轴正向加速度。
            leafCell.spin = 1.0;//粒子旋转速度
            leafCell.spinRange = 2.0;//粒子旋转速度范围
            
            leafCell.emissionRange = M_PI;//粒子发射角度范围
            
            leafCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];//粒子图片
            
            leafCell.scale = 0.2;//缩放比例
            leafCell.scaleRange = 0.2;//缩放比例
            leafCell.color = [[UIColor whiteColor] colorWithAlphaComponent:1].CGColor;
            leafCell.alphaSpeed =  -0.1;
            [array addObject:leafCell];
        }
        // 添加到粒子发射器
        snowEmitterlayer.emitterCells = array;
        return;
    }
    // 使用背板视图来作为载体
    if (self.addLayer) {
        [self.addLayer removeFromSuperlayer];
    }
    // 设置发射器图层
    CAEmitterLayer* snowEmitterlayer = [CAEmitterLayer layer];
    // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
    snowEmitterlayer.emitterShape = kCAEmitterLayerLine;
    // 发射模式
    snowEmitterlayer.emitterMode =  kCAEmitterLayerSurface;
    // 发射源的size 据定了发射源的大小
    snowEmitterlayer.emitterSize = layerView.frame.size;
    // 发射源的位置 从屏幕上方往下发射
    snowEmitterlayer.emitterPosition = CGPointMake(layerView.frame.size.width-60, -25);
    // 渲染模式，暂不使用
    self.addLayer = snowEmitterlayer;
    [layerView.layer addSublayer:snowEmitterlayer];
    NSArray *xAction = @[@"17",@"13",@"12",@"14",@"12",@"13",@"16",@"15",@"11",@"16",@"13",@"19",@"14",@"11",@"13"];
    NSMutableArray *array = [NSMutableArray array];//CAEmitterCell数组，存放不同的CAEmitterCell，我这里准备了四张不同形态的叶子图片。
    for (int i = 0; i< 5; i++) {
        NSString *imageName = @"fengyeb";
        
        CAEmitterCell *leafCell = [CAEmitterCell emitterCell];
        leafCell.birthRate = 0.8;//粒子产生速度
        leafCell.lifetime = 25;//粒子存活时间
        
        leafCell.velocity = 1;//初始速度
        leafCell.velocityRange = 2;//初始速度的差值区间，所以初始速度为5~15，后面属性range算法相同
        
        
        NSInteger tag = arc4random() % (xAction.count-1);
        leafCell.xAcceleration = -18;
        leafCell.yAcceleration = [NoticeTools isWhiteTheme]? [xAction[tag] intValue]+3 : 10+(arc4random()%10);//y轴方向的加速度，落叶下飘只需要y轴正向加速度。
        leafCell.spin = 1.0;//粒子旋转速度
        leafCell.spinRange = 2.0;//粒子旋转速度范围
        
        leafCell.emissionRange = M_PI;//粒子发射角度范围
        
        leafCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];//粒子图片
        
        leafCell.scale = 0.2;//缩放比例
        leafCell.scaleRange = 0.2;//缩放比例
        leafCell.alphaSpeed = -0.15;
        [array addObject:leafCell];
    }
    // 添加到粒子发射器
    snowEmitterlayer.emitterCells = array;
}

- (void)backLuoYe:(UIView *)layerView{
    if ([NoticeTools isWhiteTheme]) {
        UIView *rootWindow =  layerView;
        if (self.addLayer) {
            [self.addLayer removeFromSuperlayer];
        }
        // 设置发射器图层
        CAEmitterLayer* snowEmitterlayer = [CAEmitterLayer layer];
        // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
        snowEmitterlayer.emitterShape = kCAEmitterLayerLine;
        // 发射模式
        snowEmitterlayer.emitterMode =  kCAEmitterLayerSurface;
        // 发射源的size 据定了发射源的大小
        snowEmitterlayer.emitterSize = rootWindow.frame.size;
        // 发射源的位置 从屏幕上方往下发射
        snowEmitterlayer.emitterPosition = CGPointMake(rootWindow.frame.size.width*0.5, -5);
        // 渲染模式，暂不使用
        self.addLayer = snowEmitterlayer;
        [layerView.layer addSublayer:snowEmitterlayer];
        NSArray *imgArr = @[@"luoye1",@"luoye2",@"luoye3",@"luoye4",@"luoye5"];
        //NSArray *xAction = @[@"3",@"5",@"1",@"4",@"2",@"4",@"1",@"3",@"3",@"1",@"4",@"1"];
        NSMutableArray *array = [NSMutableArray array];//CAEmitterCell数组，存放不同的CAEmitterCell，我这里准备了四张不同形态的叶子图片。
        for (int i = 0; i<5; i++) {
            NSString *imageName = imgArr[arc4random()%5];
            
            CAEmitterCell *leafCell = [CAEmitterCell emitterCell];
            leafCell.birthRate = 1;//粒子产生速度
            leafCell.lifetime = 25;//粒子存活时间
            
            leafCell.velocity = 16;//初始速度
            leafCell.velocityRange = 2;//初始速度的差值区间，所以初始速度为5~15，后面属性range算法相同
            
            leafCell.yAcceleration = 30;//y轴方向的加速度，落叶下飘只需要y轴正向加速度。
            //NSInteger tag = arc4random() % (xAction.count-1);
            leafCell.xAcceleration = 10;//[xAction[tag] intValue];
            leafCell.spin = 1.0;//粒子旋转速度
            leafCell.spinRange = 2.0;//粒子旋转速度范围
            leafCell.emissionRange = M_PI;//粒子发射角度范围
            leafCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];//粒子图片
            leafCell.scale = 0.3;//缩放比例
            leafCell.scaleRange = 0.2;//缩放比例-
            leafCell.alphaSpeed = -0.2;
            [array addObject:leafCell];
        }
        // 添加到粒子发射器
        snowEmitterlayer.emitterCells = array;
    }else{
        // 使用背板视图来作为载体
        if (self.addLayer) {
            [self.addLayer removeFromSuperlayer];
        }
        // 设置发射器图层
        CAEmitterLayer* snowEmitterlayer = [CAEmitterLayer layer];
        // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
        snowEmitterlayer.emitterShape = kCAEmitterLayerLine;
        // 发射模式
        snowEmitterlayer.emitterMode =  kCAEmitterLayerSurface;
        // 发射源的size 据定了发射源的大小
        snowEmitterlayer.emitterSize = layerView.frame.size;
        // 发射源的位置 从屏幕上方往下发射
        snowEmitterlayer.emitterPosition = CGPointMake(layerView.frame.size.width-60, -5);
        // 渲染模式，暂不使用
        self.addLayer = snowEmitterlayer;
        [layerView.layer addSublayer:snowEmitterlayer];
        NSArray *imgArr = @[@"luoye1y",@"luoye2y",@"luoye3y",@"luoye4y",@"luoye5y"];
        NSMutableArray *array = [NSMutableArray array];//CAEmitterCell数组，存放不同的CAEmitterCell，我这里准备了四张不同形态的叶子图片。
        for (int i = 0; i< 4; i++) {
            NSString *imageName = imgArr[arc4random()%5];
            CAEmitterCell *leafCell = [CAEmitterCell emitterCell];
            leafCell.birthRate = 0.7;//粒子产生速度
            leafCell.lifetime = 25;//粒子存活时间
            leafCell.velocity = 6;//初始速度
            leafCell.velocityRange = 2;//初始速度的差值区间，所以初始速度为5~15，后面属性range算法相同
            leafCell.xAcceleration = -20;
            leafCell.yAcceleration =  15+(arc4random()%10);//y轴方向的加速度，落叶下飘只需要y轴正向加速度。
            leafCell.spin = 1.0;//粒子旋转速度
            leafCell.spinRange = 2.0;//粒子旋转速度范围
            leafCell.emissionRange = M_PI;//粒子发射角度范围
            leafCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];//粒子图片
            leafCell.scale = 0.25;//缩放比例
            leafCell.scaleRange = 0.25;//缩放比例
            leafCell.alphaSpeed = [NoticeTools isWhiteTheme]? -0.05:-0.1;
            [array addObject:leafCell];
        }
        // 添加到粒子发射器
        snowEmitterlayer.emitterCells = array;
    }
}

- (void)removerDisslayer{
    if (self.addLayer) {
        [self.addLayer removeFromSuperlayer];
    }
}

- (void)backRain:(UIView *)layerView{
    // 使用背板视图来作为载体
    UIView *rootWindow =  layerView;
    if (self.addLayer) {
        [self.addLayer removeFromSuperlayer];
    }
    // 设置发射器图层
    CAEmitterLayer* snowEmitterlayer = [CAEmitterLayer layer];
    // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
    snowEmitterlayer.emitterShape = kCAEmitterLayerLine;
    // 发射模式
    snowEmitterlayer.emitterMode =  kCAEmitterLayerSurface;
    // 发射源的size 据定了发射源的大小
    snowEmitterlayer.emitterSize = rootWindow.frame.size;
    // 发射源的位置 从屏幕上方往下发射
    snowEmitterlayer.emitterPosition = CGPointMake(rootWindow.frame.size.width*0.5,[NoticeTools isWhiteTheme]? -75:-20);
    // 渲染模式，暂不使用
    self.addLayer = snowEmitterlayer;
    [layerView.layer addSublayer:snowEmitterlayer];
    NSMutableArray *array = [NSMutableArray array];//CAEmitterCell数组，存放不同的CAEmitterCell，我这里准备了四张不同形态的叶子图片。
    for (int i = 0; i<4; i++) {
        NSString *imageName = [NoticeTools isWhiteTheme]?@"xieyu":@"xieyuy";
        
        CAEmitterCell *leafCell = [CAEmitterCell emitterCell];
        leafCell.birthRate = [NoticeTools isWhiteTheme]?10:5;//粒子产生速度
        leafCell.lifetime = 50;//粒子存活时间
        
        leafCell.velocity = 10;//初始速度
        leafCell.velocityRange = 20;//初始速度的差值区间，所以初始速度为5~15，后面属性range算法相同
        
        leafCell.yAcceleration = 300;//y轴方向的加速度，落叶下飘只需要y轴正向加速度。

        leafCell.xAcceleration = [NoticeTools isWhiteTheme]?-55:0;
        
        leafCell.emissionRange = M_PI;//粒子发射角度范围
        
        leafCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];//粒子图片
        
        leafCell.scale = 0.2;//缩放比例
        leafCell.scaleRange = 0.4;//缩放比例
        leafCell.color = [[UIColor whiteColor] colorWithAlphaComponent:1].CGColor;
        leafCell.alphaSpeed = [NoticeTools isWhiteTheme]? -0.04:-0.6;
        [array addObject:leafCell];
    }
    // 添加到粒子发射器
    snowEmitterlayer.emitterCells = array;
}

- (void)yeziIn:(UIView *)layerView{
    // 使用背板视图来作为载体
    UIView *rootWindow =  [UIApplication sharedApplication].keyWindow;
    if (self.addLayer) {
        [self.addLayer removeFromSuperlayer];
    }
    // 设置发射器图层
    CAEmitterLayer* snowEmitterlayer = [CAEmitterLayer layer];
    // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
    snowEmitterlayer.emitterShape = kCAEmitterLayerLine;
    // 发射模式
    snowEmitterlayer.emitterMode = kCAEmitterLayerSurface;
    // 发射源的size 据定了发射源的大小
    snowEmitterlayer.emitterSize = rootWindow.frame.size;
    // 发射源的位置 从屏幕上方往下发射
    snowEmitterlayer.emitterPosition = CGPointMake(rootWindow.frame.size.width*0.5, -150);
    // 渲染模式，暂不使用
    self.addLayer = snowEmitterlayer;
    [layerView.layer addSublayer:snowEmitterlayer];
    
    NSMutableArray *array = [NSMutableArray array];//CAEmitterCell数组，存放不同的CAEmitterCell，我这里准备了四张不同形态的叶子图片。
    for (int i = 0; i<1; i++) {
        NSString *imageName = @"yezi1";
        
        CAEmitterCell *leafCell = [CAEmitterCell emitterCell];
        leafCell.birthRate = 1.5;//粒子产生速度
        leafCell.lifetime = 50;//粒子存活时间
        
        leafCell.velocity = 15;//初始速度
        leafCell.velocityRange = 5;//初始速度的差值区间，所以初始速度为5~15，后面属性range算法相同
        
        leafCell.yAcceleration = 30;//y轴方向的加速度，落叶下飘只需要y轴正向加速度。
        
        leafCell.spin = 1.0;//粒子旋转速度
        leafCell.spinRange = 2.0;//粒子旋转速度范围
        
        leafCell.emissionRange = M_PI;//粒子发射角度范围
        
        leafCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];//粒子图片
        
        leafCell.scale = 0.3;//缩放比例
        leafCell.scaleRange = 0.2;//缩放比例
        
        [array addObject:leafCell];
    }
    // 添加到粒子发射器
    snowEmitterlayer.emitterCells = array;
}

- (void)fengyeIn:(UIView *)layerView{
    // 使用背板视图来作为载体
    UIView *rootWindow =  [UIApplication sharedApplication].keyWindow;
    if (self.addLayer) {
        [self.addLayer removeFromSuperlayer];
    }
    // 设置发射器图层
    CAEmitterLayer* snowEmitterlayer = [CAEmitterLayer layer];
    // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
    snowEmitterlayer.emitterShape = kCAEmitterLayerLine;
    // 发射模式
    snowEmitterlayer.emitterMode = kCAEmitterLayerSurface;
    // 发射源的size 据定了发射源的大小
    snowEmitterlayer.emitterSize = rootWindow.frame.size;
    // 发射源的位置 从屏幕上方往下发射
    snowEmitterlayer.emitterPosition = CGPointMake(rootWindow.frame.size.width*0.5, -150);
    // 渲染模式，暂不使用
    self.addLayer = snowEmitterlayer;
    [layerView.layer addSublayer:snowEmitterlayer];
    
    NSMutableArray *array = [NSMutableArray array];//CAEmitterCell数组，存放不同的CAEmitterCell，我这里准备了四张不同形态的叶子图片。
    for (int i = 0; i<3; i++) {
        NSString *imageName = [NSString stringWithFormat:@"fengy%d",i+1];
        
        CAEmitterCell *leafCell = [CAEmitterCell emitterCell];
        leafCell.birthRate = 0.5;//粒子产生速度
        leafCell.lifetime = 50;//粒子存活时间
        
        leafCell.velocity = 12;//初始速度
        leafCell.velocityRange = 5;//初始速度的差值区间，所以初始速度为5~15，后面属性range算法相同
        
        leafCell.yAcceleration = 20;//y轴方向的加速度，落叶下飘只需要y轴正向加速度。
        
        leafCell.spin = 1.0;//粒子旋转速度
        leafCell.spinRange = 2.0;//粒子旋转速度范围
        
        leafCell.emissionRange = M_PI;//粒子发射角度范围
        
        leafCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];//粒子图片
        
        leafCell.scale = 0.3;//缩放比例
        leafCell.scaleRange = 0.2;//缩放比例
        
        
        [array addObject:leafCell];
    }
    // 添加到粒子发射器
    snowEmitterlayer.emitterCells = array;
}

- (void)flowerIn:(UIView *)layerView{
    // 使用背板视图来作为载体
    UIView *rootWindow =  [UIApplication sharedApplication].keyWindow;
    if (self.addLayer) {
        [self.addLayer removeFromSuperlayer];
    }
    // 设置发射器图层
    CAEmitterLayer* snowEmitterlayer = [CAEmitterLayer layer];
    // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
    snowEmitterlayer.emitterShape = kCAEmitterLayerLine;
    // 发射模式
    snowEmitterlayer.emitterMode = kCAEmitterLayerSurface;
    // 发射源的size 据定了发射源的大小
    snowEmitterlayer.emitterSize = rootWindow.frame.size;
    // 发射源的位置 从屏幕上方往下发射
    snowEmitterlayer.emitterPosition = CGPointMake(rootWindow.frame.size.width*0.5, -150);
    // 渲染模式，暂不使用
    self.addLayer = snowEmitterlayer;
    [layerView.layer addSublayer:snowEmitterlayer];
    
    NSMutableArray *array = [NSMutableArray array];//CAEmitterCell数组，存放不同的CAEmitterCell，我这里准备了四张不同形态的叶子图片。
    for (int i = 0; i<5; i++) {
        NSString *imageName = [NSString stringWithFormat:@"huaer%d",i];
        
        CAEmitterCell *leafCell = [CAEmitterCell emitterCell];
        leafCell.birthRate = 0.5;//粒子产生速度
        leafCell.lifetime = 50;//粒子存活时间
        
        leafCell.velocity = 15;//初始速度
        leafCell.velocityRange = 5;//初始速度的差值区间，所以初始速度为5~15，后面属性range算法相同
        
        leafCell.yAcceleration = 30;//y轴方向的加速度，落叶下飘只需要y轴正向加速度。
        
        leafCell.spin = 1.0;//粒子旋转速度
        leafCell.spinRange = 2.0;//粒子旋转速度范围
        
        leafCell.emissionRange = M_PI;//粒子发射角度范围
        
        leafCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];//粒子图片
        
        leafCell.scale = 0.2;//缩放比例
       // leafCell.scaleRange = 0.1;//缩放比例
        
        
        [array addObject:leafCell];
    }
    // 添加到粒子发射器
    snowEmitterlayer.emitterCells = array;
}
@end
