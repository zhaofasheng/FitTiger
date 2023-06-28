//
//  NoticePlayerBokeView.m
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticePlayerBokeView.h"
#import "NoticeMoreClickView.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeVoiceCommentView.h"
@implementation NoticePlayerBokeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,10,28, 28)];
        _iconImageView.layer.cornerRadius = 14;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        [self addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-12, CGRectGetMaxY(_iconImageView.frame)-12,12, 12)];
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
        [self addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 10,180, 28)];
        _nickNameL.font = FOURTHTEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:_nickNameL];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nickNameL.frame)+3,DR_SCREEN_WIDTH-30,frame.size.height-87-30-35-24-CGRectGetMaxY(self.nickNameL.frame)-3-5)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.introL = [[UILabel alloc] init];
        self.introL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.introL.font = FIFTHTEENTEXTFONTSIZE;
        [self.scrollView addSubview:self.introL];
        
        self.userInteractionEnabled = YES;
        
    
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(20,frame.size.height-87-30, DR_SCREEN_WIDTH-40, 13)];
        _slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _slider.maximumTrackTintColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        [_slider setThumbImage:UIImageNamed(@"Image_trak_sgj") forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(handleSlide:) forControlEvents:UIControlEventValueChanged];
        
        
        _minTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(_slider.frame)+9, GET_STRWIDTH(@"000:00", 10, 10), 10)];
        _minTimeLabel.text = @"00:00";
        _minTimeLabel.font = [UIFont systemFontOfSize:10];
        _minTimeLabel.textColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:_minTimeLabel];
        
        _maxTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH(@"00:000", 10, 10), CGRectGetMaxY(_slider.frame)+9, GET_STRWIDTH(@"00:000", 10, 10), 10)];
        _maxTimeLabel.text = @"00:00";
        _maxTimeLabel.font = [UIFont systemFontOfSize:10];
        _maxTimeLabel.textColor = [UIColor colorWithHexString:@"#E1E4F0"];
        [self addSubview:_maxTimeLabel];
                
        [self addSubview:_slider];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-33)/2,CGRectGetMaxY(_slider.frame)+40-3.5, 40, 40)];
        [button setImage:UIImageNamed(@"Image_bokepause") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionsClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.playBtn = button;
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-33)/2-83,CGRectGetMaxY(_slider.frame)+40, 33, 33)];
        [button1 setImage:UIImageNamed(@"Image_back15sec") forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+50,CGRectGetMaxY(_slider.frame)+40, 33, 33)];
        [button2 setImage:UIImageNamed(@"Image_qianjin30sec") forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(preClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        
        [self bringSubviewToFront:_slider];
        
        NSArray *imgArr = @[@"Image_boklb",@"Image_bokxh",@"Image_bokdm",@"Image_bokfx"];
        CGFloat space = (DR_SCREEN_WIDTH-88-24*4)/3;
        for (int i = 0; i < 4; i++) {
            UIButton *funBtn = [[UIButton alloc] initWithFrame:CGRectMake(44+(24+space)*i, _slider.frame.origin.y-35-24, 24, 24)];
            funBtn.tag = i;
            [funBtn setBackgroundImage:UIImageNamed(imgArr[i]) forState:UIControlStateNormal];
            [self addSubview:funBtn];
            if (i == 1) {
                self.likeButton = funBtn;
                self.likeNumL = [[UILabel alloc] initWithFrame:CGRectMake(self.likeButton.frame.origin.x+14, self.likeButton.frame.origin.y-7, 70, 14)];
                self.likeNumL.font = [UIFont systemFontOfSize:10];
                self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
                [self addSubview:self.likeNumL];
            }
            if (i == 2) {
                self.comBtn = funBtn;
                self.comL = [[UILabel alloc] initWithFrame:CGRectMake(self.comBtn.frame.origin.x+14, self.comBtn.frame.origin.y-7, 70, 14)];
                self.comL.font = [UIFont systemFontOfSize:10];
                self.comL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
                [self addSubview:self.comL];
            }
            [funBtn addTarget:self action:@selector(funClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

- (void)userInfoTap{
    if (self.bokeModel.user_id) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        if (![self.bokeModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
            ctl.isOther = YES;
            ctl.userId = self.bokeModel.user_id;
        }
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}


- (void)setBokeModel:(NoticeDanMuModel *)bokeModel{
    _bokeModel = bokeModel;
    self.likeNumL.hidden = bokeModel.count_like.intValue?NO:YES;
    self.likeNumL.text = bokeModel.count_like;
    if (bokeModel.count_like.intValue) {
        [self.likeButton setBackgroundImage:UIImageNamed(!bokeModel.is_podcast_like.boolValue?@"Image_bokxhs":@"Image_bokxhss") forState:UIControlStateNormal];
        
        if (bokeModel.is_podcast_like.boolValue) {
            self.likeNumL.textColor = [UIColor colorWithHexString:@"#F47070"];
        }else{
            self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        }
        
    }else{
        
        [self.likeButton setBackgroundImage:UIImageNamed(@"Image_bokxh") forState:UIControlStateNormal];
    }
    
    NSString *url = nil;
    url = [NSString stringWithFormat:@"podcast/comment/%@?pageNo=1",self.bokeModel.bokeId];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {

            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if (allM.total.intValue) {
                [self.comBtn setBackgroundImage:UIImageNamed(@"Image_bokdms") forState:UIControlStateNormal];
                self.comL.text = allM.total;
            }else{
                [self.comBtn setBackgroundImage:UIImageNamed(@"Image_bokdm") forState:UIControlStateNormal];
                self.comL.text = @"";
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)funClick:(UIButton *)btn{
    if (btn.tag == 2) {
        NoticeVoiceCommentView *comView = [[NoticeVoiceCommentView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        comView.bokeModel = self.bokeModel;
        __weak typeof(self) weakSelf = self;
        comView.numBlock = ^(NSString * _Nonnull num) {
            if (num.intValue) {
                [weakSelf.comBtn setBackgroundImage:UIImageNamed(@"Image_bokdms") forState:UIControlStateNormal];
                weakSelf.comL.text = num;
            }else{
                [weakSelf.comBtn setBackgroundImage:UIImageNamed(@"Image_bokdm") forState:UIControlStateNormal];
                weakSelf.comL.text = @"";
            }
        };
        [comView show];
    }else if (btn.tag == 1){
        [[NoticeTools getTopViewController] showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@",self.bokeModel.podcast_no] Accept:@"application/vnd.shengxi.v5.4.3+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [[NoticeTools getTopViewController] hideHUD];
            if (success) {
                self.bokeModel.is_podcast_like = self.bokeModel.is_podcast_like.boolValue?@"0":@"1";
                if (self.bokeModel.is_podcast_like.boolValue) {
                    self.bokeModel.count_like = [NSString stringWithFormat:@"%ld",self.bokeModel.count_like.integerValue+1];
              
                }else{
                    self.bokeModel.count_like = [NSString stringWithFormat:@"%ld",self.bokeModel.count_like.integerValue-1];
                }
                
                self.likeNumL.hidden = self.bokeModel.count_like.intValue?NO:YES;
                self.likeNumL.text = self.bokeModel.count_like;
                if (self.bokeModel.count_like.intValue) {
                    [self.likeButton setBackgroundImage:UIImageNamed(!self.bokeModel.is_podcast_like.boolValue?@"Image_bokxhs":@"Image_bokxhss") forState:UIControlStateNormal];
                    if (self.bokeModel.is_podcast_like.boolValue) {
                        self.likeNumL.textColor = [UIColor colorWithHexString:@"#F47070"];
                    }else{
                        self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
                    }
                }else{
                    [self.likeButton setBackgroundImage:UIImageNamed(@"Image_bokxh") forState:UIControlStateNormal];
                }
                
            }
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
    }else if (btn.tag == 0){
        if (self.clickListBlock) {
            self.clickListBlock(YES);
        }
    }else if (btn.tag == 3){
        NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        moreView.isShare = YES;
        moreView.name = self.bokeModel.nick_name?self.bokeModel.nick_name:@"声昔每日播客";
        moreView.title = self.bokeModel.podcast_title;
        moreView.bokeId = self.bokeModel.bokeId;
        [moreView showTost];
    }
}
//滑动进度条
- (void)handleSlide:(UISlider *)slider{

    if (self.sliderBlock) {
        self.sliderBlock(slider);
    }
}

//后退
- (void)backClick{
    if (self.preBlock) {
        self.preBlock(self.slider);
    }
}

//前进
- (void)preClick{
    if (self.moveBlock) {
        self.moveBlock(self.slider);
    }
}

- (void)actionsClick{
    if (self.playBlock) {
        self.playBlock(YES);
    }
    
}

@end
