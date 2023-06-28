//
//  NoticeManagerCiTiaoCell.m
//  NoticeXi
//
//  Created by li lei on 2019/9/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerCiTiaoCell.h"
#import "NoticeMovieDetailViewController.h"
#import "NoticeBookDetailController.h"
#import "NoticeSongDetailController.h"
#import "NoticeUserInfoCenterController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeManagerCiTiaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 174, 11)];
        self.timeL.textColor = GetColorWithName(VDarkTextColor);
        self.timeL.font = ELEVENTEXTFONTSIZE;
        [self.contentView addSubview:self.timeL];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 100, 139)];
        self.iconImageView.layer.cornerRadius = 5;
        self.iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-10-66*2, 12, 66, 20)];
        [button1 setTitle:@"查看上传者" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor colorWithHexString:@"#737373"] forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:9];
        button1.layer.cornerRadius = 6;
        button1.layer.masksToBounds = YES;
        button1.layer.borderWidth = 1;
        button1.layer.borderColor = [UIColor colorWithHexString:@"#737373"].CGColor;
        [button1 addTarget:self action:@selector(lookUser) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button1];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-66, 12, 66, 20)];
        [button setTitle:@"查看词条" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#737373"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:9];
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithHexString:@"#737373"].CGColor;
        [button addTarget:self action:@selector(lookcitiao) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        self.line = [[UIView alloc] init];
        [self.contentView addSubview:self.line];
        self.line.backgroundColor = GetColorWithName(VlineColor);
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10, self.iconImageView.frame.origin.y+20, DR_SCREEN_WIDTH-10-10-CGRectGetMaxX(self.iconImageView.frame), 18)];
        self.nameL.textColor = GetColorWithName(VMainTextColor);
        self.nameL.font = EIGHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.nameL];
        
        self.typeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10, CGRectGetMaxY(self.nameL.frame)+25, DR_SCREEN_WIDTH-10-10-CGRectGetMaxX(self.iconImageView.frame), 14)];
        self.typeL.textColor = GetColorWithName(VDarkTextColor);
        self.typeL.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.typeL];
        
        self.dateL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10, CGRectGetMaxY(self.typeL.frame)+10, DR_SCREEN_WIDTH-10-10-CGRectGetMaxX(self.iconImageView.frame), 14)];
        self.dateL.textColor = GetColorWithName(VDarkTextColor);
        self.dateL.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.dateL];
        
        self.introL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10, CGRectGetMaxY(self.dateL.frame)+10, DR_SCREEN_WIDTH-10-10-CGRectGetMaxX(self.iconImageView.frame), 14)];
        self.introL.textColor = GetColorWithName(VDarkTextColor);
        self.introL.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.introL];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)longPressGestureRecognized:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    if (longPress.state == UIGestureRecognizerStateBegan) {//执行一次
        if (self.index <= 0) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                [nav.topViewController showToastWithText:@"已经是第一条，无需设置"];
            }
            return;
        }
        LCActionSheet *sheet2 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex2) {
       
            if (buttonIndex2 == 1) {
                NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                [parm setObject:@"entryPoint" forKey:@"pointKey"];
                [parm setObject:self.nextCiM.ciId forKey:@"pointValue"];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/%@/point",[NoticeTools getuserId]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    if (success) {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(readPointSetSuccess:)]) {
                            [self.delegate readPointSetSuccess:self->_index];
                        }
                    }
                } fail:^(NSError *error) {
                    
                }];
            }
        } otherButtonTitleArray:@[@"标记审阅进度"]];
        [sheet2 show];
    }
}

- (void)lookUser{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.userId = _ciM.user_id;
    ctl.isOther = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

- (void)lookcitiao{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseNavigationController *nav = nil;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        
    }
    if ([_ciM.resource_type isEqualToString:@"1"]) {
        NoticeMovieDetailViewController *ctl = [[NoticeMovieDetailViewController alloc] init];
        ctl.movie = _ciM.movie;
        ctl.passCode = self.passCode;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }else if ([_ciM.resource_type isEqualToString:@"2"]){
        NoticeBookDetailController *ctl = [[NoticeBookDetailController alloc] init];
        ctl.book = _ciM.book;
        ctl.passCode = self.passCode;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeSongDetailController *ctl = [[NoticeSongDetailController alloc] init];
        ctl.song = _ciM.song;
        ctl.passCode = self.passCode;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)setCiM:(NoticeManagerCiTiaoM *)ciM{
    _ciM = ciM;
    NSString *text = nil;
    NSString *url = nil;
    if ([_ciM.resource_type isEqualToString:@"1"]) {
        self.line.frame = CGRectMake(0, 193, DR_SCREEN_WIDTH, 1);
        text = [NoticeTools getLocalStrWith:@"movie.moviect"];
        url = ciM.movie.movie_poster;
        self.nameL.text = ciM.movie.movie_title;
        self.typeL.text = ciM.movie.movietype;
        self.dateL.text = ciM.movie.released_at;
        self.introL.text = ciM.movie.movie_intro;
    }else if ([_ciM.resource_type isEqualToString:@"2"]){
        self.line.frame = CGRectMake(0, 193, DR_SCREEN_WIDTH, 1);
        text = [NoticeTools getLocalStrWith:@"book.ct"];
        url = ciM.book.book_cover;
        self.nameL.text = ciM.book.book_name;
        self.typeL.text = ciM.book.book_author;
        self.dateL.text = ciM.book.book_intro;
        self.introL.text = @"";
    }else{
        self.line.frame = CGRectMake(0, 193-39, DR_SCREEN_WIDTH, 1);
        text = [NoticeTools getLocalStrWith:@"music.detail"];
        url = ciM.song.song_cover;
        self.nameL.text = ciM.song.song_name;
        self.typeL.text = ciM.song.song_singer;
        self.dateL.text = ciM.song.song_genre;
        self.introL.text = @"";

    }
    self.iconImageView.frame = CGRectMake(15, 40, 100,[_ciM.resource_type isEqualToString:@"3"] ? 100 : 139);
    self.timeL.text = [NSString stringWithFormat:@"%@  %@",ciM.created_at,text];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:url]
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
