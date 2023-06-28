//
//  NoticeJuBaoShopChatCell.m
//  NoticeXi
//
//  Created by li lei on 2022/7/20.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeJuBaoShopChatCell.h"
#import "BaseNavigationController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeTabbarController.h"
@implementation NoticeJuBaoShopChatCell
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
       
        _staltusL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-59-15,27, 59, 24)];
        _staltusL.font = ELEVENTEXTFONTSIZE;
        _staltusL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _staltusL.layer.cornerRadius = 12;
        _staltusL.layer.masksToBounds = YES;
        _staltusL.textAlignment = NSTextAlignmentCenter;
        _staltusL.layer.borderColor = [UIColor colorWithHexString:@"#A1A7B3"].CGColor;
        _staltusL.layer.borderWidth = 1;
        [self.contentView addSubview:_staltusL];

        _staltusL1 = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-59-15-10-38,27, 38, 24)];
        _staltusL1.font = ELEVENTEXTFONTSIZE;
        _staltusL1.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _staltusL1.layer.cornerRadius = 12;
        _staltusL1.layer.masksToBounds = YES;
        _staltusL1.textAlignment = NSTextAlignmentCenter;
        _staltusL1.layer.borderColor = [UIColor colorWithHexString:@"#A1A7B3"].CGColor;
        _staltusL1.layer.borderWidth = 1;
        [self.contentView addSubview:_staltusL1];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 75, DR_SCREEN_WIDTH-20, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setJubaoModel:(NoticeJuBaoShopChatModel *)jubaoModel{
    _jubaoModel = jubaoModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:jubaoModel.toUserM.avatar_url]];
    self.nickNameL.text = jubaoModel.resource_type.intValue == 1?jubaoModel.toUserM.nick_name : jubaoModel.shop_name;
    self.timeL.text = jubaoModel.created_at;
    self.staltusL.text = jubaoModel.type_id;
    self.staltusL1.text = jubaoModel.resource_type.intValue == 2?@"店铺" : @"买家";
}

//点击头像
- (void)userInfoTap{

    if ([self.jubaoModel.to_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
      
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = self.jubaoModel.to_user_id;
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
