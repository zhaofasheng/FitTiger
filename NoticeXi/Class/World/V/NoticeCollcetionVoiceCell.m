//
//  NoticeCollcetionVoiceCell.m
//  NoticeXi
//
//  Created by li lei on 2023/2/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeCollcetionVoiceCell.h"
#import "NoticeBingGanListView.h"
#import "NoticerTopicSearchResultNewController.h"
#import "UIView+Shadow.h"
@implementation NoticeCollcetionVoiceCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 8;
        self.contentView.layer.masksToBounds = YES;
        
        self.bkFmimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
        self.bkFmimageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bkFmimageView.clipsToBounds = YES;
        self.bkFmimageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.bkFmimageView];
        self.bkFmimageView.hidden = YES;
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualView.frame = self.bkFmimageView.bounds;
        [self.bkFmimageView addSubview:visualView];
        self.visualView = visualView;
        
        self.showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width-32)];
        self.showImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.showImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.showImageView];
        
        self.voicePlayBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 15, self.frame.size.width-38, self.frame.size.width-38)];
        self.voicePlayBackImageView.image = UIImageNamed(@"voice_cdimg");
        [self.contentView addSubview:self.voicePlayBackImageView];
        self.voicePlayBackImageView.userInteractionEnabled = YES;
        [self.voicePlayBackImageView setButtonShadowWithbuttonRadius:self.voicePlayBackImageView.frame.size.width];
        
        self.voiceShowImageView.hidden = YES;
        
        self.voiceShowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29, 29, self.voicePlayBackImageView.frame.size.width-58, self.voicePlayBackImageView.frame.size.width-58)];
        self.voiceShowImageView.userInteractionEnabled = YES;
        self.voiceShowImageView.layer.masksToBounds = YES;
        [self.voicePlayBackImageView addSubview:self.voiceShowImageView];
        self.voiceShowImageView.hidden = YES;
        
        self.voiceLenL = [[NoticeTextSpaceLabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.voicePlayBackImageView.frame), 72, 16)];
        self.voiceLenL.font = ELEVENTEXTFONTSIZE;
        self.voiceLenL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:self.voiceLenL];
        
        UIImageView *voiceBoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        voiceBoImg.image = UIImageNamed(@"img_voicebowen");
        [self.voicePlayBackImageView addSubview:voiceBoImg];
        self.playImageV = voiceBoImg;
        voiceBoImg.userInteractionEnabled = YES;

        
        self.voiceLenL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [self.playImageV addGestureRecognizer:tap];
        
        self.infoView = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-32, self.frame.size.width, 32)];
      
        [self.contentView addSubview:self.infoView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,6, 20, 20)];
        self.iconImageView.layer.cornerRadius = 10;
        self.iconImageView.layer.masksToBounds = YES;
        [self.infoView addSubview:self.iconImageView];
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, self.infoView.frame.size.width-28-52, 32)];
        self.nickNameL.font = ELEVENTEXTFONTSIZE;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.infoView addSubview:self.nickNameL];

        self.showImageView.userInteractionEnabled = YES;
        
        self.markL = [[UILabel alloc] init];
        self.markL.font = [UIFont systemFontOfSize:10];
        self.markL.textColor = [UIColor whiteColor];
        self.markL.textAlignment = NSTextAlignmentCenter;
        self.markL.layer.cornerRadius = 2;
        self.markL.layer.masksToBounds = YES;
        [self.showImageView addSubview:self.markL];
        
        self.textNumL = [[UILabel alloc] initWithFrame:CGRectMake(8, self.showImageView.frame.size.height-24-8, 72, 24)];
        self.textNumL.font = [UIFont systemFontOfSize:11];
        self.textNumL.textColor = [UIColor whiteColor];
        [self.showImageView addSubview:self.textNumL];
        self.textNumL.layer.shadowOpacity = 1;
        self.textNumL.layer.shadowRadius = 3;
        self.textNumL.layer.shadowColor = [UIColor blackColor].CGColor;
        self.textNumL.layer.shadowOffset = CGSizeMake(0.5, 1.0);
        self.textNumL.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        self.contentL = [[UILabel alloc] init];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.numberOfLines = 0;
        [self.contentView addSubview:self.contentL];
        UITapGestureRecognizer *topicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTap)];
        [self.contentL addGestureRecognizer:topicTap];
        
        self.contentView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT.minimumPressDuration = 0.3;
        [self.contentView addGestureRecognizer:longPressDeleT];
        
        //屏蔽别人心情
        self.pinbTools = [[NoticeVoicePinbi alloc] init];
        self.pinbTools.delegate = self;
        
        UIButton *likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.infoView.frame.size.width-5-32, 0, 32, 32)];
        [likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.infoView addSubview:likeBtn];
        
        self.dataButton = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 20, 20)];
        self.dataButton.userInteractionEnabled = NO;
        [likeBtn addSubview:self.dataButton];
    }
    return self;
}

