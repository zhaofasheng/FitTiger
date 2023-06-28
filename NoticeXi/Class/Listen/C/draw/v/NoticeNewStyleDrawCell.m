//
//  NoticeNewStyleDrawCell.m
//  NoticeXi
//
//  Created by li lei on 2020/6/2.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewStyleDrawCell.h"
#import "NoticeTuYaChatController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMyFriendViewController.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMineViewController.h"
#import "NoticeDrawTopicListController.h"
#import "NoticeXi-Swift.h"
#import "NoticeDrawViewController.h"
#import "NoticeTuYaChatWithOtherController.h"
#import "NoticeDrawShowListController.h"
#import "NoticeMySelfDrawController.h"
#import "NoticeCarePeopleController.h"
#import "NoticeBingGanListView.h"
@implementation NoticeNewStyleDrawCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 124+DR_SCREEN_WIDTH-70)];
        backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.08];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        backView.userInteractionEnabled = YES;
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 42, 42)];
        [backView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,15, 38, 38)];
        self.iconImageView.layer.cornerRadius = 38/2;
        self.iconImageView.layer.masksToBounds = YES;
        _iconImageView.image = UIImageNamed(@"Image_jynohe");
        [backView addSubview:self.iconImageView];
        
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];

        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10,15, backView.frame.size.width-34-10-CGRectGetMaxX(self.iconImageView.frame), 22)];
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.nickNameL.font = SIXTEENTEXTFONTSIZE;
        self.nickNameL.text = @"小二";
        [backView addSubview:self.nickNameL];
        
        self.lelveImageView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nickNameL.frame)+2, 15, 46, 21)];
        [backView addSubview:self.lelveImageView];
                
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(self.nickNameL.frame.origin.x, CGRectGetMaxY(self.nickNameL.frame)+11,GET_STRWIDTH(@"昨天14点11分", 11, 14), 14)];
        self.timeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        self.timeL.text = @"昨天14点11分";
        self.timeL.font = [UIFont systemFontOfSize:11];
        [backView addSubview:self.timeL];
        
        self.drawImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,70,backView.frame.size.width-30, backView.frame.size.width-30)];
        self.drawImageView.image = UIImageNamed(@"img_empty_img");
        [backView addSubview:self.drawImageView];
        self.drawImageView.layer.cornerRadius = 16;
        self.drawImageView.layer.masksToBounds = YES;
        self.drawImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biglook)];
        [self.drawImageView addGestureRecognizer:tapb];
        
        self.topicL = [[UILabel alloc] initWithFrame:CGRectMake(6,self.drawImageView.frame.size.height-6-24,GET_STRWIDTH(@"测试测试", 11, 11), 24)];
        self.topicL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.topicL.font = [UIFont systemFontOfSize:11];
        self.topicL.text = @"#测试#";
        self.topicL.layer.cornerRadius = 12;
        self.topicL.layer.masksToBounds = YES;
        self.topicL.textAlignment = NSTextAlignmentCenter;
        self.topicL.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.2];
        [self.drawImageView addSubview:self.topicL];
        self.topicL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTap)];
        [self.topicL addGestureRecognizer:tTap];
                
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawImageView.frame),backView.frame.size.width,54)];
        self.buttonView.userInteractionEnabled = YES;
        [backView addSubview:self.buttonView];
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15,15,24,24)];
        imageView1.image = UIImageNamed(@"Imagedrawlike");
        _firstImageView = imageView1;
        [self.buttonView addSubview:imageView1];
        
        _firstL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+3,0,50+30, 54)];
        _firstL.font = TWOTEXTFONTSIZE;
        _firstL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _firstL.text = [NoticeTools getLocalStrWith:@"py.bg"];
        [self.buttonView addSubview:_firstL];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width-204,15,24,24)];
        imageView2.image = UIImageNamed(@"Image_tuya_b");
        _firstImageView1 = imageView2;
        [self.buttonView addSubview:imageView2];
        
        _firstL1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView2.frame)+3,0,37,54)];
        _firstL1.font = TWOTEXTFONTSIZE;
        _firstL1.text = [NoticeTools getLocalStrWith:@"em.tuya"];
        _firstL1.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        [self.buttonView addSubview:_firstL1];
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_firstL1.frame)+2,15,24, 24)];
        imageView3.image = UIImageNamed(@"Image_sharehuahua");
        _thirdImageView = imageView3;
        [self.buttonView addSubview:imageView3];
        
        UILabel *shareL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView3.frame)+3,0, 37, 54)];
        shareL.text = [NoticeTools getLocalStrWith:@"py.share"];
        shareL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        shareL.font = TWOTEXTFONTSIZE;
        [self.buttonView addSubview:shareL];
        
        self.scImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shareL.frame)+2, 15, 24, 24)];
        self.scImageView.image = UIImageNamed(@"Image_pyshoucang");
        [self.buttonView addSubview:self.scImageView];
        
        UILabel *collL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.scImageView.frame)+3,0, 37, 54)];
        collL.text = [NoticeTools getLocalStrWith:@"emtion.sc"];
        collL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        collL.font = TWOTEXTFONTSIZE;
        [self.buttonView addSubview:collL];
        self.scL = collL;
        
        for (int i = 0; i < 4; i++) {
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(55*i,0,55, 54)];
            if (i == 1) {
                tapView.frame = CGRectMake(imageView2.frame.origin.x, 0, 55, 54);
            }
            if (i == 2) {
                tapView.frame = CGRectMake(imageView3.frame.origin.x, 0, 55, 54);
            }
            if (i == 3) {
                tapView.frame = CGRectMake(self.scImageView.frame.origin.x, 0, 55, 54);
            }
            tapView.userInteractionEnabled = YES;
            tapView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapV:)];
            [tapView addGestureRecognizer:tap];
            [self.buttonView addSubview:tapView];
    
        }
        
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(backView.frame.size.width-10-24, 15, 24, 24)];
        [moreBtn setBackgroundImage:UIImageNamed(@"Image_moreNew") forState:UIControlStateNormal];
        [backView addSubview:moreBtn];
        [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.pickerL = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.origin.x, backView.frame.origin.y-3, 23, 14)];
        self.pickerL.layer.cornerRadius = 3;
        self.pickerL.layer.masksToBounds = YES;
        self.pickerL.backgroundColor = [UIColor colorWithHexString:@"#A361F2"];
        self.pickerL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.pickerL.font = [UIFont systemFontOfSize:9];
        self.pickerL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.pickerL];
        self.pickerL.text = @"Pick";
        self.pickerL.hidden = YES;
    }
    return self;
}

