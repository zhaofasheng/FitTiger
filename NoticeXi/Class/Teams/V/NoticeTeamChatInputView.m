//
//  NoticeTeamChatInputView.m
//  NoticeXi
//
//  Created by li lei on 2023/6/2.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamChatInputView.h"
#import "UIView+CLSetRect.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "YYPersonItem.h"
#import "YYTextAttachmentManager.h"
#import "NSAttributedString+YY.h"

@implementation NoticeTeamChatInputView
{
    CGFloat kebordHeight;
    
    UIView *_bottomV;
    UIVisualEffectView *effectView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
                
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
                
        CGFloat space = (DR_SCREEN_WIDTH-30-24*4)/5;
        UIButton *recrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(15+space, self.frame.size.height-15-24, 24, 24)];
        [recrderBtn setImage:UIImageNamed(@"teamRecoderImg") forState:UIControlStateNormal];
        [self addSubview:recrderBtn];
        [recrderBtn addTarget:self action:@selector(recodClick) forControlEvents:UIControlEventTouchUpInside];
        self.recoderBtn = recrderBtn;
        
        self.emtionBtn = [[UIButton alloc] initWithFrame:CGRectMake(space*2+24+15, self.frame.size.height-15-24, 24, 24)];
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        [self.emtionBtn addTarget:self action:@selector(emtionClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.emtionBtn];
        
        self.imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(space*3+24*2+15, self.frame.size.height-15-24, 24, 24)];
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        [self.imgBtn addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.imgBtn];
        
        UIButton *pzBtn = [[UIButton alloc] initWithFrame:CGRectMake(space*4+24*3+15, self.frame.size.height-15-24, 24, 24)];
        [pzBtn setImage:UIImageNamed(@"teampzBtnImg") forState:UIControlStateNormal];
        [self addSubview:pzBtn];
        [pzBtn addTarget:self action:@selector(pzBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.pzBtn = pzBtn;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
        
        self.contentView = [[NoticeTeamTextView alloc] initWithFrame:CGRectMake(15,8, DR_SCREEN_WIDTH-30, 34)];
        self.contentView.tintColor = GetColorWithName(VMainThumeColor);
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.delegate = self;
        self.contentView.font = FIFTHTEENTEXTFONTSIZE;
        self.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 8;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.contentView];
        self.contentView.returnKeyType = UIReturnKeySend;
        
        self.plaStr = @"输入文字";
        _plaL = [[UILabel alloc] initWithFrame:CGRectMake(27,7, 200, 34)];
        _plaL.text = self.plaStr;
        _plaL.font = FOURTHTEENTEXTFONTSIZE;
        _plaL.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        [self addSubview:_plaL];
    }
    return self;
}

- (void)refreshButtonFrame{
    self.recoderBtn.frame = CGRectMake(self.recoderBtn.frame.origin.x, self.frame.size.height-15-24, 24, 24);
    self.emtionBtn.frame = CGRectMake(self.emtionBtn.frame.origin.x, self.frame.size.height-15-24, 24, 24);
    self.imgBtn.frame = CGRectMake(self.imgBtn.frame.origin.x, self.frame.size.height-15-24, 24, 24);
    self.pzBtn.frame = CGRectMake(self.pzBtn.frame.origin.x, self.frame.size.height-15-24, 24, 24);
}

- (void)regFirst{
    
    [self.contentView resignFirstResponder];

    if (self.imgOpen) {
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
        self.imgOpen = NO;
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
    }
    
    if (self.emotionOpen) {
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
        self.emotionOpen = NO;
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
    }
}

- (NoticeScroEmtionView *)emotionView{
    if (!_emotionView) {
        _emotionView  = [[NoticeScroEmtionView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+15)];
        _emotionView.backgroundColor = self.backgroundColor;
        __weak typeof(self) weakSelf = self;
        _emotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
            
            if (weakSelf.emtionBlock) {
                weakSelf.emtionBlock(url, buckId, pictureId, isHot);
            }
            [weakSelf emtionClick];
        };

        [[NoticeTools getTopViewController].view addSubview:_emotionView];
    }
    return _emotionView;
}


