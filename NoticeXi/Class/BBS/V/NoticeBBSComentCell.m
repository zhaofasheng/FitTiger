//
//  NoticeBBSComentCell.m
//  NoticeXi
//
//  Created by li lei on 2020/11/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSComentCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMineViewController.h"
#import "NoticeOtherUserInfoViewController.h"
#import "NoticeXi-Swift.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeBBSComentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15,35,35)];
        _iconImageView.layer.cornerRadius = 35/2;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        _iconImageView.image = [UIImage imageNamed:@"Image_jynohe"];
        
        UIView *_mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,35,35)];
        _mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_iconImageView addSubview:_mbView];
        _mbView.layer.cornerRadius = 35/2;
        _mbView.layer.masksToBounds = YES;
        _mbView.hidden = [NoticeTools isWhiteTheme]?YES:NO;
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 16, 160, 20)];
        _nickNameL.font = FOURTHTEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:_nickNameL];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+6, 160, 12)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [self.contentView addSubview:_timeL];
        
        self.textContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_iconImageView.frame)+15, DR_SCREEN_WIDTH-15-10-15-35,0)];
        self.textContentLabel.numberOfLines = 0;
        self.textContentLabel.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.textContentLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.textContentLabel];
        
        self.likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-60-15, 22.5,20,20)];
        self.likeImageView.image = UIImageNamed(@"Image_bbslike_b");
        [self.contentView addSubview:self.likeImageView];
        
        self.likeNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeImageView.frame)+2, 22.5, 50,20)];
        self.likeNum.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        self.likeNum.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.likeNum];
        
        UIView *tapLkieView = [[UIView alloc] initWithFrame:CGRectMake(self.likeImageView.frame.origin.x, 20, 15+4+50, 25)];
        tapLkieView.userInteractionEnabled = YES;
        UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap)];
        [tapLkieView addGestureRecognizer:likeTap];
        [self.contentView addSubview:tapLkieView];
        tapLkieView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        self.tapLikeV = tapLkieView;
        
        self.replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.likeImageView.frame.origin.x-35, 20, 25, 25)];
        [self.replyBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        self.replyBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:self.replyBtn];
        //self.replyBtn.hidden = YES;
        [self.replyBtn addTarget:self action:@selector(replyClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.replyView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, CGRectGetMaxY(self.textContentLabel.frame)+10, DR_SCREEN_WIDTH-75, 0)];
        self.replyView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.replyView.layer.cornerRadius = 3;
        self.replyView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.replyView];
        self.replyView.hidden = YES;
        self.replyView.userInteractionEnabled = YES;
        
        self.subComName1L = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,self.replyView.frame.size.width-20, 0)];
        self.subComName1L.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.subComName1L.font = FOURTHTEENTEXTFONTSIZE;
        [self.replyView addSubview:self.subComName1L];
        
        self.subComName2L = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.subComName1L.frame)+10,self.replyView.frame.size.width-20, 0)];
        self.subComName2L.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.subComName2L.font = THRETEENTEXTFONTSIZE;
        [self.replyView addSubview:self.subComName2L];
        
        self.moreSubComBtn = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.subComName2L.frame), DR_SCREEN_WIDTH-115, 30)];
        self.moreSubComBtn.font = THRETEENTEXTFONTSIZE;
        self.moreSubComBtn.textColor = [NoticeTools getWhiteColor:@"#9D6A54" NightColor:@"#6B493A"];
        [self.replyView addSubview:self.moreSubComBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:appdel.backImg?0:1];
        [self.contentView addSubview:line];
        self.line = line;
        
        UILongPressGestureRecognizer *longPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT.minimumPressDuration = 0.5;
        [self.contentView addGestureRecognizer:longPressDeleT];
    }
    return self;
}

