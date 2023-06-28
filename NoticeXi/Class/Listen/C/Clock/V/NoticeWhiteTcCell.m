//
//  NoticeWhiteTcCell.m
//  NoticeXi
//
//  Created by li lei on 2022/12/15.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeWhiteTcCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMineViewController.h"
#import "NoticeTcPageController.h"
#import "NoticeXi-Swift.h"
#import "NoticeBingGanListView.h"
#import "NoticeShareTostView.h"
#import "NoticeUserDubbingAndLineController.h"
@implementation NoticeWhiteTcCell

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
        
        _mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _mbView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        [_iconImageView addSubview:_mbView];
        _mbView.layer.cornerRadius = 20;
        _mbView.layer.masksToBounds = YES;
        _mbView.hidden = [NoticeTools isWhiteTheme]?YES:NO;
        
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
        
        self.contentBackView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.iconImageView.frame)+13, DR_SCREEN_WIDTH-70, 0)];
        self.contentBackView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.contentBackView.layer.cornerRadius = 10;
        self.contentBackView.layer.masksToBounds = YES;
        [self.backView addSubview:self.contentBackView];
        
        self.typeL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 34)];
        self.typeL.font = TWOTEXTFONTSIZE;
        self.typeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
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
        self.contentL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentBackView addSubview:self.contentL];
        self.contentL.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTcPageTap)];
        [self.contentBackView addGestureRecognizer:labelTap];
        
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-10-24, 15, 24, 24)];
        [moreBtn setBackgroundImage:UIImageNamed(@"Image_moreNeww") forState:UIControlStateNormal];
        [self.backView addSubview:moreBtn];
        [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setTcModel:(NoticeClockPyModel *)tcModel{
    _tcModel = tcModel;
    
    
    if (!_tcModel.userInfo && [tcModel.user_id isEqualToString:[NoticeTools getuserId]]) {
         _tcModel.userInfo = [NoticeSaveModel getUserInfo];
     }

    if (tcModel.is_anonymous.boolValue) {
        self.markImage.hidden = YES;
    }
    
    self.contentBackView.frame = CGRectMake(15, CGRectGetMaxY(self.iconImageView.frame)+13, DR_SCREEN_WIDTH-70,tcModel.contentHeight+40);
    
    self.contentL.frame = CGRectMake(15, 34,self.contentBackView.frame.size.width-30,tcModel.contentHeight);
    self.contentL.attributedText = tcModel.attLine_content;

    self.numRecL.text = tcModel.dubbing_num.integerValue?[NSString stringWithFormat:@"%@",tcModel.dubbing_num]:@"0";
    
    self.typeL.text = tcModel.tag_id.intValue == 2?[NoticeTools getLocalStrWith:@"py.tag2"]:[NoticeTools getLocalStrWith:@"py.tag1"];
    self.timeL.text = tcModel.created_atTime;
    

    if (self.managerCode.integerValue) {
        self.line.hidden = YES;
        self.hasL.hidden = YES;
        self.buttonEditView.hidden = NO;
        self.buttonEditView.frame = CGRectMake(0, CGRectGetMaxY(self.contentBackView.frame), DR_SCREEN_WIDTH, 50);
        [self.deleteBtn setTitle:[tcModel.line_status isEqualToString:@"1"] ?[NoticeTools getLocalStrWith:@"groupManager.del"]:[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
        [self.priBtn setTitle:tcModel.hide_at.intValue ?@"已隐藏":@"隐藏" forState:UIControlStateNormal];
        self.buttonView.hidden = YES;
    }else{
        self.buttonView.hidden = NO;
    }
    
    self.timeL.text = tcModel.created_atTime;
    
    
    if (tcModel.is_anonymous.boolValue) {
        _iconImageView.image = UIImageNamed(@"Image_nimingpeiy");
        self.nickNameL.text = [NoticeTools getLocalStrWith:@"py.nm"];
    }else{
        self.nickNameL.text = tcModel.userInfo.nick_name;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:tcModel.userInfo.avatar_url]
                              placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                       options:SDWebImageRefreshCached];
    }
    self.backView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 121+self.contentBackView.frame.size.height);
    
    self.buttonView.frame = CGRectMake(0, CGRectGetMaxY(self.contentBackView.frame), self.backView.frame.size.width, 54);
    
    if (tcModel.is_dubbed.intValue) {
        //Image_selfypy_b
        self.pyImageView.image = UIImageNamed(@"Image_tcyipeiyw");
        self.hasL.text = [NoticeTools getLocalStrWith:@"py.pyed"];
        
        self.hasL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }else{
        self.hasL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        self.pyImageView.image = UIImageNamed(@"Image_luynewztw");
        self.hasL.text = [NoticeTools getLocalStrWith:@"py.wantPy"];
    }

    if ([_tcModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {//自己的台词
        self.scL.text = tcModel.collection_num.intValue?tcModel.collection_num: [NoticeTools getLocalStrWith:@"emtion.sc"];
        self.scImageV.image = UIImageNamed(@"Image_pyshoucangw");//
    }else{
        self.scL.text = [NoticeTools getLocalStrWith:@"emtion.sc"];
        self.scImageV.image = UIImageNamed(tcModel.collection_id.intValue?@"Image_pyshoucangy": @"Image_pyshoucangw");
    }
    
    self.nickNameL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 15, GET_STRWIDTH(self.nickNameL.text, 16, 22), 22);
  
    
    self.lelveImageView.image = UIImageNamed(tcModel.userInfo.levelImgName);
    self.iconMarkView.image = UIImageNamed(tcModel.userInfo.levelImgIconName);
    self.lelveImageView.frame = CGRectMake(CGRectGetMaxX(_nickNameL.frame), 15+2.5, 52, 16);
}

- (void)moreClick{
    if ([_tcModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
     
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1){
                LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
                    if (buttonIndex1 == 2) {
                        [self deleteSucessWith:[NoticeClockPyModel new]];
                    }
                } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"py.sureDele"],[NoticeTools getLocalStrWith:@"groupManager.del"]]];
                [sheet1 show];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"groupManager.del"]]];
        [sheet show];
    }else{
        if ([NoticeTools isManager]) {
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
         
            } otherButtonTitleArray:@[@"删除台词",@"隐藏台词"]];
            sheet.delegate = self;
            self.managerSheet = sheet;
            [sheet show];
            return;
        }
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
     
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.jubao"]]];
        sheet.delegate = self;
        self.otherSheet = sheet;
        [sheet show];
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.managerSheet) {
        if (buttonIndex == 1){
            self.isHideTc = NO;
            self.magager.type = @"删除台词";
            [self.magager show];
        }else if (buttonIndex == 2){
            self.isHideTc = YES;
            self.magager.type = @"隐藏台词";
            [self.magager show];
        }
    }else if(self.otherSheet){
        if (buttonIndex == 1) {
            [self tapOther];
        }
    }
}