- (NoticeChocieImgListView *)imgListView{
    if (!_imgListView) {
        __weak typeof(self) weakSelf = self;
        _imgListView = [[NoticeChocieImgListView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+15)];
        _imgListView.limitNum = 1;
        _imgListView.didSelectPhotosMBlock = ^(NSMutableArray * _Nonnull photoArr) {
            
            [weakSelf sendImagePhoto:photoArr];
            [weakSelf imgClick];
        };
        [[NoticeTools getTopViewController].view addSubview:_imgListView];
    }
    return _imgListView;
}

- (UIImagePickerController *)imagePickerController{
    if (_imagePickerController==nil) {
        _imagePickerController=[[UIImagePickerController alloc]init];
        _imagePickerController.delegate = (id)self;
        _imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        [mediaTypes addObject:(NSString *)kUTTypeImage];
        _imagePickerController.mediaTypes= mediaTypes;
    }
    return _imagePickerController;
}


- (void)sendImagePhoto:(NSMutableArray *)photoArr{
    if (!photoArr.count) {
        return;
    }
    PHAsset *asset = photoArr[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if ([[TZImageManager manager] getAssetType:asset] == TZAssetModelMediaTypePhotoGif) {//如果是gif图片
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!imageData) {
                [[NoticeTools getTopViewController] showToastWithText:@"获取文件失败"];
                return ;
            }
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%9999999996];
            [self upLoadHeader:imageData path:[NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]]];
        }];
    }else{
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!imageData) {
                [[NoticeTools getTopViewController] showToastWithText:@"获取文件失败"];
                return ;
            }
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999];
            NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]];
            [self upLoadHeader:UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0.6) path:pathMd5];
            ;
        }];
    }
}

- (void)pzBtnClick{
    [self regFirst];
    if(self.startRecoderOrPzStopPlayBlock){
        self.startRecoderOrPzStopPlayBlock(YES);
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        [[NoticeTools getTopViewController] showToastWithText:@"您没有开启相机权限哦~，您可以在手机系统设置开启"];
    } else{
        //判断是否支持相机
          if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
              [[NoticeTools getTopViewController] presentViewController:self.imagePickerController animated:YES completion:nil];
          }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {

        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (photo) {
            __weak typeof(self) weakSelf = self;
            [[TZImageManager manager] savePhotoWithImage:photo location:nil completion:^(PHAsset *asset, NSError *error){
                if (!error) {
                    [weakSelf.photoArr removeAllObjects];
                    [weakSelf.photoArr addObject:asset];
                    [weakSelf sendImagePhoto:weakSelf.photoArr];
                }
            }];
        }
    }
}

- (NSMutableArray *)photoArr{
    if(!_photoArr){
        _photoArr = [[NSMutableArray alloc] init];
    }
    return _photoArr;
}

- (void)recodClick{
    [self regFirst];
    if(self.startRecoderOrPzStopPlayBlock){
        self.startRecoderOrPzStopPlayBlock(YES);
    }
    __weak typeof(self) weakSelf = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) { // 有使用麦克风的权限
                [weakSelf recoders];
            }else { // 没有麦克风权限
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.kaiqire"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"recoder.kaiqi"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 1) {
                        UIApplication *application = [UIApplication sharedApplication];
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([application canOpenURL:url]) {
                            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                if (@available(iOS 10.0, *)) {
                                    [application openURL:url options:@{} completionHandler:nil];
                                }
                            } else {
                                [application openURL:url options:@{} completionHandler:nil];
                            }
                        }
                    }
                };
                [alerView showXLAlertView];
            }
        });
    }];
}

- (void)imgClick{
    
    if(![[TZImageManager manager] authorizationStatusAuthorized]){//没有相册权限
        [[NoticeTools getTopViewController] showToastWithText:@"您没有开启相册权限哦~ 到系统设置里面开启相册权限即可使用"];
        return;
    }

    [self.contentView resignFirstResponder];
    
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    }

    if (self.imgOpen) {
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
            if (self.orignYBlock) {
                self.orignYBlock(self.frame.origin.y);
            }
        }];

    }else{
   
        [self.imgListView refreshImage];
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.imgListView.frame.size.height-self.frame.size.height, DR_SCREEN_WIDTH,self.frame.size.height);
            self.imgListView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.imgListView.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
            if (self.orignYBlock) {
                self.orignYBlock(self.frame.origin.y);
            }
        }];
        [self.imgBtn setImage:UIImageNamed(@"Image_openimgpri") forState:UIControlStateNormal];
    }
    self.imgOpen = !self.imgOpen;

}

