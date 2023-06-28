//
//  NoticeCheckCenterCell.m
//  NoticeXi
//
//  Created by li lei on 2020/6/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeCheckCenterCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMovieDetailViewController.h"
#import "NoticeBookDetailController.h"
#import "NoticeSongDetailController.h"
#import "NoticeUserInfoCenterController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeCheckCenterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = GetColorWithName(VBackColor);
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,15, 40, 40)];
        self.iconImageView.layer.cornerRadius = 20;
        self.iconImageView.layer.masksToBounds = YES;
        _iconImageView.image = UIImageNamed(@"Image_jynohe");
        [self.contentView addSubview:self.iconImageView];
        
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(26+_iconImageView.frame.origin.x, 26+_iconImageView.frame.origin.y, 15, 15)];
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10,18, DR_SCREEN_WIDTH-15-66-10-CGRectGetMaxX(self.iconImageView.frame), 15)];
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.nickNameL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:self.nickNameL];
        
        self.sendOrCollBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-66, 15, 66, 22)];
        [self.sendOrCollBtn setTitle:@"查看对象" forState:UIControlStateNormal];
        [self.sendOrCollBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.sendOrCollBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        self.sendOrCollBtn.layer.borderWidth = 1;
        self.sendOrCollBtn.layer.borderColor = GetColorWithName(VlineColor).CGColor;
        [self.contentView addSubview:self.sendOrCollBtn];
        self.sendOrCollBtn.layer.cornerRadius = 11;
        self.sendOrCollBtn.layer.masksToBounds = YES;
        [self.sendOrCollBtn addTarget:self action:@selector(sendOrCollClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(self.nickNameL.frame.origin.x, CGRectGetMaxY(self.nickNameL.frame)+11,GET_STRWIDTH(@"昨天14点11分000078", 11, 11), 11)];
        self.timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.timeL.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.timeL];
        
        self.topicL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeL.frame)+10, CGRectGetMaxY(self.nickNameL.frame)+11,GET_STRWIDTH(@"测试测试0909090909", 11, 11), 13)];
        self.topicL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.topicL.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.topicL];
        self.topicL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTap)];
        [self.topicL addGestureRecognizer:tTap];
        
        self.drawImageView = [[UIImageView alloc] initWithFrame:CGRectMake(47,70, DR_SCREEN_WIDTH-47*2, DR_SCREEN_WIDTH-47*2)];
        self.drawImageView.image = UIImageNamed(@"img_empty_img");
        [self.contentView addSubview:self.drawImageView];
        self.drawImageView.userInteractionEnabled = YES;
        self.drawImageView.layer.cornerRadius = 7;
        self.drawImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biglook)];
        [self.drawImageView addGestureRecognizer:tapb];
    }
    return self;
}

- (void)setJubaoM:(NoticeManagerJuBaoModel *)jubaoM{
    _jubaoM = jubaoM;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:jubaoM.centerUser.avatar_url] placeholderImage:UIImageNamed(@"Image_jynohe") options:SDWebImageRefreshCached];
    _nickNameL.text = jubaoM.centerUser.nick_name;
    _timeL.text = jubaoM.created_at;
    _topicL.text = jubaoM.data_fromName;
    if (jubaoM.movie_id || jubaoM.song_id || jubaoM.book_id) {
        [self.sendOrCollBtn setTitle:@"查看词条" forState:UIControlStateNormal];
        self.sendOrCollBtn.hidden = NO;
    }else{
        self.sendOrCollBtn.hidden = YES;
    }
 
    [_drawImageView sd_setImageWithURL:[NSURL URLWithString:jubaoM.image_url] placeholderImage:UIImageNamed(@"img_empty_img") options:SDWebImageRefreshCached];
}

- (void)biglook{
    YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];
    item.thumbView = _drawImageView;
    item.largeImageURL = [NSURL URLWithString:@""];
    NSArray *arr = @[item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [photoView presentFromImageView:_drawImageView toContainer:toView animated:YES completion:nil];
}

- (void)topicTap{
    
}

- (void)sendOrCollClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseNavigationController *nav = nil;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        
    }
    [nav.topViewController showHUD];
    NSString *resourceId = nil;
    NSString *type = nil;
    if (_jubaoM.movie_id) {
        resourceId = _jubaoM.movie_id;
        type = @"1";
    }else if (_jubaoM.book_id){
        resourceId = _jubaoM.book_id;
        type = @"2";
    }else if (_jubaoM.song_id){
        type = @"3";
        resourceId = _jubaoM.song_id;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"resources/%@/%@",type,resourceId] Accept:@"application/vnd.shengxi.v3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            NoticeMovie *movie = [NoticeMovie mj_objectWithKeyValues:dict[@"data"]];
            NoticeBook *book = [NoticeBook mj_objectWithKeyValues:dict[@"data"]];
            NoticeSong *song = [NoticeSong mj_objectWithKeyValues:dict[@"data"]];
            if (self->_jubaoM.entry_type.intValue == 1) {
                NoticeMovieDetailViewController *ctl = [[NoticeMovieDetailViewController alloc] init];
                ctl.movie = movie;
                ctl.passCode = self.passCode;
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            }else if (self->_jubaoM.entry_type.intValue == 2){
                NoticeBookDetailController *ctl = [[NoticeBookDetailController alloc] init];
                ctl.book = book;
                ctl.passCode = self.passCode;
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            }else{
                NoticeSongDetailController *ctl = [[NoticeSongDetailController alloc] init];
                ctl.song = song;
                ctl.passCode = self.passCode;
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            }
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)userInfoTap{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.userId = _jubaoM.user_id;
    ctl.isOther = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}
@end


