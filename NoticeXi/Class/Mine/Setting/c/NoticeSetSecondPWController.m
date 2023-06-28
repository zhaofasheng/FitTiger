//
//  NoticeSetSecondPWController.m
//  NoticeXi
//
//  Created by li lei on 2020/4/1.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeSetSecondPWController.h"
#import "CustomPickerView.h"
#import "JPUSHService.h"
#import "AppDelegate+Notification.h"
#import "NoticeSCViewController.h"
#import "NoticeCoverModel.h"
@interface NoticeSetSecondPWController ()<MyPickerViewDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *pwButton;
@property (nonatomic, strong) UILabel *passwordL;
@property (nonatomic, strong) UIImage *changeImage;
@property (nonatomic, strong) CustomPickerView *pickerView;
@property (nonatomic, strong) CustomPickerView *pickerView2;
@property (nonatomic, strong) CustomPickerView *pickerView3;
@property (nonatomic, strong) NSString *num1;
@property (nonatomic, strong) NSString *num2;
@property (nonatomic, strong) NSString *num3;
@property (nonatomic, strong) UIImageView *tapImageV;
@property (nonatomic, strong) UILabel *sureNumL;
@end

@implementation NoticeSetSecondPWController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self requectCoiver];
    if (self.aboutM.check_code.length == 3) {
        self.num1 = [self.aboutM.check_code substringToIndex:1];
        self.num2 = [self.aboutM.check_code substringWithRange:NSMakeRange(1, 1)];
        self.num3 = [self.aboutM.check_code substringFromIndex:2];
    }else{
        //设置默认密码
        self.num1 = @"0";
        self.num2 = @"0";
        self.num3 = @"0";
    }

    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    [self.view addSubview:self.backImageView];
    self.backImageView.image = UIImageNamed(@"Imag_newpw");
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    titleL.font = XGEightBoldFontSize;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    titleL.text = [NoticeTools getLocalStrWith:@"pw.title"];
    [self.view addSubview:titleL];
    
    UILabel *leftL = [[UILabel alloc] initWithFrame:CGRectMake(20,STATUS_BAR_HEIGHT, 70, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    leftL.userInteractionEnabled = YES;
    leftL.font = SIXTEENTEXTFONTSIZE;
    leftL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    leftL.text = self.isCheck?[NoticeTools getLocalStrWith:@"pw.out"]:[NoticeTools getLocalStrWith:@"pw.save"];
    [self.view addSubview:leftL];
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(savelClick)];
    [leftL addGestureRecognizer:leftTap];
        
    if (self.isCheck) {
        NoticeSocketManger *socketManger = [[NoticeSocketManger alloc] init];
        [socketManger reConnect];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdel.socketManager = socketManger;
        
        UILabel *rightL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-70,STATUS_BAR_HEIGHT, 70, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        rightL.userInteractionEnabled = YES;
        rightL.font = SIXTEENTEXTFONTSIZE;
        rightL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        rightL.text = [NoticeTools getLocalStrWith:@"pw.help"];
        [self.view addSubview:rightL];
        UITapGestureRecognizer *rightLTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpClick)];
        [rightL addGestureRecognizer:rightLTap];

    }else{

        _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-18-44,STATUS_BAR_HEIGHT+8,44,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        _switchButton.onTintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        _switchButton.thumbTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _switchButton.tintColor = [UIColor colorWithHexString:@"#8A8F99"];
        [_switchButton addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventValueChanged];
        _switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
        if ([self.aboutM.setting_value isEqualToString:@"1"]) {
            _switchButton.on = YES;
        }

        [self.view addSubview:_switchButton];
    }
    
    UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.backImageView.frame.size.height)];
    mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.backImageView addSubview:mbView];
    
    self.backImageView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    longPress.minimumPressDuration = 0.5;
    [self.backImageView addGestureRecognizer:longPress];
    
    UIImageView *pwBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,291, 375)];
    pwBackImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    pwBackImageView.center = self.view.center;
    pwBackImageView.layer.cornerRadius = 20;
    pwBackImageView.layer.masksToBounds = YES;
    pwBackImageView.userInteractionEnabled = YES;
    [self.backImageView addSubview:pwBackImageView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.frame = pwBackImageView.bounds;
    [pwBackImageView addSubview:visualView];
    
    self.pwButton = [[UIButton alloc] initWithFrame:CGRectMake(62, pwBackImageView.frame.size.height-30-40, 168, 40)];
    self.pwButton.layer.cornerRadius = 20;
    self.pwButton.layer.masksToBounds = YES;
    self.pwButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [self.pwButton setTitle:self.isCheck?[NoticeTools getLocalStrWith:@"pw.in"]: [NoticeTools getLocalStrWith:@"sure.comgir"] forState:UIControlStateNormal];
    [self.pwButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.pwButton.titleLabel.font = XGTwentyBoldFontSize;
    [self.pwButton addTarget:self action:@selector(mimaClick) forControlEvents:UIControlEventTouchUpInside];
    [pwBackImageView addSubview:self.pwButton];
    
    self.passwordL = [[UILabel alloc] initWithFrame:CGRectMake(0, 26,pwBackImageView.frame.size.width, 28)];
    self.passwordL.font = XGTwentyBoldFontSize;
    self.passwordL.textAlignment = NSTextAlignmentCenter;
    self.passwordL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.passwordL.text = [NoticeTools getLocalStrWith:@"pw.dqmm"];
    [pwBackImageView addSubview:self.passwordL];
    
    self.sureNumL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.passwordL.frame)+12,pwBackImageView.frame.size.width, 56)];
    self.sureNumL.font = XGTwentyEigthBoldFontSize;
    self.sureNumL.textAlignment = NSTextAlignmentCenter;
    self.sureNumL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.sureNumL.text = self.num1;
    [pwBackImageView addSubview:self.sureNumL];
    self.sureNumL.text = [NSString stringWithFormat:@"%@    %@    %@",self.num1,self.num2,self.num3];
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(62, CGRectGetMaxY(self.sureNumL.frame)+12, 168, 40)];
    imgView1.userInteractionEnabled = YES;
    imgView1.layer.cornerRadius = 20;
    imgView1.layer.masksToBounds = YES;
    imgView1.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [pwBackImageView addSubview:imgView1];
    _pickerView = [[CustomPickerView alloc]initWithFrame:CGRectMake(0,0,imgView1.frame.size.width,imgView1.frame.size.height)];
    _pickerView.isNomerData = YES;
    _pickerView.delegate = self;
    _pickerView.dataModel = [NSMutableArray arrayWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
    [_pickerView reloadData];
    [_pickerView scrollToIndex:self.num1.integerValue+20];//没设置密码时候默认0
    _pickerView.tag = 1;
    [imgView1 addSubview:_pickerView];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(62, CGRectGetMaxY(imgView1.frame)+12, 168, 40)];
    imgView2.layer.cornerRadius = 20;
    imgView2.layer.masksToBounds = YES;
    imgView2.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    imgView2.userInteractionEnabled = YES;
    [pwBackImageView addSubview:imgView2];
    _pickerView2 = [[CustomPickerView alloc] initWithFrame:CGRectMake(0,0,imgView1.frame.size.width,imgView1.frame.size.height)];
    _pickerView2.isNomerData = YES;
    _pickerView2.delegate = self;
    _pickerView2.dataModel = [NSMutableArray arrayWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
    [_pickerView2 reloadData];
    [_pickerView2 scrollToIndex:self.num2.integerValue+20];
    _pickerView2.tag = 2;
    [imgView2 addSubview:_pickerView2];
    
    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(62, CGRectGetMaxY(imgView2.frame)+12, 168, 40)];
    imgView3.layer.cornerRadius = 20;
    imgView3.layer.masksToBounds = YES;
    imgView3.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    imgView3.userInteractionEnabled = YES;
    [pwBackImageView addSubview:imgView3];
    _pickerView3 = [[CustomPickerView alloc]initWithFrame:CGRectMake(0,0,imgView1.frame.size.width,imgView1.frame.size.height)];
    _pickerView3.isNomerData = YES;
    _pickerView3.delegate = self;
    _pickerView3.dataModel = [NSMutableArray arrayWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
    [_pickerView3 reloadData];
    [_pickerView3 scrollToIndex:self.num3.integerValue+20];
    _pickerView3.tag = 3;
    [imgView3 addSubview:_pickerView3];
    
    if (!self.isCheck) {
        self.backImageView.hidden = !_switchButton.isOn;
        UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-150,20, 150, 17)];
        markL.font = TWOTEXTFONTSIZE;
        markL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        markL.textAlignment = NSTextAlignmentRight;
        markL.text = [NoticeTools getLocalStrWith:@"pw.long"];
        [self.backImageView addSubview:markL];
    }
    

}

