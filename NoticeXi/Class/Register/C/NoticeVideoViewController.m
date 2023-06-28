//
//  NoticeVideoViewController.m
//  NoticeXi
//
//  Created by 赵小二 on 2018/10/20.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeVideoViewController.h"
#import "NoticeChangeIntroduceViewController.h"
#import "NoticeConnectPhoneController.h"
#import "AppDelegate.h"
@interface NoticeVideoViewController ()<NoticeRecordDelegate>
@property (strong, nonatomic) UILabel *topTitleL;
@property (strong, nonatomic) UILabel *speakL;
@property (strong, nonatomic) UILabel *helloL;
@property (nonatomic, assign) BOOL hasClick;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NoticeRecoderView *recodView;
@end

@implementation NoticeVideoViewController
{
    NSInteger currentRecodTime;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //禁用右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NoticeRecoderView *recodView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    recodView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    recodView.functionView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    recodView.needLongTap = YES;
    recodView.delegate = self;
    recodView.isRgister = YES;
    recodView.isLongTime = NO;
    [recodView show];
    _recodView = recodView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_recodView canDismissWithNoClear];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    label.text = @"录制个人简介";
    [self.view addSubview:label];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        DRLog(@"%@",granted ? @"麦克风准许":@"麦克风不准许");
    }];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH,DR_SCREEN_WIDTH)];
    imageView.image = UIImageNamed(@"Image_saysome");
    [self.view addSubview:imageView];
}

- (void)longTapToSendText{
    NoticeChangeIntroduceViewController *ctl = [[NoticeChangeIntroduceViewController alloc] init];
    ctl.name = self.name;
    ctl.isFromReg = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"1" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:Message forKey:@"waveUri"];
            [parm setObject:timeLength forKey:@"waveLen"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            if (self.name) {
                [parm setObject:self.name forKey:@"nickName"];
            }
            [self showHUD];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success1) {
                
                if (success1) {
                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success2) {
                        [self hideHUD];
                        if (success2) {
                            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                            userIn.personality_test = self.hasTest?@"1":@"0";
                            [NoticeSaveModel saveUserInfo:userIn];
                            //执行引导页
                            [self.navigationController popToRootViewControllerAnimated:NO];
                            //上传成功，执行引导页
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                        }
                    } fail:^(NSError *error) {
                        [self hideHUD];
                    }];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self showToastWithText:Message];
            [self hideHUD];
        }
    }];

}

@end
