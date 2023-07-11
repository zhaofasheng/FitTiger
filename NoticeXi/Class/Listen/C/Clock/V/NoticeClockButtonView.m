//
//  NoticeClockButtonView.m
//  NoticeXi
//
//  Created by li lei on 2019/10/17.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeClockButtonView.h"
#import "NoticeXi-Swift.h"
#import "NoticeVoteView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticePyComController.h"
#import "NoticeBingGanListView.h"
#import "NoticeShareTostView.h"
@implementation NoticeClockButtonView
{
    BOOL _canNotClick;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        NSArray *arr1 = @[[NoticeTools getLocalStrWith:@"py.bg"],[NoticeTools getLocalStrWith:@"py.com"],[NoticeTools getLocalStrWith:@"py.share"],[NoticeTools getLocalStrWith:@"emtion.sc"]];
        NSArray *imgArr = @[@"Ima_sendbgn",@"Image_pypinglun",@"Image_pyfenxiang",@"Image_pyshoucang"];
        for (int i = 0; i < 4; i++) {
            UIImageView *imageV = [[UIImageView alloc] init];
            if (i == 0) {
                imageV.frame = CGRectMake(15, 13, 24, 24);
                self.tianshiImgView = imageV;
            }else{
                imageV.frame = CGRectMake(frame.size.width-168-24+(24+39)*(i-1), 13, 24, 24);
            }
            imageV.image = UIImageNamed(imgArr[i]);
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+1.5, 0, 39, 50)];
            label.font = TWOTEXTFONTSIZE;
            label.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
            label.text = arr1[i];
            [self addSubview:label];
            [self addSubview:imageV];
            
            if (i == 1) {
                self.mgL = label;
                self.moguiImgView = imageV;
            }else if (i==0){
                self.tsL = label;
            }else if (i==2){
                self.shareL = label;
                self.shenImgView = imageV;
            }
            
            if (i == 3) {
                self.sL = label;
                self.qizhiImgView = imageV;
            }
            
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(imageV.frame.origin.x, 0, 24+39, 50)];
            tapView.backgroundColor = [UIColor clearColor];
            tapView.userInteractionEnabled = YES;
            tapView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAciton:)];
            [tapView addGestureRecognizer:tap];
            [self addSubview:tapView];
        }
    }
    return self;
}

- (void)setNeedBackGround:(BOOL)needBackGround{
    _needBackGround = needBackGround;
    if (needBackGround) {
        self.tsL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.mgL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.shareL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.sL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        

        self.tianshiImgView.image = UIImageNamed(@"Ima_sendbgnw");
        self.moguiImgView.image = UIImageNamed(@"Image_pypinglunw");
        self.shenImgView.image = UIImageNamed(@"Image_pyfenxiangw");
        self.qizhiImgView.image = UIImageNamed(@"Image_pyshoucangw");
    }
}

- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:comment forKey:@"commentContent"];
    [parm setObject:self.pyModel.pyId forKey:@"dubbingId"];
    [parm setObject:@"0" forKey:@"commentId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"dubbingComment" Accept:@"application/vnd.shengxi.v4.8.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self.pyModel.comment_num = [NSString stringWithFormat:@"%d",self.pyModel.comment_num.intValue+1];
            if (self.pyModel.comment_num.intValue == 1) {
                [self pushToCom];
            }
            [self refreshButton:self.pyModel];
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)pushToCom{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticePyComController *ctl = [[NoticePyComController alloc] init];
    ctl.pyMOdel = self.pyModel;
    __weak typeof(self) weakSelf = self;
    ctl.deletePyBlock = ^(NoticeClockPyModel * _Nonnull pyModel) {
        if (weakSelf.deletePyBlock) {
            weakSelf.deletePyBlock(pyModel);
        }
    };
    [nav.topViewController.navigationController pushViewController:ctl animated:NO];
}

