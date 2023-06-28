//
//  NoticeMyFriendCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/2.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyFriendCell.h"
#import "DDHAttributedMode.h"
#import "NoticeChangeNameViewController.h"
#import "AppDelegate.h"
#import "NoticeTabbarController.h"
#import "BaseNavigationController.h"
@implementation NoticeMyFriendCell
{
    UIButton *_beizhuBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,14.5, 35, 35)];
        _iconImageView.layer.cornerRadius = 35/2;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceTap)];
        [_iconImageView addGestureRecognizer:tap];
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(22+_iconImageView.frame.origin.x, 22+_iconImageView.frame.origin.y, 15, 15)];
        self.markImage.image = UIImageNamed(@"jlzb_img");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 15,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-10-60, 15)];
        _nickNameL.font = THRETEENTEXTFONTSIZE;
        _nickNameL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:_nickNameL];
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+9,_nickNameL.frame.size.width, 11)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:_timeL];
        
        _beizhuBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-68-15,0, 68+15, 65)];
        [_beizhuBtn setTitle:@" 依然欣赏" forState:UIControlStateNormal];
        [_beizhuBtn setTitleColor:[NoticeTools getWhiteColor:@"#999999" NightColor:@"#3E3E4A"] forState:UIControlStateNormal];
        _beizhuBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        _beizhuBtn.layer.cornerRadius = 10;
        _beizhuBtn.layer.masksToBounds = YES;
        [_beizhuBtn addTarget:self action:@selector(beizhuClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_beizhuBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64.5, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = GetColorWithName(VBigLineColor);
        _line = line;
        [self.contentView addSubview:line];
        
        self.friendTimeL = [[UILabel alloc] initWithFrame:CGRectMake(_nickNameL.frame.origin.x, CGRectGetMaxY(_iconImageView.frame)+8, _nickNameL.frame.size.width, 12)];
        self.friendTimeL.textColor = [NoticeTools getWhiteColor:@"#b2b2b2" NightColor:@"#3e4a4a"];
        self.friendTimeL.font = ELEVENTEXTFONTSIZE;
        [self.contentView addSubview:self.friendTimeL];

    }
    return self;
}

- (void)setIsPipei:(BOOL)isPipei{
    _isPipei = isPipei;
    if (!_isPipei) {
        _iconImageView.userInteractionEnabled = NO;
    }
}

- (void)choiceTap{
    if (self.isPipei) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(choicePipeiUserWithTag:)]) {
            [self.delegate choicePipeiUserWithTag:self.index];
        }
    }
}

- (void)setIsSend:(BOOL)isSend{
    _isSend = isSend;
    if (isSend) {
        [_beizhuBtn setTitle:[NoticeTools getLocalStrWith:@"read.send"] forState:UIControlStateNormal];
        [_beizhuBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        _beizhuBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        _beizhuBtn.hidden = NO;
    }
}

- (void)sendImageToFriend{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendImageToFriend:)]) {
        [self.delegate sendImageToFriend:_friends];
    }
}

- (void)beizhuClick{
    if (self.isCall) {
        return;
    }
    if (_isSend) {
        [self sendImageToFriend];
        return;
    }
    BaseNavigationController *nav = nil;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    NSString *timeLen = [NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970]];
    
    
    
    if (_friends) {//我的学友
        [parm setObject:_friends.admired_at.integerValue ? @"0":timeLen forKey:@"admiredAt"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"friends/%@",_friends.lastId] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                self.friends.admired_at = self.friends.admired_at.integerValue?@"0":timeLen;
                self.friends = self.friends;
            }
            [nav.topViewController hideHUD]; 
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
    }else{//我的欣赏
        [parm setObject:_careModel.renewed_at.integerValue ? @"0":timeLen forKey:@"renewedAt"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"userSubscription/%@",_careModel.subId] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                self.careModel.renewed_at = self.careModel.renewed_at.integerValue?@"0":timeLen;
                self.careModel = self.careModel;
            }
            [nav.topViewController hideHUD];
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
    }

}

- (void)setFriends:(NoticeMyFriends *)friends{
    _friends = friends;
    _nickNameL.text = friends.nick_name;
    
    if ([friends.identity_type isEqualToString:@"0"]) {
        self.markImage.hidden = YES;
    }else if ([friends.identity_type isEqualToString:@"1"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzy_img");
    }else if ([friends.identity_type isEqualToString:@"2"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzy_img-1");
    }else{
        self.markImage.hidden = YES;
    }
    
    if ([friends.user_id isEqualToString:@"1"]) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_guanfang_b":@"Image_guanfang_y");
    }
    
    if ([_friends.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        _beizhuBtn.hidden = YES;
    }else{
        _beizhuBtn.hidden = NO;
    }
    
    self.friendTimeL.hidden = friends.renew_num.intValue ? NO:YES;
    self.friendTimeL.text = [NSString stringWithFormat:@"第%@次",friends.renew_num];
    
    if (friends.renew_num.intValue) {
        _line.frame = CGRectMake(0, 84.5, DR_SCREEN_WIDTH, 0.5);
    }else{
        _line.frame = CGRectMake(0, 64.5, DR_SCREEN_WIDTH, 0.5);
    }
    
    _timeL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@%@",friends.release_at,GETTEXTWITE(@"myfriend.mark")] setColor:[UIColor colorWithHexString:WHITEMAINCOLOR] setLengthString:friends.release_at beginSize:0];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:friends.avatar_url]]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    
    if (self.isPipei || self.isCall) {
        _beizhuBtn.hidden = NO;
        _beizhuBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-20, (65-20)/2, 20, 20);
        [_beizhuBtn setTitle:@"" forState:UIControlStateNormal];
        [_beizhuBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?(friends.isSelect?@"pp_c_b":@"pp_nc_b"):(friends.isSelect?@"pp_c_y":@"pp_nc_y")) forState:UIControlStateNormal];
    }else{
        _beizhuBtn.hidden = YES;
    }
}

- (void)setCareModel:(NoticeMyCareModel *)careModel{
    _careModel = careModel;
    [_beizhuBtn setTitle:[NoticeTools getTextWithSim:@" 再次欣赏" fantText:@" 再次關註"] forState:UIControlStateNormal];
    self.friendTimeL.hidden = YES;
    _nickNameL.text = careModel.userInfo.nick_name;
    if (_careModel.renewed_at.integerValue) {
        [_beizhuBtn setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_sendvoiceself_bs":@"Image_sendvoiceself_ys") forState:UIControlStateNormal];
    }else{
        [_beizhuBtn setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_sendvoiceself_b":@"Image_sendvoiceself_y") forState:UIControlStateNormal];
    }
    if ([careModel.userInfo.identity_type isEqualToString:@"0"]) {
        self.markImage.hidden = YES;
    }else if ([careModel.userInfo.identity_type isEqualToString:@"1"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzy_img");
    }else if ([careModel.userInfo.identity_type isEqualToString:@"2"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzy_img-1");
    }else{
        self.markImage.hidden = YES;
    }

    _timeL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@%@",careModel.established_at,[NoticeTools getTextWithSim:@"天后自动解除欣赏" fantText:@"天后自動解除關註"]] setColor:[UIColor colorWithHexString:WHITEMAINCOLOR] setLengthString:careModel.established_at beginSize:0];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:careModel.userInfo.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
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
