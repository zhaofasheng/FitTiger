//
//  NoticeVoiceImageView.m
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceImageView.h"
#import "NSData+ImageContentType.h"
#import <SDWebImage/UIImage+GIF.h>
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeScrollView.h"
@implementation NoticeVoiceImageView
{
    UIImageView *_imgV1;
    UIImageView *_imgV2;
    UIImageView *_imgV3;
    NSMutableArray *_photosItemArr;
    NSMutableArray *_photosArr;
    NSMutableArray *_mbArr;
    NoticeScrollView *_scrollView;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
        _scrollView = [[NoticeScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.bounces = NO;
        _scrollView.canScro = YES;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _photosArr = [NSMutableArray new];
        _scrollView.userInteractionEnabled = YES;
        
        _mbArr = [NSMutableArray new];
        
        [self addSubview:_scrollView];
        for (int i = 0; i < 3; i++) {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width*i, 0, frame.size.width, frame.size.height)];
            imageV.contentMode = UIViewContentModeScaleAspectFit;
            imageV.clipsToBounds = YES;
            imageV.tag = i;
            imageV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImageLook:)];
            [imageV addGestureRecognizer:tap0];
            
            UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageV.frame.size.width, imageV.frame.size.height)];
            mbView.backgroundColor =  [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
            [imageV addSubview:mbView];
            mbView.hidden = [NoticeTools isWhiteTheme]?YES:NO;
            [_mbArr addObject:mbView];
            
            UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-30-10, 10, 30, 30)];
            [closeBtn setBackgroundImage:UIImageNamed(@"ly_xxx") forState:UIControlStateNormal];
            [imageV addSubview:closeBtn];
            closeBtn.tag = i;
            [closeBtn addTarget:self action:@selector(removeImgWith:) forControlEvents:UIControlEventTouchUpInside];
            closeBtn.hidden = YES;
            if (i == 0) {
                self.closeBtn0 = closeBtn;
                _imgV1 = imageV;
            }else if (i == 1){
                self.closeBtn1 = closeBtn;
                _imgV2 = imageV;
            }else{
                self.closeBtn2 = closeBtn;
                _imgV3 = imageV;
            }
            [_photosArr addObject:imageV];
            [_scrollView addSubview:imageV];
        }

        _pageL = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-12-40,frame.size.height-20-12, 40,20)];
        _pageL.font = ELEVENTEXTFONTSIZE;
        _pageL.textAlignment = NSTextAlignmentCenter;
        _pageL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _pageL.backgroundColor=[[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.2];
        _pageL.layer.cornerRadius = 10;
        _pageL.layer.masksToBounds = YES;
        [self addSubview:_pageL];
        
        _photosItemArr = [NSMutableArray new];
    }
    return self;
}

- (void)removeImgWith:(UIButton *)button{
    if (self.imgBlock) {
        self.imgBlock(button.tag);
    }
}

- (void)setIsTime:(BOOL)isTime{
    _isTime = isTime;
    if (isTime) {
        _pageL.hidden = NO;
        for (UIImageView *imgV in _photosArr) {
            //长按保存背景图片手势
            UILongPressGestureRecognizer *longPressbaT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveBackimgTaps:)];
            longPressbaT.minimumPressDuration = 0.5;
            [imgV addGestureRecognizer:longPressbaT];
        }
        
    }
}