- (void)tapV:(UITapGestureRecognizer *)tap{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    UIView *tapV = (UIView *)tap.view;
    if (tapV.tag == 1) {
        if (!_drawM.isSelf) {
            if (!_drawM.graffiti_switch.intValue) {
                [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"hh.henotuy"]];
                return;
            }else{
                if (_drawM.dialog_num.intValue) {//有对话
                    NoticeTuYaChatWithOtherController *ctl = [[NoticeTuYaChatWithOtherController alloc] init];
                    ctl.curentDraw = _drawM;
                    ctl.toUserId = _drawM.user_id;
                    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
                    return;
                }
                NoticeDrawViewController *ctl = [[NoticeDrawViewController alloc] init];
                ctl.tuyeImage = self.drawImageView.image;
                ctl.drawId = _drawM.drawId;
                ctl.isTuYa = YES;
                ctl.isFromDrawList = YES;
                ctl.userId = _drawM.user_id;
                if (_drawM.topic_name) {
                    NoticeTopicModel *topM = [[NoticeTopicModel alloc] init];
                    topM.topic_id = _drawM.topic_id;
                    topM.topic_name = _drawM.topic_name;
                    ctl.topicM = topM;
                }
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
                return;
            }
        }
        if (!_drawM.chat_num.intValue) {
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"hh.havenotuya"]];
            return;
        }
        NoticeTuYaChatController *ctl = [[NoticeTuYaChatController alloc] init];
        ctl.drawId = _drawM.drawId;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }else if (tapV.tag == 0){//点赞和取消点赞
        tapV.userInteractionEnabled = NO;
        if (_drawM.isSelf) {//如果是自己的画
            tapV.userInteractionEnabled = YES;
            if (!_drawM.publicly_like_num.intValue) {
                [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.noBg"]];
                return;
            }
            NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            listView.drawM = self.drawM;
            [listView showTost];
            return;
        }
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:@"2" forKey:@"likeType"];
        if (_drawM.like_type.intValue == 2) {
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/artworkLike/%@",_drawM.user_id,_drawM.drawId] Accept:@"application/vnd.shengxi.v3.6+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                tapV.userInteractionEnabled = YES;
                if (success) {
                    self->_drawM.like_type = @"0";
                    self->_drawM.publicly_like_num =  [NSString stringWithFormat:@"%d",self->_drawM.publicly_like_num.intValue-1];
                    if (self->_drawM.publicly_like_num.intValue) {
                        self->_firstL.text = self->_drawM.publicly_like_num;
                    }else{
                        self->_firstL.text = [NoticeTools getLocalStrWith:@"py.bg"];
                    }
                    self->_firstImageView.image = UIImageNamed([self->_drawM.like_type isEqualToString:@"2"]?@"Imagedrawlikes":@"Imagedrawlike");
                }
            } fail:^(NSError * _Nullable error) {
                tapV.userInteractionEnabled = YES;
            }];
        }else{
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/artworkLike/%@",_drawM.user_id,_drawM.drawId] Accept:@"application/vnd.shengxi.v3.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                tapV.userInteractionEnabled = YES;
                if (success) {
                    self->_drawM.like_type = @"2";
                    self->_drawM.publicly_like_num =  [NSString stringWithFormat:@"%d",self->_drawM.publicly_like_num.intValue+1];
                    if (self->_drawM.publicly_like_num.intValue) {
                        self->_firstL.text = self->_drawM.publicly_like_num;
                    }else{
                        self->_firstL.text = [NoticeTools getLocalStrWith:@"py.bg"];
                    }
                    self->_firstImageView.image = UIImageNamed([self->_drawM.like_type isEqualToString:@"2"]?@"Imagedrawlikes":@"Imagedrawlike");
                }
            } fail:^(NSError * _Nullable error) {
                tapV.userInteractionEnabled = YES;
            }];
        }
    }else if (tapV.tag == 2){
        [nav.topViewController showToastWithText:@"历史功能不能使用"];
    }
    else if (tapV.tag == 3){
        if (_drawM.isSelf) {
            if (_drawM.like_num.intValue) {
                NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
                listView.scDrawM = self.drawM;
                [listView showTost];
                return;
            }
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.nocol"]];
            return;
        }
        [nav.topViewController showHUD];
        __weak typeof(self) weakSelf = self;
        if (_drawM.collection_id && _drawM.collection_id.length) {
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"artworkCollection/%@",_drawM.collection_id] Accept:@"application/vnd.shengxi.v4.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [nav.topViewController hideHUD];
                if (success) {
                    weakSelf.drawM.collection_id = @"";
                    weakSelf.scImageView.image = UIImageNamed(@"Image_pyshoucang");
                }
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
        }else{
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:_drawM.drawId forKey:@"artworkId"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"artworkCollection" Accept:@"application/vnd.shengxi.v4.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [nav.topViewController hideHUD];
                if (success) {
                    weakSelf.drawM.collection_id = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                    weakSelf.scImageView.image = UIImageNamed(@"Image_pyshoucangy");
                }
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
        }
    }
}

