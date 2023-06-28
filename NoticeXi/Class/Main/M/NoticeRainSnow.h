//
//  NoticeRainSnow.h
//  NoticeXi
//
//  Created by li lei on 2019/3/6.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeRainSnow : UIView

@property (nonatomic, strong)  CAEmitterLayer*addLayer;
- (void)dissAllLayer;
- (void)rainIn:(UIView *)layerView;
- (void)snowIn:(UIView *)layerView;
- (void)flowerIn:(UIView *)layerView;
- (void)yeziIn:(UIView *)layerView;
- (void)fengyeIn:(UIView *)layerView;
- (void)backSnow:(UIView *)layerView;
- (void)backRain:(UIView *)layerView;
- (void)backFlower:(UIView *)layerView;
- (void)backLuoYe:(UIView *)layerView;
- (void)backFengYe:(UIView *)layerView;
- (void)removerDisslayer;
@end

NS_ASSUME_NONNULL_END
