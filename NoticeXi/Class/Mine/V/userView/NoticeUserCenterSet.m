//
//  NoticeUserCenterSet.m
//  NoticeXi
//
//  Created by li lei on 2019/12/18.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserCenterSet.h"
#import "NoticeCustumButton.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeUserCenterSet

{
    UILabel *_titleL;
    UIButton *_saveBtn;
    UILabel *_subTitleL1;
    UILabel *_subTitleL2;
    UILabel *_subTitleL3;
    UILabel *_subTitleL4;
    NoticeCustumButton *_mbBtn1;
    NoticeCustumButton *_mbBtn2;
    NoticeCustumButton *_sgjBtn1;
    NoticeCustumButton *_sgjBtn2;
    NSMutableArray *_buttonArr2;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+15, DR_SCREEN_WIDTH, 23)];
        titleL.font = TWOThretyTEXTFONTSIZE;
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#999999":@"#b2b2b2"];
        titleL.text = [NoticeTools getTextWithSim:@"心情簿封面设置" fantText:@"心情簿封面設置"];
        _titleL = titleL;
        [self addSubview:titleL];
        
        //封面图亮度
        _subTitleL1 = [[UILabel alloc] initWithFrame:CGRectMake(33, CGRectGetMaxY(_titleL.frame)+20, DR_SCREEN_WIDTH-15-33, 17)];
        _subTitleL1.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#999999":@"#72727f"];
        _subTitleL1.text = [NoticeTools getTextWithSim:@"封面图亮度" fantText:@"封面圖亮度"];
        [self addSubview:_subTitleL1];
        
        for (int i = 0; i < 2; i++) {
            NoticeCustumButton *mbBtn = [[NoticeCustumButton alloc] initWithFrame:CGRectMake(i == 0? _subTitleL1.frame.origin.x+10:208, CGRectGetMaxY(_subTitleL1.frame)+10, 22+GET_STRWIDTH(@"原图亮度", 17, 17), 17+20)];
            mbBtn.imageView.frame = CGRectMake(0, 24/2, 14, 14);
            mbBtn.imageView.layer.cornerRadius = 7;
            mbBtn.imageView.layer.masksToBounds = YES;
            mbBtn.label.frame = CGRectMake(22, 0, GET_STRWIDTH(@"原图亮度", 17, 17), 17+20);
            mbBtn.label.font = SEVENTEENTEXTFONTSIZE;
            [self addSubview:mbBtn];
            mbBtn.userInteractionEnabled = YES;
            mbBtn.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceMbTap:)];
            [mbBtn addGestureRecognizer:tap];
            if (i == 0) {
                mbBtn.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#72727f"];
                mbBtn.imageView.backgroundColor = GetColorWithName(VMainThumeColor);
                _mbBtn1 = mbBtn;
            }else{
                mbBtn.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#3E3E4A"];
                mbBtn.imageView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#DDDDDD":@"#3E3E4A"];
                _mbBtn2 = mbBtn;
            }
        }
        
        //氛围
        _subTitleL2 = [[UILabel alloc] initWithFrame:CGRectMake(33, CGRectGetMaxY(_subTitleL1.frame)+55, DR_SCREEN_WIDTH-15-33, 17)];
        _subTitleL2.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#999999":@"#72727f"];
        _subTitleL2.text = [NoticeTools getTextWithSim:@"封面图气氛" fantText:@"封面圖氣氛"];
        [self addSubview:_subTitleL2];
        
        _buttonArr2 = [NSMutableArray new];
        
        for (int j = 0; j < 3; j++) {
            NoticeCustumButton *button = [[NoticeCustumButton alloc] initWithFrame:CGRectMake(_subTitleL1.frame.origin.x+10+(37+73)*j, CGRectGetMaxY(_subTitleL2.frame)+10,37,37)];
            button.tag = j;
            button.imageView.frame = CGRectMake(0, 23/2, 14, 14);
            button.imageView.layer.cornerRadius = 7;
            button.imageView.layer.masksToBounds = YES;
            button.label.frame = CGRectMake(22, 0, 17, 37);
            button.label.font = SEVENTEENTEXTFONTSIZE;
            
            if (j == 0) {
                button.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#72727f"];
                button.imageView.backgroundColor = GetColorWithName(VMainThumeColor);
            }else{
                button.imageView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#DDDDDD":@"#3E3E4A"];
                button.label.textColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#3E3E4A"];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLL:)];
            [button addGestureRecognizer:tap];
            [self addSubview:button];
            [_buttonArr2 addObject:button];
        }
        
        for (int k = 0; k < 3; k++) {
            NoticeCustumButton *button = [[NoticeCustumButton alloc] initWithFrame:CGRectMake(_subTitleL1.frame.origin.x+10+(37+73)*k, CGRectGetMaxY(_subTitleL2.frame)+10+37,37,37)];
            button.tag = k+3;
            button.imageView.frame = CGRectMake(0, 23/2, 14, 14);
            button.imageView.layer.cornerRadius = 7;
            button.imageView.layer.masksToBounds = YES;
            button.label.frame = CGRectMake(22, 0, 17, 37);
            button.label.font = SEVENTEENTEXTFONTSIZE;
            button.imageView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#DDDDDD":@"#3E3E4A"];
            button.label.textColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#3E3E4A"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLL:)];
            [button addGestureRecognizer:tap];
            [self addSubview:button];
            [_buttonArr2 addObject:button];
        }
        
        //迷你时光机
        _subTitleL3 = [[UILabel alloc] initWithFrame:CGRectMake(33, CGRectGetMaxY(_subTitleL2.frame)+10+37+37+10, DR_SCREEN_WIDTH-15-33, 17)];
        _subTitleL3.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#999999":@"#72727f"];
        [self addSubview:_subTitleL3];
        
        for (int i = 0; i < 2; i++) {
            NoticeCustumButton *mbBtn = [[NoticeCustumButton alloc] initWithFrame:CGRectMake(i == 0? _subTitleL1.frame.origin.x+10:230, CGRectGetMaxY(_subTitleL3.frame)+10, 22+ (i == 0 ? 135:67), 17+20)];
            mbBtn.imageView.frame = CGRectMake(0, 23/2, 14, 14);
            mbBtn.imageView.layer.cornerRadius = 7;
            mbBtn.imageView.layer.masksToBounds = YES;
            mbBtn.label.frame = CGRectMake(22, 0, i == 0 ? 135 : 67, 17+20);
            mbBtn.label.font = SIXTEENTEXTFONTSIZE;
            [self addSubview:mbBtn];
            mbBtn.userInteractionEnabled = YES;
            mbBtn.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choicesgjTap:)];
            [mbBtn addGestureRecognizer:tap];
            if (i == 0) {
                mbBtn.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#72727f"];
                mbBtn.imageView.backgroundColor = GetColorWithName(VMainThumeColor);
                _sgjBtn1 = mbBtn;
            }else{
                mbBtn.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#3E3E4A"];
                mbBtn.imageView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#DDDDDD":@"#3E3E4A"];
                _sgjBtn2 = mbBtn;
            }
        }
        
        //相册
        _subTitleL4 = [[UILabel alloc] initWithFrame:CGRectMake(33, CGRectGetMaxY(_subTitleL3.frame)+20+37, DR_SCREEN_WIDTH-15-33, 17)];
        _subTitleL4.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#999999":@"#72727f"];
        [self addSubview:_subTitleL4];

        //1.初始化layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //layout.naviHeight = NAVIGATION_BAR_HEIGHT;
        // 设置列的最小间距
        layout.minimumInteritemSpacing = 0;
        // 设置最小行间距
        layout.minimumLineSpacing = 0;
        self.layout = layout;
        
        //2.初始化collectionView
        _merchantCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_subTitleL4.frame.origin.x,CGRectGetMaxY(_subTitleL4.frame)+20, 70*4+30,220) collectionViewLayout:self.layout];
        _merchantCollectionView.dataSource = self;
        _merchantCollectionView.delegate = self;
        _merchantCollectionView.showsVerticalScrollIndicator = NO;
        _merchantCollectionView.showsHorizontalScrollIndicator = NO;
        [_merchantCollectionView registerClass:[NoticePhotoCell class] forCellWithReuseIdentifier:@"CollectionViewCellID"];
        _merchantCollectionView.backgroundColor = GetColorWithName(VBackColor);
        [self addSubview:_merchantCollectionView];
        
        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-102)/2, frame.size.height-20-40-BOTTOM_HEIGHT, 102, 40)];
        saveButton.layer.cornerRadius = 20;
        saveButton.layer.masksToBounds = YES;
        saveButton.backgroundColor = GetColorWithName(VMainThumeColor);
        [saveButton setTitle:[NoticeTools getLocalStrWith:@"groupManager.save"] forState:UIControlStateNormal];
        [saveButton setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        saveButton.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
        [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn = saveButton;
        [self addSubview:saveButton];
        
        [self show];
    }
    return self;
}

