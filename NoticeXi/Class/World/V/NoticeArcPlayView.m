//
//  NoticeArcPlayView.m
//  NoticeXi
//
//  Created by li lei on 2021/9/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeArcPlayView.h"
#import "NoticeMineViewController.h"
#import "NoticeShareTostView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticerTopicSearchResultNewController.h"
#import "NoticeTabbarController.h"
#import "NoticeBackVoiceViewController.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeBingGanListView.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeArcPlayView
{
    UIView *mbView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.2];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
        UIView *nbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        nbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self addSubview:nbView];
        mbView = nbView;
        
        self.image = UIImageNamed(@"voicedefault.jpg");
        
        self.svagPlayer = [[SVGAPlayer alloc] initWithFrame:self.bounds];
        _svagPlayer.userInteractionEnabled = YES;
        _svagPlayer.loops = INT16_MAX;
        _svagPlayer.clearsAfterStop = YES;
        _svagPlayer.contentMode = UIViewContentModeScaleAspectFill;
        _svagPlayer.clipsToBounds = YES;
        self.parser = [[SVGAParser alloc] init];
        //bottombig
        [self.parser parseWithNamed:@"paopao" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            self.svagPlayer.videoItem = videoItem;
            [self.svagPlayer startAnimation];
        } failureBlock:nil];

        [self addSubview:self.svagPlayer];
        
        UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 172)];
        tapV.userInteractionEnabled = YES;
        [self addSubview:tapV];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vTap)];
        [tapV addGestureRecognizer:tap1];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(10,172, DR_SCREEN_WIDTH-60, 166)];
        self.backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.1];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        [self addSubview:self.backView];
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,21, 35, 35)];
        _iconImageView.layer.cornerRadius = 35/2;
        _iconImageView.layer.masksToBounds = YES;
        [self.backView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
                
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 19,self.backView.frame.size.width-56-40, 22)];
        _nickNameL.font = XGSIXBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.backView addSubview:_nickNameL];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, CGRectGetMaxY(_nickNameL.frame)+2, 200, 14)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        [self.backView addSubview:_timeL];
                
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-5-34, 15, 34, 34)];
        [btn setBackgroundImage:UIImageNamed(@"Image_moreNew") forState:UIControlStateNormal];
        [self.backView addSubview:btn];
        [btn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(10,73, 150, 40)];
        self.playerView.delegate = self;
        self.playerView.isThird = YES;
        [self.playerView.playButton setImage:UIImageNamed(@"Image_newplay") forState:UIControlStateNormal];
        [self.backView addSubview:_playerView];
        
        self.playerView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.2];
        self.playerView.slieView.trackTintColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.2];
        self.playerView.slieView.progressTintColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];
        self.playerView.leftView.hidden = YES;
        self.playerView.rightView.hidden = YES;
        
        _playView = [[UIView alloc] initWithFrame:CGRectMake(-15, -3,_playerView.frame.size.height+15+5, _playerView.frame.size.height+6)];
        _playView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [_playView addGestureRecognizer:tap];
        [self.playerView addSubview:_playView];
        
        _rePlayView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), _playerView.frame.origin.y,_playerView.frame.size.height, _playerView.frame.size.height)];
        [_rePlayView addTarget:self action:@selector(playReplay) forControlEvents:UIControlEventTouchUpInside];
        [_rePlayView setImage:UIImageNamed(@"Imag_reply_img") forState:UIControlStateNormal];
        _rePlayView.hidden = YES;
        [self.backView addSubview:_rePlayView];
        
        self.dragView = [[UIView alloc] initWithFrame:CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height)];
        self.dragView.userInteractionEnabled = YES;
        self.dragView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
        [self.playerView addSubview:self.dragView];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.17;
        [self.dragView addGestureRecognizer:longPress];
        
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView.frame.size.height-58-10, self.backView.frame.size.width, 58)];
        [self.backView addSubview:self.buttonView];
        
        //话题
        _topiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0, GET_STRWIDTH(@"#神奇难受和快乐的的的的的#", 12, 58), 58)];
        _topiceLabel.font = [UIFont systemFontOfSize:12];
        _topiceLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _topiceLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *taptop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTextClick)];
        [_topiceLabel addGestureRecognizer:taptop];
        [self.buttonView addSubview:_topiceLabel];
        
        CGFloat btnWidth = GET_STRWIDTH([NoticeTools getLocalStrWith:@"py.bg"], 12, 54) + 24 +5;
        self.hsBackView = [[UIView alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width-15-5-btnWidth*2,0,btnWidth,58)];
        self.hsBackView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        [self.buttonView addSubview:self.hsBackView];
        self.hsBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *hsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replayClick)];
        [self.hsBackView addGestureRecognizer:hsTap];
        
        self.hsButton = [[UIImageView alloc] initWithFrame:CGRectMake(0,17,24,24)];
        self.hsButton.image = UIImageNamed(@"Image_newclickhs");
        [self.hsBackView addSubview:self.hsButton];
        
        self.hsL = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, btnWidth-24-3, 58)];
        self.hsL.font = TWOTEXTFONTSIZE;
        self.hsL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.hsL.text = [NoticeTools getLocalStrWith:@"em.hs"];
        [self.hsBackView addSubview:self.hsL];
    
        self.bgBackView = [[UIView alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width-5-btnWidth,0,btnWidth,58)];
        self.bgBackView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        [self.buttonView addSubview:self.bgBackView];
        self.hsBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [self.bgBackView addGestureRecognizer:bgTap];
        
        self.sendBGBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0,15,24,24)];
        self.sendBGBtn.image = UIImageNamed(@"Ima_sendbgn");
        [self.bgBackView addSubview:self.sendBGBtn];
        
        self.bingGL = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, btnWidth-24-3, 58)];
        self.bingGL.font = TWOTEXTFONTSIZE;
        self.bingGL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.bingGL.text = [NoticeTools getLocalStrWith:@"py.bg"];
        [self.bgBackView addSubview:self.bingGL];
              
        //屏蔽别人心情
        self.pinbTools = [[NoticeVoicePinbi alloc] init];
        self.pinbTools.delegate = self;
    }
    return self;
}

