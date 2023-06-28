//
//  NoticeWhitePyCell.m
//  NoticeXi
//
//  Created by li lei on 2022/12/15.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeWhitePyCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMineViewController.h"
#import "NoticeTcPageController.h"
#import "AFHTTPSessionManager.h"
#import "NoticePyComController.h"
#import "NoticeXi-Swift.h"
#import "NoticeUserDubbingAndLineController.h"
@implementation NoticeWhitePyCell

{
    UIView *_playView;//播放点击
    BOOL _isManagerDelete;
    UIButton *_rePlayView;//重播点击,点击重播，就重头开始播放
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 105+68)];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        [self.contentView addSubview:self.backView];
        self.backView.userInteractionEnabled = YES;
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 44, 44)];
        [self.backView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
        [self.backView addSubview:_iconImageView];
        _iconImageView.image = UIImageNamed(@"Image_jynohe");
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        

        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 15, 200, 22)];
        _nickNameL.font = SIXTEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:_nickNameL];
        
        self.lelveImageView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nickNameL.frame)+2, 15, 46, 21)];
        [self.backView addSubview:self.lelveImageView];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+3, 160, 14)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [self.backView addSubview:_timeL];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, 150, 40)];
        self.playerView.delegate = self;
        self.playerView.isThird = YES;
        [self.playerView.playButton setImage:UIImageNamed(@"Image_newplay") forState:UIControlStateNormal];
        [self.backView addSubview:_playerView];
        
        _rePlayView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), _playerView.frame.origin.y,_playerView.frame.size.height, _playerView.frame.size.height)];
        [_rePlayView addTarget:self action:@selector(playReplay) forControlEvents:UIControlEventTouchUpInside];
        [_rePlayView setImage:UIImageNamed(@"Imag_reply_img") forState:UIControlStateNormal];
        _rePlayView.hidden = YES;
        [self.backView addSubview:_rePlayView];
        
        _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,_playerView.frame.size.width, _playerView.frame.size.height)];
        _playView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [_playView addGestureRecognizer:tap];
        [self.playerView addSubview:_playView];
        
        self.contentBackView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.playerView.frame)+15, DR_SCREEN_WIDTH-70, 0)];
        self.contentBackView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.contentBackView.layer.cornerRadius = 10;
        self.contentBackView.layer.masksToBounds = YES;
        [self.backView addSubview:self.contentBackView];
        
        self.typeL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 34)];
        self.typeL.font = TWOTEXTFONTSIZE;
        self.typeL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentBackView addSubview:self.typeL];
        
        self.luyinMarkImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentBackView.frame.size.width-28-16, 8, 16, 16)];
        self.luyinMarkImage.image = UIImageNamed(@"luyinnum_imgbw");
        [self.contentBackView addSubview:self.luyinMarkImage];
        
        self.numRecL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.luyinMarkImage.frame), 8, 28, 16)];
        self.numRecL.textColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
        self.numRecL.font = ELEVENTEXTFONTSIZE;
        [self.contentBackView addSubview:self.numRecL];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(15, 34,self.contentBackView.frame.size.width-30, 0)];
        self.contentL.numberOfLines = 0;
        self.contentL.textColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentBackView addSubview:self.contentL];
        self.contentL.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTcPageTap)];
        [self.contentBackView addGestureRecognizer:labelTap];
        
        self.buttonView = [[NoticeClockButtonView alloc] initWithFrame:CGRectMake(0, 0,self.backView.frame.size.width, 50)];
        self.buttonView.delegate = self;
        self.buttonView.needBackGround = YES;
        [self.backView addSubview:self.buttonView];
        
        __weak typeof(self) weakSelf = self;
        self.buttonView.deletePyBlock = ^(NoticeClockPyModel * _Nonnull pyModel) {
            if (weakSelf.deletePyBlock) {
                weakSelf.deletePyBlock(pyModel);
            }
        };

        self.dragView = [[UIView alloc] initWithFrame:CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height)];
        self.dragView.userInteractionEnabled = YES;
        self.dragView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
        [self.playerView addSubview:self.dragView];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.0;
        [self.dragView addGestureRecognizer:longPress];
        
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-10-24, 15, 24, 24)];
        [moreBtn setBackgroundImage:UIImageNamed(@"Image_moreNeww") forState:UIControlStateNormal];
        [self.backView addSubview:moreBtn];
        [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.pickerL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y-6, 23, 14)];
        self.pickerL.layer.cornerRadius = 3;
        self.pickerL.layer.masksToBounds = YES;
        self.pickerL.backgroundColor = [UIColor colorWithHexString:@"#A361F2"];
        self.pickerL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.pickerL.font = [UIFont systemFontOfSize:9];
        self.pickerL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.pickerL];
        self.pickerL.text = @"Pick";
        self.pickerL.hidden = YES;

    }
    return self;
}