- (void)helpClick{
    NoticeSCViewController *ctl = [[NoticeSCViewController alloc] init];
    ctl.navigationItem.title = [NoticeTools getLocalStrWith:@"pw.help"];
    ctl.toUser = [NSString stringWithFormat:@"%@1",socketADD];
    ctl.toUserId = @"1";
    ctl.isNeedHelp = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)selectTitlt:(NSString *)str tag:(NSInteger)tag{
    if (tag == 1) {
        self.num1 = str;
    }else if (tag == 2){
        self.num2 = str;
    }else{
        self.num3 = str;
    }
    self.sureNumL.text = [NSString stringWithFormat:@"%@    %@    %@",self.num1,self.num2,self.num3];
}

//点击密码按钮
- (void)mimaClick{
    if (!self.isCheck) {
        [self showToastWithText:[NSString stringWithFormat:@"%@%@%@%@%@",[NoticeTools getLocalStrWith:@"pw.cu"],self.num1,self.num2,self.num3,[NoticeTools getLocalStrWith:@"pw.nowangji"]]];
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:[NSString stringWithFormat:@"%@%@%@",self.num1,self.num2,self.num3] forKey:@"checkCode"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"loginCheckCode/verify" Accept:@"application/vnd.shengxi.v4.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [NoticeTools saveNeedSecondCheckForLogin:@"0"];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

//长按更好图片
- (void)longPressGestureRecognized:(id)sender{
    if (self.isCheck) {
        return;
    }
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    if (longPress.state == UIGestureRecognizerStateBegan) {//执行一次
        LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
            if (buttonIndex1 == 0) {
                return ;
            }
            if (buttonIndex1 == 1){
                TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
                imagePicker.sortAscendingByModificationDate = false;
                imagePicker.allowPickingOriginalPhoto = false;
                imagePicker.alwaysEnableDoneBtn = true;
                imagePicker.allowPickingVideo = false;
                imagePicker.allowPickingGif = false;
                imagePicker.allowCrop = true;
                imagePicker.cropRect = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-BOTTOM_HEIGHT-3);
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"pw.change"]]];
        [sheet1 show];
        
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

    [self showHUD];
    
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"23" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"logincheck_cover" forKey:@"coverName"];
            [parm setObject:Message forKey:@"coverUri"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/covers",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success2) {
                [self hideHUD];
                if (success2) {
                    NoticeCoverModel *covverM = [NoticeCoverModel mj_objectWithKeyValues:dict[@"data"]];
                    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:covverM.coverUrl]
                                          placeholderImage:UIImageNamed(@"Imag_newpw")
                                                   options:SDWebImageRefreshCached];
                    self.tapImageV.hidden = YES;
                }
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
            
        }else{
            [self hideHUD];
        }
    }];
}