- (void)deleTapT1:(UILongPressGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan){
        NSString *str = [self.pyCommentM.replyM.userInfo.userId isEqualToString:[NoticeTools getuserId]]?[NoticeTools getLocalStrWith:@"groupManager.del"]:[NoticeTools getLocalStrWith:@"chat.jubao"];
        if ([NoticeTools isManager]) {
            str = @"管理删除回复";
        }
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[str]];
        self.subSheet = sheet;
        sheet.delegate = self;
        [sheet show];
    }
}

- (void)deleTapT:(UILongPressGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
   
        if (self.pyCommentM) {
         
            NSArray *arr = nil;
            if ([self.pyCommentM.userInfo.userId isEqualToString:[NoticeTools getuserId]]) {//自己的留言  删除
                arr = @[[NoticeTools getLocalStrWith:@"groupManager.del"]];
            }else{
                if (self.isSelfPy){//不是自己的留言，但是是自己的配音
                    arr = @[[NoticeTools getLocalStrWith:@"chat.jubao"],[NoticeTools getLocalStrWith:@"groupManager.del"]];
                }else{
                    arr = @[[NoticeTools getLocalStrWith:@"chat.jubao"]];
                }
            }
            if ([NoticeTools isManager]) {
                arr = @[@"管理员删除"];
            }
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            } otherButtonTitleArray:arr];
            sheet.delegate = self;
            [sheet show];
            return;
        }
    }
}

- (void)deletePyComment{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];

    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"dubbingComment/%@",self.pyCommentM.commentId] Accept:@"application/vnd.shengxi.v4.8.1+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if (self.deleteBlock) {
                self.deleteBlock(self.pyCommentM);
            }
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)deleteSubPyReply{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];

    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"dubbingComment/%@",self.pyCommentM.replyM.commentId] Accept:@"application/vnd.shengxi.v4.8.1+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self.pyCommentM.reply = nil;
            self.pyCommentM.replyM = nil;
            if (self.deleteReplyBlock) {
                self.deleteReplyBlock(self.pyCommentM);
            }
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (self.pyCommentM) {
        if (actionSheet == self.subSheet) {//长按的是回复
            if (buttonIndex == 1) {
                if ([NoticeTools isManager]) {
                    self.magager.type = @"管理员删除回复";
                    [self.magager show];
                    return;
                }
                if ([self.pyCommentM.replyM.userInfo.userId isEqualToString:[NoticeTools getuserId]]) {//自己的回复，删除
                    
                    __weak typeof(self) weakSelf = self;
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"py.issueredel"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                    alerView.resultIndex = ^(NSInteger index) {
                        if (index == 1) {
                            [weakSelf deleteSubPyReply];
                        }
                    };
                    [alerView showXLAlertView];
                }else{//别人的回复是举报
                    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
                    juBaoView.reouceId = self.pyCommentM.replyM.commentId;
                    juBaoView.reouceType = @"132";
                    [juBaoView showView];
                }
            }
            return;
        }
        
        if (buttonIndex == 1) {
            if ([NoticeTools isManager]) {
                self.magager.type = @"管理员删除";
                [self.magager show];
                return;
            }
        }
        
        if ([self.pyCommentM.userInfo.userId isEqualToString:[NoticeTools getuserId]]) {//自己的留言  删除
            //arr = @[[NoticeTools getLocalStrWith:@"groupManager.del"]];
            if (buttonIndex == 1) {
                __weak typeof(self) weakSelf = self;
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"py.issueredel"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 1) {
                        [weakSelf deletePyComment];
                    }
                };
                [alerView showXLAlertView];
                
            }
        }else{
            if (self.isSelfPy){//不是自己的留言，但是是自己的配音
                // arr = @[[NoticeTools getLocalStrWith:@"chat.jubao"],[NoticeTools getLocalStrWith:@"groupManager.del"]];
                if (buttonIndex == 1) {
                    [self jubao];
                }else if (buttonIndex == 2){
                    __weak typeof(self) weakSelf = self;
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"py.issueredel"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                    alerView.resultIndex = ^(NSInteger index) {
                        if (index == 1) {
                            [weakSelf deletePyComment];
                        }
                    };
                    [alerView showXLAlertView];
                }
            }else{
                if (buttonIndex == 1) {
                    [self jubao];
                }
            }
        }
        return;
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
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/dubbingComment/%@",[self.magager.type isEqualToString:@"管理员删除"]?self.pyCommentM.commentId:self.pyCommentM.replyM.commentId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        [self.magager removeFromSuperview];
        if (success) {
            
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)jubao{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    if (self.pyCommentM) {
        juBaoView.reouceId = self.pyCommentM.commentId;
        juBaoView.reouceType = @"131";
    }else{
        juBaoView.reouceId = self.commentM?self.commentM.commentId: self.subComModel.commentId;
        juBaoView.reouceType = @"130";
    }

    [juBaoView showView];
}

