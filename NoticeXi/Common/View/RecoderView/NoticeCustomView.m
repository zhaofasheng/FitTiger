//
//  NoticeCustomView.m
//  NoticeXi
//
//  Created by li lei on 2018/11/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeCustomView.h"

@implementation NoticeCustomView

{
    UIImageView *_imageView;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        _scroVlew = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scroVlew.showsVerticalScrollIndicator = NO;
        _scroVlew.showsHorizontalScrollIndicator = NO;
        _scroVlew.bounces = NO;
        _imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_scroVlew addSubview:_imageView];
        [self addSubview:_scroVlew];
        _scroVlew.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        self.textL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.textL.numberOfLines = 0;
        self.textL.textColor = GetColorWithName(VMainTextColor);
        self.textL.font = SIXTEENTEXTFONTSIZE;
        self.textL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textL];
        self.textL.hidden = YES;
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    if (!_image) {
        return;
    }
    CGFloat Wpirx = image.size.width/image.size.height;
    CGFloat Hpirx = image.size.height/image.size.width;
    if (image.size.width > image.size.height) {//如果宽度大于高度，则纵向铺满
        _imageView.frame = CGRectMake(0, 0, self.frame.size.height*Wpirx, self.frame.size.height);
    }else{
        _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*Hpirx);
    }
    [_scroVlew setContentOffset:CGPointMake((_imageView.frame.size.width-self.frame.size.width)/2,(_imageView.frame.size.height-self.frame.size.height)/2) animated:NO];//居中显示
    _scroVlew.contentSize = CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height);
    _scroVlew.center = self.center;
    _imageView.image = image;
}


- (void)setYyImage:(YYImage *)yyImage{
    _yyImage = yyImage;
    if (!_yyImage) {
        return;
    }
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_scroVlew setContentOffset:CGPointMake((_imageView.frame.size.width-self.frame.size.width)/2,(_imageView.frame.size.height-self.frame.size.height)/2) animated:NO];//居中显示
    _scroVlew.contentSize = CGSizeMake(0,0);
    _scroVlew.center = self.center;
    
    _imageView.image = yyImage;
}

- (void)setImageData:(NSData *)imageData{
    _imageData = imageData;
    if (!imageData) {
        return;
    }
    UIImage *image = [UIImage imageWithData:imageData];
    CGFloat Wpirx = image.size.width/image.size.height;
    CGFloat Hpirx = image.size.height/image.size.width;
    if (image.size.width > image.size.height) {//如果宽度大于高度，则纵向铺满
        _imageView.frame = CGRectMake(0, 0, self.frame.size.height*Wpirx, self.frame.size.height);
    }else{
        _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*Hpirx);
    }
     [_scroVlew setContentOffset:CGPointMake((_imageView.frame.size.width-self.frame.size.width)/2,(_imageView.frame.size.height-self.frame.size.height)/2) animated:NO];//居中显示
    _scroVlew.contentSize = CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height);
    _scroVlew.center = self.center;
    
    _imageView.image = image;
}
@end