- (void)requectCoiver{
    //获取封面
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/covers?coverName=logincheck_cover",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
        if (success1) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NSMutableArray *arr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeCoverModel *model = [NoticeCoverModel mj_objectWithKeyValues:dic];
                [arr addObject:model];
            }
            if (arr.count) {
                NoticeCoverModel *covverM = arr[0];
                [self.backImageView sd_setImageWithURL:[NSURL URLWithString:covverM.coverUrl]
                                      placeholderImage:UIImageNamed(@"Imag_newpw")
                                               options:SDWebImageRefreshCached];
                self.tapImageV.hidden = YES;
            }
            
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

//是否启动密码
- (void)changeVale:(UISwitch *)switchbutton{
    self.backImageView.hidden = !switchbutton.isOn;
}

//保存设置
- (void)savelClick{
    if (self.isCheck) {
        [NoticeSaveModel outLoginClearData];
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate deleteAlias];

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
        [appdel.socketManager.timer invalidate];
        [appdel.socketManager.webSocket close];
        appdel.socketManager = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATIONNEEDACTION" object:nil];
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"other" forKey:@"settingTag"];
    [parm setObject:@"login_check_switch" forKey:@"settingName"];
    [parm setObject:_switchButton.isOn?@"1":@"2" forKey:@"settingValue"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (!self->_switchButton.isOn) {
                [self hideHUD];
                self.aboutM.check_code = [NSString stringWithFormat:@"%@%@%@",self.num1,self.num2,self.num3];
                self.aboutM.setting_value = self.switchButton.isOn?@"1":@"2";
                self.checkModelBlock(self.aboutM);
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            NSMutableDictionary *parm1 = [NSMutableDictionary new];
            [parm1 setObject:[NSString stringWithFormat:@"%@%@%@",self.num1,self.num2,self.num3] forKey:@"checkCode"];
            [[DRNetWorking shareInstance] requestWithPatchPath:@"loginCheckCode" Accept:@"application/vnd.shengxi.v4.3+json" parmaer:parm1 page:0 success:^(NSDictionary * _Nullable dict1, BOOL success1) {
                [self hideHUD];
                if (success1) {
                    self.aboutM.check_code = [NSString stringWithFormat:@"%@%@%@",self.num1,self.num2,self.num3];
                    self.aboutM.setting_value = self.switchButton.isOn?@"1":@"2";
                    self.checkModelBlock(self.aboutM);
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