- (void)emtionClick{
    
    [self.contentView resignFirstResponder];
    
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    }
    
    if (self.emotionOpen) {
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
     
        [UIView animateWithDuration:0.5 animations:^{
  
            self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
            if (self.orignYBlock) {
                self.orignYBlock(self.frame.origin.y);
            }
        }];

    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.emotionView.frame.size.height-self.frame.size.height, DR_SCREEN_WIDTH,self.frame.size.height);
            self.emotionView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.emotionView.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
            if (self.orignYBlock) {
                self.orignYBlock(self.frame.origin.y);
            }
        }];
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_sb") forState:UIControlStateNormal];
    }
    self.emotionOpen = !self.emotionOpen;

}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
    }
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
    }

    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.frame.size.height, DR_SCREEN_WIDTH, self.frame.size.height);
    self.isresiger = NO;
    
    kebordHeight = keyboardF.size.height;

    _bottomV.hidden = YES;
    if (self.orignYBlock) {
        self.orignYBlock(self.frame.origin.y);
    }
    if(self.replyMsgModel){
        self.replayView.frame = CGRectMake(0, self.frame.origin.y-40, DR_SCREEN_WIDTH, 40);
    }
}

- (void)keyboardDiddisss{
    _bottomV.hidden = NO;
    self.isresiger = YES;

    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    kebordHeight = 0;
    if (self.orignYBlock) {
        self.orignYBlock(self.frame.origin.y);
    }
    if(self.replyMsgModel){
        self.replayView.frame = CGRectMake(0, self.frame.origin.y-40, DR_SCREEN_WIDTH, 40);
    }
}

- (void)sendClick{
    NSString *str = [YYTextAttachmentManager attributedStringToString:self.contentView.attributedText];
    if(!str || !str.length){
        return;
    }
    if (self.sendTextBlock) {
        if(self.currentSelectedPersonItems.count){//是否有艾特人
            NSMutableArray *atPrsons = [[NSMutableArray alloc] init];
            for (YYPersonItem *person in self.currentSelectedPersonItems) {
                [atPrsons addObject:person.userId];
            }
            self.sendTextBlock(str, self.replyMsgModel, [NoticeTools arrayToJSONString:atPrsons]);
        }else{
            self.sendTextBlock(str,self.replyMsgModel,nil);
        }
        
    }
    if(self.saveKey){
        [NoticeComTools removeWithKey:self.saveKey];
    }
    self.contentView.text = @"";
    [self textViewDidChangeSelection:self.contentView];
    if(self.replyMsgModel){
        self.replyMsgModel = nil;
        self.replayView.hidden = YES;
    }
}

- (void)requestPerson{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"mass/member/%@",self.teamModel.teamId] Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            self.atPersonView.syArr = [[NSMutableArray alloc] init];
            YYPersonItem *allData = [YYPersonItem mj_objectWithKeyValues:dict[@"data"]];
            [self.personArr  removeAllObjects];
            if(allData.administrators.count){
                YYPersonItem *adminItem = [[YYPersonItem alloc] init];
                adminItem.title = @"超级管理员";
                [self.personArr addObject:adminItem];
                [self.atPersonView.syArr addObject:@"管"];
                for (NSDictionary *dic in allData.administrators) {
                    YYPersonItem *personItem = [YYPersonItem mj_objectWithKeyValues:dic];
                    [adminItem.personArr addObject:personItem];
                }
            }
   
            for (NSDictionary *dic in allData.members) {
                YYPersonItem *personItem = [YYPersonItem mj_objectWithKeyValues:dic];
                [self.personArr addObject:personItem];
                [self.atPersonView.syArr addObject:personItem.title];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)remvokUserId:(NSString *)userId{
    for (YYPersonItem *item in self.personArr) {
        for (YYPersonItem *person in item.personArr) {
            if([person.userId isEqualToString:userId]){
                [item.personArr removeObject:person];
                [self.atPersonView.tableView reloadData];
                [self.atPersonView remvokUserId:userId];
                break;
            }
        }
    }
    
}

