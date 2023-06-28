//
//  NoticeCarePeopleCell.m
//  NoticeXi
//
//  Created by li lei on 2021/4/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCarePeopleCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeCarePeopleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.contentView.userInteractionEnabled = YES;
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 16, 40, 40)];
        [self.contentView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,18,36, 36)];
        _iconImageView.layer.cornerRadius = 18;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [self.contentView addGestureRecognizer:iconTap];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
                
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,15,180, 21)];
        _nickNameL.font = XGFifthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];
        _nickNameL.text = @"天天都开心的丫丫";
        
        self.lelveImageView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nickNameL.frame)+2, (68-21)/2, 46, 21)];
        self.lelveImageView.frame = CGRectMake(_iconImageView.frame.origin.x+20, _iconImageView.frame.origin.y+20, 16, 16);
        [self.contentView addSubview:self.lelveImageView];
        self.lelveImageView.userInteractionEnabled = NO;
        
        self.hasNewInfoL = [[UILabel alloc] initWithFrame:CGRectMake(_nickNameL.frame.origin.x, 38, 36, 16)];
        self.hasNewInfoL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.hasNewInfoL.layer.cornerRadius = 2;
        self.hasNewInfoL.layer.masksToBounds = YES;
        self.hasNewInfoL.font = [UIFont systemFontOfSize:10];
        self.hasNewInfoL.text = [NoticeTools getLocalStrWith:@"xs.hasnew"];
        self.hasNewInfoL.textColor = [UIColor colorWithHexString:@"#F8932E"];
        [self.contentView addSubview:self.hasNewInfoL];
        self.hasNewInfoL.textAlignment = NSTextAlignmentCenter;
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,36,180, 16)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:_timeL];
        _timeL.hidden = YES;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 67.5, DR_SCREEN_WIDTH-10-CGRectGetMaxX(_iconImageView.frame), 0.5)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        _line = line;
        [self.contentView addSubview:line];
    
        self.funBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-65, 24, 65, 24)];
        [self.contentView addSubview:self.funBtn];
        [self.funBtn addTarget:self action:@selector(funClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, 24, 24, 24)];
        [self.moreBtn addTarget:self action:@selector(moreSetClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn setImage:UIImageNamed(@"Image_moreNeww") forState:UIControlStateNormal];
        self.moreBtn.hidden = YES;
        
        
    }
    return self;
}

- (void)moreSetClick{
    if (self.isSendWhite) {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {

        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"xs.nohexs"],[NoticeTools getLocalStrWith:@"xs.geblack"],[NoticeTools getLocalStrWith:@"xs.calxs"]]];
        sheet.delegate = self;
        [sheet show];
        return;
    }
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {

    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"xs.nohexs"],[NoticeTools getLocalStrWith:@"xs.geblack"]]];
    sheet.delegate = self;
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        XLAlertView *alertView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"xs.canxsnext"] message:[NoticeTools getLocalStrWith:@"xs.surecanl"] sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        __weak typeof(self) weakSelf = self;
        alertView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }
                [nav.topViewController showHUD];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admires/%@/%@",_careModel.user_id,[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v5.1.0+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        if (weakSelf.cancelCareBlock) {
                            weakSelf.cancelCareBlock(weakSelf.careModel);
                        }
                    }
                } fail:^(NSError * _Nullable error) {
                    [nav.topViewController hideHUD];
                }];
            }
        };
        [alertView showXLAlertView];
    }else if(buttonIndex == 2){
        XLAlertView *alertView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"xs.sureblack"] message:[NoticeTools getLocalStrWith:@"xs.blackcontent"] sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        __weak typeof(self) weakSelf = self;
        alertView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }
                [nav.topViewController showHUD];
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:self.careModel.user_id forKey:@"toUserId"];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/blacklist",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        if (weakSelf.cancelCareBlock) {
                            weakSelf.cancelCareBlock(weakSelf.careModel);
                        }
                    }
                } fail:^(NSError * _Nullable error) {
                    [nav.topViewController hideHUD];
                }];
            }

        };
        [alertView showXLAlertView];
    }else if (buttonIndex == 3){
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"xs.surecanxs"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf cancelCare];
            }
        };
        [alerView showXLAlertView];
    }
}

