//
//  NoticeVoicePinbi.m
//  NoticeXi
//
//  Created by li lei on 2019/6/14.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoicePinbi.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeSCViewController.h"
@implementation NoticeVoicePinbi

- (void)pinbiWithModel:(NoticeVoiceListModel *)model{
    self.priModel = model;
    if ([NoticeTools isManager]) {
        NSArray *arr = @[[NoticeTools getLocalStrWith:@"groupManager.del"],@"隐藏",model.is_mark.boolValue?@"取消标记" :@"标记"];
        
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:arr];
        self.pinbiSheet = sheet;
        sheet.delegate = self;
        [sheet show];
        return;
    }
    if ([model.resource_type isEqualToString:@"1"] || [model.resource_type isEqualToString:@"2"] || [model.resource_type isEqualToString:@"3"]) {
        if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是别人

            NSArray *arr = model.content_type.intValue == 1?@[[NoticeTools getLocalStrWith:@"chat.jubao"]]:@[[NoticeTools getLocalStrWith:@"chat.jubao"]];
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            } otherButtonTitleArray:arr];
            self.pinbiSheet = sheet;
            sheet.delegate = self;
            [sheet show];
        }
    }else{
        if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
            
            NSArray *arr = @[[NoticeTools getLocalStrWith:@"em.so"],[NoticeTools getLocalStrWith:@"chat.jubao"]];
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            } otherButtonTitleArray:arr];
            self.pinbiSheet = sheet;
            sheet.delegate = self;
            [sheet show];
        }
    }
}

- (void)guanzhu{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickGuanzhu)]) {
        [self.delegate clickGuanzhu];
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if (actionSheet == self.pinbiSheet) {
        if ([NoticeTools isManager]) {
            if (buttonIndex == 1) {
                [self managerDeleteVoice];
            }else if (buttonIndex == 2){
                [self setHideVoice];
            }else if (buttonIndex == 3){
                [self setBioaji];
            }
            return;
        }
        if ([self.priModel.resource_type isEqualToString:@"1"] || [self.priModel.resource_type isEqualToString:@"2"] || [self.priModel.resource_type isEqualToString:@"3"]) {
            if (buttonIndex == 1) {
                [self jubao];
            }else if (buttonIndex == 2){
                [self shareToGroup];
            }
        }else{
            if (buttonIndex == 1) {
                [self pinbgi];
            }else if (buttonIndex == 2){
                [self jubao];
            }
        }
        return;
    }
}

//分享到社团
- (void)shareToGroup{
    NoticeShareGroupView *shareGroupView = [[NoticeShareGroupView alloc] initWithShareVoiceToGroup];
    shareGroupView.voiceM = self.priModel;
    [shareGroupView showShareView];
}


- (void)jiaoliu{
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
    vc.toUser = [NSString stringWithFormat:@"%@%@",socketADD,self.priModel.subUserModel.userId];
    vc.identType = self.priModel.subUserModel.identity_type;
    vc.lelve = self.priModel.subUserModel.levelImgName;
    vc.toUserId = self.priModel.subUserModel.userId;
    vc.navigationItem.title = self.priModel.subUserModel.nick_name;
    [nav.topViewController.navigationController pushViewController:vc animated:YES];
}

- (void)setTop:(NoticeVoiceListModel *)model code:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [parm setObject:model.topAt.intValue?@"0": [NSString stringWithFormat:@"%.f",currentTime] forKey:@"topAt"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/voices/%@",model.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
         [self.magager removeFromSuperview];
        if (success) {
            [nav.topViewController showToastWithText:model.topAt.intValue?@"取消置顶成功": @"置顶成功，请手动刷新"];
            model.topAt = model.topAt.intValue?@"0":@"456789";
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];

}
- (void)jubao{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = self.priModel.voice_id;
    juBaoView.reouceType = @"1";
    [juBaoView showView];
}

- (void)pinbgi{
    [[NoticeTools getTopViewController] showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.priModel.voice_id forKey:@"voiceId"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voiceLike" Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            [[NoticeTools getTopViewController] showToastWithText:@"谢谢你的反馈，对方不会收到通知"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NOLIKEVOICENotification" object:self userInfo:@{@"voiceId":self.priModel.voice_id}];
        }
    } fail:^(NSError *error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
    
}

- (void)managerDeleteVoice{
    self.magager.type = @"删除心情";
    [self.magager show];
}

- (void)setHideVoice{
    self.isTop = NO;
    self.magager.type = @"设为隐藏心情";
    [self.magager show];
}

- (void)setBioaji{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"849527" forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/warm/markVoice/%@",self.priModel.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            [nav.topViewController showToastWithText:@"操作已执行"];
            self.priModel.is_mark = self.priModel.is_mark.boolValue?@"0":@"1";
            if (self.delegate && [self.delegate respondsToSelector:@selector(markSucess)]) {
                [self.delegate markSucess];
            }
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        self.magager.markL.text = @"密码错误请重新输入";
        [nav.topViewController hideHUD];
    }];
}


- (void)sureManagerClick:(NSString *)code{
    [self.magager removeFromSuperview];

    if (self.isTop) {
        [self setTop:self.priModel code:code];
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    if ([self.magager.type isEqualToString:@"设为隐藏心情"]) {
        [parm setObject:@"1" forKey:@"isHidden"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/voices/%@",self.priModel.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                [self.magager removeFromSuperview];
                [nav.topViewController showToastWithText:@"操作已执行"];
            }else{
                self.magager.markL.text = @"密码错误请重新输入";
            }
        } fail:^(NSError *error) {
            self.magager.markL.text = @"密码错误请重新输入";
            [nav.topViewController hideHUD];
        }];
    }else if([self.magager.type isEqualToString:@"删除心情"]){
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/voices/%@",self.priModel.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"emtion.deleSuc"]];
            }
        } fail:^(NSError *error) {
            [nav.topViewController hideHUD];
        }];
    }
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}

@end
