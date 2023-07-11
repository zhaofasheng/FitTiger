//
//  NoticeNewVoiceListCell.m
//  NoticeXi
//
//  Created by li lei on 2021/3/26.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewVoiceListCell.h"
#import "BaseNavigationController.h"
#import "NoticerTopicSearchResultNewController.h"
#import "NoticeTabbarController.h"
#import "NoticeBackVoiceViewController.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMyMovieController.h"
#import "NoticeMyBookController.h"
#import "NoticeMySongController.h"
#import "NoticeMyMovieComController.h"
#import "UIView+CLSetRect.h"
#import "NoticeBingGanListView.h"
//获取全局并发队列和主队列的宏定义
#define globalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define mainQueue dispatch_get_main_queue()
@implementation NoticeNewVoiceListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.contentView.userInteractionEnabled = YES;

        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-85) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[NoticeVoiceCommentCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:self.tableView];
        
        self.headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, 472+12)];
        self.headerView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        self.tableView.tableHeaderView = self.headerView;
        self.headerView.userInteractionEnabled = YES;
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, DR_SCREEN_WIDTH-40, 472)];
        backImageView.image = UIImageNamed(@"playvoice_backsimg");
        [backImageView setAllCorner:5];
        backImageView.userInteractionEnabled = YES;
        [self.headerView addSubview:backImageView];
        self.cdplayView = backImageView;
        
        self.voicePlayBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake((backImageView.frame.size.width-216)/2, 74,216, 216)];
        self.voicePlayBackImageView.image = UIImageNamed(@"voice_cdplayimg");
        [backImageView addSubview:self.voicePlayBackImageView];
        self.voicePlayBackImageView.userInteractionEnabled = YES;
        
        //话题
        _topiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,336, self.cdplayView.frame.size.width-40, 20)];
        _topiceLabel.font = FIFTHTEENTEXTFONTSIZE;
        _topiceLabel.textColor = [UIColor colorWithHexString:@"#456DA0"];
        _topiceLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *taptop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTextClick)];
        [_topiceLabel addGestureRecognizer:taptop];
        [self.cdplayView addSubview:_topiceLabel];
        
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(self.cdplayView.frame.size.width-64, 384, 44, 44)];
        [self.playButton addTarget:self action:@selector(playNoReplay) forControlEvents:UIControlEventTouchUpInside];
        [self.playButton setBackgroundImage:UIImageNamed(@"playvcd_img") forState:UIControlStateNormal];
        [self.cdplayView addSubview:self.playButton];

        
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(20,402, DR_SCREEN_WIDTH-40-150, 13)];
        _slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#25262E"];
        _slider.maximumTrackTintColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.1];
        [_slider setThumbImage:UIImageNamed(@"Image_trak_sgjs") forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(handleSlide:) forControlEvents:UIControlEventValueChanged];
        [self.cdplayView addSubview:_slider];
        
        _minTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(_slider.frame)+9, GET_STRWIDTH(@"000:00", 10, 14), 14)];
        _minTimeLabel.text = @"00:00";
        _minTimeLabel.font = [UIFont systemFontOfSize:10];
        _minTimeLabel.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.cdplayView addSubview:_minTimeLabel];
        
        _maxTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_slider.frame)-GET_STRWIDTH(@"00:000", 10, 10), CGRectGetMaxY(_slider.frame)+9, GET_STRWIDTH(@"00:000", 10, 10), 10)];
        _maxTimeLabel.text = @"00:00";
        _maxTimeLabel.font = [UIFont systemFontOfSize:10];
        _maxTimeLabel.textAlignment = NSTextAlignmentRight;
        _maxTimeLabel.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.cdplayView addSubview:_maxTimeLabel];
        
        _mbView = [[UIView alloc] initWithFrame:CGRectMake(50,(STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT-39)/2, 39, 39)];
        _mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self.contentView addSubview:_mbView];
        _mbView.layer.cornerRadius = 39/2;
        _mbView.layer.masksToBounds = YES;
        _mbView.userInteractionEnabled = YES;
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 39)];
        [_mbView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        
        self.iconMarkView.layer.masksToBounds = YES;

        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2,2, 35, 35)];
        _iconImageView.layer.cornerRadius = 35/2;
        _iconImageView.layer.masksToBounds = YES;
        [_mbView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mbView.frame)+8,STATUS_BAR_HEIGHT,DR_SCREEN_WIDTH-50-8-39, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        _nickNameL.font = XGEightBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:_nickNameL];
        
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-65-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, 65+BOTTOM_HEIGHT+20)];
        self.buttonView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.buttonView.layer.cornerRadius = 10;
        self.buttonView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.buttonView];
        self.buttonView.userInteractionEnabled = YES;
        
        UIView *comView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 120, 40)];
        comView.userInteractionEnabled = YES;
        comView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        comView.layer.cornerRadius = 20;
        comView.layer.masksToBounds = YES;
        [self.buttonView addSubview:comView];
        
        UIImageView *comImagv = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 20, 20)];
        [comView addSubview:comImagv];
        comImagv.image = UIImageNamed(@"Image_editcom");
        
        UILabel *editL = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, comView.frame.size.width-32, 40)];
        editL.font = TWOTEXTFONTSIZE;
        editL.text = [NoticeTools getLocalStrWith:@"ly.openis"];
        editL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [comView addSubview:editL];
        
        UITapGestureRecognizer *edittap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTap)];
        [comView addGestureRecognizer:edittap];
        
        CGFloat btnWidth = (DR_SCREEN_WIDTH-20-120)/4;
        
        for (int i = 0; i < 4; i++) {
            UIView *subBtnView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(comView.frame)+btnWidth*i,15, btnWidth,50)];
            subBtnView.userInteractionEnabled = YES;
            subBtnView.tag = i;
            [self.buttonView addSubview:subBtnView];
            
            UITapGestureRecognizer *funTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funTap:)];
            [subBtnView addGestureRecognizer:funTap];
            
            if (i == 0) {
                self.comButton = [[UIButton alloc] initWithFrame:CGRectMake((btnWidth-24)/2, 0, 24, 24)];
                self.comButton.userInteractionEnabled = NO;
                [self.comButton setBackgroundImage:UIImageNamed(@"Image_voicecoms") forState:UIControlStateNormal];
                [subBtnView addSubview:self.comButton];
                
                self.comL = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, btnWidth, 23)];
                self.comL.font = [UIFont systemFontOfSize:10];
                self.comL.textColor = [UIColor colorWithHexString:@"#25262E"];
                self.comL.textAlignment = NSTextAlignmentCenter;
                [subBtnView addSubview:self.comL];
                self.comL.text = [NoticeTools getLocalStrWith:@"cao.liiuyan"];
            }else if (i == 1){
                //
                self.hsButton = [[UIButton alloc] initWithFrame:CGRectMake((btnWidth-24)/2, 0, 24, 24)];
                self.hsButton.userInteractionEnabled = NO;
                [self.hsButton setBackgroundImage:UIImageNamed(@"Image_newhsbtn") forState:UIControlStateNormal];
                [subBtnView addSubview:self.hsButton];
                
                self.numL = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, btnWidth, 23)];
                self.numL.font = [UIFont systemFontOfSize:10];
                self.numL.textColor = [UIColor colorWithHexString:@"#25262E"];
                self.numL.textAlignment = NSTextAlignmentCenter;
                [subBtnView addSubview:self.numL];
            }else if (i == 2){
                
                self.sendBGBtn = [[UIButton alloc] initWithFrame:CGRectMake((btnWidth-24)/2, 0, 24, 24)];//
                self.sendBGBtn.userInteractionEnabled = NO;
                [self.sendBGBtn setBackgroundImage:UIImageNamed(@"Image_newbgbtn") forState:UIControlStateNormal];
                [subBtnView addSubview:self.sendBGBtn];

                self.bgL = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, btnWidth, 23)];
                self.bgL.font = [UIFont systemFontOfSize:10];
                self.bgL.textColor = [UIColor colorWithHexString:@"#25262E"];
                self.bgL.textAlignment = NSTextAlignmentCenter;
                [subBtnView addSubview:self.bgL];
            }else{
                self.careButton = [[UIButton alloc] initWithFrame:CGRectMake((btnWidth-24)/2, 0, 24, 24)];
                self.careButton.userInteractionEnabled = NO;
                [self.careButton setBackgroundImage:UIImageNamed(@"Image_liketa") forState:UIControlStateNormal];
                [subBtnView addSubview:self.careButton];
                
                self.likeStatusL = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, btnWidth, 23)];
                self.likeStatusL.font = [UIFont systemFontOfSize:10];
                self.likeStatusL.textColor = [UIColor colorWithHexString:@"#25262E"];
                self.likeStatusL.textAlignment = NSTextAlignmentCenter;
                [subBtnView addSubview:self.likeStatusL];
            }
        }
        
        self.userInteractionEnabled = YES;


        self.otherMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [self.contentView addSubview:self.otherMoreBtn];
        self.otherMoreBtn.hidden = YES;
        [self.otherMoreBtn setImage:UIImageNamed(@"Image_sangedian") forState:UIControlStateNormal];
        [self.otherMoreBtn addTarget:self action:@selector(otherClick) forControlEvents:UIControlEventTouchUpInside];
        self.otherMoreBtn.hidden = YES;
        
        //屏蔽别人心情
        self.pinbTools = [[NoticeVoicePinbi alloc] init];
        self.pinbTools.delegate = self;
        
    }
    return self;
}

