//
//  NoticeAboutView.m
//  NoticeXi
//
//  Created by li lei on 2019/12/19.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeAboutView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserTopiceListController.h"
#import "NoticeTopicModel.h"
#import "NoticeSetLikeTopicController.h"
@implementation NoticeAboutView
{
    UILabel *_nameL;
    UILabel *_markL;
    UILabel *_numL;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMiss)];
        [self addGestureRecognizer:tap];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.frame = CGRectMake(0, 0,325, 430-23*2);
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        self.contentView.layer.cornerRadius = 15;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        self.contentView.center = self.center;
        UITapGestureRecognizer *contengTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noAction)];
        [self.contentView addGestureRecognizer:contengTap];
        
        UIImageView *headerImagev = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width-110)/2,15, 110,110)];
        headerImagev.layer.cornerRadius = 110/2;
        headerImagev.layer.masksToBounds = YES;
        if (![NoticeTools isWhiteTheme]) {
            UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
            mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            [headerImagev addSubview:mbView];
        }
        [self.contentView addSubview:headerImagev];
        _headerIimag = headerImagev;
        
        headerImagev.userInteractionEnabled = YES;
        UITapGestureRecognizer *shortTap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoIconTap)];
        [headerImagev addGestureRecognizer:shortTap];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(69+headerImagev.frame.origin.x, 69+headerImagev.frame.origin.y, 40, 40)];
        self.markImage.image = UIImageNamed(@"jlzb_img");
        [self.contentView addSubview:self.markImage];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerImagev.frame)+22, self.contentView.frame.size.width, 20)];
        nameL.font = [UIFont systemFontOfSize:20];
        nameL.textColor = GetColorWithName(VMainTextColor);
        nameL.textAlignment = NSTextAlignmentCenter;
        _nameL = nameL;
        [self.contentView addSubview:nameL];
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameL.frame)+10, self.contentView.frame.size.width, 11)];
        numL.font = [UIFont systemFontOfSize:11];
        numL.textColor = [NoticeTools getWhiteColor:@"#999999" NightColor:@"#3E3E4A"];
        numL.textAlignment = NSTextAlignmentCenter;
        numL.text = [NSString stringWithFormat:@"%@：%@",GETTEXTWITE(@"my.num"),self.aboutM.frequency_no];
        _numL = numL;
        [self.contentView addSubview:numL];
        
        NSString *hasHy = self.aboutM.friend_num.integerValue ? [NSString stringWithFormat:@"有%@个学友",self.aboutM.friend_num] : @"还没有和任何人成为学友";
        NSString *hasSx = self.aboutM.oring.integerValue ? (self.aboutM.oring.integerValue >= 300 ? [NSString stringWithFormat:@"记录了%@分钟回忆",self.aboutM.voice_total_lens] : [NSString stringWithFormat:@"记录了%@秒回忆",self.aboutM.voice_total_lens]) : @"还没有发布过心情";
        
        NSString *allStr = [NSString stringWithFormat:@"%@ %@",hasHy,hasSx];
        
        UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(numL.frame)+10, self.contentView.frame.size.width, 11)];
        markL.font = [UIFont systemFontOfSize:11];
        markL.textColor = [NoticeTools getWhiteColor:@"#999999" NightColor:@"#3E3E4A"];
        markL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:markL];
        _markL = markL;
        markL.attributedText = [DDHAttributedMode setTwoColorString:allStr setColor:GetColorWithName(VMainThumeColor) setLengthString:self.aboutM.friend_num.integerValue? self.aboutM.friend_num : @"" beginSize:1 setLengthString1:self.aboutM.voice_total_lens.integerValue ? self.aboutM.voice_total_lens : @"" beginSize1:allStr.length-2-self.aboutM.voice_total_len.length];

        UILabel *subL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_markL.frame)+37, self.contentView.frame.size.width, 14)];
        subL.text = [NoticeTools getTextWithSim:@"最喜欢的话题:" fantText:@"最喜歡的話題:"];
        subL.font = FOURTHTEENTEXTFONTSIZE;
        subL.textColor = [NoticeTools getWhiteColor:@"#999999" NightColor:@"#72727f"];
        subL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:subL];
        
        for (int i = 0; i < 3; i++) {
            UILabel *topL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subL.frame)+10+23*i,self.contentView.frame.size.width, 13)];
            topL.font = ELEVENTEXTFONTSIZE;
            topL.textAlignment = NSTextAlignmentCenter;
            topL.textColor = GetColorWithName(VMainThumeColor);
            topL.userInteractionEnabled = YES;
            topL.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTap:)];
            [topL addGestureRecognizer:tap];
            [self.contentView addSubview:topL];
            if (i == 0) {
                self.labelTopic1 = topL;
            }else if (i == 1){
                self.labelTopic2 = topL;
            }else{
                self.labelTopic3 = topL;
            }
        }
        self.achBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-85, self.contentView.frame.size.width, 85)];
        [self.contentView addSubview:self.achBackView];
        
        self.achButton = [[UIButton alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width-80)/2,0,80, 22)];
        [self.achButton setTitleColor:[NoticeTools getWhiteColor:@"#999999" NightColor:@"72727f"] forState:UIControlStateNormal];
        self.achButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.achButton setTitle:@"成就" forState:UIControlStateNormal];
        [self.achBackView addSubview:self.achButton];
        
        self.titleL1 = [[UILabel alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width-130)/2, CGRectGetMaxY(self.achButton.frame)+12, GET_STRWIDTH(@"穿越小达人:", 11, 12), 12)];
        self.titleL1.textColor = [NoticeTools getWhiteColor:@"#999999" NightColor:@"#3E3E4A"];
        self.titleL1.font = ELEVENTEXTFONTSIZE;
        self.titleL1.text = @"今日想法:";
        [self.achBackView addSubview:self.titleL1];
        
        self.achImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleL1.frame), CGRectGetMaxY(self.achButton.frame)+10, 14, 15)];
        self.achImageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_achjb_b":@"Image_achjb_y");
        [self.achBackView addSubview:self.achImageView1];
        
        self.achL1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.achImageView1.frame)+5, CGRectGetMaxY(self.achButton.frame)+12, self.contentView.frame.size.width-CGRectGetMaxX(self.achImageView1.frame), 12)];
        self.achL1.textColor = [NoticeTools getWhiteColor:@"#FDC571" NightColor:@"#B0894F"];
        self.achL1.font = ELEVENTEXTFONTSIZE;
        [self.achBackView addSubview:self.achL1];
    }
    return self;
}