//点击的是别人的台词/配音
- (void)tapOther{

    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId =  _tcModel.tcId;
    juBaoView.reouceType = @"7";
    [juBaoView showView];
}

- (void)userInfoTap{
    if (_tcModel.is_anonymous.integerValue) {
        if (![NoticeTools isManager]) {
            return;
        }
    }
    if ([_tcModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        if (!self.isGoToUserCenter) {
            NoticeUserDubbingAndLineController *ctl = [[NoticeUserDubbingAndLineController alloc] init];
            ctl.isFromLine = YES;
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
            ctl.isFromLine = YES;
            ctl.userId = _tcModel.user_id;
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
            }
            return;
        }
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _tcModel.user_id;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

//自己是否对该台词进行了配音
- (void)selfSendSameTc{
    if (_tcModel.is_dubbed.boolValue) {
        [self goTcPageTap];
        return;
    }
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWithPeiYing:_tcModel.line_content];
    recodeView.pyTag = _tcModel.tag_id.intValue;
    recodeView.isPy = YES;
    recodeView.delegate = self;
    [recodeView show];
}
- (void)reRecoderLocalVoice{
    [self sendSameTc];
}

//抢先配音
- (void)sendSameTc{
    if (_tcModel.is_dubbed.integerValue) {
        [self goTcPageTap];
        return;
    }
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWithPeiYing:_tcModel.line_content];
    recodeView.pyTag = _tcModel.tag_id.intValue;
    recodeView.isPy = YES;
    recodeView.delegate = self;
    [recodeView show];
}

- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength isNiMing:(BOOL)isNiming{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"22" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:self->_tcModel.tcId forKey:@"lineId"];
            [parm setObject:Message forKey:@"dubbingUri"];
            [parm setObject:timeLength forKey:@"dubbingLen"];
            [parm setObject:isNiming?@"1":@"0" forKey:@"isAnonymous"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"dubbings" Accept:@"application/vnd.shengxi.v4.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [nav.topViewController hideHUD];
                if (success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGETHEROOTSELECTARTPY" object:nil];
                    self->_tcModel.is_dubbed = @"1";
                    self->_tcModel.dubbing_num = [NSString stringWithFormat:@"%ld",(long)(self->_tcModel.dubbing_num.integerValue+1)];
          
                    self.numRecL.text = [NSString stringWithFormat:@"%@",self->_tcModel.dubbing_num];
                    self.pyImageView.image = UIImageNamed(@"Image_tcyipeiyw");
                    self.hasL.text = [NoticeTools getLocalStrWith:@"py.pyed"];
                    self.hasL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
                    [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.sendsus"]];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(recoderSuccess:)]) {
                        [self.delegate recoderSuccess:self.tcModel];
                    }
                }
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
        }else{
            [nav.topViewController hideHUD];
        }
    }];
}

- (void)deleteSucessWith:(NoticeClockPyModel *)model{
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"lines/%@",_tcModel.tcId] Accept:@"application/vnd.shengxi.v4.1+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(delegateSuccess:)]) {
                [self.delegate delegateSuccess:self.tcModel];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)sureManagerClick:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.isHideTc) {
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:code forKey:@"confirmPasswd"];
        [parm setValue:[NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]] forKey:@"hideAt"];
        
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/lines/%@",_tcModel.tcId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                [self.magager removeFromSuperview];
                [nav.topViewController showToastWithText:@"台词已隐藏"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(delegateSuccess:)]) {
                    [self.delegate delegateSuccess:self.tcModel];
                }
            }
        } fail:^(NSError * _Nullable error) {
            
        }];
        return;
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/lines/%@",_tcModel.tcId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            [nav.topViewController showToastWithText:@"操作已执行"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(delegateSuccess:)]) {
                [self.delegate delegateSuccess:self.tcModel];
            }
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)goTcPageTap{
    if (!_tcModel.dubbing_num.intValue) {
        [self selfSendSameTc];
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticeTcPageController *ctl = [[NoticeTcPageController alloc] init];
    ctl.tcModel = _tcModel;
    if (self.tcModel.is_dubbed.intValue) {
        ctl.hasSelfPy = YES;
    }
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
        NSArray *arr1 = @[@"隐藏",[NoticeTools getLocalStrWith:@"groupManager.del"]];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/arr1.count*i, 0, DR_SCREEN_WIDTH/arr1.count, 50)];
            [button setTitle:arr1[i] forState:UIControlStateNormal];
            [button setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            
            [button addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                button.tag = 0;
                self.priBtn = button;
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

- (UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentBackView.frame), self.backView.frame.size.width, 54)];
        _buttonView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendSameTc)];
        
        self.pyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 24, 24)];
        self.pyImageView.image = UIImageNamed(@"Image_luynewztw");
        [_buttonView addSubview:self.pyImageView];
        
        self.hasL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pyImageView.frame)+3, 0, 50, 54)];
        self.hasL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        self.hasL.font = XGTWOBoldFontSize;
        self.hasL.text = [NoticeTools getLocalStrWith:@"py.wantPy"];
        [_buttonView addSubview:self.hasL];
        
        UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24+3+50, 54)];
        tapV.userInteractionEnabled = YES;
        tapV.backgroundColor = [UIColor clearColor];
        [_buttonView addSubview:tapV];
        [tapV addGestureRecognizer:tap];
        
        
        self.scImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-42-24, 15, 24, 24)];
        self.scImageV.image = UIImageNamed(@"Image_pyshoucangw");
        [_buttonView addSubview:self.scImageV];
        
        self.scL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.scImageV.frame)+3, 0, 15+24, 54)];
        self.scL.font = TWOTEXTFONTSIZE;
        self.scL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.scL.text = [NoticeTools getLocalStrWith:@"emtion.sc"];
        [_buttonView addSubview:self.scL];
        
        UIView *scTapV = [[UIView alloc] initWithFrame:CGRectMake(self.scImageV.frame.origin.x, 0, 24+3+15+24, 54)];
        scTapV.userInteractionEnabled = YES;
        scTapV.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *scTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scLineTap)];
        [scTapV addGestureRecognizer:scTap];
        [_buttonView addSubview:scTapV];
        [self.backView addSubview:_buttonView];
        
        UIImageView *shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(scTapV.frame.origin.x-38-5-24-5, 15, 24, 24)];
        shareImageView.image = UIImageNamed(@"Image_pyfenxiangw");
        [_buttonView addSubview:shareImageView];
        
        UILabel *shareL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shareImageView.frame)+3, 0,43, 54)];
        shareL.font = TWOTEXTFONTSIZE;
        shareL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        shareL.text = [NoticeTools getLocalStrWith:@"py.share"];
        [_buttonView addSubview:shareL];
        
        UIView *shareTapV = [[UIView alloc] initWithFrame:CGRectMake(shareImageView.frame.origin.x, 0,48+24, 54)];
        shareTapV.userInteractionEnabled = YES;
        shareTapV.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *shareTapVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTapVTap)];
        [shareTapV addGestureRecognizer:shareTapVTap];
        [_buttonView addSubview:shareTapV];
    }
    return _buttonView;
}