- (UIImageView *)voiceimageView{
    if(!_voiceimageView){
        _voiceimageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 76, 212, 212)];
        _voiceimageView.userInteractionEnabled = YES;
        [self.cdplayView addSubview:_voiceimageView];
        self.numBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(155, 212-28, 57, 28)];
        self.numBtn.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        self.numBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.numBtn setImage:UIImageNamed(@"imgnums_marimg") forState:UIControlStateNormal];
        self.numBtn.buttonImagePosition = FSCustomButtonImagePositionLeft;
        [self.numBtn addTarget:self action:@selector(lookMoreImg) forControlEvents:UIControlEventTouchUpInside];
        [_voiceimageView addSubview:self.numBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMoreImg)];
        [_voiceimageView addGestureRecognizer:tap];
    }
    return _voiceimageView;
}

- (UILabel *)redNumL{
    if (!_redNumL) {

        self.redNumL = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, self.cdplayView.frame.size.width, 20)];
        self.redNumL.font = [UIFont fontWithName:@"zihunxinquhei" size:18];
        self.redNumL.textAlignment = NSTextAlignmentCenter;
        self.redNumL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        [self.cdplayView addSubview:self.redNumL];
    }
    return _redNumL;
}

- (NoticeBgmHasChoiceShowView *)bgmChoiceView{
    if (!_bgmChoiceView) {
        _bgmChoiceView = [[NoticeBgmHasChoiceShowView alloc] initWithFrame:CGRectMake(20, 365, DR_SCREEN_WIDTH-40-40, 20)];
        [self.cdplayView addSubview:_bgmChoiceView];
        _bgmChoiceView.isShow = YES;
        _bgmChoiceView.closeBtn.hidden = YES;
        _bgmChoiceView.nameView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        _bgmChoiceView.nameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _bgmChoiceView.markImageView.image = UIImageNamed(@"dark_bgmimg");
        _bgmChoiceView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        _bgmChoiceView.hidden = YES;
        
        _bgmChoiceView.layer.shadowColor = [UIColor blackColor].CGColor;
        _bgmChoiceView.layer.shadowOpacity = 0.8f;
        _bgmChoiceView.layer.shadowRadius = 4.f;
        _bgmChoiceView.layer.shadowOffset = CGSizeMake(4,4);
    }
    return _bgmChoiceView;
}