- (void)deleTapT:(UILongPressGestureRecognizer *)tap{

    if (tap.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hasClickMoreWith:)]) {//更多点击
            [self.delegate hasClickMoreWith:self.index];
        }
        
        if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
            [self.pinbTools pinbiWithModel:_voiceM];
        }
    }
}

//屏蔽成功回调
- (void)pinbiSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(otherPinbSuccess)]) {
        [self.delegate otherPinbSuccess];
    }
}

- (void)markSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreMarkSuccess)]) {
        [self.delegate moreMarkSuccess];
    }
}

//点击播放
- (void)playNoReplay{
    DRLog(@"点击播放区域");
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop:)]) {
        [self.delegate startPlayAndStop:self.index];
    }
}

- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.subUserModel.avatar_url]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageRefreshCached];
    self.nickNameL.text = voiceM.subUserModel.nick_name;
    
    self.voiceShowImageView.hidden = YES;
    if (voiceM.img_list.count){
        self.voiceShowImageView.hidden = NO;
        if(voiceM.content_type.intValue != 1){
            if ([voiceM.img_list[0] containsString:@".gif"] || [voiceM.img_list[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [self.showImageView setImageWithURL:[NSURL URLWithString:voiceM.img_list[0]] placeholder:UIImageNamed(@"Image_pubumoren") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [self.showImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.img_list[0]] placeholderImage:UIImageNamed(@"Image_pubumoren") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
        }else{
            [self.bkFmimageView sd_setImageWithURL:[NSURL URLWithString:voiceM.img_list[0]] placeholderImage:UIImageNamed(@"Image_voicmoren") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
             
            }];
            if ([voiceM.img_list[0] containsString:@".gif"] || [voiceM.img_list[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [self.voiceShowImageView setImageWithURL:[NSURL URLWithString:voiceM.img_list[0]] placeholder:UIImageNamed(@"Image_pubumoren") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [self.voiceShowImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.img_list[0]] placeholderImage:UIImageNamed(@"Image_pubumoren") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                 
                }];
            }
        }

        
    }else{
        if(voiceM.content_type.intValue == 1){
            self.bkFmimageView.image = UIImageNamed(@"Image_voicmoren");
        }else{
            [self.showImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.default_img]
                                  placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                           options:SDWebImageRefreshCached];
        }
    }
    

    self.dataButton.image = UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbgs": @"Ima_sendbgnws");
    self.showImageView.frame = CGRectMake(0, 0, self.frame.size.width, voiceM.height-32-voiceM.textPbheight);
    self.infoView.frame = CGRectMake(0, self.frame.size.height-32, self.frame.size.width, 32);
    self.nickNameL.frame = CGRectMake(28, 0, self.infoView.frame.size.width-28-52, 32);
    
    if (voiceM.content_type.intValue == 1) {
        self.showImageView.hidden = YES;
        self.voicePlayBackImageView.hidden = NO;
        self.voiceLenL.hidden = NO;
        self.voiceLenL.text = [NSString stringWithFormat:@"%@s    ",voiceM.nowTime.integerValue?voiceM.nowTime:voiceM.voice_len];
        
        self.voicePlayBackImageView.frame = CGRectMake(19, 15, self.frame.size.width-38, self.frame.size.width-38);
        self.voiceShowImageView.frame = CGRectMake(29, 29, self.voicePlayBackImageView.frame.size.width-58, self.voicePlayBackImageView.frame.size.width-58);
        self.voiceShowImageView.layer.cornerRadius = self.voiceShowImageView.frame.size.width/2;
        self.playImageV.frame = CGRectMake((self.voicePlayBackImageView.frame.size.width-24)/2, (self.voicePlayBackImageView.frame.size.width-24)/2, 24, 24);
        self.voiceLenL.frame = CGRectMake(8, CGRectGetMaxY(self.voicePlayBackImageView.frame), 72, 16);
        self.bkFmimageView.hidden = NO;
        self.bkFmimageView.frame = self.bounds;
        self.visualView.frame = self.bounds;
    
    }else{
        self.bkFmimageView.hidden = YES;
        self.voicePlayBackImageView.hidden = YES;
        self.showImageView.hidden = NO;
        self.voiceLenL.hidden = YES;
    }
    
    self.markL.hidden = YES;
    if ((voiceM.voiceIdentity.intValue == 4 && self.isGround) || voiceM.isSelf || voiceM.isTop) {
        self.markL.hidden = NO;
        if (voiceM.isTop) {
            self.markL.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            self.markL.text = @"声昔Pick";
        }else if (voiceM.isSelf){
            self.markL.backgroundColor = [UIColor colorWithHexString:@"#000000"];
            if (voiceM.voiceIdentity.intValue == 1) {
                self.markL.text = [NoticeTools getLocalStrWith:@"n.open"];
            }else if (voiceM.voiceIdentity.intValue == 2){
                self.markL.text = [NoticeTools getLocalStrWith:@"n.tpkjian"];
            }else{
                self.markL.text = [NoticeTools getLocalStrWith:@"n.onlyself"];
            }
        }else{
            self.markL.text =[NoticeTools chinese:@"你的欣赏" english:@"Following" japan:@"フォロワー"];
            self.markL.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
        }
        self.markL.frame = CGRectMake(8, 8, GET_STRWIDTH(self.markL.text, 10, 16)+8, 16);
    }
    
    self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.contentL.hidden = YES;
    self.textNumL.hidden = YES;
    if (voiceM.content_type.intValue == 2) {
        self.textNumL.frame = CGRectMake(8, self.showImageView.frame.size.height-24-8, 72, 24);
        self.textNumL.hidden = NO;
        self.textNumL.text = [NSString stringWithFormat:@"%ld字",voiceM.voice_content.length];
        
        self.contentL.hidden = NO;
        self.contentL.frame = CGRectMake(8, CGRectGetMaxY(self.showImageView.frame)+4, self.frame.size.width-16, voiceM.textPbheight);
       
        if(voiceM.topicName && voiceM.topicName.length){//存在话题
            self.contentL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@%@",voiceM.topicName,voiceM.voice_content] setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:voiceM.topicName beginSize:0];
        }else{
            self.contentL.text = voiceM.textContent;
        }
    }else{
        if(voiceM.topicName && voiceM.topicName.length){//存在话题
            self.contentL.hidden = NO;
            self.contentL.frame = CGRectMake(8, CGRectGetMaxY(self.showImageView.frame)+4, self.frame.size.width-16, voiceM.textPbheight);
            self.contentL.text = voiceM.topicName;
            self.contentL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        }
    }
    
    if(voiceM.topic_name && _voiceM.topic_name.length){
        self.contentL.userInteractionEnabled = YES;
    }else{
        self.contentL.userInteractionEnabled = NO;
    }
}

- (NSShadow *)shadow{
    if(!_shadow){
        _shadow = [[NSShadow alloc] init];
        _shadow.shadowBlurRadius = 6;
        _shadow.shadowOffset = CGSizeMake(0, 0);
        _shadow.shadowColor = [UIColor blackColor];
    }
    return _shadow;
}

- (void)topTap{
    if (_voiceM.topic_name && _voiceM.topic_name.length) {
        NoticerTopicSearchResultNewController *ctl = [[NoticerTopicSearchResultNewController alloc] init];
        ctl.topicName = _voiceM.topic_name;
        ctl.topicId = _voiceM.topic_id;
        if (_voiceM.content_type.intValue == 2) {
            ctl.isTextVoice = YES;
        }
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)likeClick{

    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.is_collected.boolValue) {//取消「有启发」
            _voiceM.likeNoMove = YES;
            _voiceM.canTapLike = YES;
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    self->_voiceM.is_collected = @"0";

                    self.voiceM.zaned_num = [NSString stringWithFormat:@"%d",self.voiceM.zaned_num.intValue-1];
                    if (self.voiceM.zaned_num.intValue < 0) {
                        self.voiceM.zaned_num = @"0";
                    }
                    self.dataButton.image = UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbgs": @"Ima_sendbgnws");
        
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelCollectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
                }
                self->_voiceM.canTapLike = NO;
            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
            }];
        }else{
            _voiceM.canTapLike = YES;
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:@"5" forKey:@"needDelay"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    self->_voiceM.canTapLike = NO;
                    self->_voiceM.is_collected = @"1";
                    self.voiceM.zaned_num = [NSString stringWithFormat:@"%d",self.voiceM.zaned_num.intValue+1];
                    [[NoticeTools getTopViewController] showToastWithText:[NoticeTools getLocalStrWith:@"em.senbgt"]];
                    self.dataButton.image = UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbgs": @"Ima_sendbgnws");
    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
                }
            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
                [[NoticeTools getTopViewController] hideHUD];
            }];
        }
        return;
    }
    
    if (!self.voiceM.zaned_num.intValue) {
        [[NoticeTools getTopViewController] showToastWithText:[NoticeTools getLocalStrWith:@"py.noBg"]];
        return;
    }
    NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    listView.voiceM = self.voiceM;
    [listView showTost];
}

@end
