//
//  NoticeDanMuCell.m
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDanMuCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeXi-Swift.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeDanMuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,20,24, 24)];
        _iconImageView.layer.cornerRadius = 12;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        [self addSubview:_iconImageView];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(43, 15, DR_SCREEN_WIDTH-43-60, 37)];
        self.backView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.1];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        self.backView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT.minimumPressDuration = 0.5;
        [self.backView addGestureRecognizer:longPressDeleT];
        [self.contentView addSubview:self.backView];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, self.backView.frame.size.width-30, 21)];
        self.titleL.font = FIFTHTEENTEXTFONTSIZE;
        self.titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.backView addSubview:self.titleL];
        self.titleL.numberOfLines = 0;
        
        self.likeImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.backView.frame)+8,15+(self.backView.frame.size.height-20)/2, 20, 20)];
        self.likeImage.image = UIImageNamed(@"Image_likeDMs");
        [self.contentView addSubview:self.likeImage];
        self.likeImage.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap)];
        [self.likeImage addGestureRecognizer:tap];
        
        self.likeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.backView.frame), CGRectGetMaxY(self.likeImage.frame),36, 17)];
        self.likeL.font = TWOTEXTFONTSIZE;
        self.likeL.textAlignment = NSTextAlignmentCenter; 
        self.likeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:self.likeL];
        self.likeL.hidden = YES;
    }
    return self;
}


- (void)deleTapT:(UILongPressGestureRecognizer *)tap{

    if (tap.state == UIGestureRecognizerStateBegan) {
        [self moreClick];
    }
}


- (void)setModel:(NoticeDanMuListModel *)model{
    _model = model;
   
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userM.avatar_url]];
    if ([model.userM.userId isEqualToString:[NoticeTools getuserId]]) {
        self.iconImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-24, 20, 24, 24);
        self.backView.frame = CGRectMake(DR_SCREEN_WIDTH-15-24-4-30-model.textWidth, 15, model.textWidth+30, model.textHeight+16);
        self.likeImage.frame = CGRectMake(self.backView.frame.origin.x-8-20,15+(self.backView.frame.size.height-20-(model.barrage_likes.intValue?17:0))/2, 20, 20);
    }else{
        self.iconImageView.frame = CGRectMake(15, 20, 24, 24);
        self.backView.frame = CGRectMake(43, 15, model.textWidth+30, model.textHeight+16);
        self.likeImage.frame = CGRectMake(CGRectGetMaxX(self.backView.frame)+8,15+(self.backView.frame.size.height-20-(model.barrage_likes.intValue?17:0))/2, 20, 20);
    }
    
    self.likeL.frame = CGRectMake(self.likeImage.frame.origin.x-8, CGRectGetMaxY(self.likeImage.frame),36, 17);
    self.titleL.frame = CGRectMake(15, 8, model.textWidth, model.textHeight);
    
    self.titleL.attributedText = model.attStr;
    
    self.titleL.textColor = [UIColor colorWithHexString:model.barrage_colour?model.barrage_colour:@"#FFFFFF"];
    self.likeL.text = model.barrage_likes.integerValue?model.barrage_likes:@"0";
    self.likeL.hidden = model.barrage_likes.intValue?NO:YES;
    if (self.model.is_likes.intValue) {
        self.likeImage.image = UIImageNamed(@"Image_likeDMsy");
    }else{
        self.likeImage.image = UIImageNamed(@"Image_likeDMs");
    }
}

- (void)moreClick{
    
    if ([NoticeTools isManager]) {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[@"查看用户(管理员)",@"删除弹幕(管理员)",[NoticeTools getLocalStrWith:@"chat.jubao"]]];
        sheet.delegate = self;
        [sheet show];
    }else{
        if ([self.model.userM.userId isEqualToString:[NoticeTools getuserId]]) {
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"groupManager.del"]]];
            sheet.delegate = self;
            [sheet show];
        }else{
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.jubao"]]];
            sheet.delegate = self;
            [sheet show];
        }
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([NoticeTools isManager]) {
        if (buttonIndex == 3) {
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = self.model.danmuId;
            juBaoView.reouceType = @"10";
            [juBaoView showView];
        }else if (buttonIndex == 1){
            
            NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
            if (![[NoticeTools getuserId] isEqualToString:self.model.userM.userId]) {
                
                ctl.isOther = YES;
                ctl.userId = self.model.userM.userId;
            }
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
          
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
                
            }
        }else if (buttonIndex == 2){
            self.magager.type = @"管理员删除";
            [self.magager show];
        }
    }else{
        if (buttonIndex == 1) {
            if ([self.model.userM.userId isEqualToString:[NoticeTools getuserId]]) {
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }
                [nav.topViewController showHUD];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"podcast/barrage/%@",self.model.danmuId] Accept:@"application/vnd.shengxi.v4.9.7+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        if (self.deleteBlock) {
                            self.deleteBlock(self.model);
                        }
                    }
                } fail:^(NSError * _Nullable error) {
                    [nav.topViewController hideHUD];
                }];
                return;
            }
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = self.model.danmuId;
            juBaoView.reouceType = @"10";
            [juBaoView showView];
        }
    }
}

- (void)sureManagerClick:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
 
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/barrage/%@",self.model.danmuId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        [self.magager removeFromSuperview];
        if (success) {
            if (self.deleteBlock) {
                self.deleteBlock(self.model);
            }
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}


- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}

- (void)likeTap{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    [nav.topViewController showHUD];
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.model.is_likes.intValue?@"0":@"1" forKey:@"likesType"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/barrage/%@",self.model.danmuId] Accept:@"application/vnd.shengxi.v4.9.7+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self.model.is_likes = self.model.is_likes.intValue?@"0":@"1";
            if (self.model.is_likes.intValue) {
                self.likeImage.image = UIImageNamed(@"Image_likeDMsy");
                self.model.barrage_likes = [NSString stringWithFormat:@"%d",self.model.barrage_likes.intValue+1];
            }else{
                if (self.model.barrage_likes.intValue == 1) {
                    self.model.barrage_likes = @"0";
                }else{
                   self.model.barrage_likes = [NSString stringWithFormat:@"%d",self.model.barrage_likes.intValue-1];
                }
                self.likeImage.image = UIImageNamed(@"Image_likeDMs");
            }
            self.likeL.text = self.model.barrage_likes.integerValue?self.model.barrage_likes:@"0";
            
            if ([self.model.userM.userId isEqualToString:[NoticeTools getuserId]]) {
                self.likeImage.frame = CGRectMake(self.backView.frame.origin.x-8-20,15+(self.backView.frame.size.height-20-(self.model.barrage_likes.intValue?17:0))/2, 20, 20);
            }else{
                self.likeImage.frame = CGRectMake(CGRectGetMaxX(self.backView.frame)+8,15+(self.backView.frame.size.height-20-(self.model.barrage_likes.intValue?17:0))/2, 20, 20);
            }
            self.likeL.hidden = self.model.barrage_likes.intValue?NO:YES;
            self.likeL.frame = CGRectMake(self.likeImage.frame.origin.x-8, CGRectGetMaxY(self.likeImage.frame),36, 17);
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
