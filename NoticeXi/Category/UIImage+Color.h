//
//  UIImage+Color.h
//  XCUtil
//
//  Created by 赵发生 on 16/9/22.
//  Copyright © 2016年 赵发生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
/**
 *  使用颜色生成指定大小的图片
 *
 *  @param color 图片颜色
 *  @param size  图片尺寸
 *
 *  @return 生成的图片
 */
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;
/**
 *  图片着色
 *
 *  @param tintColor 颜色
 *

 */
-(UIImage *)imageWithTintColor:(UIColor *)tintColor;
/**
 *  图片着色保持原有的颜色
 *
 *  @param tintColor 颜色
 *

 */
-(UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

/**
 高斯模糊
 @param image image
 @param blur (0 - 1 之间)
 @return image
 */

+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;


@end