- (void)setCareModel:(NoticeFriendAcdModel *)careModel{
    _careModel = careModel;
    if (self.isOfCared || self.isSendWhite) {
        self.moreBtn.hidden = NO;
        self.funBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-65-24-10, 24, 65, 24);
    }
    if (self.isLikeEachOther || self.isSendWhite) {
        [self.funBtn setTitle:[NoticeTools getLocalStrWith:@"xs.sendhe"] forState:UIControlStateNormal];
        self.funBtn.titleLabel.font = ELEVENTEXTFONTSIZE;
        [self.funBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        self.funBtn.layer.cornerRadius = 12;
        self.funBtn.layer.masksToBounds = YES;
        self.funBtn.layer.borderColor = [UIColor colorWithHexString:@"#0099E6"].CGColor;
        self.funBtn.layer.borderWidth = 1;
    }else{
        if (self.type == 1) {
            
            if ([NoticeTools getLocalType] == 1) {
                [self.funBtn setBackgroundImage:UIImageNamed(careModel.is_admire.boolValue?@"Image_hxguanzhuen": @"Image_yiguanzhuen") forState:UIControlStateNormal];
            }else if ([NoticeTools getLocalType] == 2){
                [self.funBtn setBackgroundImage:UIImageNamed(careModel.is_admire.boolValue?@"Image_hxguanzhuja": @"Image_yiguanzhuja") forState:UIControlStateNormal];
            }else{
                [self.funBtn setBackgroundImage:UIImageNamed(careModel.is_admire.boolValue?@"Image_hxguanzhu": @"Image_yiguanzhu") forState:UIControlStateNormal];
            }
        }else{
            if ([NoticeTools getLocalType] == 1) {
                [self.funBtn setBackgroundImage:UIImageNamed(careModel.is_admire.boolValue?@"Image_hxguanzhuen": @"Image_carebtnen") forState:UIControlStateNormal];
            }else if ([NoticeTools getLocalType] == 2){
                [self.funBtn setBackgroundImage:UIImageNamed(careModel.is_admire.boolValue?@"Image_hxguanzhuja": @"Image_carebtnja") forState:UIControlStateNormal];
            }else{
                [self.funBtn setBackgroundImage:UIImageNamed(careModel.is_admire.boolValue?@"Image_hxguanzhu": @"Image_carebtn") forState:UIControlStateNormal];
            }
            
        }
    }
    self.nickNameL.text = careModel.nick_name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:careModel.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
    self.hasNewInfoL.hidden = careModel.is_update.intValue?NO:YES;
    self.timeL.hidden = careModel.is_update.intValue?YES:NO;
    self.timeL.text = careModel.created_at;

    self.lelveImageView.image = UIImageNamed(careModel.smallLevelImgName);
    
    self.iconMarkView.image = UIImageNamed(careModel.levelImgIconName);
}