- (void)requestAch{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingTag=other&settingName=achievement_visibility",self.isOther?self.userId:[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeAbout *setM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            if (setM.setting_value.intValue == 1) {
                [self getAch];
            }else{
                self.achBackView.hidden = YES;
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)getAch{
    NSMutableArray *arr = [NSMutableArray new];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"%@/achievement",self.isOther?self.userId:[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict1, BOOL success1) {
        if (success1) {
            if ([dict1[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            for (NSDictionary *dic in dict1[@"data"]) {
                NoticeAchievementModel *model = [NoticeAchievementModel mj_objectWithKeyValues:dic];
                [arr addObject:model];
            }
            if (arr.count) {
                for (NoticeAchievementModel *achM in arr) {
                    if ([achM.achievement_type isEqualToString:@"1"]) {
                        self.achmentDate = achM;
                    }else if ([achM.achievement_type isEqualToString:@"2"]){
                        self.achmentSgj = achM;
                    }
                }
            }
            self.achBackView.hidden = NO;
            NSString *num = @"0";
            num = self.achmentDate.started_at.intValue? [NSString stringWithFormat:@"%.f",(self.achmentDate.latest_at_timeValue-self.achmentDate.started_at_timeValue)/86400+1] : @"0";
            if (self.achmentDate.latest_at_timeValue < self.achmentDate.yesterDay_timeValue) {//记录断掉显示当前记录为零
                num =  @"0";
            }
            self.achL1.text = [NSString stringWithFormat:@"连续记录%@天",num];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

//空事件，防止点击退出
- (void)noAction{
    
}

- (void)topicTap:(UITapGestureRecognizer *)tap{
    if (self.isOther) {
        if (_isJustFriend || !_topicArr) {
            return;
        }
    }

    UILabel *label = (UILabel *)tap.view;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (label.tag == 0) {
        if (_topicArr.count) {//有话题就跳转到话题
            //跳转到话题页面
            NoticeTopicModel *top1 = _topicArr[0];
            NoticeUserTopiceListController *ctl = [[NoticeUserTopiceListController alloc] init];
            ctl.topicId = top1.topic_id;
            ctl.topicName = top1.topic_name;
            ctl.navigationItem.title = top1.name;
            ctl.nickName = _userInfo.nick_name;
            ctl.userId = _userInfo.user_id;
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            ctl.isOther = self.isOther;
        }else if (!self.isOther){//无话题是自己主页就跳转的设置话题页面
            NoticeSetLikeTopicController *ctl = [[NoticeSetLikeTopicController alloc] init];
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];
        }
    }else if (label.tag == 1){
        if (_topicArr.count < 2) {
            return;
        }
        //跳转到话题页面
        NoticeTopicModel *top2 = _topicArr[1];
        NoticeUserTopiceListController *ctl = [[NoticeUserTopiceListController alloc] init];
        ctl.topicId = top2.topic_id;
        ctl.navigationItem.title = top2.name;
        ctl.nickName = _userInfo.nick_name;
        ctl.userId = _userInfo.user_id;
        ctl.isOther = self.isOther;
        ctl.topicName = top2.topic_name;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }else{
        if (_topicArr.count < 3) {
            return;
        }
        //跳转到话题页
        NoticeTopicModel *top3 = _topicArr[2];
        NoticeUserTopiceListController *ctl = [[NoticeUserTopiceListController alloc] init];
        ctl.topicId = top3.topic_id;
        ctl.topicName = top3.topic_name;
        ctl.navigationItem.title = top3.name;
        ctl.nickName = _userInfo.nick_name;
        ctl.userId = _userInfo.user_id;
        ctl.isOther = self.isOther;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)gotoIconTap{

    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:!self.isOther ? @[@"换头像",[NoticeTools getLocalStrWith:@"mineme.saveimg"]] : @[[NoticeTools getLocalStrWith:@"mineme.saveimg"]]];
    sheet.delegate = self;
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (buttonIndex == 1) {
        if (self.isOther) {
            [self.headerIimag.image saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
                [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"yl.baocsus"]];
            }];
            return ;
        }
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePicker.sortAscendingByModificationDate = false;
        imagePicker.allowPickingOriginalPhoto = false;
        imagePicker.alwaysEnableDoneBtn = true;
        imagePicker.allowPickingVideo = false;
        imagePicker.allowPickingGif = false;
        imagePicker.allowCrop = true;
        imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
        [nav.topViewController presentViewController:imagePicker animated:YES completion:nil];
        
    }else if(buttonIndex == 2){
        [self.headerIimag.image saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
            [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"yl.baocsus"]];
        
        }];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%9999678999];
            [self upLoadHeader:choiceImage path:filePath withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }else{
            [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""] withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }
    }];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path withDate:(NSString *)date{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"6" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
   
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:errorMessage forKey:@"avatarUri"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
             [nav.topViewController showHUDWithText:@"头像上传中..."];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success1) {
                [nav.topViewController hideHUD];
                if (success1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATION" object:nil];
                    self.headerIimag.image = image;
                }
            } fail:^(NSError *error) {
                [nav.topViewController hideHUD];
            }];
        }else{
            [nav.topViewController showToastWithText:errorMessage];
        }
    }];
}

