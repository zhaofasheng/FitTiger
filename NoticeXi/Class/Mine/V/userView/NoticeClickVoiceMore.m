//
//  NoticeClickVoiceMore.m
//  NoticeXi
//
//  Created by li lei on 2019/6/14.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeClickVoiceMore.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeZjListView.h"
#import "NoticeReEditTopicController.h"
#import "NoticeTextVoiceController.h"
#import "NoticeSayToSelfController.h"
#import "NoticeShareTostView.h"
#import "NoticeSendViewController.h"
@implementation NoticeClickVoiceMore

- (void)voiceClickMoreWith:(NoticeVoiceListModel *)model{

    self.priModel = model;
    NSArray *arr = @[model.is_top.boolValue?[NoticeTools getLocalStrWith:@"more.canzd"] :[NoticeTools getLocalStrWith:@"more.zdvocie"],[NoticeTools getLocalStrWith:@"sendTextt.reSend"],[NoticeTools getLocalStrWith:@"more.addzj"],[NoticeTools getLocalStrWith:@"py.share"],(model.is_shared.intValue || model.is_admire.intValue)?[NoticeTools getLocalStrWith:@"mineme.cancleshanre"]:[NoticeTools getLocalStrWith:@"em.gx"],[NoticeTools getLocalStrWith:@"more.saytoself"],[NoticeTools getLocalStrWith:@"groupManager.del"]];
    if (model.content_type.intValue == 2) {//文字心情
        arr = @[model.is_top.boolValue?[NoticeTools getLocalStrWith:@"more.canzd"] :[NoticeTools getLocalStrWith:@"more.zdvocie"],[NoticeTools getLocalStrWith:@"sendTextt.reSend"],[NoticeTools getLocalStrWith:@"more.addzj"],[NoticeTools getLocalStrWith:@"n.setfanwei"],[NoticeTools getLocalStrWith:@"groupManager.del"]];
        if ([model.subUserModel.userId isEqualToString:@"1"]) {
            arr = @[model.is_top.boolValue?[NoticeTools getLocalStrWith:@"more.canzd"] :[NoticeTools getLocalStrWith:@"more.zdvocie"],[NoticeTools getLocalStrWith:@"sendTextt.reSend"],[NoticeTools getLocalStrWith:@"more.addzj"],model.is_shared.intValue?[NoticeTools getLocalStrWith:@"mineme.canceltd"]:[NoticeTools getLocalStrWith:@"em.td"],[NoticeTools getLocalStrWith:@"groupManager.del"],model.topAt.intValue? @"取消置顶为小二有话说":@"置顶为小二有话说"];
        }
        if (model.is_private.boolValue) {
            arr = @[[NoticeTools getLocalStrWith:@"mineme.cancelonglyself"],[NoticeTools getLocalStrWith:@"groupManager.del"]];
        }
    }else{
        arr = @[model.is_top.boolValue?[NoticeTools getLocalStrWith:@"more.canzd"] :[NoticeTools getLocalStrWith:@"more.zdvocie"],[NoticeTools getLocalStrWith:@"sendTextt.reSend"],[NoticeTools getLocalStrWith:@"more.addzj"],[NoticeTools getLocalStrWith:@"py.share"],[NoticeTools getLocalStrWith:@"n.setfanwei"],model.note_num.intValue?[NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"more.saytoself"],model.note_num]: [NoticeTools getLocalStrWith:@"more.saytoself"],[NoticeTools getLocalStrWith:@"groupManager.del"]];
        if ([model.subUserModel.userId isEqualToString:@"1"]) {
            arr = @[model.is_top.boolValue?[NoticeTools getLocalStrWith:@"more.canzd"] :[NoticeTools getLocalStrWith:@"more.zdvocie"],[NoticeTools getLocalStrWith:@"sendTextt.reSend"],[NoticeTools getLocalStrWith:@"more.addzj"],[NoticeTools getLocalStrWith:@"n.setfanwei"],(model.is_shared.intValue || model.is_admire.intValue) ?[NoticeTools getLocalStrWith:@"mineme.cancleshanre"]:[NoticeTools getLocalStrWith:@"em.gx"],model.note_num.intValue?[NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"more.saytoself"],model.note_num]: [NoticeTools getLocalStrWith:@"more.saytoself"],[NoticeTools getLocalStrWith:@"groupManager.del"],model.topAt.intValue? @"取消置顶为小二有话说":@"置顶为小二有话说"];
        }
    }
    
    if (model.resource) {//书影音
        if (model.is_private.boolValue) {
            arr = @[[NoticeTools getLocalStrWith:@"mineme.cancelonglyself"],[NoticeTools getLocalStrWith:@"groupManager.del"],model.note_num.intValue?[NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"more.saytoself"],model.note_num]: [NoticeTools getLocalStrWith:@"more.saytoself"]];
            if (model.content_type.intValue == 2) {
                arr = @[[NoticeTools getLocalStrWith:@"mineme.cancelonglyself"],[NoticeTools getLocalStrWith:@"groupManager.del"]];
            }
        }else{
            arr = @[[NoticeTools getLocalStrWith:@"groupManager.del"],model.note_num.intValue?[NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"more.saytoself"],model.note_num]: [NoticeTools getLocalStrWith:@"more.saytoself"]];
            if (model.content_type.intValue == 2) {
                arr = @[[NoticeTools getLocalStrWith:@"groupManager.del"]];
            }
        }
    }
    
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:arr];
    self.priSheet = sheet;
    sheet.delegate = self;
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.priSheet) {
        if (self.priModel.resource) {//书影音心情
            if (self.priModel.is_private.boolValue) {
                if (buttonIndex == 1) {
                    [self cancelPri];
                }else if(buttonIndex == 2){
                    [self deleteVoice];
                }else if(buttonIndex == 3){
                    [self sayToSelf];
                }
            }else{
                if (buttonIndex == 1) {
                    [self deleteVoice];
                }else if(buttonIndex == 2){
                    if (self.priModel.content_type.intValue == 2) {
                        [self shareToGroup];
                    }else{
                        [self sayToSelf];
                    }
                    
                }else if(buttonIndex == 3){
                    [self shareToGroup];
                }
            }
            return;
        }
        
        if (self.priModel.is_private.boolValue) {
            if (buttonIndex == 1) {
                [self cancelPri];
            }else if (buttonIndex == 2){
                if (self.priModel.content_type.intValue == 1) {//语音心情
                    [self sayToSelf];
                }else{
                    [self deleteVoice];
                }
            }else if(buttonIndex == 3){
                [self deleteVoice];
            }
            return;
        }
        
        if (self.priModel.content_type.intValue ==2) {//文字心情的时候
            if (buttonIndex == 1) {
                [self topVoice];
            }else if(buttonIndex == 2){
                [self editVoice];
            }else if(buttonIndex == 3){
                [self addTozJ];
            }else if(buttonIndex == 4){
                [self shanreVoice];
            }
            else if(buttonIndex == 5){
                [self deleteVoice];
            } else if(buttonIndex == 6){
                [self setSysTop];
            }
        }else{
    
            if (buttonIndex == 1) {
                [self topVoice];
            }else if(buttonIndex == 2){
                [self editVoice];
            }else if(buttonIndex == 3){
                [self addTozJ];
            }else if(buttonIndex == 4){
                [self share];
            }else if(buttonIndex == 5){
                [self shanreVoice];
            }
            else if(buttonIndex == 6){
                [self sayToSelf];
            }else if (buttonIndex == 7){
                [self deleteVoice];
            }else if (buttonIndex == 8){
                [self setSysTop];
            }
        }
    }
}

