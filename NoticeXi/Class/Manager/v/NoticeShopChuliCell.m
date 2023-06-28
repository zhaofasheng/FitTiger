//
//  NoticeShopChuliCell.m
//  NoticeXi
//
//  Created by li lei on 2022/7/19.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopChuliCell.h"
#import "BaseNavigationController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeTabbarController.h"

@implementation NoticeShopChuliCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 34, 34)];
        _iconImageView.layer.cornerRadius = 17;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 20, 160, 18)];
        _nickNameL.font = THRETEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:_nickNameL];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,40, 180, 14)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.contentView addSubview:_timeL];
       
        _staltusL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50-15,25, 50, 28)];
        _staltusL.font = ELEVENTEXTFONTSIZE;
        _staltusL.textColor = [UIColor colorWithHexString:@"#E1E4F0"];
        _staltusL.layer.cornerRadius = 2;
        _staltusL.layer.masksToBounds = YES;
        
        _staltusL.textAlignment = NSTextAlignmentCenter;
        _staltusL.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.contentView addSubview:_staltusL];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-100-15-15, 25, 50, 28)];
        [button setTitle:@"通过" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button addTarget:self action:@selector(agreeClick) forControlEvents:UIControlEventTouchUpInside];
        self.agereeBtn = button;
        button.backgroundColor = [UIColor colorWithHexString:@"#7ACC6B"];
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = YES;
        [self.contentView addSubview:button];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50-15, 25, 50, 28)];
        [button1 setTitle:@"拒绝" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button1.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button1 addTarget:self action:@selector(noClick) forControlEvents:UIControlEventTouchUpInside];
        self.noBtn = button1;
        button1.backgroundColor = [UIColor colorWithHexString:@"#DB6E6E"];
        button1.layer.cornerRadius = 2;
        button1.layer.masksToBounds = YES;
        [self.contentView addSubview:button1];
    }
    return self;
}

- (void)agreeClick{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/shopApply/%@/1?confirmPasswd=%@",self.chuliM.shopId,self.managerCode] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
   
        if (success) {
            self.chuliM.audit_status = @"1";
            if (_chuliM.audit_status.intValue == 1 || _chuliM.audit_status.intValue == 2) {
                self.agereeBtn.hidden = YES;
                self.noBtn.hidden = YES;
                self.staltusL.hidden = NO;
                _staltusL.text = _chuliM.audit_status.intValue==1?@"已通过":@"已拒绝";
            }else{
                _staltusL.hidden = YES;
                self.agereeBtn.hidden = NO;
                self.noBtn.hidden = NO;
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)noClick{
    if (self.userM) {
        if (self.outWhiteBlock) {
            self.outWhiteBlock(self.userM);
        }
        return;
    }
    if (!self.inputV) {
        NoticeBBSComentInputView *inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        inputView.delegate = self;
        inputView.isRead = YES;
        inputView.ismanager = YES;
        inputView.limitNum = 100;
        inputView.needClear = YES;
        inputView.plaStr = @"输入拒绝理由";
        inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [inputView.sendButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [inputView showJustComment:nil];
        
        self.inputV = inputView;
    }
    [self.inputV showJustComment:nil];
    [self.inputV.contentView becomeFirstResponder];
    [self.inputV.backView removeFromSuperview];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self.inputV.backView];
    self.inputV.backView.hidden = NO;
}

- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:comment forKey:@"audit_fail_reason"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/shopApply/%@/2?confirmPasswd=%@",self.chuliM.shopId,self.managerCode] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
   
        if (success) {
            self.chuliM.audit_status = @"2";
            if (_chuliM.audit_status.intValue == 1 || _chuliM.audit_status.intValue == 2) {
                self.agereeBtn.hidden = YES;
                self.noBtn.hidden = YES;
                self.staltusL.hidden = NO;
                _staltusL.text = _chuliM.audit_status.intValue==1?@"已通过":@"已拒绝";
            }else{
                _staltusL.hidden = YES;
                self.agereeBtn.hidden = NO;
                self.noBtn.hidden = NO;
            }
        }
        
    } fail:^(NSError * _Nullable error) {
    }];
    [self.inputV clearView];
}

- (void)setUserM:(NoticeAbout *)userM{
    _userM = userM;
    self.agereeBtn.hidden = YES;
    self.staltusL.hidden = YES;
    self.noBtn.hidden = NO;
    self.noBtn.frame = CGRectMake(DR_SCREEN_WIDTH-80-15, 25, 80, 28);
    self.noBtn.layer.cornerRadius = 14;
    self.noBtn.backgroundColor = [UIColor whiteColor];
    self.noBtn.layer.borderWidth = 1;
    self.noBtn.layer.borderColor = [UIColor colorWithHexString:@"#0099E6"].CGColor;
    [self.noBtn setTitle:@"移出白名单" forState:UIControlStateNormal];
    [self.noBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userM.avatar_url]];
    self.nickNameL.text = userM.nick_name;
}

- (void)setBoKeModel:(NoticeDanMuModel *)boKeModel{
    _boKeModel = boKeModel;
    self.agereeBtn.hidden = YES;
    self.noBtn.hidden = YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:boKeModel.avatar_url]];
    self.nickNameL.text = boKeModel.nick_name;
    self.timeL.text = boKeModel.sendAt;
    self.staltusL.hidden = NO;
    if (boKeModel.podcast_type.intValue == 1) {
        self.staltusL.text = @"已通过";
    }else if (boKeModel.podcast_type.intValue == 2){
        self.staltusL.text = @"待审核";
    }else if (boKeModel.podcast_type.intValue == 3){
        self.staltusL.text = @"已拒绝";
    }else{
        self.staltusL.hidden = YES;
    }
}

- (void)setChuliM:(NoticeShopChuliModel *)chuliM{
    _chuliM = chuliM;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:chuliM.userM.avatar_url]];
    self.nickNameL.text = chuliM.shop_name;
    self.timeL.text = chuliM.created_at;
    
    if (_chuliM.audit_status.intValue == 1 || _chuliM.audit_status.intValue == 2) {
        self.agereeBtn.hidden = YES;
        self.noBtn.hidden = YES;
        self.staltusL.hidden = NO;
        _staltusL.text = _chuliM.audit_status.intValue==1?@"已通过":@"已拒绝";
    }else{
        _staltusL.hidden = YES;
        self.agereeBtn.hidden = NO;
        self.noBtn.hidden = NO;
    }
}

//点击头像
- (void)userInfoTap{
    NSString *userId = self.boKeModel?self.boKeModel.user_id:self.chuliM.user_id;
    if ([userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
      
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = userId ;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
      
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
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