- (void)tapAciton:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (tapV.tag == 1) {
        if (self.noNeedPush) {
            return;
        }
        if (self.pyModel.is_anonymous.intValue) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.colNMcom"]];
            return;
        }
        [self pushToCom];
    }else if (tapV.tag == 0){
        [self voteWithTag:4];
        return;
    }else if (tapV.tag == 2){
        NoticeShareTostView *view = [[NoticeShareTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        view.isPyOrTc = YES;
        view.pyModel = self.pyModel;
        [view showTost];
    }
    
    if (tapV.tag == 3) {
        if ([_pyModel.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {//自己点击收藏
            [self selfTapColloction];
        }else{//别人点击收藏
            [self otherCollection];
        }
    }
}

- (void)otherCollection{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.pyModel.is_anonymous.boolValue) {
        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.colNmTosat"]];
        return;
    }
    [nav.topViewController showHUD];
    if (self.pyModel.collection_id.intValue) {//取消收藏
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"dubbings/downloadlog/%@",self.pyModel.collection_id] Accept:@"application/vnd.shengxi.v5.0.0+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.cancelCol"]];
                self.pyModel.collection_id = @"0";
                [self refreshButton:self.pyModel];
            }
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:_pyModel.pyId forKey:@"dubbingId"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"dubbings/downloadlog" Accept:@"application/vnd.shengxi.v4.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"emtion.scSus"]];
            NoticeMJIDModel *model = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            self.pyModel.collection_id = model.allId;
            [self refreshButton:self.pyModel];
        }
        [nav.topViewController hideHUD];
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)selfTapColloction{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.pyModel.downloaded_num.intValue > 0) {//收到贴贴就弹出贴贴列表
        NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        listView.scModel = self.pyModel;
        [listView showTost];
    }else{
        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.nocol"]];
    }
    return;
}

- (void)voteWithTag:(NSInteger)tag{
    NoticeClockPyModel *model = _pyModel;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    NSString *userId = model.from_user_id;
    if ([userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {//如果是自己的配音点击送贴贴
        NSInteger allVote = model.vote_option_one.intValue+model.vote_option_two.intValue+model.vote_option_three.intValue+model.vote_option_four.intValue;
        if (allVote > 0) {//收到贴贴就弹出贴贴列表
            NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            listView.pyModel = self.pyModel;
            [listView showTost];
        }else{
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.noBg"]];
        }
        return;
    }
    
    //新版本点赞一律传类型是4，取消点赞，之前是什么，现在就取消什么
    [nav.topViewController showHUD];
    if ([model.vote_option isEqualToString:@"1"]) {//如果已经投票过了
        [self deleteVote:0];
        return;
    }else if ([model.vote_option isEqualToString:@"2"]) {
        [self deleteVote:1];
        return;
    }else if ([model.vote_option isEqualToString:@"3"]) {
        [self deleteVote:2];
        return;
    }else if ([model.vote_option isEqualToString:@"4"]) {
        [self deleteVote:3];
        return;
    }

    NSMutableDictionary *parm = [NSMutableDictionary new];
    
    [parm setObject:model.pyId forKey:@"dubbingId"];
    [parm setObject:@"4" forKey:@"voteOption"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"dubbingsVote" Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            NoticeClockPyModel *models = [NoticeClockPyModel mj_objectWithKeyValues:dict[@"data"]];
            if (models.tag_id.intValue == 2) {
                models.line_content = [NSString stringWithFormat:@"#求freestyle#%@",models.line_content];
            }else{
                models.line_content = [NSString stringWithFormat:@"#求配音#%@",models.line_content];
            }
            model.vote_id = models.tcId;//这里只是为了方便解析而用
            model.vote_option_four = [NSString stringWithFormat:@"%ld",(long)(model.vote_option_four.integerValue+1)];
            model.vote_option = @"4";
            self.needPost = YES;
            [self refreshButton:model];
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

//管理员点击别人的台词/配音
- (void)tapManager{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"chat.jubao"] fantText:@"舉報"],@"设为声昔君picker",@"隐藏配音(管理员)",@"删除配音(管理员)"]];
    self.managerSheet = sheet;
    sheet.delegate = self;
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.managerSheet) {
        if (buttonIndex == 1) {
            [self tapOther];
        }else if (buttonIndex == 2){
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"dubbings/%@/pickStatus",_pyModel.pyId] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dict[@"data"]];
                    if (model.pick_status.intValue == 2 || model.pick_status.intValue == 1) {
                        self->_pyModel.isPicker = YES;
                    }else{
                        self->_pyModel.isPicker = NO;
                    }
                    if (self->_pyModel.isPicker) {
                        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"配音曾被选为Picker,确定再次设置？" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                        } otherButtonTitleArray:@[@"确定？"]];
                        self.managerPickerSheet = sheet;
                        sheet.delegate = self;
                        [sheet show];
                    }else{
                        if (self.delegate && [self.delegate respondsToSelector:@selector(setPickerPy:)]) {
                            [self.delegate setPickerPy:self->_pyModel];
                        }
                    }
                }
            } fail:^(NSError * _Nullable error) {
            }];
        }
        else if (buttonIndex == 3){
            if (self.delegate && [self.delegate respondsToSelector:@selector(setHidePy:)]) {
                [self.delegate setHidePy:_pyModel];
            }
        }else if (buttonIndex == 4){
            [self deleteSelf];
        }
    }
    if (actionSheet == self.managerPickerSheet) {
        if (buttonIndex == 1) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(setPickerPy:)]) {
                [self.delegate setPickerPy:_pyModel];
            }
        }
    }
}