- (void)setSysTop{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.priModel.topAt.intValue?@"0": [NSString stringWithFormat:@"%.f",currentTime] forKey:@"topAt"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/voices/%@",[[NoticeSaveModel getUserInfo] user_id],self.priModel.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            [nav.topViewController showToastWithText:self.priModel.topAt.intValue?@"取消置顶成功": @"置顶成功，请手动刷新"];
            self.priModel.topAt = self.priModel.topAt.intValue?@"0":@"456789";
        }
    } fail:^(NSError *error) {
        
    }];
}

//分享到社团
- (void)shareToGroup{

    NoticeShareGroupView *shareGroupView = [[NoticeShareGroupView alloc] initWithShareVoiceToGroup];
    shareGroupView.voiceM = self.priModel;
    [shareGroupView showShareView];
}

//共享或者投递
- (void)shanreVoice{
    [self.shareWorld shareToWorldWitn:self.priModel];
}

//共享或者取消共享成功回调
- (void)shareToWorldSucess{
    
//
//    if (!self.priModel.is_shared.intValue) {//取消共享的时候从列表删除
//        if (self.delegate && [self.delegate respondsToSelector:@selector(moreClickDeleteSucess)]) {
//            [self.delegate moreClickDeleteSucess];
//        }
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShareVoice:)]) {
        [self.delegate clickShareVoice:self.priModel];
    }
}

