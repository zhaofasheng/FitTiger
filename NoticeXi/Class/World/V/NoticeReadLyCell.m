//
//  NoticeReadLyCell.m
//  NoticeXi
//
//  Created by li lei on 2021/6/29.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeReadLyCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeReadLyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0];
        
        self.cirView = [[UIView alloc] initWithFrame:CGRectMake(15,0, DR_SCREEN_WIDTH-30, 20)];
        self.cirView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.cirView.layer.cornerRadius = 10;
        self.cirView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.cirView];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 56)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:self.backView];
     
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 23, 23)];
        self.iconImageView.layer.cornerRadius = 23/2;
        self.iconImageView.layer.masksToBounds = YES;
        [self.backView addSubview:self.iconImageView];
        
        if ([NoticeTools isManager]) {
            _iconImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
            [_iconImageView addGestureRecognizer:iconTap];
        }

        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(44, 16, self.backView.frame.size.width-44-66, 20)];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.numberOfLines = 0;
        [self.backView addSubview:self.contentL];
        
        self.subiconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
        self.subiconImageView.layer.cornerRadius = 20/2;
        self.subiconImageView.layer.masksToBounds = YES;
        [self.backView addSubview:self.subiconImageView];
        
        self.subcontentL = [[UILabel alloc] initWithFrame:CGRectMake(44, CGRectGetMaxY(self.contentL.frame), self.backView.frame.size.width-74-64, 20)];
        self.subcontentL.font = FOURTHTEENTEXTFONTSIZE;
        self.subcontentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.subcontentL.numberOfLines = 0;
        [self.backView addSubview:self.subcontentL];
        
        self.likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-26-20, 17, 20, 20)];
        [self.backView addSubview:self.likeImageView];
        self.likeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap)];
        [self.likeImageView addGestureRecognizer:tap];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeImageView.frame), 17, 26, 20)];
        self.numL.font = TWOTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView addSubview:self.numL];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(44, 55, self.backView.frame.size.width-44, 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.backView addSubview:self.line];
        
        self.contentView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressicon = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longIconPressGestureRecognized:)];
        longPressicon.minimumPressDuration = 0.5;
        [self.contentView addGestureRecognizer:longPressicon];
    }
    return self;
}

- (void)userInfoTap{
    
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.isOther = YES;
    ctl.userId = self.liuyan.from_user_id;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
  
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

- (void)longIconPressGestureRecognized:(UILongPressGestureRecognizer *)tap{
  
    if (tap.state == UIGestureRecognizerStateBegan) {
        if (self.longTapBlock) {
            self.longTapBlock(self.liuyan);
        }
    }
}

- (void)setLiuyan:(NoticeLy *)liuyan{
    _liuyan = liuyan;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:liuyan.avatar_url] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
    
    self.contentL.attributedText = liuyan.allreadTextAttStr;

    if (liuyan.replyted_at.integerValue) {
        self.subcontentL.hidden = NO;
        self.subiconImageView.hidden = NO;
        self.subcontentL.attributedText = liuyan.replyTextAttStr;
        [self.subiconImageView sd_setImageWithURL:[NSURL URLWithString:liuyan.reply_avatar_url]];
    }else{
        self.subcontentL.hidden = YES;
        self.subiconImageView.hidden = YES;
    }
    
    if (liuyan.height1 < 40) {
        self.contentL.frame = CGRectMake(44, 19, self.backView.frame.size.width-44-66, 20);
        self.line.frame = CGRectMake(44, 55, self.backView.frame.size.width-44, 1);
        self.backView.frame = CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 56+(liuyan.replyted_at.integerValue?(liuyan.height2+10):0));
        
    }else{
        self.contentL.frame = CGRectMake(44, 16, self.backView.frame.size.width-44-66, liuyan.height1);
        self.line.frame = CGRectMake(44, CGRectGetMaxY(self.contentL.frame)+15, self.backView.frame.size.width-44, 1);
        self.backView.frame = CGRectMake(15, 10, DR_SCREEN_WIDTH-30, liuyan.height1+16+15+(liuyan.replyted_at.integerValue?(liuyan.height2+10):0));
    }
    if (liuyan.replyted_at.integerValue) {
        self.subiconImageView.frame = CGRectMake(44,CGRectGetMaxY(self.contentL.frame)+10, 20, 20);
        self.subcontentL.frame = CGRectMake(CGRectGetMaxX(self.subiconImageView.frame)+10, CGRectGetMaxY(self.contentL.frame)+10, self.backView.frame.size.width-74-64, liuyan.height2);
        self.line.frame = CGRectMake(44, CGRectGetMaxY(self.subcontentL.frame)+15, self.backView.frame.size.width-44, 1);
    }
    self.numL.text = liuyan.like_num.intValue?liuyan.like_num:@"";
    self.likeImageView.image = liuyan.is_zan.intValue?UIImageNamed(@"Image_likeDMy"):UIImageNamed(@"Image_nodianzan");
}

- (void)likeTap{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    [nav.topViewController showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"comment/zan/%@",self.liuyan.liuyanId] Accept:@"application/vnd.shengxi.v4.9.20+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if (self.liuyan.is_zan.boolValue) {
                self.liuyan.is_zan = @"0";
                self.liuyan.like_num = [NSString stringWithFormat:@"%d",self.liuyan.like_num.intValue-1];
            }else{
                self.liuyan.is_zan = @"1";
                self.liuyan.like_num = [NSString stringWithFormat:@"%d",self.liuyan.like_num.intValue+1];
            }
            self.numL.text = self.liuyan.like_num.intValue?self.liuyan.like_num:@"";
            self.numL.textColor = self.liuyan.is_zan.intValue?[UIColor colorWithHexString:@"#0099E6"]:[UIColor colorWithHexString:@"#5C5F66"];
            self.likeImageView.image = self.liuyan.is_zan.intValue?UIImageNamed(@"Image_likeDMy"):UIImageNamed(@"Image_nodianzan");
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
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