- (void)setAobut:(NoticeAbout *)aobut{
    _aobut = aobut;
    if ([_aobut.cover_brightness isEqualToString:@"2"]) {//原图亮度
        _mbBtn2.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#72727f"];
        _mbBtn2.imageView.backgroundColor = GetColorWithName(VMainThumeColor);
        _mbBtn1.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#3E3E4A"];
        _mbBtn1.imageView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#DDDDDD":@"#3E3E4A"];
    }else{
        _mbBtn1.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#72727f"];
        _mbBtn1.imageView.backgroundColor = GetColorWithName(VMainThumeColor);
        _mbBtn2.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#3E3E4A"];
        _mbBtn2.imageView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#DDDDDD":@"#3E3E4A"];
    }
    
    if (!_aobut.cover_efficacy.integerValue) {//氛围
        _aobut.cover_efficacy = @"0";
    }
    for (NoticeCustumButton *allV in self->_buttonArr2) {
        if (allV.tag == _aobut.cover_efficacy.integerValue) {
            allV.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#72727f"];
            allV.imageView.backgroundColor = GetColorWithName(VMainThumeColor);
        }else{
            allV.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#3E3E4A"];
            allV.imageView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#DDDDDD":@"#3E3E4A"];
        }
    }
    
    if ([_aobut.minimachine_visibility isEqualToString:@"2"]) {//迷你时光机
        _sgjBtn2.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#72727f"];
        _sgjBtn2.imageView.backgroundColor = GetColorWithName(VMainThumeColor);
        _sgjBtn1.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#3E3E4A"];
        _sgjBtn1.imageView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#DDDDDD":@"#3E3E4A"];
    }else{
        _sgjBtn1.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#72727f"];
        _sgjBtn1.imageView.backgroundColor = GetColorWithName(VMainThumeColor);
        _sgjBtn2.label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#3E3E4A"];
        _sgjBtn2.imageView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#DDDDDD":@"#3E3E4A"];
    }
}