- (void)moreClick{
    if ([NoticeTools isManager]) {
        [self managerTap];
        return;
    }
    if (_drawM.isSelf) {//如果是自己的作品
        NSString *str = _drawM.graffiti_switch.integerValue?[NoticeTools getLocalStrWith:@"hh.cannottuy"]:[NoticeTools getLocalStrWith:@"hh.cantuya"];
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 3) {
                LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
                    if (buttonIndex1 == 2) {
                        [self deleteDraw];
                    }
                } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"hh.sczuopin"],[NoticeTools getLocalStrWith:@"groupManager.del"]]];
                [sheet1 show];
            }else if (buttonIndex == 2){
                [self senImagView:nil];
            }
        } otherButtonTitleArray:@[str,[NoticeTools getLocalStrWith:@"hh.givetolike"],[NoticeTools getLocalStrWith:@"groupManager.del"]]];
        sheet.delegate = self;
        [sheet show];
    }else{
        [self jubao];
    }
}

//管理员操作
- (void)managerTap{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[@"删除作品",@"设为仅作者可见",@"查看作者封面",_drawM.top_id.intValue?@"取消今日推荐": @"设为今日推荐"]];
    sheet.delegate = self;
    self.isManagerSheet = sheet;
    [sheet show];
}

- (void)jubao{//举报
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {

    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.jubao"]]];
    sheet.delegate = self;
    [sheet show];
}

- (void)deleteDraw{//删除自己的作品
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/artwork/%@",_drawM.user_id,_drawM.drawId] Accept:@"application/vnd.shengxi.v3.6+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteNewDrawSucessWith:)]) {
                [self.delegate deleteNewDrawSucessWith:self.index];
            }
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.isManagerSheet) {
        if (buttonIndex == 1){
             self.magager.type = @"删除作品";
             [self.magager show];
         }else if (buttonIndex == 2){
             self.magager.type = @"设为仅作者可见";
             [self.magager show];
         }else if (buttonIndex == 3){
             self.magager.type = @"查看作者封面";
             [self.magager show];
         }else if (buttonIndex == 4){
             self.magager.type =_drawM.top_id.intValue?@"取消今日推荐": @"设为今日推荐";
             [self.magager show];
         }  else if (buttonIndex == 5){
             NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
             juBaoView.reouceId = _drawM.drawId;
             juBaoView.reouceType = @"5";
             [juBaoView showView];
         }
        return;
    }
    if (_drawM.isSelf) {//自己的作品
        if (buttonIndex == 1) {
            [self setTUYE];
        }
        return;
    }else{
        if (buttonIndex == 1) {
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = _drawM.drawId;
            juBaoView.reouceType = @"5";
            [juBaoView showView];
            
        }
    }
}