- (NoticeVoiceImgList *)imageViewS{
    if (!_imageViewS) {
        self.imageViewS = [[NoticeVoiceImgList alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_playerView.frame)+15, 0, 0)];
        [self.backView addSubview:self.imageViewS];
    }
    return _imageViewS;
}

- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.subUserModel.avatar_url]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageRefreshCached];

    self.timeL.text = [NSString stringWithFormat:@"%@%@",voiceM.content_type.intValue==1?[NoticeTools getLocalStrWith:@"em.time"]:[NoticeTools getLocalStrWith:@"em.textTime"],voiceM.sharedTime];
    self.nickNameL.text = voiceM.subUserModel.nick_name;
    
    //对话或者悄悄话数量
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.chat_num.integerValue) {
            self.hsL.text = _voiceM.chat_num;
        }else{
            self.hsL.text = [NoticeTools getLocalStrWith:@"em.hs"];
        }
        if (_voiceM.zaned_num.intValue) {
            self.bingGL.text = _voiceM.zaned_num;
        }else{
            self.bingGL.text = [NoticeTools getLocalStrWith:@"py.bg"];
        }
    }else{
        if (_voiceM.dialog_num.integerValue) {
            self.hsL.text = _voiceM.dialog_num;
        }else{
            self.hsL.text = [NoticeTools getLocalStrWith:@"em.hs"];
        }
        self.bingGL.text = [NoticeTools getLocalStrWith:@"py.bg"];
    }
    
    //话题
    if (voiceM.topic_name && voiceM.topic_name.length) {
        self.topiceLabel.text = voiceM.topicName;
        self.topiceLabel.hidden = NO;
    }else{
        self.topiceLabel.hidden = YES;
    }

    self.playerView.hidden = NO;
    self.playerView.timeLen = voiceM.nowTime.integerValue?voiceM.nowTime: voiceM.voice_len;
    self.playerView.voiceUrl = voiceM.voice_url;
    self.playerView.slieView.progress = voiceM.nowPro >0 ?voiceM.nowPro:0;
    
    //位置
    if (voiceM.voice_len.integerValue < 5) {
        self.playerView.frame = CGRectMake(10,73, 130, 40);
    }else if (voiceM.voice_len.integerValue >= 5 && voiceM.voice_len.integerValue <= 105){
        self.playerView.frame = CGRectMake(10, 73, 130+voiceM.voice_len.integerValue, 40);
    }else if (voiceM.voice_len.integerValue >= 120){
        self.playerView.frame = CGRectMake(10,73, 130+120, 40);
    }
    else{
        self.playerView.frame = CGRectMake(10,73, 130+voiceM.voice_len.integerValue, 40);
    }

    self.dragView.frame =  CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height);
    [self.playerView refreWithFrame];
    _rePlayView.hidden = voiceM.isPlaying? NO:YES;
    _rePlayView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame),self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
    
    if (_voiceM.img_list.count) {//有图片
        self.imageViewS.frame = CGRectMake(0, 123, DR_SCREEN_WIDTH-80, (DR_SCREEN_WIDTH-80-18)/3);
        self.backView.frame = CGRectMake(10, 172, DR_SCREEN_WIDTH-60, 166 + self.imageViewS.frame.size.height+15);
    }else{
        //纯音频心情
        self.backView.frame = CGRectMake(10, 172, DR_SCREEN_WIDTH-60, 166);
    }
    
    self.frame = CGRectMake(20, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-40, DR_SCREEN_WIDTH-40, 182+self.backView.frame.size.height);
    
    self.imageViewS.hidden = voiceM.img_list.count ? NO  : YES;
    self.imageViewS.imgArr = voiceM.img_list;
    
    self.buttonView.frame = CGRectMake(0, self.backView.frame.size.height-58, self.backView.frame.size.width, 58);
    self.svagPlayer.frame = self.bounds;
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (_voiceM.subUserModel.spec_bg_type.intValue ==1) {//默认背景
        
        if (appdel.backDefaultImg) {
            self.image = [UIImage boxblurImage:appdel.backDefaultImg withBlurNumber:appdel.effect];
        }else{
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_voiceM.subUserModel.spec_bg_default_photo] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                
                if (data) {
                    UIImage *gqImage = [UIImage imageWithData:data];
                    appdel.backDefaultImg = gqImage;
                    self.image = [UIImage boxblurImage:appdel.backDefaultImg withBlurNumber:appdel.effect];
                }
            }];
        
        }
        [self.parser parseWithNamed:@"paopao" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            self.svagPlayer.videoItem = videoItem;
            [self.svagPlayer startAnimation];
        } failureBlock:nil];
        self.svagPlayer.hidden = NO;
    }else if(_voiceM.subUserModel.spec_bg_type.intValue == 2 || _voiceM.subUserModel.spec_bg_type.intValue == 4){//自定义背景
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_voiceM.subUserModel.spec_bg_type.intValue == 2?_voiceM.subUserModel.spec_bg_photo_url:_voiceM.subUserModel.spec_bg_skin_url] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            
            if (data) {
                UIImage *gqImage = [UIImage imageWithData:data];
                self.image = [UIImage boxblurImage:gqImage withBlurNumber:appdel.effect];
            }
        }];
        if (_voiceM.subUserModel.spec_bg_type.intValue == 4) {
            [self.parser parseWithURL:[NSURL URLWithString:_voiceM.subUserModel.spec_bg_svg_url] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                self.svagPlayer.videoItem = videoItem;
                [self.svagPlayer startAnimation];
            } failureBlock:nil];
            self.svagPlayer.hidden = NO;
        }else{
            [self.svagPlayer pauseAnimation];
            self.svagPlayer.hidden = YES;
        }
    }else{
        [self.svagPlayer pauseAnimation];
        self.svagPlayer.hidden = YES;
        self.image = UIImageNamed(@"voicedefault.jpg");
    }
    
    mbView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)vTap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeTap)]) {
        [self.delegate closeTap];
    }
}

