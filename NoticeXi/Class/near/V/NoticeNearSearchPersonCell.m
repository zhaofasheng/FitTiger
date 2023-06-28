//
//  NoticeNearSearchPersonCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeNearSearchPersonCell.h"
#import "DDHAttributedMode.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeWhiteCardDetiailController.h"
@implementation NoticeNearSearchPersonCell
{
    UIButton *_beizhuBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,14.5,35, 35)];
        _iconImageView.layer.cornerRadius = 35/2;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 0,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15, 64.5)];
        _nickNameL.font = FIFTHTEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,65-18-11,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15, 11)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:_timeL];
        
        _beizhuBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-90, 0, 90, 65)];
        [_beizhuBtn setTitle:GETTEXTWITE(@"set.outblack") forState:UIControlStateNormal];
        [_beizhuBtn setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
        _beizhuBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [_beizhuBtn addTarget:self action:@selector(beizhuClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_beizhuBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 64.5, DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-10, 0.5)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        [self.contentView addSubview:line];
        _line = line;
    }
    return self;
}

- (UILabel *)choiceL{
    if (!_choiceL) {
        _choiceL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-70, 0, 70, 64.6)];
        _choiceL.font = SIXTEENTEXTFONTSIZE;
        _choiceL.text = [NoticeTools getLocalStrWith:@"bz.yx"];
        _choiceL.textAlignment = NSTextAlignmentCenter;
        _choiceL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.contentView addSubview:_choiceL];
    }
    return _choiceL;
}

- (void)setRecodM:(NoticeSendCardRecord *)recodM{
    _recodM = recodM;
    _beizhuBtn.hidden = YES;
    NSString *str = [NSString stringWithFormat:@"%@ %@",recodM.fromUserInfo.nick_name,[NoticeTools getLocalStrWith:@"bz.giveyou"]];
    _nickNameL.attributedText = [DDHAttributedMode setSizeAndColorString:str setColor:[UIColor colorWithHexString:@"#737780"] setSize:12 setLengthString:[NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"bz.giveyou"]] beginSize:recodM.fromUserInfo.nick_name.length];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:recodM.fromUserInfo.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    self.sendWhiteBtn.hidden = NO;
    [self.sendWhiteBtn setTitle:[NoticeTools getLocalStrWith:@"sendTextt.look"] forState:UIControlStateNormal];
    self.sendWhiteBtn.frame = CGRectMake(DR_SCREEN_WIDTH-20-47, (65-24)/2, 47, 24);
    self.line.frame = CGRectMake(20, 64, DR_SCREEN_WIDTH-20, 1);
}

- (void)beizhuClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteFriendIn:)]) {
        [self.delegate deleteFriendIn:self.index];
    }
}

