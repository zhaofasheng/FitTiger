//
//  DrawPath.h
//  10-涂鸦画板
//
//  Created by 陈弘根 on 15/8/4.
//  Copyright (c) 2019年 赵发生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawPath : UIBezierPath

@property (nonatomic, strong) UIColor *lineColor;

+ (instancetype)path;

@end