- (void)moreClick{
    if ([NoticeTools isManager]) {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
          
        } otherButtonTitleArray:@[@"设为声昔君Picker",@"隐藏",[NoticeTools getLocalStrWith:@"groupManager.del"]]];
        sheet.delegate = self;
        self.otherSheet = sheet;
        [sheet show];
        return;
    }
    if ([_pyModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {//如果是自己的配音
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 2){
                LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
                    
                } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"songList.suredele"],[NoticeTools getLocalStrWith:@"groupManager.del"]]];
                self.selfSheet = sheet1;
                sheet1.delegate = self;
                [sheet1 show];
            }
        } otherButtonTitleArray:@[self.pyModel.is_anonymous.intValue?[NoticeTools getLocalStrWith:@"hh.canniming"]:[NoticeTools getLocalStrWith:@"py.nm"],[NoticeTools getLocalStrWith:@"groupManager.del"]]];
        self.selfFirstSheet = sheet;
        sheet.delegate = self;
        [sheet show];
    }else{
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
          
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.jubao"]]];
        sheet.delegate = self;
        self.otherSheet = sheet;
        [sheet show];
    }
    
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([NoticeTools isManager]) {
        if (buttonIndex == 1) {
            self.isSetPicker = YES;
            [self setPickerPy:self.pyModel];
        }else if (buttonIndex == 2){
            [self setHidePy:self.pyModel];
        }else if(buttonIndex == 3){
            [self deleteSucessWith:self.pyModel];
        }
        return;
    }
    if ([_pyModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {
        if (actionSheet == self.selfSheet) {
            if (buttonIndex == 2) {
                [self deleteSucessWith:self.pyModel];
            }
        }else if (actionSheet == self.selfFirstSheet){
            if (buttonIndex == 1) {
                [self setNIming:self.pyModel];
            }
        }
        
    }else{
        if (actionSheet == self.otherSheet) {
            if (buttonIndex == 1) {
                NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
                juBaoView.reouceId = _pyModel.pyId;
                juBaoView.reouceType = @"8";
                [juBaoView showView];
            }
        }
    }
}

- (void)setPyModel:(NoticeClockPyModel *)pyModel{
    
    _pyModel = pyModel;
    if (!_pyModel.pyUserInfo && [pyModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {
        _pyModel.pyUserInfo = [NoticeSaveModel getUserInfo];
    }
    
    self.pickerL.hidden = pyModel.isPicker?NO:YES;
    
    self.contentBackView.frame = CGRectMake(15, CGRectGetMaxY(self.playerView.frame)+15, DR_SCREEN_WIDTH-70,self.isTcPage?0: pyModel.contentHeight+40);
    
    self.contentL.frame = CGRectMake(15, 34,self.contentBackView.frame.size.width-30,self.isTcPage ? 0 : (self.contentBackView.frame.size.height-40));
    self.contentL.attributedText = pyModel.attLine_content;
    self.contentBackView.hidden = self.isTcPage;
    
    self.buttonView.pyModel = pyModel;

    self.numRecL.text = pyModel.dubbing_num.integerValue?[NSString stringWithFormat:@"%@",pyModel.dubbing_num]:@"0";
    
    self.buttonView.isTcPage = self.isTcPage;
    if (self.isNeedPost) {
        self.buttonView.isTcPage = YES;
    }
        
    self.typeL.text = pyModel.tag_id.intValue == 2?[NoticeTools getLocalStrWith:@"py.tag2"]:[NoticeTools getLocalStrWith:@"py.tag1"];
    self.timeL.text = pyModel.created_atTime;
    if (pyModel.is_anonymous.boolValue) {
        _iconImageView.image = UIImageNamed(@"Image_nimingpeiy");
        self.nickNameL.text = [NoticeTools getLocalStrWith:@"py.nm"];
        self.lelveImageView.hidden = YES;
        self.iconMarkView.hidden = YES;
    }else{
        self.iconMarkView.hidden = NO;
        self.lelveImageView.hidden = NO;
        if ([pyModel.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
            self.nickNameL.text = [[NoticeSaveModel getUserInfo] nick_name];
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]]
                                  placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                           options:SDWebImageRefreshCached];
        }else{
            self.nickNameL.text = pyModel.pyUserInfo.nick_name;
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:pyModel.pyUserInfo.avatar_url]
                                  placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                           options:SDWebImageRefreshCached];
        }
    }
    
    self.playerView.timeLen = pyModel.nowTime.integerValue?pyModel.nowTime: pyModel.dubbing_len;

    self.playerView.voiceUrl = pyModel.dubbing_url;
    self.playerView.slieView.progress = pyModel.nowPro >0 ?pyModel.nowPro:0;
    
    if (pyModel.dubbing_len.integerValue < 5) {
        self.playerView.frame = CGRectMake(15+(self.isHot?15:0), CGRectGetMaxY(_iconImageView.frame)+15+(self.isHot?15:0), 130, 40);
    }else if (pyModel.dubbing_len.integerValue >= 5 && pyModel.dubbing_len.integerValue <= 105){
        self.playerView.frame = CGRectMake(15+(self.isHot?15:0), CGRectGetMaxY(_iconImageView.frame)+15+(self.isHot?15:0), 130+pyModel.dubbing_len.integerValue, 40);
    }else if (pyModel.dubbing_len.integerValue >= 120){
        self.playerView.frame = CGRectMake(15+(self.isHot?15:0), CGRectGetMaxY(_iconImageView.frame)+15+(self.isHot?15:0), 130+120, 40);
    }
    else{
        self.playerView.frame = CGRectMake(15+(self.isHot?15:0), CGRectGetMaxY(_iconImageView.frame)+15+(self.isHot?15:0), 130+pyModel.dubbing_len.integerValue, 40);
    }
 
    [self.playerView refreWithFrame];
    self.dragView.frame =  CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height);
   
    self.pickImageView.hidden = pyModel.isPicker?NO:YES;

    _playView.frame = CGRectMake(0, 0,_playerView.frame.size.width, _playerView.frame.size.height);
    _rePlayView.hidden = pyModel.isPlaying? NO:YES;
    _rePlayView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame),self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
    if (!self.noNeedPush) {
        self.noticeView.hidden = ! pyModel.comArr.count;
        self.noticeView.frame = CGRectMake(15, CGRectGetMaxY(self.contentBackView.frame)+10,self.backView.frame.size.width-30, 30);
        if (self.isDisappear || !pyModel.comArr.count) {
            [self.noticeView.timer invalidate];
        }else{
            self.noticeView.comArr = pyModel.comArr;
        }
    }else{
        self.noticeView.hidden = YES;
    }

    if (self.pyModel.comArr.count && !self.noNeedPush) {
        self.backView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 105+68+self.contentBackView.frame.size.height+50);
        self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(self.noticeView.frame)+10, self.backView.frame.size.width, 50);
    }else{
        self.backView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 105+68+self.contentBackView.frame.size.height);
        self.buttonView.frame = CGRectMake(0,self.isTcPage?CGRectGetMaxY(self.playerView.frame): CGRectGetMaxY(self.contentBackView.frame), self.backView.frame.size.width, 50);
    }
    if (self.isTcPage) {
        self.noticeView.hidden = YES;
        self.backView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 160);
        self.buttonView.frame = CGRectMake(0,self.backView.frame.size.height-50, self.backView.frame.size.width, 50);
        self.buttonView.hidden = NO;
    }
    
    self.nickNameL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 15, GET_STRWIDTH(self.nickNameL.text, 16, 22), 22);
  
    self.lelveImageView.image = UIImageNamed(pyModel.pyUserInfo.levelImgName);
    self.iconMarkView.image = UIImageNamed(pyModel.pyUserInfo.levelImgIconName);
    self.lelveImageView.frame = CGRectMake(CGRectGetMaxX(_nickNameL.frame), 15+2.5, 52, 16);
}