- (void)shareTapVTap{
    NoticeShareTostView *view = [[NoticeShareTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    view.isPyOrTc = YES;
    view.tcModel = self.tcModel;
    [view showTost];
}

//点击收藏
- (void)scLineTap{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if ([_tcModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//自己的
    
        if (self.tcModel.collection_num.intValue > 0) {//收到贴贴就弹出贴贴列表
            NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            listView.scTCModel = self.tcModel;
            [listView showTost];
        }else{
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.nocol"]];
        }
    }else{

        [nav.topViewController showHUD];
        if (self.tcModel.collection_id.intValue) {
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"linesCollection/%@",self.tcModel.collection_id] Accept:@"application/vnd.shengxi.v5.0.0+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [nav.topViewController hideHUD];
                if (success) {
                    [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.cancelCol"]];
                    self.tcModel.collection_id = @"0";
                    self.scImageV.image = UIImageNamed(@"Image_pyshoucangw");
                }
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
            return;
        }
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.tcModel.tcId forKey:@"lineId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"linesCollection" Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeMJIDModel *idM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
                [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"emtion.scSus"]];
                self.tcModel.collection_id = idM.allId;
                self.scImageV.image = UIImageNamed(@"Image_pyshoucangy");
            }
            [nav.topViewController hideHUD];
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
    }
}

- (void)editClick:(UIButton *)button{
    if (button.tag == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(editManagerWithDelete)]) {
            [self.delegate editManagerWithDelete];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(editManagerWithHide)]) {
            [self.delegate editManagerWithHide];
        }
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