- (void)setBlackPerson:(NoticeNearPerson *)blackPerson{
    if (self.type == 1) {
        if ([blackPerson.identity_type isEqualToString:@"0"]) {
            self.markImage.hidden = YES;
        }else if ([blackPerson.identity_type isEqualToString:@"1"]){
            self.markImage.hidden = NO;
            self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzy_img");
        }else if ([blackPerson.identity_type isEqualToString:@"2"]){
            self.markImage.hidden = NO;
            self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzy_img-1");
        }else{
            self.markImage.hidden = YES;
        }
        if ([blackPerson.user_id isEqualToString:@"1"]) {
            self.markImage.hidden = NO;
            self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_guanfang_b":@"Image_guanfang_y");
        }
        [_beizhuBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        _beizhuBtn.titleLabel.font = ELEVENTEXTFONTSIZE;
        
        _beizhuBtn.frame = CGRectMake(DR_SCREEN_WIDTH-20-81, 41/2, 81, 24);
        _beizhuBtn.layer.cornerRadius = 12;
        _beizhuBtn.layer.masksToBounds = YES;
        _beizhuBtn.layer.borderWidth = 1;
        _beizhuBtn.layer.borderColor = [UIColor colorWithHexString:@"#0099E6"].CGColor;
    }
    else{
        self.markImage.hidden = YES;
        [_beizhuBtn setTitle:GETTEXTWITE(@"set.outblack") forState:UIControlStateNormal];
    }
    [_beizhuBtn setTitle:self.isGrayList?[NoticeTools getLocalStrWith:@"black.m1"]: [NoticeTools getLocalStrWith:@"black.m2"] forState:UIControlStateNormal];
    _blackPerson = blackPerson;
    _nickNameL.text = blackPerson.nick_name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:blackPerson.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
}

- (void)setWhitePerson:(NoticeNearPerson *)whitePerson{
    _whitePerson = whitePerson;
    if ([whitePerson.identity_type isEqualToString:@"0"]) {
        self.markImage.hidden = YES;
    }else if ([whitePerson.identity_type isEqualToString:@"1"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzy_img");
    }else if ([_blackPerson.identity_type isEqualToString:@"2"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzy_img-1");
    }else{
        self.markImage.hidden = YES;
    }
    [_beizhuBtn setTitle:@"手动移出" forState:UIControlStateNormal];
    _nickNameL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,18,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15, 13);
    _nickNameL.text = whitePerson.nick_name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:whitePerson.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    _timeL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@天后自动离开白名单",whitePerson.released_at] setColor:[UIColor colorWithHexString:WHITEMAINCOLOR] setLengthString:whitePerson.released_at beginSize:0];
}

- (void)setPerson:(NoticeNearPerson *)person{
    _person = person;
    _beizhuBtn.hidden = YES;
    _nickNameL.text = person.nick_name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:person.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    if (self.sendAll) {
        self.choiceL.hidden = !person.isselect;
    }
    if (self.sendWhite) {
        if (person.whiteType == 1) {
            self.sendWhiteBtn.hidden = YES;
            self.sureSendBtn.hidden = NO;
            self.errBtn.hidden = NO;
        }else{
            self.sendWhiteBtn.hidden = NO;
            self.sureSendBtn.hidden = YES;
            self.errBtn.hidden = YES;
        }
    }
    self.line.frame = CGRectMake(20, 64, DR_SCREEN_WIDTH-20, 1);
}

- (void)sendClick{
    if (self.recodM) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        
        [nav.topViewController showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"famousQuotesCards/%@",self.recodM.card_no] Accept:@"application/vnd.shengxi.v4.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                NoticeWhiteCardDetiailController *ctl = [[NoticeWhiteCardDetiailController alloc] init];
                ctl.whiteModel = [NoticeWhiteVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            }
       
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
        return;
    }
    if (self.sendBlock) {
        self.sendBlock(self.person);
    }
}

- (void)sureSendClick{
    if (self.sureSendBlock) {
        self.sureSendBlock(self.person);
    }
}

- (void)errClick{
    if (self.errBlock) {
        self.errBlock(self.person);
    }
}

- (UIButton *)sendWhiteBtn{
    if (!_sendWhiteBtn) {
        _sendWhiteBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-60, (65-24)/2, 60, 24)];
        _sendWhiteBtn.backgroundColor = self.backgroundColor;
        _sendWhiteBtn.layer.cornerRadius = 12;
        _sendWhiteBtn.layer.masksToBounds = YES;
        [_sendWhiteBtn setTitle:[NoticeTools getLocalStrWith:@"xs.sendhe"] forState:UIControlStateNormal];
        [_sendWhiteBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        _sendWhiteBtn.titleLabel.font = ELEVENTEXTFONTSIZE;
        [self.contentView addSubview:_sendWhiteBtn];
        _sendWhiteBtn.layer.borderWidth = 1;
        _sendWhiteBtn.layer.borderColor = [UIColor colorWithHexString:@"#0099E6"].CGColor;
        [_sendWhiteBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendWhiteBtn;
}

- (UIButton *)sureSendBtn{
    if (!_sureSendBtn) {
        _sureSendBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-50, (65-30)/2, 50, 30)];
        _sureSendBtn.backgroundColor = GetColorWithName(VMainThumeColor);
        _sureSendBtn.layer.cornerRadius = 5;
        _sureSendBtn.layer.masksToBounds = YES;
        [_sureSendBtn setTitle:@"送" forState:UIControlStateNormal];
        [_sureSendBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        _sureSendBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:_sureSendBtn];
        [_sureSendBtn addTarget:self action:@selector(sureSendClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureSendBtn;
}

- (UIButton *)errBtn{
    if (!_errBtn) {
        _errBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-50-10-50, (65-30)/2, 50, 30)];
        _errBtn.backgroundColor = GetColorWithName(VMainThumeColor);
        _errBtn.layer.cornerRadius = 5;
        _errBtn.layer.masksToBounds = YES;
        [_errBtn setTitle:[NoticeTools getLocalStrWith:@"bz.dcl"] forState:UIControlStateNormal];
        [_errBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        _errBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:_errBtn];
        [_errBtn addTarget:self action:@selector(errClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _errBtn;
}
@end