- (void)sureManagerClick:(NSString *)code{

    if ([self.magager.type isEqualToString:@"删除作品"]) {
        [self managerDeleteWith:code];
    }else if ([self.magager.type isEqualToString:@"设为仅作者可见"]){
        [self setOnlySelfWith:code];
    }else if ([self.magager.type isEqualToString:@"查看作者封面"]){
        [self mangaerLookUserWith:code];
    }else if ([self.magager.type isEqualToString:@"设为今日推荐"]){
        [self setTodayHot:code];
    }else if ([self.magager.type isEqualToString:@"取消今日推荐"]){
        [self setTodayUp:code isUp:YES];
    }

}

- (void)setTodayHot:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"artworks/%@/pick",_drawM.drawId] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            NoticeClockPyModel *pickM = [NoticeClockPyModel mj_objectWithKeyValues:dict[@"data"]];
            if (pickM.top_status.intValue == 0) {
                [self setTodayUp:code isUp:NO];
            }else if (pickM.top_status.intValue == 1){
                [self setTodayUp:code isUp:YES];
            }else if (pickM.top_status.intValue == 2 || pickM.top_status.intValue == 3){
                [self.magager removeFromSuperview];
                LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"作品曾被推荐过，确定再次推荐？" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self setTodayUp:code isUp:NO];
                    }
                } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"main.sure"]]];
                [sheet show];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)setTodayUp:(NSString *)code isUp:(BOOL)isUp{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    [parm setObject:isUp?@"0": [NSString stringWithFormat:@"%.f",currentTime] forKey:@"topAt"];

    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/artwork/%@",_drawM.drawId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            self->_drawM.top_id = isUp?@"0": [NSString stringWithFormat:@"%.f",currentTime];
            [nav.topViewController showToastWithText:@"操作已执行"];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

//管理员删除作品
- (void)managerDeleteWith:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/artwork/%@",_drawM.drawId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [nav.topViewController showToastWithText:@"操作已执行"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteNewDrawSucessWith:)]) {
                [self.delegate deleteNewDrawSucessWith:self.index];
            }
            [self.magager removeFromSuperview];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
  
}

//管理员设置仅作者可见
- (void)setOnlySelfWith:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [parm setObject:@"1" forKey:@"isHidden"];

    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/artwork/%@",_drawM.drawId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            [nav.topViewController showToastWithText:@"操作已执行"];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)mangaerLookUserWith:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/users/login" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
            ctl.userId = self->_drawM.user_id;
            ctl.isOther = YES;
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)setTUYE{//设置是否可以涂鸦
    if (_drawM.graffiti_switch.integerValue) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.surejinzhi"]:@"確定禁止塗鴉嗎?" message:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.jinzhitosat" ]:@"如果當前作品下有塗鴉，也會壹並刪除" sureBtn:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"main.sure"]:@"確定" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [self setNotuye];
            }
        };
        [alerView showXLAlertView];
    }else{
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.changtuya"]:@"當前禁止塗鴉，是否改為允許塗鴉?" sureBtn:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"main.sure"]:@"確定" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [self setNotuye];
            }
        };
        [alerView showXLAlertView];
    }
}