- (void)funClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    if (self.isLikeEachOther || self.isSendWhite) {
        if (self.isSendWhite) {
            if (self.sendBlock) {
                self.sendBlock(self.careModel);
            }
            return;
        }
        if (!self.resourceId) {
            [nav.topViewController hideHUD];
            return;
        }
        [nav.topViewController showHUD];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.careModel.user_id forKey:@"toUserId"];
        [parm setObject:self.resourceId forKey:@"artworkId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"artworkGifts" Accept:@"application/vnd.shengxi.v4.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                [UIView animateWithDuration:1 animations:^{
                    [nav.topViewController showToastWithText:[NSString stringWithFormat:@"%@{%@}",self.careModel.nick_name,[NoticeTools getLocalStrWith:@"group.hassenddraw"]]];
                } completion:^(BOOL finished) {
                    [nav.topViewController.navigationController popViewControllerAnimated:YES];
                }];
            }
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
        return;
    }
    if (self.type != 1) {
        if (!self.careModel.is_admire.intValue) {//点击欣赏
            [nav.topViewController showHUD];
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:_careModel.from_user_id forKey:@"toUserId"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admires" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    self.careModel.is_admire = @"1";
                    
                    if ([NoticeTools getLocalType] == 1) {
                        [self.funBtn setBackgroundImage:UIImageNamed(self.careModel.is_admire.boolValue?@"Image_hxguanzhuen": @"Image_carebtnen") forState:UIControlStateNormal];
                    }else if ([NoticeTools getLocalType] == 2){
                        [self.funBtn setBackgroundImage:UIImageNamed(self.careModel.is_admire.boolValue?@"Image_hxguanzhuja": @"Image_carebtnja") forState:UIControlStateNormal];
                    }else{
                        [self.funBtn setBackgroundImage:UIImageNamed(self.careModel.is_admire.boolValue?@"Image_hxguanzhu": @"Image_carebtn") forState:UIControlStateNormal];
                    }
                    [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"xs.xssus"]];
                }
                [nav.topViewController hideHUD];
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
            return;
        }
    }
    if (self.type == 1 && self.careModel.needCare) {
        [nav.topViewController showHUD];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.careModel.user_id forKey:@"toUserId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admires" Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                self.careModel.needCare = NO;
                [self.funBtn setBackgroundImage:UIImageNamed( @"Image_yiguanzhu") forState:UIControlStateNormal];
            }
            [nav.topViewController hideHUD];
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
        return;
    }
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"xs.surecanxs"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf cancelCare];
        }
    };
    [alerView showXLAlertView];

}

- (void)cancelCare{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admires/%@",_careModel.user_id] Accept:@"application/vnd.shengxi.v5.1.0+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if (self.type == 1 || self.isSendWhite) {
                self.careModel.is_admire = @"0";
                self.careModel.needCare = YES;
                if (!self.isSendWhite) {
                    
                    if ([NoticeTools getLocalType] == 1) {
                        [self.funBtn setBackgroundImage:UIImageNamed(@"Image_carebtnen") forState:UIControlStateNormal];
                    }else if ([NoticeTools getLocalType] == 2){
                        [self.funBtn setBackgroundImage:UIImageNamed(@"Image_carebtnja") forState:UIControlStateNormal];
                    }else{
                        [self.funBtn setBackgroundImage:UIImageNamed(@"Image_carebtn") forState:UIControlStateNormal];
                    }
                }
                if (self.cancelCareBlock) {
                    self.cancelCareBlock(self.careModel);
                }
            }else{
                self.careModel.is_admire = @"0";
                if (!self.isSendWhite) {
                    
                    if ([NoticeTools getLocalType] == 1) {
                        [self.funBtn setBackgroundImage:UIImageNamed(self.careModel.is_admire.boolValue?@"Image_hxguanzhuen": @"Image_carebtnen") forState:UIControlStateNormal];
                    }else if ([NoticeTools getLocalType] == 2){
                        [self.funBtn setBackgroundImage:UIImageNamed(self.careModel.is_admire.boolValue?@"Image_hxguanzhuja": @"Image_carebtnja") forState:UIControlStateNormal];
                    }else{
                        [self.funBtn setBackgroundImage:UIImageNamed(self.careModel.is_admire.boolValue?@"Image_hxguanzhu": @"Image_carebtn") forState:UIControlStateNormal];
                    }
                }
                
            }
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)userInfoTap{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    self.careModel.is_update = @"0";
    ctl.isOther = YES;
    if (self.type == 1 || self.isSendWhite) {
        ctl.userId = self.careModel.user_id;
    }else{
        ctl.userId = self.careModel.from_user_id;
    }
    self.hasNewInfoL.hidden = _careModel.is_update.intValue?NO:YES;
    if (_careModel.is_update.intValue || !self.isSendWhite) {
        self.nickNameL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,15,180, 21);
    }else{
        self.nickNameL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,0,180, 68);
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
   
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
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
