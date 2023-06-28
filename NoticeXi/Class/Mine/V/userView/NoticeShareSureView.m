//
//  NoticeShareSureView.m
//  NoticeXi
//
//  Created by li lei on 2022/5/26.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeShareSureView.h"
#import "NoticeSCViewController.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeShareSureView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-280)/2, (DR_SCREEN_HEIGHT-231)/2, 280, 231)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 10;
        self.keyView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 280, 25)];
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = XGEightBoldFontSize;
        label.text = [NoticeTools getLocalStrWith:@"shanre.to"];
        [self.keyView addSubview:label];
        
        self.toiconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 50, 26, 26)];
        self.toiconImageView.layer.cornerRadius = 13;
        self.toiconImageView.layer.masksToBounds = YES;
        [self.keyView addSubview:self.toiconImageView];
        
        self.toNameL = [[UILabel alloc] initWithFrame:CGRectMake(47, 53, 200, 20)];
        self.toNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.toNameL.font = FOURTHTEENTEXTFONTSIZE;
        [self.keyView addSubview:self.toNameL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 89, 250, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.keyView addSubview:line];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 109, 230, 60)];
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        backV.layer.cornerRadius = 8;
        backV.layer.masksToBounds = YES;
        [self.keyView addSubview:backV];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [backV addSubview:self.iconImageView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(68,8,230-70,21)];
        self.nameL.font = FOURTHTEENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backV addSubview:self.nameL];
        
        self.typeL = [[UILabel alloc] initWithFrame:CGRectMake(68, 33, 230-79, 20)];
        self.typeL.font = FOURTHTEENTEXTFONTSIZE;
        self.typeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backV addSubview:self.typeL];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, 189, 250, 1)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.keyView addSubview:line1];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,190, 280/2, 41)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"groupManager.rethink"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.keyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(280/2,190, 280/2, 41)];
        [sureBtn setTitle:[NoticeTools getLocalStrWith:@"py.share"] forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.keyView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake((280-1)/2, 190, 1, 41)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.keyView addSubview:line2];
    }
    return self;
}

- (void)cancelClick{
    [self removeFromSuperview];
}

- (void)sureClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];

    if (self.voiceM) {
        NSMutableDictionary* _sendDic = [NSMutableDictionary new];
        [_sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.userM.userId] forKey:@"to"];
        [_sendDic setObject:@"singleChat" forKey:@"flag"];
        NSMutableDictionary *messageDic = [NSMutableDictionary new];
        [messageDic setObject:self.voiceM.voice_id forKey:@"shareId"];
        [messageDic setObject:@"6" forKey:@"dialogContentType"];
        [_sendDic setObject:messageDic forKey:@"data"];
         AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdel.socketManager sendMessage:_sendDic];
        if (self.dissMissBlock) {
            self.dissMissBlock(YES);
        }
        NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
        vc.toUser = [NSString stringWithFormat:@"%@%@",socketADD,self.userM.userId];
        vc.toUserId = self.userM.userId;
        vc.lelve = self.userM.levelImgName;
        vc.navigationItem.title = self.userM.nick_name;
        [nav.topViewController.navigationController pushViewController:vc animated:NO];
    }
    if (self.pyModel) {
        NSMutableDictionary* _sendDic = [NSMutableDictionary new];
        [_sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.userM.userId] forKey:@"to"];
        [_sendDic setObject:@"singleChat" forKey:@"flag"];
        NSMutableDictionary *messageDic = [NSMutableDictionary new];
        [messageDic setObject:self.pyModel.pyId forKey:@"shareId"];
        [messageDic setObject:@"7" forKey:@"dialogContentType"];
        [_sendDic setObject:messageDic forKey:@"data"];
         AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdel.socketManager sendMessage:_sendDic];
        if (self.dissMissBlock) {
            self.dissMissBlock(YES);
        }
        NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
        vc.toUser = [NSString stringWithFormat:@"%@%@",socketADD,self.userM.userId];
        vc.toUserId = self.userM.userId;
        vc.lelve = self.userM.levelImgName;
        vc.navigationItem.title = self.userM.nick_name;
        [nav.topViewController.navigationController pushViewController:vc animated:NO];
    }
    if (self.tcModel) {
        NSMutableDictionary* _sendDic = [NSMutableDictionary new];
        [_sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.userM.userId] forKey:@"to"];
        [_sendDic setObject:@"singleChat" forKey:@"flag"];
        NSMutableDictionary *messageDic = [NSMutableDictionary new];
        [messageDic setObject:self.tcModel.line_id?self.tcModel.line_id: self.tcModel.tcId forKey:@"shareId"];
        [messageDic setObject:@"8" forKey:@"dialogContentType"];
        [_sendDic setObject:messageDic forKey:@"data"];
         AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdel.socketManager sendMessage:_sendDic];
        if (self.dissMissBlock) {
            self.dissMissBlock(YES);
        }
        NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
        vc.toUser = [NSString stringWithFormat:@"%@%@",socketADD,self.userM.userId];
        vc.toUserId = self.userM.userId;
        vc.lelve = self.userM.levelImgName;
        vc.navigationItem.title = self.userM.nick_name;
        [nav.topViewController.navigationController pushViewController:vc animated:NO];
    }
    [self removeFromSuperview];
}

- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.subUserModel.avatar_url]];
    self.nameL.text = voiceM.subUserModel.nick_name;
    self.typeL.text = [NoticeTools getLocalStrWith:@"intro.sharexq"];
}

- (void)setPyModel:(NoticeClockPyModel *)pyModel{
    _pyModel = pyModel;
    if ([pyModel.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        self.nameL.text = [[NoticeSaveModel getUserInfo] nick_name];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]]
                              placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                       options:SDWebImageRefreshCached];
    }else{
        self.nameL.text = pyModel.pyUserInfo.nick_name;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:pyModel.pyUserInfo.avatar_url]
                              placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                       options:SDWebImageRefreshCached];
    }
    self.typeL.text = [NSString stringWithFormat:@"[%@]",[NoticeTools getLocalStrWith:@"py.py"]];
}

- (void)setTcModel:(NoticeClockPyModel *)tcModel{
    _tcModel = tcModel;
    self.nameL.text = tcModel.userInfo.nick_name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:tcModel.userInfo.avatar_url]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageRefreshCached];
    self.typeL.text =  [NSString stringWithFormat:@"#%@#%@",tcModel.tag_id.intValue==1?@"求配音":@"freestyle",tcModel.line_content];
}

- (void)setUserM:(NoticeFriendAcdModel *)userM{
    _userM = userM;
    [self.toiconImageView sd_setImageWithURL:[NSURL URLWithString:userM.avatar_url]];
    self.toNameL.text = userM.nick_name;
}

- (void)showTost{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    self.keyView.transform = CGAffineTransformMakeScale(0.70, 0.70);

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.keyView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
@end
