//
//  NoticeNewTuiJianCell.m
//  NoticeXi
//
//  Created by li lei on 2021/5/17.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewTuiJianCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeNewTuiJianCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.userInteractionEnabled = YES;
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,10, 40, 40)];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_iconImageView];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_iconImageView.frame)+10,50, 14)];
        _nickNameL.font = [UIFont systemFontOfSize:10];
        _nickNameL.textColor = [UIColor colorWithHexString:@"#B8BECC"];
        [self.contentView addSubview:_nickNameL];
        _nickNameL.textAlignment = NSTextAlignmentCenter;
        
        self.careButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nickNameL.frame)+10, 50, 20)];
        self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
        self.careButton.titleLabel.font = TWOTEXTFONTSIZE;
        [self.careButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.careButton.layer.cornerRadius = 10;
        self.careButton.layer.masksToBounds = YES;
        [self.contentView addSubview:self.careButton];
        [self.careButton addTarget:self action:@selector(careClick) forControlEvents:UIControlEventTouchUpInside];
        
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
    }
    return self;
}

- (void)setCareM:(NoticeFriendAcdModel *)careM{
    _careM = careM;
   
    self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [self.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
    self.nickNameL.text = careM.nick_name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:careM.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
}

- (void)careClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    //_voiceM.subUserModel.userId
    [nav.topViewController showHUD];
    
    if (self.careM.careId.integerValue) {
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admires/%@",self.careM.userId] Accept:@"application/vnd.shengxi.v5.1.0+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                self.careM.careId = @"0";
                if (self.careM.careId.intValue) {
                    self.careButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
                    [self.careButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
                }else{
                    self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                    [self.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
                }
            }
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
        return;
    }
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.careM.userId forKey:@"toUserId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admires" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeMJIDModel *idM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            self.careM.careId = idM.allId;
            if (self.careM.careId.intValue) {
                self.careButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
                [self.careButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
                [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"xs.xssus"]];
            }else{
                self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                [self.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
            }
        }
        [nav.topViewController hideHUD];
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)userInfoTap{
    
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    
    __weak typeof(self) weakSelf = self;
    ctl.careClickBlock = ^(NSString * _Nonnull careId, NSString * _Nonnull userId) {
        weakSelf.careM.careId = careId;
        if (weakSelf.careM.careId.intValue) {
            weakSelf.careButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
            [weakSelf.careButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
        }else{
            weakSelf.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [weakSelf.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
        }
    };
    
    ctl.isOther = YES;
    ctl.userId = self.careM.userId;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
   
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