//留言留言
- (void)replyClick{
    if (self.pyCommentM) {
        return;
    }

}

- (void)likeTap{
    if (self.pyCommentM) {
        [self pyZan];
        return;
    }

}

- (void)pyZan{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.pyCommentM.zan_id.intValue) {//已点赞，就是取消点赞
        [nav.topViewController showHUD];
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"dubbingCommentZan/%@",self.pyCommentM.zan_id] Accept:@"application/vnd.shengxi.v4.8.1+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                self.pyCommentM.zan_id = @"0";
                self.pyCommentM.zaned_num = [NSString stringWithFormat:@"%d",self.pyCommentM.zaned_num.intValue-1];
                self.likeImageView.image = self.pyCommentM.zan_id.intValue?UIImageNamed(@"Image_bbslike_y"):UIImageNamed(@"Image_bbslike_b");
                self.likeNum.text = [NSString stringWithFormat:@"%d",self.pyCommentM.zaned_num.intValue];
                self.likeNum.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            }
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];

    }else{
        [nav.topViewController showHUD];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.pyCommentM.commentId forKey:@"commentId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"dubbingCommentZan" Accept:@"application/vnd.shengxi.v4.8.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                NoticeMJIDModel *idM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
                self.pyCommentM.zan_id = idM.allId;
                self.pyCommentM.zaned_num = [NSString stringWithFormat:@"%d",self.pyCommentM.zaned_num.intValue+1];
                self.likeImageView.image = self.pyCommentM.zan_id.intValue?UIImageNamed(@"Image_bbslike_y"):UIImageNamed(@"Image_bbslike_b");
                self.likeNum.text = [NSString stringWithFormat:@"%d",self.pyCommentM.zaned_num.intValue];
                self.likeNum.textColor = [UIColor colorWithHexString:@"#0099E6"];
            }
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
    }
}

