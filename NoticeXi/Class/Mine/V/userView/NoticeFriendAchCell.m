//
//  NoticeFriendAchCell.m
//  NoticeXi
//
//  Created by li lei on 2020/5/11.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeFriendAchCell.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeFriendAchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
        self.iconImageView.layer.cornerRadius = 15;
        self.iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        if (![NoticeTools isWhiteTheme]) {
            UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            [_iconImageView addSubview:mbView];
        }
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+15, 0, DR_SCREEN_WIDTH-60-120, 50)];
        self.nickNameL.textColor = GetColorWithName(VMainTextColor);
        self.nickNameL.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.nickNameL];
        
        self.achL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-100, 0, 100, 50)];
        self.achL.textColor = [NoticeTools getWhiteColor:@"#FFA77B" NightColor:@"#B37556"];
        self.achL.font = FOURTHTEENTEXTFONTSIZE;
        self.achL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.achL];
    }
    return self;
}
- (void)userInfoTap{
    if (self.isSelf) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _achModel.user_id;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

- (void)setAchModel:(NoticeFriendAcdModel *)achModel{
    _achModel = achModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:achModel.avatar_url]
    placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
             options:SDWebImageRefreshCached];
    self.nickNameL.text = achModel.nick_name;
    self.achL.text = [NSString stringWithFormat:@"连续%.f天",achModel.total.floatValue];
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