- (NoticeBBSComentInputView *)inputView{
    if (!_inputView) {
        _inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        _inputView.delegate = self;
        _inputView.isRead = YES;
        _inputView.isVoiceComment = YES;
        _inputView.limitNum = 100;
        _inputView.plaStr = [NoticeTools getLocalStrWith:@"ly.openis"];
        _inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        _inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
    return _inputView;
}

- (void)lookMoreImg{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSString *str in self.voiceM.img_list) {
        NSArray *array = [str componentsSeparatedByString:@"?"];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        
        item.thumbView         = self.voiceimageView;
        item.largeImageURL     = [NSURL URLWithString:array[0]];
        [photos addObject:item];
    }

    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:photos];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:self.voiceimageView
                   toContainer:toView
                      animated:YES completion:nil];
}

//点击留言
- (void)editTap{
    self.inputView.saveKey = [NSString stringWithFormat:@"voicecom%@%@",[NoticeTools getuserId],self.voiceM.voice_id];
    [self.inputView.contentView becomeFirstResponder];
    [self.inputView showJustComment:nil];
}


- (void)funTap:(UITapGestureRecognizer *)tap{
    UIView *tapView = (UIView *)tap.view;
    if (tapView.tag == 0) {//留言

        if (self.dataArr.count) {
            if (self.dataArr.count) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
            return;
        }
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"no.noliuyan"]];
    }else if (tapView.tag == 1) {//悄悄话
        [self replayClick];
    }else if (tapView.tag == 2) {//贴贴
        [self likeClick];
    }else if (tapView.tag == 3) {//欣赏或者加到专辑
        
        if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
            [self careClick];
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(addVoiceToZj)]) {
                [self.delegate addVoiceToZj];
            }
        }
    }
}