- (void)setPyCommentM:(NoticeBBSComent *)pyCommentM{
    _pyCommentM = pyCommentM;
    

    self.textContentLabel.attributedText = pyCommentM.allTextAttStr;
    self.textContentLabel.numberOfLines = 0;
    self.textContentLabel.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+5, DR_SCREEN_WIDTH-57-20,pyCommentM.textHeight);
    
    [self.replyBtn setTitle:[NoticeTools getLocalType] == 1?@"Reply":@"回复" forState:UIControlStateNormal];
    self.replyBtn.enabled = NO;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:pyCommentM.userInfo.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
    self.timeL.text = pyCommentM.created_at;
    self.timeL.frame = CGRectMake(_nickNameL.frame.origin.x, CGRectGetMaxY(self.textContentLabel.frame)+10, 160, 17);
    self.nickNameL.text = pyCommentM.userInfo.nick_name;
    
    self.likeImageView.image = pyCommentM.zan_id.intValue?UIImageNamed(@"Image_bbslike_y"):UIImageNamed(@"Image_bbslike_b");
    self.likeNum.text = [NSString stringWithFormat:@"%d",pyCommentM.zaned_num.intValue];
    self.likeNum.textColor = [UIColor colorWithHexString:pyCommentM.zan_id.integerValue? @"#0099E6":@"#8A8F99"];
    
    self.replyBtn.frame = CGRectMake(DR_SCREEN_WIDTH-22-50, self.nickNameL.frame.origin.y, 50, 20);
    [self.replyBtn setTitle:[NoticeTools getLocalType] == 1?@"Reply":@"回复" forState:UIControlStateNormal];
    [self.replyBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
    self.replyBtn.hidden = YES;
    
    self.likeImageView.frame = CGRectMake(DR_SCREEN_WIDTH-24-37,self.timeL.frame.origin.y-3.5,24,24);
    self.likeNum.frame =  CGRectMake(CGRectGetMaxX(self.likeImageView.frame)+2,self.likeImageView.frame.origin.y,37,24);
    self.tapLikeV.frame = CGRectMake(self.likeImageView.frame.origin.x,self.likeImageView.frame.origin.y, 15+4+50, 25);
    
    if (!pyCommentM.reply && self.isSelfPy) {
        self.replyBtn.hidden = NO;
    }else{
        self.replyBtn.hidden = YES;
        
    }
    
    if (pyCommentM.reply || pyCommentM.replyM) {
        self.replyBackView.hidden = NO;
        self.replyBackView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(self.timeL.frame)+10, DR_SCREEN_WIDTH-15-10-15-35,30+pyCommentM.replyM.replyTextHeight);
        
        self.replyNickNameL.text = pyCommentM.replyM.userInfo.nick_name;
        self.replyNickNameL.frame = CGRectMake(5, 0, self.replyBackView.frame.size.width-5, 15);
        
        self.replyL.frame = CGRectMake(5,20,DR_SCREEN_WIDTH-15-10-15-35-5,pyCommentM.replyM.replyTextHeight);
        self.replyL.attributedText = pyCommentM.replyM.allTextAttStr;
        self.replyL.numberOfLines = 0;
        
        self.sLine.frame = CGRectMake(0, 0, 0.5, self.replyBackView.frame.size.height-10);
        self.line.frame = CGRectMake(self.textContentLabel.frame.origin.x, CGRectGetMaxY(self.replyBackView.frame)+5,DR_SCREEN_WIDTH-15-10-15-35, 0.5);
    }else{
        self.replyBackView.hidden = YES;
        self.line.frame = CGRectMake(self.textContentLabel.frame.origin.x, CGRectGetMaxY(self.timeL.frame)+10,DR_SCREEN_WIDTH-15-10-15-35, 0.5);
    }
}


- (UILabel *)replyL{
    if (!_replyL) {
        _replyL = [[UILabel alloc] init];
        _replyL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _replyL.font = FOURTHTEENTEXTFONTSIZE;
        _replyL.numberOfLines = 0;
        [self.replyBackView addSubview:_replyL];
    }
    return _replyL;
}

- (UILabel *)replyNickNameL{
    if (!_replyNickNameL) {
        _replyNickNameL = [[UILabel alloc] init];
        _replyNickNameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _replyNickNameL.font = FOURTHTEENTEXTFONTSIZE;
        [self.replyBackView addSubview:_replyNickNameL];
    }
    return _replyNickNameL;
}

- (UIView *)sLine{
    if (!_sLine) {
        _sLine = [[UIView alloc] init];
        _sLine.backgroundColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        [self.replyBackView addSubview:_sLine];
    }
    return _sLine;
}

- (UIView *)replyBackView{
    if (!_replyBackView) {
        _replyBackView = [[UIView alloc] init];
        
        _replyBackView.backgroundColor = self.backgroundColor;
        [self.contentView addSubview:_replyBackView];
        _replyBackView.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT1:)];
        longPressDeleT.minimumPressDuration = 0.5;
        [_replyBackView addGestureRecognizer:longPressDeleT];
    }
    return _replyBackView;
}

- (void)userInfoTap{
    if (self.hideBlock) {
        self.hideBlock(YES);
    }
    if (self.pyCommentM){

        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        if (![self.pyCommentM.from_user_id isEqualToString:[NoticeTools getuserId]]) {
            ctl.isOther = YES;
            ctl.userId = self.pyCommentM.from_user_id;
        }
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
      
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
