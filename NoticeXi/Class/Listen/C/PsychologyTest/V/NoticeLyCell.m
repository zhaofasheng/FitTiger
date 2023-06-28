//
//  NoticeLyCell.m
//  NoticeXi
//
//  Created by li lei on 2019/1/30.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeLyCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeLyCell
{
    UIImageView *_iconImageView;
    UILabel *_contentL;
    UILabel *_nameL;
    UILabel *_typeL;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 25,44, 44)];
        _iconImageView.layer.cornerRadius = 22;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uscerCenterTap)];
        [_iconImageView addGestureRecognizer:tap];
        [self.contentView addSubview:_iconImageView];
        if (![NoticeTools isWhiteTheme]) {
            UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            [_iconImageView addSubview:mbView];
        }

        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+19,30, DR_SCREEN_WIDTH-60-60-44, 14)];
        _nameL.font = TWOTEXTFONTSIZE;
        _nameL.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:_nameL];
        
        _typeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameL.frame)+15, _nameL.frame.origin.y-8, 55, 20)];
        _typeL.font = [UIFont systemFontOfSize:9];
        _typeL.textColor = GetColorWithName(VMainThumeWhiteColor);
        _typeL.textAlignment = NSTextAlignmentCenter;
        _typeL.layer.cornerRadius = 20/2;
        _typeL.layer.masksToBounds = YES;
        [self.contentView addSubview:_typeL];
        
        _contentL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _contentL.textColor = GetColorWithName(VMainTextColor);
        _contentL.font = TWOTEXTFONTSIZE;
        _contentL.numberOfLines = 0;
        [self.contentView addSubview:_contentL];
    
        self.delBtn = [[UIButton alloc] init];
        [self.delBtn setTitle:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
        self.delBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [self.delBtn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FF8108":@"#B26910"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.delBtn];
        [self.delBtn addTarget:self action:@selector(delLiuy) forControlEvents:UIControlEventTouchUpInside];
        self.delBtn.hidden = YES;
    }
    return self;
}

- (void)uscerCenterTap{
    if ([_lyModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (!self.isOpen) {
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
            }
            return;
        }
        UINavigationController *nav = (UINavigationController *)appdel.window.rootViewController;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _lyModel.user_id;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
   
        if (!self.isOpen) {
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
            }
            return;
        }
        UINavigationController *nav = (UINavigationController *)appdel.window.rootViewController;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

- (void)delLiuy{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteLiuYanWith:)]) {
        [self.delegate deleteLiuYanWith:self.index];
    }
}

- (void)setLyModel:(NoticeTestLyModel *)lyModel{
    _lyModel = lyModel;
    _nameL.text = lyModel.nick_name;
    _nameL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+19,30,GET_STRWIDTH(lyModel.nick_name, 12, 14), 14);
    
    _typeL.frame = CGRectMake(CGRectGetMaxX(_nameL.frame)+15, _nameL.frame.origin.y-4, 55, 20);
    _typeL.text = lyModel.personality_title;
    _typeL.backgroundColor = [UIColor colorWithHexString:lyModel.isT?@"#90D3F6":@"#F5C2C5"];
    if (![NoticeTools isWhiteTheme]) {
        _typeL.backgroundColor = [UIColor colorWithHexString:lyModel.isT?@"#6593AC":@"#AB878A"];
    }
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:lyModel.avatar_url]
                                    placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                             options:SDWebImageRefreshCached];
    _contentL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+20,CGRectGetMaxY(_nameL.frame)+20, DR_SCREEN_WIDTH-60-60-44, lyModel.cellHeight>20? lyModel.cellHeight : 14);
    _contentL.attributedText = [NoticeTools getStringWithLineHight:4 string:lyModel.content];
    
    if ([lyModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        self.delBtn.hidden = NO;
        self.delBtn.frame = CGRectMake(_contentL.frame.origin.x, CGRectGetMaxY(_contentL.frame), GET_STRWIDTH([NoticeTools getLocalStrWith:@"groupManager.del"],12, 30), 30);
    }else{
        self.delBtn.hidden = YES;
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