- (void)likeClick{
    //判断是否是自己,不是自己则为点击「有启发」
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){

        if (_voiceM.is_collected.boolValue) {//取消「有启发」
            if (_voiceM.canTapLike) {//防止多次点击
                return;
            }
            _voiceM.likeNoMove = YES;
            _voiceM.is_collected = @"0";
            [self.sendBGBtn setBackgroundImage:UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbg": @"Ima_sendbgn") forState:UIControlStateNormal];

            [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelCollectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
            _voiceM.canTapLike = YES;
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {

                if (success) {
                    self->_voiceM.canTapLike = NO;
                    self->_voiceM.is_collected = @"0";
                }
            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
            }];
        }else{//「有启发」
      
            if (_voiceM.canTapLike) {
                return;
            }
            [self.sendBGBtn setBackgroundImage:UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbg": @"Ima_sendbgn") forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
            _voiceM.is_collected = @"1";
            _voiceM.canTapLike = YES;
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:@"5" forKey:@"needDelay"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    self->_voiceM.canTapLike = NO;
                    self->_voiceM.is_collected = @"1";
                    [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"em.senbgt"]];
                }

            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
                [nav.topViewController hideHUD];
            }];
        }
        return;
    }
    if (!self.voiceM.zaned_num.intValue) {
        [nav.topViewController showToastWithText:@"还没有收到贴贴哦~"];
        return;
    }
    NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    listView.voiceM = self.voiceM;
    [listView showTost];
}


- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;

    //话题
    if (voiceM.topic_name && voiceM.topic_name.length) {
        self.topiceLabel.text = voiceM.topicName;
        self.topiceLabel.hidden = NO;
    }else{
        self.topiceLabel.hidden = YES;
    }
        
   // [self showName];
    
    self.nickNameL.text = voiceM.subUserModel.nick_name;
    [self.sendBGBtn setBackgroundImage:UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbg": @"Image_newbgbtn") forState:UIControlStateNormal];

    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.subUserModel.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    

    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.chat_num.integerValue) {
            self.numL.text = _voiceM.chat_num;
        }else{
            self.numL.text = @"";
        }
    }else{
        if (_voiceM.dialog_num.integerValue) {
            self.numL.text = _voiceM.dialog_num;
        }else{
            self.numL.text = @"";
        }
    }
    
    
    if (voiceM.is_private.boolValue) {
        self.numL.hidden = YES;
        self.hsButton.hidden = YES;
        self.sendBGBtn.hidden = YES;
        self.bgL.hidden = YES;
    }else{
        self.bgL.hidden = NO;
        self.numL.hidden = NO;
        self.hsButton.hidden = NO;
        self.sendBGBtn.hidden = NO;
    }

    self.iconMarkView.image = UIImageNamed(_voiceM.subUserModel.levelImgIconName);
    self.redNumL.text = voiceM.creatTime1;

    voiceM.isDownloading = YES;


    if (voiceM.bgm_name) {
        self.bgmChoiceView.hidden = NO;
        self.bgmChoiceView.title = voiceM.bgm_name;
    }else{
        _bgmChoiceView.hidden = YES;
    }

    //对话或者悄悄话数量
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.chat_num.integerValue) {
            self.numL.text = _voiceM.chat_num;
        }else{
            self.numL.text = [NoticeTools getLocalStrWith:@"em.hs"];
        }
        if (_voiceM.zaned_num.intValue) {
            self.bgL.text = _voiceM.zaned_num;
        }else{
            self.bgL.text = [NoticeTools getLocalStrWith:@"py.bg"];
        }
        self.otherMoreBtn.hidden = YES;
        
        if (self.voiceM.albumArr.count) {
            [self.careButton setBackgroundImage:UIImageNamed(@"Image_jonnzjy") forState:UIControlStateNormal];
            NoticeZjModel *zjM = self.voiceM.albumArr[0];
            self.likeStatusL.text = zjM.album_name;
        
        }else{
            [self.careButton setBackgroundImage:UIImageNamed(@"Image_jonnzj") forState:UIControlStateNormal];
            self.likeStatusL.text = [NoticeTools getLocalStrWith:@"add.zjian"];
        }
    }else{
        if (_voiceM.dialog_num.integerValue) {
            self.numL.text = _voiceM.dialog_num;
        }else{
            self.numL.text = [NoticeTools getLocalStrWith:@"em.hs"];
        }
        self.bgL.text = [NoticeTools getLocalStrWith:@"py.bg"];
        if (!_voiceM.resource) {
            self.careButton.hidden = NO;
        }else{
            self.careButton.hidden = YES;
        }
        
        
        if (_voiceM.is_myadmire.intValue) {
            [self.careButton setBackgroundImage:UIImageNamed(@"Image_liketay") forState:UIControlStateNormal];
            self.likeStatusL.text = [NoticeTools getLocalStrWith:@"intro.yilike"];
        }else{
            [self.careButton setBackgroundImage:UIImageNamed(@"Image_liketa") forState:UIControlStateNormal];
            self.likeStatusL.text = [NoticeTools getLocalStrWith:@"minee.xs"];
        }
        if (self.needMoreBtn) {
            self.otherMoreBtn.hidden = NO;
        }
    }
    
    [self.comButton setBackgroundImage:UIImageNamed(@"Image_voicecoms") forState:UIControlStateNormal];
    self.comL.textColor = [UIColor colorWithHexString:@"#25262E"];
    if (!self.dataArr.count && !self.isSendLy) {
        self.isDown = YES;
        [self requestData];
    }

    self.slider.value = voiceM.nowPro > 0?voiceM.nowPro: 0;
    self.slider.maximumValue = self.voiceM.voice_len.intValue;
    self.slider.minimumValue = 0;
    self.minTimeLabel.text = voiceM.nowPro > 0? [self getMMSSFromSS:self.voiceM.voice_len.intValue-voiceM.nowTime.intValue]: @"00:00";
    self.maxTimeLabel.text = voiceM.nowPro > 0? [self getMMSSFromSS:voiceM.nowTime.intValue]:[self getMMSSFromSS:self.voiceM.voice_len.intValue];
    
    if(voiceM.img_list.count){
        self.voiceimageView.hidden = NO;
        self.voicePlayBackImageView.frame = CGRectMake(self.cdplayView.frame.size.width-216-12, 74,216, 216);
        [self.voiceimageView setImageWithURL:[NSURL URLWithString:voiceM.img_list[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
       
        }];
        [self.numBtn setTitle:[NSString stringWithFormat:@"%ld张",voiceM.img_list.count] forState:UIControlStateNormal];
    }else{
        _voiceimageView.hidden = YES;
        self.voicePlayBackImageView.frame = CGRectMake((self.cdplayView.frame.size.width-216)/2, 74,216, 216);
    }
}

