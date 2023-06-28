//
//  NoticeShareToWorld.m
//  NoticeXi
//
//  Created by li lei on 2019/6/14.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeShareToWorld.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"

@implementation NoticeShareToWorld

- (void)shareToWorldWitn:(NoticeVoiceListModel *)model{
    
    self.shareModel = model;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
  
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"n.open"],[NoticeTools getLocalType]? [NoticeTools getLocalStrWith:@"n.tpkjian"]:@"同频(互相欣赏)可见",[NoticeTools getLocalStrWith:@"n.onlyself"]]];
    sheet.delegate = self;
    [sheet show];

}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if (buttonIndex == self.shareModel.voiceIdentity.intValue) {
        return;
    }
    
    if (buttonIndex >0) {

        if(buttonIndex == 1){
            [self changeAreaButtonIndex:buttonIndex];
        }else if (buttonIndex == 2){
            __weak typeof(self) weakSelf = self;
             XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"更改为同频可见后，心情下的不是互相关注的人的悄悄话和留言会被删除？" english:@"Comments from non-mutual-followers will be deleted. Make the change?" japan:@"非共同フォロワーのコメントは削除されます。変化を起こす？"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] cancleBtn:[NoticeTools chinese:@"更改" english:@"Change" japan:@"はい"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    [weakSelf changeAreaButtonIndex:buttonIndex];
                }
            };
            [alerView showXLAlertView];
        }else if (buttonIndex == 3){
            __weak typeof(self) weakSelf = self;
             XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"更改为仅自己可见后，心情下的悄悄话和留言都会被删除？" english:@"Comments will be deleted after changing to Me Only. Make the change?" japan:@"「自分だけ」に変更すると、コメントが削除されます。変化を起こす？"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] cancleBtn:[NoticeTools chinese:@"更改" english:@"Change" japan:@"はい"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    [weakSelf changeAreaButtonIndex:buttonIndex];
                }
            };
            [alerView showXLAlertView];
        }
    }

}

- (void)changeAreaButtonIndex:(NSInteger)buttonIndex{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:[NSString stringWithFormat:@"%ld",buttonIndex] forKey:@"voiceIdentity"];
    [[NoticeTools getTopViewController] showHUD];
    __weak typeof(self) weakSelf = self;
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"voices/%@",self.shareModel.voice_id] Accept:@"application/vnd.shengxi.v5.3.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            weakSelf.shareModel.voiceIdentity = [NSString stringWithFormat:@"%ld",buttonIndex];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SETTOPNOTICENTERION" object:self userInfo:@{@"voiceId":weakSelf.shareModel.voice_id,@"isTop":weakSelf.shareModel.is_top,@"voiceIdentity":weakSelf.shareModel.voiceIdentity}];
     
            [[NoticeTools getTopViewController] showToastWithText:[NoticeTools getLocalStrWith:@"n.chanage"]];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)setLiekEachOther:(NoticeVoiceListModel *)model shareM:(NoticeShareModel *)shareM{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    NSString *titleStr = nil;
    NSString *btnStr = nil;
    if (model.is_admire.boolValue) {
        titleStr = [NoticeTools getLocalStrWith:@"mineme.cancleshanre"];
        btnStr = [NoticeTools getLocalStrWith:@"sure.comgir"];
        shareM.tips = [NoticeTools getLocalStrWith:@"mineme.surecanshanre"];
    }else{
        titleStr = [NoticeTools getLocalStrWith:@"mineme.sharetosy"];
        btnStr = [NoticeTools getLocalStrWith:@"em.gx"];
    }
    
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initNewWithTitle:titleStr message:shareM.tips sureBtn:btnStr cancleBtn:model.is_admire.boolValue?[NoticeTools getLocalStrWith:@"groupManager.rethink"]: [NoticeTools getLocalStrWith:@"main.cancel"]];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            if (!model.is_admire.boolValue) {//共享到世界
                [nav.topViewController showHUD];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"setAdmire/%@",model.voice_id] Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        model.is_admire = @"1";
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(shareToWorldSucess)]) {
                            [weakSelf.delegate shareToWorldSucess];
                        }
                        [nav.topViewController showToastWithText:model.content_type.intValue==1?[NoticeTools getLocalStrWith:@"em.hasgx"]: [NoticeTools getLocalStrWith:@"em.hastd"]];
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }
            else{//取消共享到世界
                [nav.topViewController showHUD];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"delAdmire/%@",model.voice_id] Accept:@"application/vnd.shengxi.v5.1.0+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        model.is_admire = @"0";
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(shareToWorldSucess)]) {
                            [weakSelf.delegate shareToWorldSucess];
                        }
                        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"mineme.ych"]];
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }
        }
    };
    [alerView showXLAlertView];
}

- (void)shareOrBack:(NoticeVoiceListModel *)model shareM:(NoticeShareModel *)shareM{
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    NSString *titleStr = nil;
    NSString *btnStr = nil;
    if (model.is_shared.boolValue) {
        titleStr = model.content_type.intValue==1?[NoticeTools getLocalStrWith:@"mineme.cancleshanre"]: [NoticeTools getLocalStrWith:@"mineme.canceltd"];
        btnStr = [NoticeTools getLocalStrWith:@"sure.comgir"];
        shareM.tips = model.content_type.intValue==1? [NoticeTools getLocalStrWith:@"mineme.surecanshanre"]: @"";
    }else{
        titleStr = model.content_type.intValue==1?[NoticeTools getLocalStrWith:@"mineme.sharetosy"]: [NoticeTools getLocalStrWith:@"em.shanretogc"];
        btnStr = model.content_type.intValue==1?[NoticeTools getLocalStrWith:@"mineme.suregx"]: [NoticeTools getLocalStrWith:@"mineme.suretd"];
    }
    
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initNewWithTitle:titleStr message:shareM.tips sureBtn:btnStr cancleBtn:model.is_shared.boolValue?[NoticeTools getLocalStrWith:@"groupManager.rethink"]: [NoticeTools getLocalType]?@"cancel":@"确认取消"];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            if (!model.is_shared.boolValue) {//共享到世界
                [nav.topViewController showHUD];
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:model.voice_id forKey:@"voiceId"];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices/share" Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        model.is_shared = @"1";
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(shareToWorldSucess)]) {
                            [weakSelf.delegate shareToWorldSucess];
                        }
                        [nav.topViewController showToastWithText:model.content_type.intValue==1?[NoticeTools getLocalStrWith:@"em.hasgx"]: [NoticeTools getLocalStrWith:@"em.hastd"]];
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }
            else{//取消共享到世界
                [nav.topViewController showHUD];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/voices/%@/share",[[NoticeSaveModel getUserInfo] user_id],model.voice_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        model.is_shared = @"0";
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(shareToWorldSucess)]) {
                            [weakSelf.delegate shareToWorldSucess];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATION" object:nil];
                        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"mineme.ych"]];
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }
        }
    };
    [alerView showXLAlertView];
}

@end