//点击的是别人的台词/配音
- (void)tapOther{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = _pyModel.pyId;
    juBaoView.reouceType = @"8";
    [juBaoView showView];
}

- (void)deleteSelf{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteSucessWith:)]) {
        [self.delegate deleteSucessWith:_pyModel];
    }
}

//取消投票
- (void)deleteVote:(NSInteger)tag{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    NoticeClockPyModel *model = _pyModel;
    NSString *url = [NSString stringWithFormat:@"dubbingsVote/%@",model.vote_id];
    [[DRNetWorking shareInstance] requestWithDeletePath:url Accept:@"application/vnd.shengxi.v5.0.0+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if (tag == 0) {
                model.vote_option_one = [NSString stringWithFormat:@"%ld",(long)(model.vote_option_one.integerValue-1)];
            }else if (tag == 1){
                model.vote_option_two = [NSString stringWithFormat:@"%ld",(long)(model.vote_option_two.integerValue-1)];
            }else if (tag == 2){
                model.vote_option_three = [NSString stringWithFormat:@"%ld",(long)(model.vote_option_three.integerValue-1)];
            }else{
                model.vote_option_four = [NSString stringWithFormat:@"%ld",(long)(model.vote_option_four.integerValue-1)];
            }
            model.vote_option = @"0";
            self.needPost = YES;
            [self refreshButton:model];
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)setPyModel:(NoticeClockPyModel *)pyModel{
    _pyModel = pyModel;
    [self refreshButton:pyModel];
}

- (void)refreshButton:(NoticeClockPyModel *)model{
    NSString *userId = model.from_user_id;

    NSInteger allVote = model.vote_option_one.intValue+model.vote_option_two.intValue+model.vote_option_three.intValue+model.vote_option_four.intValue;
    
    self.mgL.text = self.pyModel.comment_num.intValue?self.pyModel.comment_num:[NoticeTools getLocalStrWith:@"py.com"];
    self.tsL.text = allVote? [NSString stringWithFormat:@"%ld",allVote]:[NoticeTools getLocalStrWith:@"py.bg"];
    if ([userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {//自己的心情
        self.tianshiImgView.image = UIImageNamed(self.needBackGround?@"Ima_sendbgnw": @"Ima_sendbgn");
        self.qizhiImgView.image = UIImageNamed(self.needBackGround?@"Image_pyshoucangw": @"Image_pyshoucang");
        self.sL.text = model.downloaded_num.intValue?model.downloaded_num: [NoticeTools getLocalStrWith:@"emtion.sc"];
 
    }else{
        if (self.pyModel.vote_option.intValue) {//已点赞
            self.tianshiImgView.image = UIImageNamed(@"Image_songbg");
        }else{
            self.tianshiImgView.image = UIImageNamed(self.needBackGround?@"Ima_sendbgnw": @"Ima_sendbgn");
        }
        
        self.sL.text = [NoticeTools getLocalStrWith:@"emtion.sc"];
        if (self.pyModel.collection_id.intValue) {
            self.qizhiImgView.image = UIImageNamed(@"Image_pyshoucangy");
        }else{
            self.qizhiImgView.image = UIImageNamed(self.needBackGround?@"Image_pyshoucangw": @"Image_pyshoucang");
        }
    }
    if (model.is_anonymous.boolValue) {
        self.mgL.hidden = YES;
        self.sL.hidden = YES;
        self.shareL.hidden = YES;
        self.qizhiImgView.hidden = YES;
        self.moguiImgView.hidden = YES;
        self.shenImgView.hidden = YES;
    }else{
        self.mgL.hidden = NO;
        self.sL.hidden = NO;
        
        self.qizhiImgView.hidden = NO;
        self.moguiImgView.hidden = NO;
        self.shareL.hidden = NO;
        self.shenImgView.hidden = NO;
    }
    if (self.isTcPage) {
        if (self.needPost) {
            self.needPost = NO;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"postHasDianZanInPage" object:self userInfo:[model mj_keyValues]];
        }
    }
}
@end
