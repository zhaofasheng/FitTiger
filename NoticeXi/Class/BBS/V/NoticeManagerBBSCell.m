//
//  NoticeManagerBBSCell.m
//  NoticeXi
//
//  Created by li lei on 2020/11/12.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerBBSCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeManagerBBSCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 45, 20)];
        self.markL.font = ELEVENTEXTFONTSIZE;
        self.markL.backgroundColor = GetColorWithName(VBackColor);
        self.markL.textColor = GetColorWithName(VMainThumeWhiteColor);
        self.markL.textAlignment = NSTextAlignmentCenter;
        self.markL.layer.cornerRadius = 2;
        self.markL.layer.masksToBounds = YES;
        [self.contentView addSubview:self.markL];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60,5,30,30)];
        _iconImageView.layer.cornerRadius = 30/2;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        _iconImageView.image = [UIImage imageNamed:@"Image_jynohe"];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+5,0,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-10,40)];
        self.titleL.font = THRETEENTEXTFONTSIZE;
        self.titleL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:self.titleL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = GetColorWithName(VlineColor);
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)userInfoTap{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    if (![_contriM.userInfo.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        ctl.isOther = YES;
        ctl.userId = _contriM.userInfo.userId;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        
    }
}

- (void)setContriM:(NoticeContributionModel *)contriM{
    _contriM = contriM;
    
    if (contriM.post_id.intValue) {
        self.markL.hidden = NO;
        self.markL.backgroundColor = GetColorWithName(VMainThumeColor);
        self.markL.textColor = GetColorWithName(VMainThumeWhiteColor);
        self.markL.text = @"已采纳";
    }else if (contriM.contribution_status.integerValue > 1){
        self.markL.hidden = NO;
        self.markL.backgroundColor = [UIColor colorWithHexString:@"#FC6677"];
        self.markL.textColor = GetColorWithName(VMainThumeWhiteColor);
        self.markL.text = [NoticeTools getLocalStrWith:@"emtion.deleSuc"];
    }else{
        self.markL.hidden = YES;
    }
    self.titleL.text = contriM.contribution_title;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:contriM.userInfo.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
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