- (NoticeShareToWorld *)shareWorld{
    if (!_shareWorld) {
        //分享到世界
        _shareWorld = [[NoticeShareToWorld alloc] init];
        _shareWorld.delegate = self;
    }
    return _shareWorld;
}

//取消仅自己可见
- (void)cancelPri{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.priModel.is_private.integerValue ? @"0" : @"1" forKey:@"privateStatus"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/voices/%@",[[NoticeSaveModel getUserInfo] user_id],self.priModel.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            [nav.topViewController showToastWithText:@"已取消仅自己可见"];
            self.priModel.is_private = @"0";
        }
        [nav.topViewController hideHUD];
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}


//置顶心情
- (void)topVoice{
    if (self.priModel.is_top.boolValue) {
        [self sureTop];
    }else{
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalType]?@"The topped mood will be seen by others\n top it?":@"置顶后将在个人主页被所有人可见，确定置顶吗?" message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"main.sure"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf sureTop];
            }
        };
        [alerView showXLAlertView];
    }
}

- (void)sureTop{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.priModel.is_top.boolValue?@"0": @"1" forKey:@"isTop"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"voices/%@",self.priModel.voice_id] Accept:@"application/vnd.shengxi.v5.0.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self.priModel.is_top = self.priModel.is_top.boolValue?@"0":@"1";
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SETTOPNOTICENTERION" object:self userInfo:@{@"voiceId":self.priModel.voice_id,@"isTop":self.priModel.is_top,@"voiceIdentity":self.priModel.voiceIdentity}];
            if (self.priModel.is_top.boolValue) {
                
                [nav.topViewController showToastWithText: [NoticeTools getLocalStrWith:@"groupVoice.zd"]];
            }else{
                [nav.topViewController showToastWithText: [NoticeTools getLocalStrWith:@"groupVoice.cancelZD"]];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

//加到专辑
- (void)addTozJ{
    NoticeZjListView* _listView = [[NoticeZjListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    _listView.choiceM = self.priModel;
    __weak typeof(self) weakSelf = self;
    _listView.addSuccessBlock = ^(NoticeZjModel * _Nonnull model) {
        if (weakSelf.priModel.albumArr.count) {
            [weakSelf.priModel.albumArr insertObject:model atIndex:0];
        }else{
            [weakSelf.priModel.albumArr addObject:model];
        }
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(moreClickAddToZjSucess)]) {
            [weakSelf.delegate moreClickAddToZjSucess];
        }
    };

    [_listView show];
}

//分享
- (void)share{
    if (self.priModel.voiceIdentity.intValue != 1) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController showToastWithText:@"只有公开的心情才可以共享哦~"];
        return;
    }
    NoticeShareTostView *view = [[NoticeShareTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    view.voiceM = self.priModel;
    [view showTost];
}

//自己留言
- (void)sayToSelf{
    
    //判断是否是自己,不是自己则为点击「有启发」
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.priModel.note_num.integerValue) {
        NoticeSayToSelfController *ctl = [[NoticeSayToSelfController alloc] init];
        ctl.voiceId = self.priModel.voice_id;
        ctl.choiceM = self.priModel;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
        return;
    }
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(needStopBecauseLy)]) {
        [self.delegate needStopBecauseLy];
    }
    
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    recodeView.isSayToSelf = YES;
    recodeView.hideCancel = NO;
    recodeView.isReply = YES;
    recodeView.delegate = self;
    [recodeView show];
}