- (void)setImgArr:(NSArray *)imgArr{
    _imgArr = imgArr;
    _pageL.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)imgArr.count];
    for (UIView *mbV in _mbArr) {
        mbV.hidden = [NoticeTools isWhiteTheme]?YES:NO;
    }
    
    if (imgArr.count > 1) {
        if (!_isTime) {
           _scrollView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height);
        }
        
    }else{
        _scrollView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height);
    }
    for (int i = 0; i < _photosArr.count;i++) {
        
        UIImageView *imageav = _photosArr[i];
        imageav.frame = CGRectMake(_scrollView.frame.size.width*i, 0, self.frame.size.width, _scrollView.frame.size.height);
        
        UIView *mbV = _mbArr[i];
        mbV.frame = CGRectMake(0, 0, self.frame.size.width, _scrollView.frame.size.height);
    }
    
    
    _scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH*imgArr.count, 0);

    if (imgArr.count == 1){
        
        [_photosItemArr removeAllObjects];
        
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _imgV1;
        if (self.isLocaImage) {
            _imgV1.image = [UIImage sd_imageWithGIFData:[imgArr[0] objectForKey:@"ImageDatas"]];
        }else{
            NSArray *array = [imgArr[0] componentsSeparatedByString:@"?"];
            item.largeImageURL     = [NSURL URLWithString:[NoticeTools hasChinese:array[0]]];

            if ([imgArr[0] containsString:@".gif"] || [imgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV1 sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
        }

        [_photosItemArr addObject:item];
    }else if (imgArr.count == 2){

        [_photosItemArr removeAllObjects];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _imgV1;
        
        YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
        item1.thumbView         = _imgV2;
        
        if (self.isLocaImage) {
            _imgV1.image = [UIImage sd_imageWithGIFData:[imgArr[0] objectForKey:@"ImageDatas"]];
            _imgV2.image = [UIImage sd_imageWithGIFData:[imgArr[1] objectForKey:@"ImageDatas"]];
        }else{
            if ([imgArr[0] containsString:@".gif"] || [imgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV1 sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
            if ([imgArr[1] containsString:@".gif"] || [imgArr[1] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV2 setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV2 sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
            NSArray *array = [imgArr[0] componentsSeparatedByString:@"?"];
            NSArray *array2 = [imgArr[1] componentsSeparatedByString:@"?"];
            item.largeImageURL     = [NSURL URLWithString:array[0]];
            item1.largeImageURL     = [NSURL URLWithString:array2[0]];
        }

        
        [_photosItemArr addObject:item];
        [_photosItemArr addObject:item1];
    }else if (imgArr.count == 3){
    
        [_photosItemArr removeAllObjects];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _imgV1;
        
        YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
        item1.thumbView         = _imgV2;
        
        YYPhotoGroupItem *item2 = [YYPhotoGroupItem new];
        item2.thumbView         = _imgV3;

        if (self.isLocaImage) {
            _imgV1.image = [UIImage sd_imageWithGIFData:[imgArr[0] objectForKey:@"ImageDatas"]];
            _imgV2.image = [UIImage sd_imageWithGIFData:[imgArr[1] objectForKey:@"ImageDatas"]];
            _imgV3.image = [UIImage sd_imageWithGIFData:[imgArr[2] objectForKey:@"ImageDatas"]];
        }else{
            NSArray *array = [imgArr[0] componentsSeparatedByString:@"?"];
            NSArray *array2 = [imgArr[1] componentsSeparatedByString:@"?"];
            
            NSArray *array3 = [imgArr[2] componentsSeparatedByString:@"?"];
            if ([imgArr[0] containsString:@".gif"] || [imgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV1 sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
            if ([imgArr[1] containsString:@".gif"] || [imgArr[1] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV2 setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV2 sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
            if ([imgArr[2] containsString:@".gif"] || [imgArr[2] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV3 setImageWithURL:[NSURL URLWithString:imgArr[2]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [_imgV3 sd_setImageWithURL:[NSURL URLWithString:imgArr[2]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
            
            item.largeImageURL     = [NSURL URLWithString:array[0]];
            item1.largeImageURL     = [NSURL URLWithString:array2[0]];
            item2.largeImageURL     = [NSURL URLWithString:array3[0]];
            
        }
        [_photosItemArr addObject:item];
        [_photosItemArr addObject:item1];
        [_photosItemArr addObject:item2];
    }
}

- (void)saveBackimgTaps:(UILongPressGestureRecognizer *)tap{
    if (self.isLocaImage) {
        return;
    }
    if (tap.state == UIGestureRecognizerStateBegan){
        UIImageView *tapView = (UIImageView *)tap.view;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        __weak typeof(self) weakSelf = self;
        if (self.isOther) {
            
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [tapView.image saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
                        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"yl.baocsus"]];
                    }];
                }
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"mineme.saveimg"]]];
            [sheet show];
        }else{
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(changeFeminatu)]) {
                        [weakSelf.delegate changeFeminatu];
                    }
                }else if(buttonIndex == 2){
                    [tapView.image saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
                        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"yl.baocsus"]];
                    }];
                }
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"mineme.changmoren"],[NoticeTools getLocalStrWith:@"mineme.saveimg"]]];
            [sheet show];
        }
    }
}

- (void)setIsLocaImage:(BOOL)isLocaImage{
    _isLocaImage = isLocaImage;
    if (isLocaImage) {
        self.closeBtn0.hidden = NO;
        self.closeBtn1.hidden = NO;
        self.closeBtn2.hidden = NO;
    }
}

//保存图片
- (void)bigImageLook:(UITapGestureRecognizer *)tap{
 
    UIImageView *tapView = (UIImageView *)tap.view;
    
    if (_isTime) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(funViewChangeHide)]) {
            [self.delegate funViewChangeHide];
        }
        return;
        
    }
    
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    if (!self.isLocaImage) {
        NSArray *array = [_imgArr[tapView.tag] componentsSeparatedByString:@"?"];
        item.largeImageURL     = [NSURL URLWithString:array[0]];
    }
    
    item.thumbView         = tapView;
    
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:_photosItemArr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:tapView
                   toContainer:toView
                      animated:YES completion:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //ScrollView中根据滚动距离来判断当前页数
    int page = (int)scrollView.contentOffset.x/DR_SCREEN_WIDTH;

    _pageL.text = [NSString stringWithFormat:@"%d/%lu",page+1,(unsigned long)_imgArr.count];
  
}


@end