-(NSString *)getMMSSFromSS:(NSInteger)totalTime{
    
    NSInteger seconds = totalTime;
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    if (seconds <0) {
        return format_time = @"00:00";
    }
    return format_time;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.voiceM = self.voiceM;
    cell.comModel = self.dataArr[indexPath.row];

    __weak typeof(self) weakSelf = self;

    cell.deleteComBlock = ^(NSString * _Nonnull comId) {
        for (NoticeVoiceComModel *inM in weakSelf.dataArr) {
            if ([inM.subId isEqualToString:comId]) {
                [weakSelf.dataArr removeObject:inM];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    cell.manageDeleteComBlock = ^(NSString * _Nonnull comId) {
        for (NoticeVoiceComModel *inM in weakSelf.dataArr) {
            if ([inM.subId isEqualToString:comId]) {
                inM.comment_status = @"3";
                inM.content = [NoticeTools getLocalStrWith:@"nesw.hasdel"];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceComModel *model = self.dataArr[indexPath.row];
    if (model.replys.count) {//有回复
        NoticeVoiceComModel *subModel = model.replysArr[0];
        if (model.reply_num.integerValue > 1) {//超过一条回复
            return model.mainTextHeight+subModel.subTextHeight+83+10+69+40;
        }
        return model.mainTextHeight+subModel.subTextHeight+83+10+69;
    }
    return model.mainTextHeight+83;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

- (UIView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        _sectionView.backgroundColor = self.contentView.backgroundColor;
        
        self.lyNumL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 50)];
        self.lyNumL.font = XGSIXBoldFontSize;
        self.lyNumL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_sectionView addSubview:self.lyNumL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-20, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [_sectionView addSubview:line];
    }
    return _sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)requestData{
   
    if(self.voiceM.isRequesting){
        return;
    }
    
    NSString *url = nil;
    if (self.isDown) {
        self.pageNo = 1;
        url = [NSString stringWithFormat:@"voice/comment/%@?pageNo=1",self.voiceM.voice_id];
    }else{
        url = [NSString stringWithFormat:@"voice/comment/%@?pageNo=%ld",self.voiceM.voice_id,self.pageNo];
    }
    
    self.voiceM.isRequesting = YES;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.3.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            self.sectionView.hidden = NO;
            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if ([NoticeTools getLocalType] == 1) {
                self.lyNumL.text = [NSString stringWithFormat:@"%@ comments",allM.total];
            }else if ([NoticeTools getLocalType] == 2){
                self.lyNumL.text = [NSString stringWithFormat:@"%@ コメント",allM.total];
            }else{
                self.lyNumL.text = [NSString stringWithFormat:@"%@条留言",allM.total];
            }

            for (NSDictionary *dic in allM.list) {
                NoticeVoiceComModel *model = [NoticeVoiceComModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }

            [self.tableView reloadData];
        }
        self.voiceM.isRequesting = NO;
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError * _Nullable error) {
        self.voiceM.isRequesting = NO;
    }];
}

- (void)createRefesh{
    
    __weak NoticeNewVoiceListCell *ctl = self;

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo ++;
        ctl.isDown = NO;
        [ctl requestData];
    }];
}