- (void)editVoice{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.priModel.content_type.intValue == 2) {
        NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
        ctl.isReEdit = YES;
        ctl.voiceM = self.priModel;
        __weak typeof(self) weakSelf = self;
        ctl.reEditBlock = ^(NoticeVoiceListModel * _Nonnull voiceM) {
            weakSelf.priModel = voiceM;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(moreClickEditSusscee:)]) {
                [weakSelf.delegate moreClickEditSusscee:voiceM];
            }
        };
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        return;
    }
    NoticeSendViewController *ctl = [[NoticeSendViewController alloc] init];
    ctl.isEditVoice = YES;
    ctl.voiceM = self.priModel;
    __weak typeof(self) weakSelf = self;
    ctl.reEditBlock = ^(NoticeVoiceListModel * _Nonnull voiceM) {
        weakSelf.priModel = voiceM;
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(moreClickEditSusscee:)]) {
            [weakSelf.delegate moreClickEditSusscee:voiceM];
        }
    };
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

//删除
- (void)deleteVoice{
    __weak typeof(self) weakSelf = self;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    LCActionSheet *sheet2 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex2) {
        if (buttonIndex2 ==2 ) {
            [nav.topViewController showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/voices/%@",[[NoticeSaveModel getUserInfo] user_id],self.priModel.voice_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [nav.topViewController hideHUD];
                if (success) {
      
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(moreClickDeleteSucess)]) {
                        [weakSelf.delegate moreClickDeleteSucess];
                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHUSERINFORNOTICATIONrili" object:self userInfo:@{@"voiceId":self.priModel.voice_id}];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATION" object:nil];
                }
            } fail:^(NSError *error) {
                [nav.topViewController hideHUD];
            }];
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"songList.suredele"],[NoticeTools getLocalStrWith:@"main.sure"]]];
    [sheet2 show];
}

//悄悄话
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"13" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            NSMutableDictionary *parm = [NSMutableDictionary new];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            [parm setObject:Message forKey:@"noteUri"];
            [parm setObject:timeLength forKey:@"noteLen"];
            [nav.topViewController showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voice/%@/note",self->_priModel.voice_id] Accept:@"application/vnd.shengxi.v3.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [nav.topViewController hideHUD];
                
                
                //判断是否是自己,不是自己则为点击「有启发」
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }
                if (!self.priModel.note_num.integerValue) {//第一次留言则跳转
                    NoticeSayToSelfController *ctl = [[NoticeSayToSelfController alloc] init];
                    ctl.voiceId = self.priModel.voice_id;
                    ctl.choiceM = self.priModel;
                    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
                   
                }else{
                    [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"yl.lychengg"]];
                }
                self.priModel.note_num = [NSString stringWithFormat:@"%ld",self->_priModel.note_num.integerValue+1];
            } fail:^(NSError *error) {
                [nav.topViewController hideHUD];
            }];
            
        }else{
            [nav.topViewController showToastWithText:Message];
            [nav.topViewController hideHUD];
        }
    }];
}
@end