- (void)setAboutM:(NoticeAbout *)aboutM{
    _aboutM = aboutM;
    NSString *hasHy = self.aboutM.friend_num.integerValue ? [NSString stringWithFormat:@"有%@个学友",self.aboutM.friend_num] : @"还没有和任何人成为学友";
    NSString *hasSx = self.aboutM.oring.integerValue ? (self.aboutM.oring.integerValue >= 300 ? [NSString stringWithFormat:@"记录了%@分钟回忆",self.aboutM.voice_total_lens] : [NSString stringWithFormat:@"记录了%@秒回忆",self.aboutM.voice_total_lens]) : @"还没有发布过心情";
    NSString *allStr = [NSString stringWithFormat:@"%@ %@",hasHy,hasSx];
    _markL.attributedText = [DDHAttributedMode setTwoColorString:allStr setColor:GetColorWithName(VMainThumeColor) setLengthString:aboutM.friend_num.integerValue? aboutM.friend_num : @"" beginSize:1 setLengthString1:aboutM.voice_total_lens.integerValue ? aboutM.voice_total_lens : @"" beginSize1:allStr.length-2-aboutM.voice_total_len.length];
}

- (void)setUserInfo:(NoticeUserInfoModel *)userInfo{
    _userInfo = userInfo;
    if ([_userInfo.identity_type isEqualToString:@"0"]) {
        self.markImage.hidden = YES;
    }else if ([_userInfo.identity_type  isEqualToString:@"1"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzy_img");
    }else{
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzy_img-1");
    }
    if ([userInfo.user_id isEqualToString:@"1"]) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_guanfang_b":@"Image_guanfang_y");
    }
    
    [_headerIimag sd_setImageWithURL:[NSURL URLWithString:self.userInfo.avatar_url]
                          placeholderImage:UIImageNamed(@"Image_jynohe")
                                   options:SDWebImageRefreshCached];
    _nameL.text = userInfo.nick_name;
    _numL.text = [NSString stringWithFormat:@"%@：%@",GETTEXTWITE(@"my.num"),userInfo.frequency_no];
}