- (void)setIsDisappear:(BOOL)isDisappear{
    _isDisappear = isDisappear;
    if (isDisappear) {
        if (self.isHot) {
            [_noticeView.timer invalidate];
        }
    }
}

- (void)setNoNeedPush:(BOOL)noNeedPush{
    _noNeedPush = noNeedPush;
    self.buttonView.noNeedPush = noNeedPush;
}

//设置匿名
- (void)setNIming:(NoticeClockPyModel *)model{
    if ([_pyModel.pyId isEqualToString:model.pyId] && model.is_anonymous.boolValue) {

        [self sureNiMing:model];
    }else{
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"yl.peiyings"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf sureNiMing:model];
            }
        };
        [alerView showXLAlertView];
    }
}

- (void)sureNiMing:(NoticeClockPyModel *)model{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:_pyModel.is_anonymous.boolValue?@"0":@"1" forKey:@"isAnonymous"];
    NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"dubbings/%@",_pyModel.pyId] Accept:@"application/vnd.shengxi.v4.1+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self->_pyModel.is_anonymous = self->_pyModel.is_anonymous.boolValue?@"0":@"1";
            [nav.topViewController showToastWithText:self->_pyModel.is_anonymous.boolValue?[NoticeTools getLocalStrWith:@"hh.hasnim"]:[NoticeTools getLocalStrWith:@"hh.qxnimin"]];
            if (self->_pyModel.is_anonymous.integerValue) {
                self->_iconImageView.image = UIImageNamed(@"Image_nimingpeiy");
                self.nickNameL.text = [NoticeTools getLocalStrWith:@"py.nm"];
                if (self.setNimingBlock) {
                    self.setNimingBlock(YES);
                }
                self.lelveImageView.hidden = YES;
                self.iconMarkView.hidden = YES;
            }else{
                self.lelveImageView.hidden = NO;
                self.iconMarkView.hidden = NO;
                self->_pyModel.pyUserInfo = userInfo;
                self.nickNameL.text = self->_pyModel.pyUserInfo.nick_name;
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self->_pyModel.pyUserInfo.avatar_url]
                                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                               options:SDWebImageRefreshCached];
            }
            self.buttonView.pyModel = self.pyModel;
        }
        
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)deleteSucessWith:(NoticeClockPyModel *)model{
    if ([model.pyId isEqualToString:_pyModel.pyId]) {
        
        if ([NoticeTools isManager] && ![model.from_user_id isEqualToString:[NoticeTools getuserId]]) {//管理操作，并且当前配音非自己的
            self.isSetPicker = NO;
            self.magager.type = @"删除配音";
            _isManagerDelete = YES;
            [self.magager show];
            return;
        }
        
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"dubbings/%@",_pyModel.pyId] Accept:@"application/vnd.shengxi.v4.1+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(delegateSuccess:)]) {
                    [self.delegate delegateSuccess:self.index];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(deleteSuccessFor:)]) {
                    [self.delegate deleteSuccessFor:self->_pyModel];
                }
            }
        } fail:^(NSError * _Nullable error) {
        }];
    }
}

