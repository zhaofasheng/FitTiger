//
//  NoticePlayerBokeView.h
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticePlayerBokeView.h"
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePlayerBokeView : UIView
@property (nonatomic,strong) UISlider * slider;
@property (nonatomic, strong) UILabel *minTimeLabel;
@property (nonatomic, strong) UILabel *maxTimeLabel;
@property (nonatomic, strong)  UIButton *playButton;
@property (nonatomic, strong) UILabel *introL;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NoticeDanMuModel *bokeModel;
@property (nonatomic,copy) void (^preBlock)(UISlider *slider);
@property (nonatomic,copy) void (^moveBlock)(UISlider *slider);
@property (nonatomic,copy) void (^playBlock)(BOOL clickPlay);
@property (nonatomic,copy) void (^sliderBlock)(UISlider *slider);
@property (nonatomic,copy) void (^choiceDanMuBlock)(BOOL goDanMu);
@property (nonatomic,copy) void (^clickListBlock)(BOOL list);
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *likeNumL;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *comBtn;
@property (nonatomic, strong) UILabel *comL;
@end

NS_ASSUME_NONNULL_END