//下雨下雪切换
- (void)changeLL:(UITapGestureRecognizer *)tap{
    NoticeCustumButton *tapV = (NoticeCustumButton *)tap.view;

    BaseNavigationController *nav = nil;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setValue:@"moodbook" forKey:@"settingTag"];
    [parm setValue:@"cover_efficacy" forKey:@"settingName"];
    [parm setValue:[NSString stringWithFormat:@"%ld",(long)tapV.tag] forKey:@"settingValue"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self.aobut.cover_efficacy = [NSString stringWithFormat:@"%ld",(long)tapV.tag];
            [NoticeSaveModel saveSetCenter:self.aobut];
            self.aobut = self.aobut;
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
    
}

- (void)choiceMbTap:(UITapGestureRecognizer *)tap{
    NoticeCustumButton *mbB = (NoticeCustumButton *)tap.view;
    
    BaseNavigationController *nav = nil;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setValue:@"moodbook" forKey:@"settingTag"];
    [parm setValue:@"cover_brightness" forKey:@"settingName"];
    [parm setValue:mbB.tag == 0 ? @"1":@"2" forKey:@"settingValue"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self.aobut.cover_brightness = mbB.tag == 0 ? @"1":@"2";
            [NoticeSaveModel saveSetCenter:self->_aobut];
            self.aobut = self.aobut;
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];

}