- (void)setHidePy:(NoticeClockPyModel *)model{
    if ([model.pyId isEqualToString:_pyModel.pyId]){
        self.isSetPicker = NO;
        self.magager.type = @"隐藏配音";
        _isManagerDelete = NO;
        [self.magager show];
        return;
    }
}

- (void)setPickerPy:(NoticeClockPyModel *)model{
    if ([model.pyId isEqualToString:_pyModel.pyId]){
        self.isSetPicker = YES;
        self.magager.type = @"设为声昔君Picker";
        _isManagerDelete = NO;
        [self.magager show];
        return;
    }
}

- (void)sureManagerClick:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    if (self.isSetPicker) {
        [parm setObject:[NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]] forKey:@"pickedAt"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/dubbings/%@",_pyModel.pyId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                [self.magager removeFromSuperview];
                [nav.topViewController showToastWithText:@"操作已执行"];
            }else{
                self.magager.markL.text = @"密码错误请重新输入";
            }
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
        return;
    }
    if (_isManagerDelete) {
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/dubbings/%@",_pyModel.pyId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                [self.magager removeFromSuperview];
                [nav.topViewController showToastWithText:@"操作已执行"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(delegateSuccess:)]) {
                    [self.delegate delegateSuccess:self.index];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(deleteSuccessFor:)]) {
                    [self.delegate deleteSuccessFor:self->_pyModel];
                }
            }else{
                self.magager.markL.text = @"密码错误请重新输入";
            }
        } fail:^(NSError *error) {
            [nav.topViewController hideHUD];
        }];
    }else{
        [parm setObject:[NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]] forKey:@"hideAt"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/dubbings/%@",_pyModel.pyId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                [self.magager removeFromSuperview];
                [nav.topViewController showToastWithText:@"操作已执行"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(delegateSuccess:)]) {
                    [self.delegate delegateSuccess:self.index];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(deleteSuccessFor:)]) {
                    [self.delegate deleteSuccessFor:self->_pyModel];
                }
            }else{
                self.magager.markL.text = @"密码错误请重新输入";
            }
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
    }
}