- (void)setTopicArr:(NSMutableArray *)topicArr{
    _topicArr = topicArr;
    
    if (topicArr.count) {
        self.labelTopic1.textColor = GetColorWithName(VMainThumeColor);
    }else{
        self.contentView.frame = CGRectMake(0, 0,325, 430-23*2);
        self.labelTopic1.textColor = [NoticeTools getWhiteColor:@"#46cdcf" NightColor:@"#318f90"];
        self.labelTopic1.text = self.isOther ?([NoticeTools isSimpleLau]?@"ta还没有设置最喜欢的话题":@"ta還沒有設置最喜歡的話題"):([NoticeSaveModel isNounE]?([NoticeTools isSimpleLau]?@"设置你最喜欢的话题，让操场看到你":@"設置妳最喜歡的話題，讓操场看到妳") : ([NoticeTools isSimpleLau]?@"设置你最喜欢的话题，让同伴更懂你":@"設置妳最喜歡的話題，讓同伴更懂妳"));
    }
    if (topicArr.count == 1) {
       self.contentView.frame = CGRectMake(0, 0,325, 430-23*2);
        self.labelTopic1.text = [topicArr[0] name];
    }else if (topicArr.count == 2){
        self.contentView.frame = CGRectMake(0, 0,325, 430-23);
        self.labelTopic1.text = [topicArr[0] name];
        self.labelTopic2.text = [topicArr[1] name];
    }else if (topicArr.count == 3){
        self.contentView.frame = CGRectMake(0, 0,325, 430);
        self.labelTopic1.text = [topicArr[0] name];
        self.labelTopic2.text = [topicArr[1] name];
        self.labelTopic3.text = [topicArr[2] name];
    }
    self.contentView.center = self.center;
    self.achBackView.frame = CGRectMake(0, self.contentView.frame.size.height-85, self.contentView.frame.size.width, 85);
}

- (void)setIsJustFriend:(BOOL)isJustFriend{
    _isJustFriend = isJustFriend;
    self.labelTopic1.textColor = [NoticeTools getWhiteColor:@"#B2B2B2" NightColor:@"#3E3E4A"];
    self.labelTopic1.text = [NoticeTools getTextWithSim:@"ta设置了话题仅对学友可见" fantText:@"ta設置了話題僅對学友可見"];
}

- (void)setIsOtherNodata:(BOOL)isOtherNodata{
    _isOtherNodata = isOtherNodata;
    self.labelTopic1.textColor = [NoticeTools getWhiteColor:@"#B2B2B2" NightColor:@"#3E3E4A"];
    self.labelTopic1.text = [NoticeTools getTextWithSim:@"ta暂未设置最喜欢的话题" fantText:@"ta暫未設置最喜歡的話題"];
}

- (void)dissMiss{
    self.isShowing = NO;
    [self removeFromSuperview];
}

- (void)showTostView{
    self.isShowing = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.view addSubview:self];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.contentView.layer.position = self.center;
    self.contentView.transform = CGAffineTransformMakeScale(0.20, 0.20);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)showTostViewAnmtion{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController.view addSubview:self];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}
@end
