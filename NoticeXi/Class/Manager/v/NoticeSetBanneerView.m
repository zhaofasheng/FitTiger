//
//  NoticeSetBanneerView.m
//  NoticeXi
//
//  Created by li lei on 2021/1/15.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeSetBanneerView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "ZFSDateFormatUtil.h"
@implementation NoticeSetBanneerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(15, (self.frame.size.height-240)/2-150, DR_SCREEN_WIDTH-30, 240)];
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        [self addSubview:self.contentView];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        
        NSArray *arr = @[@"上传banner图",@"上传正文图",@"设定时间"];
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 60*i+10, self.contentView.frame.size.width-30, 50)];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            [btn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            [self.contentView addSubview:btn];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            if (i == 0) {
                self.btn1 = btn;
            }else if (i == 1){
                self.btn2 = btn;
            }else{
                self.btn3 = btn;
            }
        }
        
        self.finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 60*3+10,(self.contentView.frame.size.width-30)/2, 40)];
        [self.finishBtn setTitle:[NoticeTools getLocalStrWith:@"groupfm.finish"] forState:UIControlStateNormal];
        [self.finishBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        self.finishBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.finishBtn];
        [self.finishBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.finishBtn.frame), 60*3+10,(self.contentView.frame.size.width-30)/2, 40)];
        [self.cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.cancelBtn];
        [self.cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)cancelClick{
    [self removeFromSuperview];
}

- (void)finishClick{
    
    if (self.contentImage && self.banneerImage && self.time) {
        if (self.bannerId) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
            
            [nav.topViewController showHUD];
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:self.managerCode forKey:@"confirmPasswd"];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/banners/%@",self.bannerId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    [self upLoadHeader];
                }
                [nav.topViewController hideHUD];
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
        }else{
           [self upLoadHeader];
        }
        
    }
}

- (void)getTimeToValue:(NSString *)theTimeStr{

    self.time = theTimeStr;
    [self.btn3 setTitle:theTimeStr forState:UIControlStateNormal];
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 2) {
        FDAlertView *alert = [[FDAlertView alloc] init];
        RBCustomDatePickerView * contentView=[[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        contentView.delegate=self;
        alert.contentView = contentView;
        [alert show];
        return;
    }
    self.choiceType = btn.tag;
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = YES;
    imagePicker.allowPickingMultipleVideo = YES;
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.allowCrop = NO;
    imagePicker.showSelectBtn = YES;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    if (self.choiceType == 0) {
        [self.btn1 setTitle:@"已选择banner图" forState:UIControlStateNormal];
        self.banneerImage = choiceImage;
    }else{
        [self.btn2 setTitle:@"已选择正文图" forState:UIControlStateNormal];
        self.contentImage = choiceImage;
    }
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
           // [self upLoadHeader:choiceImage path:filePath withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }else{
           // [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""] withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }
    }];
}

- (void)upLoadHeader{

    NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    [nav.topViewController showHUD];
    
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"130" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:self.banneerImage parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {

            [self upContentImage:Message];

        }else{
            [nav.topViewController showToastWithText:Message];
            [self cancelClick];
        }
    }];
}

- (void)upContentImage:(NSString *)bannerUrl{
    NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"130" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    [[XGUploadDateManager sharedManager] uploadImageWithImage:self.contentImage parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            if (!bucketId) {
                bucketId = @"0";
            }
            [self upInfo:bannerUrl conUrl:Message bucketId:bucketId];

        }else{
            [nav.topViewController showToastWithText:Message];
            [self cancelClick];
        }
    }];
}

- (void)upInfo:(NSString *)bannerUrl  conUrl:(NSString *)conUrl bucketId:(NSString *)bucketId{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    NSString *timeInt = [NSString stringWithFormat:@"%@:00",self.time];
    NSInteger timeNum = [ZFSDateFormatUtil timeIntervalWithDateString:timeInt];
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:bannerUrl forKey:@"titleImageUri"];
    [parm setObject:conUrl forKey:@"contentImageuUri"];
    [parm setObject:bucketId forKey:@"bucketId"];
    [parm setObject:@"1" forKey:@"typeId"];
    [parm setObject:[NSString stringWithFormat:@"%ld",timeNum] forKey:@"startedAt"];
    [parm setObject:self.managerCode forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/banners" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        [self cancelClick];
        if (success) {
            if (self.refreshBlock) {
                self.refreshBlock(YES);
            }
          [nav.topViewController showToastWithText:@"创建成功"];
        }
        
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
        [self cancelClick];
    }];
}

@end
