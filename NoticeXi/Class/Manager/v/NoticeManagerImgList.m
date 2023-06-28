//
//  NoticeManagerImgList.m
//  NoticeXi
//
//  Created by li lei on 2019/9/4.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerImgList.h"
#import "NSData+ImageContentType.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeManagerImgList
{
    NSMutableArray *_photosItemArr;
    NSMutableArray *_vArr;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _vArr = [NSMutableArray new];
        for (int i = 0; i < 3; i++) {
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(((DR_SCREEN_WIDTH-12)/3+6)*i, 0, (DR_SCREEN_WIDTH-12)/3, (DR_SCREEN_WIDTH-12)/3)];
            [self addSubview:imgV];
            imgV.tag = i;
            [_vArr addObject:imgV];
            
            imgV.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBig:)];
            [imgV addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)setImgArr:(NSArray *)imgArr{
    _imgArr = imgArr;
   
    for (UIImageView *imgV in _vArr) {
        imgV.hidden = imgV.tag  > (imgArr.count-1) ? YES : NO;
    }
    
    if (imgArr.count == 1) {
        NSArray *array = [imgArr[0] componentsSeparatedByString:@"?"];
        
        _photosItemArr = [NSMutableArray new];
        
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _vArr[0];
        item.largeImageURL     = [NSURL URLWithString:array[0]];
        [_photosItemArr addObject:item];
        
        [_vArr[0] sd_setImageWithURL:imgArr[0] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                [self->_vArr[0] sd_setImageWithURL:item.largeImageURL placeholderImage:GETUIImageNamed(@"img_empty")];//如果加载缩略图出错，就加载原图
            }
        }];
    }else if (imgArr.count == 2){
        NSArray *array = [imgArr[0] componentsSeparatedByString:@"?"];
        
        _photosItemArr = [NSMutableArray new];
        
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _vArr[0];
        item.largeImageURL     = [NSURL URLWithString:array[0]];
        [_photosItemArr addObject:item];
        
        [_vArr[0] sd_setImageWithURL:imgArr[0] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                [self->_vArr[0] sd_setImageWithURL:item.largeImageURL placeholderImage:GETUIImageNamed(@"img_empty")];//如果加载缩略图出错，就加载原图
            }
        }];
        
        NSArray *array1 = [imgArr[1] componentsSeparatedByString:@"?"];
        YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
        item1.thumbView         = _vArr[1];
        item1.largeImageURL     = [NSURL URLWithString:array1[0]];
        [_photosItemArr addObject:item1];
        
        [_vArr[1] sd_setImageWithURL:imgArr[1] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                [self->_vArr[1] sd_setImageWithURL:item1.largeImageURL placeholderImage:GETUIImageNamed(@"img_empty")];//如果加载缩略图出错，就加载原图
            }
        }];
    }else if (imgArr.count == 3){
        NSArray *array = [imgArr[0] componentsSeparatedByString:@"?"];
        
        _photosItemArr = [NSMutableArray new];
        
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _vArr[0];
        item.largeImageURL     = [NSURL URLWithString:array[0]];
        [_photosItemArr addObject:item];
        
        [_vArr[0] sd_setImageWithURL:imgArr[0] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                [self->_vArr[0] sd_setImageWithURL:item.largeImageURL placeholderImage:GETUIImageNamed(@"img_empty")];//如果加载缩略图出错，就加载原图
            }
        }];
        
        NSArray *array1 = [imgArr[1] componentsSeparatedByString:@"?"];
        YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
        item1.thumbView         = _vArr[1];
        item1.largeImageURL     = [NSURL URLWithString:array1[0]];
        [_photosItemArr addObject:item1];
        
        [_vArr[1] sd_setImageWithURL:imgArr[1] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                [self->_vArr[1] sd_setImageWithURL:item1.largeImageURL placeholderImage:GETUIImageNamed(@"img_empty")];//如果加载缩略图出错，就加载原图
            }
        }];
        
        NSArray *array2 = [imgArr[2] componentsSeparatedByString:@"?"];
        YYPhotoGroupItem *item2 = [YYPhotoGroupItem new];
        item2.thumbView         = _vArr[2];
        item2.largeImageURL     = [NSURL URLWithString:array2[0]];
        [_photosItemArr addObject:item2];
        
        [_vArr[2] sd_setImageWithURL:imgArr[2] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                [self->_vArr[2] sd_setImageWithURL:item2.largeImageURL placeholderImage:GETUIImageNamed(@"img_empty")];//如果加载缩略图出错，就加载原图
            }
        }];
    }
}

- (void)tapBig:(UITapGestureRecognizer *)tap{
    UIImageView *tapView = (UIImageView *)tap.view;

    NSArray *array = [_imgArr[tapView.tag] componentsSeparatedByString:@"?"];
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = tapView;
    item.largeImageURL     = [NSURL URLWithString:array[0]];
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:_photosItemArr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:tapView
                   toContainer:toView
                      animated:YES completion:nil];
}

@end