- (void)setNotuye{//设置是否可以涂鸦
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (_drawM.graffiti_switch.integerValue) {
        [parm setObject:@"0" forKey:@"graffitiSwitch"];
    }else{
        [parm setObject:@"1" forKey:@"graffitiSwitch"];
    }
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/artwork/%@",_drawM.user_id,_drawM.drawId] Accept:@"application/vnd.shengxi.v3.6+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
         [nav.topViewController hideHUD];
        if (success) {
            self->_drawM.chat_num = @"0";
            self->_drawM.graffiti_switch = self->_drawM.graffiti_switch.integerValue? @"0":@"1";
            [nav.topViewController showToastWithText:!self->_drawM.graffiti_switch.integerValue?[NoticeTools getLocalStrWith:@"hh.ccan"]:[NoticeTools getLocalStrWith:@"hh.cno"]];
            
        }
    } fail:^(NSError *error) {
         [nav.topViewController hideHUD];
    }];
}

- (void)biglook{

    YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];
    item.thumbView = _drawImageView;
    item.largeImageURL = [NSURL URLWithString:@""];
    NSArray *arr = @[item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    photoView.isSendToFriend = _drawM.isSelf? YES:NO;
    __weak typeof(self) weakSelf = self;
    photoView.sendToFriendBlock = ^(BOOL send, UIImage *sendImage) {
        [weakSelf senImagView:sendImage];
    };
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [photoView presentFromImageView:_drawImageView toContainer:toView animated:YES completion:nil];
}

- (void)senImagView:(UIImage *)image{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/admires?type=3",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in dict[@"data"]) {
                [arr addObject:dic];
            }
            if (arr.count) {
                NoticeCarePeopleController *ctl = [[NoticeCarePeopleController alloc] init];
                ctl.isLikeEachOther = YES;
                ctl.resourceId = self.drawM.drawId;
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            }else{
                [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"hh.nolike"]];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)setDrawM:(NoticeDrawList *)drawM{
    _drawM = drawM;
    _firstL1.hidden = NO;
    _firstImageView1.hidden = NO;
    if ([_drawM.is_private isEqualToString:@"1"]) {

        _iconImageView.image = [UIImage imageNamed:@"Image_jynohe"];
    }else{
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_drawM.avatar_url]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageRefreshCached];
    }
    self.pickerL.hidden = drawM.isPick?NO:YES;

    if ([_drawM.user_id isEqualToString:@"1"]) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_guanfang_b":@"Image_guanfang_y");
    }
    
    _nickNameL.text = _drawM.is_private.intValue?[NoticeTools getLocalStrWith:@"hh.niminghuajia"]: _drawM.nick_name;
    _timeL.text = _drawM.created_at;
    self.topicL.text = _drawM.topName;
    self.timeL.frame = CGRectMake(self.nickNameL.frame.origin.x, CGRectGetMaxY(self.nickNameL.frame)+6,GET_STRWIDTH(_drawM.created_at, 11, 11), 11);
    
    if (!_drawM.topName) {
        self.topicL.hidden = YES;
    }else{
        self.topicL.hidden = NO;
    }
    self.topicL.frame = CGRectMake(6,self.drawImageView.frame.size.height-6-24,GET_STRWIDTH(self.topicL.text, 11, 11)+10, 24);
    
    [self.drawImageView sd_setImageWithURL:[NSURL URLWithString:_drawM.artwork_url] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    _firstL.text = _drawM.publicly_like_num.intValue?_drawM.publicly_like_num:[NoticeTools getLocalStrWith:@"py.bg"];
    if (_drawM.isSelf) {
        
        _firstImageView.image = UIImageNamed(@"Imagedrawlike");
        _firstL1.text = _drawM.chat_num.intValue ? _drawM.chat_num : [NoticeTools getLocalStrWith:@"em.tuya"];
        self.scImageView.image = UIImageNamed(@"Image_pyshoucang");
        self.scL.text = _drawM.like_num.intValue?_drawM.like_num:[NoticeTools getLocalStrWith:@"emtion.sc"];
    }else{
        _firstImageView.image = UIImageNamed([drawM.like_type isEqualToString:@"2"]?@"Imagedrawlikes":@"Imagedrawlike");
        _firstL1.text = _drawM.dialog_num.intValue ? _drawM.dialog_num : [NoticeTools getLocalStrWith:@"em.tuya"];
        self.scImageView.image = UIImageNamed(_drawM.collection_id.intValue?@"Image_pyshoucangy": @"Image_pyshoucang");
        self.scL.text = [NoticeTools getLocalStrWith:@"emtion.sc"];
    }
    if (self.type == 1) {
        self.timeL.hidden = YES;
        if (self.topicL.text.length) {
            self.nickNameL.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10,18, DR_SCREEN_WIDTH-15-66-10-CGRectGetMaxX(self.iconImageView.frame), 15);
            self.topicL.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10,CGRectGetMaxY(self.nickNameL.frame)+6,DR_SCREEN_WIDTH-CGRectGetMaxX(_timeL.frame)-15, 11);
        }else{
            self.nickNameL.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10,self.iconImageView.frame.origin.y, DR_SCREEN_WIDTH-15-66-10-CGRectGetMaxX(self.iconImageView.frame),self.iconImageView.frame.size.height);
        }
    }
    
    self.nickNameL.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10,15, GET_STRWIDTH(self.nickNameL.text, 16, 22), 22);
    
  
    self.lelveImageView.image = UIImageNamed(_drawM.levelImgName);
    self.iconMarkView.image = UIImageNamed(_drawM.levelImgIconName);
   
    self.lelveImageView.frame = CGRectMake(CGRectGetMaxX(_nickNameL.frame), 15+2.5, 52, 16);
}