//点击发送
- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    if (!comment || !comment.length) {
        return;
    }
    self.isSendLy = YES;
    if (self.dataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:comment forKey:@"content"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voice/comment/%@/%@",self.voiceM.voice_id,@"0"] Accept:@"application/vnd.shengxi.v5.3.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.isDown = YES;
            [self requestData];
            
        }
        self.isSendLy = NO;
    } fail:^(NSError * _Nullable error) {
        self.isSendLy = NO;
    }];
}

- (void)otherClick{
    [self.pinbTools pinbiWithModel:_voiceM];
}

//屏蔽成功回调
- (void)pinbiSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(otherPinbSuccess)]) {
        [self.delegate otherPinbSuccess];
    }
}

//点击悄悄话
- (void)replayClick{

    if (self.noPush) {
        if (self.replyClickBlock) {
            self.replyClickBlock(YES);
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHS:)]) {
        [self.delegate clickHS:self.voiceM];
    }
    
}

- (void)deleteCare{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    //_voiceM.subUserModel.userId
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admires/%@",_voiceM.subUserModel.userId] Accept:@"application/vnd.shengxi.v5.1.0+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self.voiceM.is_myadmire = @"0";
            if (self.voiceM.is_myadmire.intValue) {
                [self.careButton setBackgroundImage:UIImageNamed(@"Image_liketay") forState:UIControlStateNormal];
                self.likeStatusL.text = [NoticeTools getLocalStrWith:@"intro.yilike"];
            }else{
                [self.careButton setBackgroundImage:UIImageNamed(@"Image_liketa") forState:UIControlStateNormal];
                self.likeStatusL.text = [NoticeTools getLocalStrWith:@"minee.xs"];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

//欣赏
- (void)careClick{

    if (self.voiceM.is_myadmire.intValue) {
        
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"xs.surecanxs"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf deleteCare];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    //_voiceM.subUserModel.userId
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:_voiceM.subUserModel.userId forKey:@"toUserId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admires" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeMJIDModel *idM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            self.voiceM.is_myadmire = idM.allId;
            if (self.voiceM.is_myadmire.intValue) {
                [self.careButton setBackgroundImage:UIImageNamed(@"Image_liketay") forState:UIControlStateNormal];
                self.likeStatusL.text = [NoticeTools getLocalStrWith:@"intro.yilike"];
                [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"xs.xssus"]];
            }else{
                [self.careButton setBackgroundImage:UIImageNamed(@"Image_liketa") forState:UIControlStateNormal];
                self.likeStatusL.text = [NoticeTools getLocalStrWith:@"minee.xs"];
            }
        }
        [nav.topViewController hideHUD];
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)userInfoTap{
//    if (self.noPushToUserCenter) {
//        return;
//    }
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    
    __weak typeof(self) weakSelf = self;
    ctl.careClickBlock = ^(NSString * _Nonnull careId, NSString * _Nonnull userId) {
        weakSelf.voiceM.is_myadmire = careId;
        if (weakSelf.voiceM.is_myadmire.intValue) {
            [weakSelf.careButton setBackgroundImage:UIImageNamed(@"Image_liketay") forState:UIControlStateNormal];
            weakSelf.likeStatusL.text = [NoticeTools getLocalStrWith:@"intro.yilike"];
        }else{
            [weakSelf.careButton setBackgroundImage:UIImageNamed(@"Image_liketa") forState:UIControlStateNormal];
            weakSelf.likeStatusL.text = [NoticeTools getLocalStrWith:@"minee.xs"];
        }
    };
    
    
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


//点击播放
- (void)playNoReplay{
    DRLog(@"点击播放区域");
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop:)]) {
        [self.delegate startPlayAndStop:self.index];
    }
}

//滑动进度条
- (void)handleSlide:(UISlider *)slider{
    if(!_voiceM.isPlaying){
        [self playNoReplay];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag: progross:)]) {
        [self.delegate endDrag:self.tag progross:slider.value];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
