//
//  UIImage+Color.m
//  XCUtil
//
//  Created by 赵发生 on 16/9/22.
//  Copyright © 2016年 赵发生. All rights reserved.
//

#import "UIImage+Color.h"
#import <Accelerate/Accelerate.h>
@implementation UIImage (Color)

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}


- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    //填充颜色
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:blendMode alpha:1.0];
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    }
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
{
    if (!image) {
        return nil;
    }
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    
    int boxSize     = (int)(blur * 100); //100为最大模糊程度
    boxSize         = boxSize - (boxSize % 2) + 1;
    CGImageRef img  = image.CGImage;
    
    vImage_Buffer     inBuffer, outBuffer;
    vImage_Error      error;
    
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData       = CGDataProviderCopyData(inProvider);
    
    //设置从CGImage获取对象的属性
    void *pixelBuffer;
    inBuffer.width      = CGImageGetWidth(img);
    inBuffer.height     = CGImageGetHeight(img);
    inBuffer.rowBytes   = CGImageGetBytesPerRow(img);
    inBuffer.data       = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer         = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(!pixelBuffer){
        return nil;
    };
    outBuffer.data      = pixelBuffer;
    outBuffer.width     = CGImageGetWidth(img);
    outBuffer.height    = CGImageGetHeight(img);
    outBuffer.rowBytes  = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
        return nil;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef  = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //清除;
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}
@end