- (void)topicTextClick{
    if (_voiceM.topic_name && _voiceM.topic_name.length) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(stopPlay)]) {
            [self.delegate stopPlay];
        }
        NoticerTopicSearchResultNewController *ctl = [[NoticerTopicSearchResultNewController alloc] init];
        ctl.topicName = _voiceM.topic_name;
        ctl.topicId = _voiceM.topic_id;
        if (_voiceM.content_type.intValue == 2) {
            ctl.isTextVoice = YES;
        }
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

- (void)userInfoTap{

    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        ctl.isOther = YES;
        ctl.userId = _voiceM.subUserModel.userId;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
   
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

- (void)moreClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasClickMoreWith:)]) {//更多点击
        [self.delegate hasClickMoreWith:self.index];
    }
    
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        [self.pinbTools pinbiWithModel:_voiceM];
    }
}

- (void)replayClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHS:)]) {
        [self.delegate clickHS:self.voiceM];
    }
}

//屏蔽成功回调
- (void)pinbiSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(otherPinbSuccess)]) {
        [self.delegate otherPinbSuccess];
    }
}

- (void)likeClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    //判断是否是自己,不是自己则为点击「有启发」
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){

        if (_voiceM.is_collected.boolValue) {//取消「有启发」
            if (_voiceM.canTapLike) {//防止多次点击
                return;
            }
            _voiceM.likeNoMove = YES;
            _voiceM.is_collected = @"0";
            self.sendBGBtn.image = UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbg": @"Ima_sendbgn");

            [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelCollectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
            _voiceM.canTapLike = YES;
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {

                if (success) {
                    self->_voiceM.canTapLike = NO;
                    self->_voiceM.is_collected = @"0";
                    
                    self.voiceM.zaned_num = [NSString stringWithFormat:@"%d",self.voiceM.zaned_num.intValue-1];
                    if (self.voiceM.zaned_num.intValue < 0) {
                        self.voiceM.zaned_num = @"0";
                    }

                    if (self.voiceM.resource) {
                        if (self->_voiceM.zaned_num.intValue) {
                            self.bingGL.text = self->_voiceM.zaned_num;
                        }else{
                            self.bingGL.text = [NoticeTools getLocalStrWith:@"py.bg"];
                        }
                    }
                }
            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
            }];
        }else{//「有启发」
   
            if (_voiceM.canTapLike) {
                return;
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
            _voiceM.is_collected = @"1";
            _voiceM.canTapLike = YES;
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:@"5" forKey:@"needDelay"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    self->_voiceM.canTapLike = NO;
                    self->_voiceM.is_collected = @"1";
                    self.voiceM.zaned_num = [NSString stringWithFormat:@"%d",self.voiceM.zaned_num.intValue+1];
                    [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"em.senbgt"]];
                    self.sendBGBtn.image = UIImageNamed(self->_voiceM.is_collected.intValue?@"Image_songbg": @"Ima_sendbgn");

                    if (self.voiceM.resource) {
                        if (self->_voiceM.zaned_num.intValue) {
                            self.bingGL.text = self->_voiceM.zaned_num;
                        }else{
                            self.bingGL.text = [NoticeTools getLocalStrWith:@"py.bg"];
                        }
                    }
                }

        
                
            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
                [nav.topViewController hideHUD];
            }];
        }
        return;
    }
    if (!self.voiceM.zaned_num.intValue) {
        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.noBg"]];
        return;
    }
    NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    listView.voiceM = self.voiceM;
    [listView showTost];
}

