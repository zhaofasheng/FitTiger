//
//  NoticeQuestionDetailCell.m
//  NoticeXi
//
//  Created by li lei on 2021/6/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeQuestionDetailCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeQuestionDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
  
        self.headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
        self.headerV.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
        [self.contentView addSubview:self.headerV];
        self.headL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-15, 44)];
        self.headL.font = [UIFont fontWithName:XGBoldFontName size:16];
        self.headL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.headerV addSubview:self.headL];
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,15+44,36, 36)];
        _iconImageView.layer.cornerRadius = 18;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        [self.contentView addSubview:_iconImageView];
                
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 15+44,180, 21)];
        _nickNameL.font = XGFifthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:_nickNameL];
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(_nickNameL.frame.origin.x,CGRectGetMaxY(_nickNameL.frame)+3,140, 16)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = [UIColor colorWithHexString:@"#737780"];
        [self.contentView addSubview:_timeL];
        
        //
        _infoL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+1,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15-10, 17)];
        _infoL.font = THRETEENTEXTFONTSIZE;
        _infoL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _infoL.numberOfLines = 0;
        [self.contentView addSubview:_infoL];
    }
    return self;
}

- (void)setQuestionM:(NoticeUserQuestionModel *)questionM{
    _questionM = questionM;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:questionM.userM.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    self.nickNameL.text = questionM.userM.nick_name;
    self.timeL.text = questionM.created_at;
    self.infoL.text = questionM.describe;
    self.infoL.frame = CGRectMake(15, 105, DR_SCREEN_WIDTH-30, GET_STRHEIGHT(questionM.describe, 13, DR_SCREEN_WIDTH-30));
    self.headL.text = [NSString stringWithFormat:@"%@ %@",questionM.msgM.supply,questionM.msgM.title];
}

- (void)userInfoTap{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.userId = self.questionM.userM.piPeiId;
    ctl.isOther = [self.questionM.userM.piPeiId isEqualToString:[NoticeTools getuserId]]?NO: YES;
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