- (void)refreshManageUserId:(NSString *)userId{
    for (YYPersonItem *item in self.personArr) {
        for (YYPersonItem *person in item.personArr) {
            if([person.userId isEqualToString:userId]){
                person.identity = @"1";
                [self.atPersonView.tableView reloadData];
                break;
            }
        }
    }
}

- (void)presentPersonListViewController {
    if(!self.personArr.count){
        return;
    }
    [self regFirst];
    __weak typeof(self) weakSelf = self;
    
    self.atPersonView.dataArr = self.personArr;
    self.atPersonView.atBlock = ^(NSMutableArray * _Nonnull atArrary) {
        [weakSelf.contentView becomeFirstResponder];
        if(!atArrary.count){
            return;
        }
        for (YYPersonItem *person in atArrary) {//艾特的人转成图片显示在输入框
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:weakSelf.contentView.font.pointSize]};
            NSMutableArray *currentSelectedPersonItems = [[weakSelf.contentView.attributedText getCurrentAtPersonItems] mutableCopy];
            [currentSelectedPersonItems addObject:person];//这里可以判断去重...（根据自己需求情况而定）

            //将人的名字转化为NSTextAttachment
            [[YYTextAttachmentManager getInstance] transformTextWithTextView:weakSelf.contentView tickedPersonItems:currentSelectedPersonItems atAllPersons:nil canRepeat:NO needBack:weakSelf.needBack color:[UIColor colorWithHexString:@"#0099E6"] attributes:attributes completeBlock:^(NSMutableAttributedString *mutableAttributedString, NSRange selectedRange) {
                weakSelf.needBack = NO;
                weakSelf.contentView.attributedText = mutableAttributedString;
                weakSelf.contentView.selectedRange = selectedRange;
                [weakSelf textViewDidChange:weakSelf.contentView];
                [weakSelf textViewDidChangeSelection:weakSelf.contentView];
            }];
        }
    };
    [self.atPersonView showATView];
}

- (void)setSaveKey:(NSString *)saveKey{
    _saveKey = saveKey;
    if(saveKey){
     
        NSString *saveContent = [NoticeComTools getInputWithKey:saveKey];
        if(saveContent && saveContent.length){
            self.contentView.text = saveContent;
        }
    }
}

//发送文案的时候，最终是从这里获取当前选中的人员
- (void)textViewDidChange:(UITextView *)textView {
    self.currentSelectedPersonItems = [NSMutableArray arrayWithArray:[self.contentView.attributedText getCurrentAtPersonItems]];

    //获取高亮部分
    UITextPosition * position = [textView positionFromPosition:textView.markedTextRange.start offset:0];
    if(!position){
        if(self.saveKey){
            [NoticeComTools saveInput:textView.text saveKey:self.saveKey];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"@"]) {
        
        if (range.length > 0) {
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text];
            [self.contentView.textStorage replaceCharactersInRange:range withAttributedString:attributedString];
        }
        
        self.needBack = YES; //需要将手动输入的@删除
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentPersonListViewController];
        });
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [self sendClick];
        return NO;
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (textView.text.length) {
        _plaL.text = @"";
    }else{
        _plaL.text = self.plaStr;
    }
    CGRect frame = textView.frame;
    
    NSInteger num = 3000;

    if (textView.text.length > num) {
        textView.text = [textView.text substringToIndex:num];
    }
    float height;
    height = [self heightForTextView:textView WithText:[YYTextAttachmentManager attributedStringToString:self.contentView.attributedText]];
    if (height > 120) {
        height = 120;
    }
    if (height <= 35) {
        height = 36;
    }
    frame.size.height = height;

    if (self.contentView.needBackOldPoint) {
        self.contentView.selectedRange = self.contentView.oldRange;
        self.contentView.needBackOldPoint= NO;
    }
    if (self.isresiger) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-(57+height)-self->kebordHeight, DR_SCREEN_WIDTH,57+height);
        if(self.replyMsgModel){
            self.replayView.frame = CGRectMake(0, self.frame.origin.y-40, DR_SCREEN_WIDTH, 40);
        }
        
        self.contentView.frame = CGRectMake(15,8, DR_SCREEN_WIDTH-30, height);
        [self refreshButtonFrame];
        if (self.orignYBlock) {
            self.orignYBlock(self.frame.origin.y);
        }
    } completion:nil];
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height+(size.size.height>36?10:0)+5;
    return textHeight;
}