//点击播放
- (void)playNoReplay{
    DRLog(@"点击播放区域");
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop:)]) {
        [self.delegate startPlayAndStop:0];
    }
}

//点击重新播放
- (void)playReplay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRePlayer:)]) {
        [self.delegate startRePlayer:0];
    }
}

- (void)longPressGestureRecognized:(id)sender{

    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    if (!_voiceM.isPlaying) {
        if (longPressState == UIGestureRecognizerStateEnded) {
            [self playNoReplay];
        }
        return;
    }
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            DRLog(@"开始%.f",p.x);
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginDrag:)]) {
                [self.delegate beginDrag:0];
            }
            [self dragWithPoint:p];
            break;
        }
        case UIGestureRecognizerStateChanged:{
         
            [self dragWithPoint:p];
            break;
        }
        default: {
     
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag: progross:)]) {
                [self.delegate endDrag:0 progross:p.x/self.playerView.frame.size.width];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag:)]) {
                [self.delegate endDrag:0];
            }
            break;
        }
    }
}

- (void)dragWithPoint:(CGPoint)p{
    self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;
    if (_voiceM.moveSpeed > 0) {
        //每像素代表多少秒，等同于时间
        CGFloat beishuNum = _voiceM.voice_len.intValue/self.playerView.frame.size.width;
        [self.playerView refreshMoveFrame:beishuNum*_voiceM.moveSpeed*p.x];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragingFloat: index:)]) {
        if ((_voiceM.voice_len.floatValue/self.playerView.frame.size.width)*p.x < _voiceM.voice_len.length/5) {
            return;
        }
        [self.delegate dragingFloat:(_voiceM.voice_len.floatValue/self.playerView.frame.size.width)*p.x index:0];
    }
}
@end