- (void)topicTap{
    if (!_drawM.topName || self.noPushTopic) {
        return;
    }
    NoticeDrawTopicListController *ctl = [[NoticeDrawTopicListController alloc] init];
    ctl.topicName = _drawM.topic_name;
    ctl.topicId = _drawM.topic_id;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

//点击头像
- (void)userInfoTap{
    if (!self.goCenter) {
        if (_drawM.isSelf) {
            NoticeMySelfDrawController *ctl = [[NoticeMySelfDrawController alloc] init];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
            }
            return;
        }
        NoticeDrawShowListController *ctl = [[NoticeDrawShowListController alloc] init];
        ctl.listType = 5;
        ctl.userId = _drawM.user_id;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
        return;
    }
    if (_drawM.is_private.integerValue) {
        return;
    }
    if (_drawM.isSelf) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _drawM.user_id;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}
    
- (void)sendOrCollClick{

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    __weak typeof(self) weakSelf = self;
    if (!_drawM.isSelf) {
        NoticeShareGroupView *shareGroupView = [[NoticeShareGroupView alloc] initWithShareOtherDrawToGroup];
        shareGroupView.drawM = self.drawM;
        __block NoticeShareGroupView *strongBlock = shareGroupView;
        shareGroupView.clickCollectBlock = ^(BOOL collection) {
            [nav.topViewController showHUD];
            if (_drawM.collection_id && _drawM.collection_id.length) {
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"artworkCollection/%@",_drawM.collection_id] Accept:@"application/vnd.shengxi.v4.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        weakSelf.drawM.collection_id = @"";
                        strongBlock.drawM = weakSelf.drawM;
                    }
                } fail:^(NSError * _Nullable error) {
                    [nav.topViewController hideHUD];
                }];
            }else{
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:_drawM.drawId forKey:@"artworkId"];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"artworkCollection" Accept:@"application/vnd.shengxi.v4.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        weakSelf.drawM.collection_id = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                        strongBlock.drawM = weakSelf.drawM;
                    }
                } fail:^(NSError * _Nullable error) {
                    [nav.topViewController hideHUD];
                }];
            }
        };
        [shareGroupView showShareView];
 
    }else{
        NoticeShareGroupView *shareGroupView = [[NoticeShareGroupView alloc] initWithShareSelfDrawToGroup];
        shareGroupView.drawM = self.drawM;
        shareGroupView.sendImage = _drawImageView.image;
        shareGroupView.clickMoreFriendBlock = ^(BOOL more) {
            [weakSelf senImagView:_drawImageView.image];
        };
        [shareGroupView showShareView];
    }
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
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
