

//
//  NoticeVoiceImgList.m
//  NoticeXi
//
//  Created by li lei on 2019/11/28.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceImgList.h"

@implementation NoticeVoiceImgList
{
    NSMutableArray *_photosItemArr;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _photosItemArr = [NSMutableArray new];
        for (int i = 0; i < 3; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.layer.cornerRadius = 8;
            imgView.layer.masksToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            [self addSubview:imgView];
            imgView.hidden = YES;
            if (i == 0) {
                self.imgV1 = imgView;
            }else if (i == 1){
                self.imgV2 = imgView;
            }else{
                self.imgV3 = imgView;
            }
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imgView addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)setImgArr:(NSArray *)imgArr{
    _imgArr = imgArr;
    
    self.imgV1.hidden = imgArr.count?NO:YES;
    self.imgV2.hidden = imgArr.count >= 2 ? NO:YES;
    self.imgV3.hidden = imgArr.count == 3? NO:YES;
    
    self.imgV1.frame = CGRectMake(15, 0, self.frame.size.height, self.frame.size.height);
    self.imgV2.frame = CGRectMake(CGRectGetMaxX(self.imgV1.frame)+8, 0, self.frame.size.height, self.frame.size.height);
    self.imgV3.frame = CGRectMake(CGRectGetMaxX(self.imgV2.frame)+8, 0, self.frame.size.height, self.frame.size.height);
    
    if (imgArr.count) {
        if (imgArr.count == 1) {
     
            [_photosItemArr removeAllObjects];
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView         = _imgV1;
            item.largeImageURL     = [NSURL URLWithString:imgArr[0]];
            [_photosItemArr addObject:item];
            

            if ([imgArr[0] containsString:@".gif"] || [imgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV1 sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
            
        }else if (imgArr.count == 2){
            NSArray *array = [imgArr[0] componentsSeparatedByString:@"?"];
            NSArray *array2 = [imgArr[1] componentsSeparatedByString:@"?"];
            
            [_photosItemArr removeAllObjects];
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView         = _imgV1;
            item.largeImageURL     = [NSURL URLWithString:array[0]];
            [_photosItemArr addObject:item];
            
            if ([imgArr[0] containsString:@".gif"] || [imgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                    
                }];
            }else{
                [_imgV1 sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }

            YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
            item1.thumbView         = _imgV2;
            item1.largeImageURL     = [NSURL URLWithString:array2[0]];
            [_photosItemArr addObject:item1];
            if ([imgArr[1] containsString:@".gif"] || [imgArr[1] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV2 setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                    
                }];
            }else{
                [_imgV2 sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
        }else{
            NSArray *array = [imgArr[0] componentsSeparatedByString:@"?"];
            NSArray *array2 = [imgArr[1] componentsSeparatedByString:@"?"];
            NSArray *array3 = [imgArr[2] componentsSeparatedByString:@"?"];
            
            [_photosItemArr removeAllObjects];
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView         = _imgV1;
            item.largeImageURL     = [NSURL URLWithString:array[0]];
            [_photosItemArr addObject:item];
            
            if ([imgArr[0] containsString:@".gif"] || [imgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                    
                }];
            }else{
                [_imgV1 sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }

            YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
            item1.thumbView         = _imgV2;
            item1.largeImageURL     = [NSURL URLWithString:array2[0]];
            [_photosItemArr addObject:item1];
            if ([imgArr[1] containsString:@".gif"] || [imgArr[1] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV2 setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV2 sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
            
            
            YYPhotoGroupItem *item2 = [YYPhotoGroupItem new];
            item2.thumbView         = _imgV3;
            item2.largeImageURL     = [NSURL URLWithString:array3[0]];
            [_photosItemArr addObject:item2];
            
            if ([imgArr[2] containsString:@".gif"] || [imgArr[2] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV3 setImageWithURL:[NSURL URLWithString:imgArr[2]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                    
                }];
            }else{
                [_imgV3 sd_setImageWithURL:[NSURL URLWithString:imgArr[2]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
        }
    }
}

- (void)setShareImgArr:(NSArray *)shareImgArr{
    _shareImgArr = shareImgArr;
    
    self.imgV1.hidden = shareImgArr.count?NO:YES;
    self.imgV2.hidden = shareImgArr.count >= 2 ? NO:YES;
    self.imgV3.hidden = shareImgArr.count == 3? NO:YES;
    
    self.imgV1.frame = CGRectMake(10, 0, self.frame.size.height, self.frame.size.height);
    self.imgV2.frame = CGRectMake(CGRectGetMaxX(self.imgV1.frame)+5, 0, self.frame.size.height, self.frame.size.height);
    self.imgV3.frame = CGRectMake(CGRectGetMaxX(self.imgV2.frame)+5, 0, self.frame.size.height, self.frame.size.height);
    
    if (shareImgArr.count) {
        if (shareImgArr.count == 1) {
            NSArray *array = [shareImgArr[0] componentsSeparatedByString:@"?"];
            
            [_photosItemArr removeAllObjects];
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView         = _imgV1;
            item.largeImageURL     = [NSURL URLWithString:array[0]];
            [_photosItemArr addObject:item];
            
            if ([shareImgArr[0] containsString:@".gif"] || [shareImgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:shareImgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV1 sd_setImageWithURL:[NSURL URLWithString:shareImgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
        }else if (shareImgArr.count == 2){
            NSArray *array = [shareImgArr[0] componentsSeparatedByString:@"?"];
            NSArray *array2 = [shareImgArr[1] componentsSeparatedByString:@"?"];
            
            [_photosItemArr removeAllObjects];
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView         = _imgV1;
            item.largeImageURL     = [NSURL URLWithString:array[0]];
            [_photosItemArr addObject:item];
            
            if ([shareImgArr[0] containsString:@".gif"] || [shareImgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:shareImgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV1 sd_setImageWithURL:[NSURL URLWithString:shareImgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
            
            YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
            item1.thumbView         = _imgV2;
            item1.largeImageURL     = [NSURL URLWithString:array2[0]];
            [_photosItemArr addObject:item1];
            if ([shareImgArr[1] containsString:@".gif"] || [shareImgArr[1] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV2 setImageWithURL:[NSURL URLWithString:shareImgArr[1]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV2 sd_setImageWithURL:[NSURL URLWithString:shareImgArr[1]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
            
        }else{
            NSArray *array = [shareImgArr[0] componentsSeparatedByString:@"?"];
            NSArray *array2 = [shareImgArr[1] componentsSeparatedByString:@"?"];
            NSArray *array3 = [shareImgArr[2] componentsSeparatedByString:@"?"];
            
            [_photosItemArr removeAllObjects];
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView         = _imgV1;
            item.largeImageURL     = [NSURL URLWithString:array[0]];
            [_photosItemArr addObject:item];
            if ([shareImgArr[0] containsString:@".gif"] || [shareImgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:shareImgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV1 sd_setImageWithURL:[NSURL URLWithString:shareImgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
            
            YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
            item1.thumbView         = _imgV2;
            item1.largeImageURL     = [NSURL URLWithString:array2[0]];
            [_photosItemArr addObject:item1];
            if ([shareImgArr[1] containsString:@".gif"] || [shareImgArr[1] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV2 setImageWithURL:[NSURL URLWithString:shareImgArr[1]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV2 sd_setImageWithURL:[NSURL URLWithString:shareImgArr[1]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
            
            YYPhotoGroupItem *item2 = [YYPhotoGroupItem new];
            item2.thumbView         = _imgV3;
            item2.largeImageURL     = [NSURL URLWithString:array3[0]];
            [_photosItemArr addObject:item2];
            if ([shareImgArr[2] containsString:@".gif"] || [shareImgArr[2] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV3 setImageWithURL:[NSURL URLWithString:shareImgArr[2]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV3 sd_setImageWithURL:[NSURL URLWithString:shareImgArr[2]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
        }
    }
}

- (void)setImageNum:(NSInteger)imageNum{
    _imageNum = imageNum;
    self.imgV1.hidden = imageNum>0?NO:YES;
    self.imgV2.hidden = imageNum >= 2 ? NO:YES;
    self.imgV3.hidden = imageNum == 3? NO:YES;
    
    self.imgV1.frame = CGRectMake(10, 0, self.frame.size.height, self.frame.size.height);
    self.imgV2.frame = CGRectMake(CGRectGetMaxX(self.imgV1.frame)+5, 0, self.frame.size.height, self.frame.size.height);
    self.imgV3.frame = CGRectMake(CGRectGetMaxX(self.imgV2.frame)+5, 0, self.frame.size.height, self.frame.size.height);
    
    if (imageNum == 1) {
        [_photosItemArr removeAllObjects];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _imgV1;
        [_photosItemArr addObject:item];
    }else if (imageNum == 2){
        [_photosItemArr removeAllObjects];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _imgV1;
        [_photosItemArr addObject:item];
        
        YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
        item1.thumbView         = _imgV2;
        [_photosItemArr addObject:item1];
    }else if (imageNum == 3){
        [_photosItemArr removeAllObjects];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _imgV1;
        [_photosItemArr addObject:item];
        
        YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
        item1.thumbView         = _imgV2;
        [_photosItemArr addObject:item1];
        
        YYPhotoGroupItem *item2 = [YYPhotoGroupItem new];
        item2.thumbView         = _imgV3;
        [_photosItemArr addObject:item2];
    }
}

- (void)tapImageView:(UITapGestureRecognizer *)tap{
    UIImageView *tapView = (UIImageView *)tap.view;
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:_photosItemArr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:tapView
                   toContainer:toView
                      animated:YES completion:nil];
}
@end