- (void)choicesgjTap:(UITapGestureRecognizer *)tap{
    NoticeCustumButton *mbB = (NoticeCustumButton *)tap.view;
    
    BaseNavigationController *nav = nil;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setValue:@"moodbook" forKey:@"settingTag"];
    [parm setValue:@"minimachine_visibility" forKey:@"settingName"];
    [parm setValue:mbB.tag == 0 ? @"1":@"2" forKey:@"settingValue"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self.aobut.minimachine_visibility = mbB.tag == 0 ? @"1":@"2";
            [NoticeSaveModel saveSetCenter:self->_aobut];
            self.aobut = self.aobut;
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
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
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99999999999];
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
    
    BaseNavigationController *nav = nil;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"23" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"moodbook_cover" forKey:@"coverName"];
            [parm setObject:Message forKey:@"coverUri"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/covers",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success2) {
                [nav.topViewController hideHUD];
                if (success2) {
                    NoticeCoverModel *covverM = [NoticeCoverModel mj_objectWithKeyValues:dict[@"data"]];
                    [self.dataArr addObject:covverM];
                    [self.merchantCollectionView reloadData];
                    [nav.topViewController showToastWithText:@"上传封面成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresCoverNotice" object:nil];
                }
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
            
        }else{
            [nav.topViewController hideHUD];
        }
    }];
}

//删除封面
- (void)delegateImageAt:(NSInteger)index{
    BaseNavigationController *nav = nil;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/covers/%@",[NoticeTools getuserId],[self.dataArr[index] coverId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [self.dataArr removeObjectAtIndex:index];
            [self.merchantCollectionView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresCoverNotice" object:nil];
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count == 0 || indexPath.row == self.dataArr.count) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            imagePicker.sortAscendingByModificationDate = false;
            imagePicker.allowPickingOriginalPhoto = false;
            imagePicker.alwaysEnableDoneBtn = true;
            imagePicker.allowPickingVideo = false;
            imagePicker.allowPickingGif = false;
            imagePicker.allowCrop = true;
            imagePicker.cropRect = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-BOTTOM_HEIGHT-3);
            [nav.topViewController presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticePhotoCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellID" forIndexPath:indexPath];
    merchentCell.imageCellView.userInteractionEnabled = YES;
    merchentCell.index = indexPath.row;
    merchentCell.delegate = self;
    merchentCell.isUserSet = YES;
    merchentCell.delegteButton.hidden = NO;
    if (!self.dataArr.count) {
        merchentCell.imageCellView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_setCenter":@"Image_setCentery");
        merchentCell.imageCellView.userInteractionEnabled = NO;
        merchentCell.delegteButton.hidden = YES;
    }else{
        if (indexPath.row < self.dataArr.count) {
            merchentCell.coverModel = self.dataArr[indexPath.row];
        }else{
            merchentCell.imageCellView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_setCenter":@"Image_setCentery");
            merchentCell.imageCellView.userInteractionEnabled = NO;
            merchentCell.delegteButton.hidden = YES;
        }
    }
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (self.dataArr.count == 8) {
        return self.dataArr.count;
    }
    return self.dataArr.count+1;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(70,105);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)show{

    _subTitleL4.text = [NoticeTools getTextWithSim:@"封面相册(上传多张时每次随机展示)" fantText:@"封面相冊(上傳多張時每次隨機展示)"];
    
    _sgjBtn1.label.text = [NoticeTools getTextWithSim:@"仅自己和学友可见" fantText:@"僅自己和学友可見"];
    _sgjBtn2.label.text = [NoticeTools getTextWithSim:@"他人可见" fantText:@"他人可見"];
    _subTitleL3.text = [NoticeTools getTextWithSim:@"迷你时光机" fantText:@"迷妳時光機"];
    
    _subTitleL2.text = [NoticeTools getTextWithSim:@"封面图气氛" fantText:@"封面圖氣氛"];
    NSArray *titl2 = @[[NoticeTools isSimpleLau] ?@"无":@"無",@"雨",@"雪",[NoticeTools isSimpleLau] ?@"叶":@"葉",@"花",[NoticeTools isWhiteTheme]?@"枫":@"楓"];
    for (int j = 0; j < _buttonArr2.count; j++) {
        NoticeCustumButton *button = _buttonArr2[j];
        button.label.text = titl2[j];
    }
    
    _subTitleL1.text = [NoticeTools getTextWithSim:@"封面图亮度" fantText:@"封面圖亮度"];
    _titleL.text = [NoticeTools getTextWithSim:@"心情簿封面设置" fantText:@"心情簿封面設置"];
    _mbBtn1.label.text = [NoticeTools getTextWithSim:@"稍稍调低" fantText:@"稍稍調低"];
    _mbBtn2.label.text = [NoticeTools getTextWithSim:@"原图亮度" fantText:@"原圖亮度"];
}

- (void)saveClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backClick)]) {
        [self.delegate backClick];
    }
}


@end