- (void)longPressGestureRecognized:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    if (!_pyModel.isPlaying) {
        if (longPressState == UIGestureRecognizerStateEnded) {
            [self playNoReplay];
        }
        return;
    }
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
           
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginDrag:)]) {
                [self.delegate beginDrag:self.tag];
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
                [self.delegate endDrag:self.tag progross:p.x/self.playerView.frame.size.width];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag:)]) {
                [self.delegate endDrag:self.tag];
            }
            break;
        }
    }
}
- (void)dragWithPoint:(CGPoint)p{
    self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;

    if (self.delegate && [self.delegate respondsToSelector:@selector(dragingFloat: index:)]) {
        if ((_pyModel.dubbing_len.floatValue/self.playerView.frame.size.width)*p.x < _pyModel.dubbing_len.length/5) {
            return;
        }
        [self.delegate dragingFloat:(_pyModel.dubbing_len.floatValue/self.playerView.frame.size.width)*p.x index:self.tag];
    }
}

//点击重新播放
- (void)playReplay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRePlayer:)]) {
        [self.delegate startRePlayer:self.index];
    }
}
//点击播放
- (void)playNoReplay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop:)]) {
        [self.delegate startPlayAndStop:self.index];
    }
}

- (void)userInfoTap{
    if (_pyModel.is_anonymous.integerValue) {
        if (![NoticeTools isManager]) {
            return;
        }
    }
    if ([_pyModel.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        //
        if (!self.isGoToUserCenter) {
            NoticeUserDubbingAndLineController *ctl = [[NoticeUserDubbingAndLineController alloc] init];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
            }
            return;
        }
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        if (!self.isGoToUserCenter) {
            NoticeUserDubbingAndLineController *ctl = [[NoticeUserDubbingAndLineController alloc] init];
            ctl.isOther = YES;
            ctl.userId = _pyModel.from_user_id;
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
            }
            return;
        }
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _pyModel.from_user_id;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

- (void)goTcPageTap{
    if (self.isTcPage) {
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticeTcPageController *ctl = [[NoticeTcPageController alloc] init];
    ctl.tcModel = _pyModel;
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}

- (UIView *)buttonEditView{
    if (!_buttonEditView) {
        _buttonEditView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        _buttonEditView.hidden = YES;
        [self.contentView addSubview:self.buttonEditView];
        NSArray *arr1 = @[@"隐藏",@"删除配音和台词",[NoticeTools getLocalStrWith:@"groupManager.del"]];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/arr1.count*i, 0, DR_SCREEN_WIDTH/arr1.count, 50)];
            [button setTitle:arr1[i] forState:UIControlStateNormal];
            [button setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            
            [button addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                button.tag = 0;
                self.priBtn = button;
            }else if (i == 1){
                button.tag = 2;
                self.allDeleteBtn = button;
            }
            else{
                button.tag = 1;
                self.deleteBtn = button;
            }
            [_buttonEditView addSubview:button];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, DR_SCREEN_WIDTH, 1)];
            line.backgroundColor = GetColorWithName(VlistColor);
            [_buttonEditView addSubview:line];
        }
    }
    return _buttonEditView;
}

- (LXAdvertScrollview *)noticeView{
    if (!_noticeView) {
        _noticeView = [[LXAdvertScrollview alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _noticeView.needBackGround = YES;
        _noticeView.layer.cornerRadius = 3;
        _noticeView.layer.masksToBounds = YES;
        _noticeView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        [self.backView addSubview:_noticeView];
        _noticeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comVCTap)];
        [_noticeView addGestureRecognizer:tap];
    }
    return _noticeView;
}



- (void)comVCTap{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticePyComController *ctl = [[NoticePyComController alloc] init];
    ctl.pyMOdel = self.pyModel;
    __weak typeof(self) weakSelf = self;
    ctl.deletePyBlock = ^(NoticeClockPyModel * _Nonnull pyModel) {
        if (weakSelf.deletePyBlock) {
            weakSelf.deletePyBlock(pyModel);
        }
    };
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

- (void)editClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editManager:)]) {
        [self.delegate editManager:btn.tag];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