- (void)recoders{
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    recodeView.isSayToSelf = YES;
    recodeView.hideCancel = NO;
    recodeView.noPushLeade = YES;
    recodeView.isReply = YES;
    recodeView.delegate = self;
    recodeView.startRecdingNeed = YES;
    [recodeView show];
}

- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    [self sendTime:timeLength path:locaPath];
}


//发送音频
- (void)sendTime:(NSString *)time path:(NSString *)path{

    if (!path) {
        [[NoticeTools getTopViewController] showToastWithText:@"文件不存在"];
        return;
    }


    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,path]],[path pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"89" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];
    
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:path parm:parm1 progressHandler:^(CGFloat progress) {
      
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId,BOOL sussess) {
        if (sussess) {
            if(self.uploadVoiceBlock){
                self.uploadVoiceBlock(path, time, Message, YES,bucketId);
            }
            [[NoticeTools getTopViewController] hideHUD];
        } else{
            if(self.uploadVoiceBlock){
                self.uploadVoiceBlock(path, time, @"", NO,@"");
            }
            [[NoticeTools getTopViewController] hideHUD];
            [[NoticeTools getTopViewController] showToastWithText:Message];
        }
    }];
}

//发送图片
- (void)upLoadHeader:(NSData *)image path:(NSString * __nullable)path{
    if (!path) {
        path = [NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"88" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    [[NoticeTools getTopViewController] showHUD];
    [[XGUploadDateManager sharedManager] uploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            if(self.uploadimgBlock){
                self.uploadimgBlock(image, errorMessage, YES, bucketId);
            }

            [[NoticeTools getTopViewController] hideHUD];
            
        }else{
            if(self.uploadimgBlock){
                self.uploadimgBlock(image, @"", NO, @"");
            }
            [[NoticeTools getTopViewController] showToastWithText:errorMessage];
            [[NoticeTools getTopViewController] hideHUD];
            
        }
    }];
}

- (void)replyMsg{
    if(self.replyMsgModel.contentType == 1){
        self.replayView.replyLabel.text = [NSString stringWithFormat:@"%@：%@",self.replyMsgModel.fromUserM.mass_nick_name,self.replyMsgModel.content];
    }else{
        self.replayView.replyLabel.text = [NSString stringWithFormat:@"%@：%@",self.replyMsgModel.fromUserM.mass_nick_name,self.replyMsgModel.contentType==2?@"「图片」":@"「语音」"];
    }
    self.replayView.hidden = NO;
    [self.contentView becomeFirstResponder];
}

- (NoticeTeamRpelyView *)replayView{
    if(!_replayView){
        _replayView = [[NoticeTeamRpelyView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y-40, DR_SCREEN_WIDTH, 40)];
        __weak typeof(self) weakSelf = self;
        _replayView.closeUseBlock = ^(BOOL close) {
            weakSelf.replyMsgModel = nil;
            weakSelf.replayView.hidden = YES;
        };
        [self.superview addSubview:_replayView];
        [self.superview bringSubviewToFront:_replayView];
    }
    return _replayView;
}

- (NSMutableArray *)personArr{
    if(!_personArr){
        _personArr = [[NSMutableArray alloc] init];
    }
    return _personArr;
}

- (NoticeAtTeamsListView *)atPersonView{
    if(!_atPersonView){
        _atPersonView = [[NoticeAtTeamsListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        
    }
    return _atPersonView;
}
@end
