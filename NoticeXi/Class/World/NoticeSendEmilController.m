//
//  NoticeSendEmilController.m
//  NoticeXi
//
//  Created by li lei on 2022/12/30.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendEmilController.h"
#import "NoticeCurentLeaveController.h"
#import "NSString+HDExtension.h"
#import "CXDatePickerView.h"
#import "NSDate+CXCategory.h"
#import "ZFSDateFormatUtil.h"
@interface NoticeSendEmilController ()

@property (nonatomic, strong) UILabel *startL;
@property (nonatomic, strong) UILabel *endL;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *endBtn;
@property (strong, nonatomic) UITextField *phoneView;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UILabel *upLeavelL;
@property (nonatomic, assign) BOOL isOverTime;
@property (nonatomic, assign) BOOL hasChoiceStartTime;
@property (nonatomic, assign) BOOL hasChoiceEndTime;
@property (nonatomic, assign) BOOL hasSend;
@property (nonatomic, strong) UIView *hasSendView;
@property (nonatomic, strong) UILabel *errorL;
@end

@implementation NoticeSendEmilController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text =  [NoticeTools chinese:@"下载音频" english:@"Download" japan:@"ダウンロード"];
    
    [self.navBarView.rightButton setImage:UIImageNamed(@"Image_expliandown") forState:UIControlStateNormal];
    [self.navBarView.rightButton addTarget:self action:@selector(explainClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+20, DR_SCREEN_WIDTH-40, 56*2)];
    dateView.backgroundColor = [UIColor whiteColor];
    dateView.layer.cornerRadius = 8;
    dateView.layer.masksToBounds = YES;
    [self.view addSubview:dateView];
    
    UILabel *markL1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, (DR_SCREEN_WIDTH-70)/2, 56)];
    markL1.text = [NoticeTools chinese:@"开始日期" english:@"Start date" japan:@"開始日"];
    markL1.font = FOURTHTEENTEXTFONTSIZE;
    markL1.textColor = [UIColor colorWithHexString:@"#25262E"];
    [dateView addSubview:markL1];
    
    self.startL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markL1.frame)-(self.canChoiceDate?20:0), 0, markL1.frame.size.width, 56)];
    self.startL.textAlignment = NSTextAlignmentRight;
    self.startL.text = self.canChoiceDate?[NoticeTools chinese:@"请选择开始日期" english:@"Select start date" japan:@"開始日を選択"]:[NSString stringWithFormat:@"%@-%@-%@",self.year,self.month,self.day];
    self.startL.font = FOURTHTEENTEXTFONTSIZE;
    self.startL.textAlignment = NSTextAlignmentRight;
    self.startL.textColor = [UIColor colorWithHexString:self.canChoiceDate? @"#8A8F99":@"#25262E"];
    [dateView addSubview:self.startL];
    dateView.userInteractionEnabled = YES;
    self.startL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceStart)];
    [self.startL addGestureRecognizer:tap1];
    
    UILabel *markL2 = [[UILabel alloc] initWithFrame:CGRectMake(15,56, (DR_SCREEN_WIDTH-70)/2, 56)];
    markL2.text = [NoticeTools chinese:@"结束日期" english:@"End date" japan:@"終了日"];
    markL2.font = FOURTHTEENTEXTFONTSIZE;
    markL2.textColor = [UIColor colorWithHexString:@"#25262E"];
    [dateView addSubview:markL2];
    
    self.endL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markL1.frame)-(self.canChoiceDate?20:0), 56, markL1.frame.size.width, 56)];
    self.endL.textAlignment = NSTextAlignmentRight;
    self.endL.text = self.canChoiceDate?[NoticeTools chinese:@"请选择结束日期" english:@"Select end date" japan:@"終了日を選択"]:[NSString stringWithFormat:@"%@-%@-%@",self.year,self.month,self.day];
    self.endL.font = FOURTHTEENTEXTFONTSIZE;
    self.endL.textAlignment = NSTextAlignmentRight;
    self.endL.textColor = [UIColor colorWithHexString:self.canChoiceDate? @"#8A8F99":@"#25262E"];
    [dateView addSubview:self.endL];
    dateView.userInteractionEnabled = YES;
    self.endL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceEnd)];
    [self.endL addGestureRecognizer:tap2];
    
    if (self.canChoiceDate) {
        self.startBtn = [[UIButton alloc] initWithFrame:CGRectMake(dateView.frame.size.width-35, 18, 20, 20)];
        [self.startBtn setImage:UIImageNamed(@"cellnextbutton") forState:UIControlStateNormal];
        [self.startBtn addTarget:self action:@selector(choiceStart) forControlEvents:UIControlEventTouchUpInside];
        [dateView addSubview:self.startBtn];
        
        self.endBtn = [[UIButton alloc] initWithFrame:CGRectMake(dateView.frame.size.width-35, 18+56, 20, 20)];
        [self.endBtn setImage:UIImageNamed(@"cellnextbutton") forState:UIControlStateNormal];
        [self.endBtn addTarget:self action:@selector(choiceEnd) forControlEvents:UIControlEventTouchUpInside];
        [dateView addSubview:self.endBtn];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 55.5, dateView.frame.size.width-40, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [dateView addSubview:line];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(dateView.frame)+20, DR_SCREEN_WIDTH-40, 56)];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *markL3 = [[UILabel alloc] initWithFrame:CGRectMake(15,0, (DR_SCREEN_WIDTH-70)/2-40, 56)];
    markL3.text = [NoticeTools chinese:@"下载到" english:@"To" japan:@"Eメール"];
    markL3.font = FOURTHTEENTEXTFONTSIZE;
    markL3.textColor = [UIColor colorWithHexString:@"#25262E"];
    [backView addSubview:markL3];
    
    self.phoneView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markL3.frame), 0, backView.frame.size.width-CGRectGetMaxX(markL3.frame)-15, 56)];
    self.phoneView.keyboardType = UIKeyboardTypeEmailAddress;
    [self.phoneView setupToolbarToDismissRightButton];
    self.phoneView.textAlignment = NSTextAlignmentRight;
    self.phoneView.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.phoneView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.phoneView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools chinese:@"请输入邮箱" english:@"Email address" japan:@"電子メールアドレス"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
    [backView addSubview:self.phoneView];
    self.phoneView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.phoneView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.downButton = [[UIButton alloc] initWithFrame:CGRectMake(67, CGRectGetMaxY(backView.frame)+56, DR_SCREEN_WIDTH-67*2, 56)];
    self.downButton.layer.cornerRadius = 28;
    self.downButton.layer.masksToBounds = YES;
    self.downButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [self.downButton setTitle:[NoticeTools chinese:@"下载" english:@"Download" japan:@"ダウンロード"] forState:UIControlStateNormal];
    self.downButton.titleLabel.font = NINETEENTEXTFONTSIZE;
    [self.downButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    [self.downButton addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downButton];
    
    if (!self.canChoiceDate) {
        self.upLeavelL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.downButton.frame)+20, DR_SCREEN_WIDTH, 22)];
        self.upLeavelL.font = FOURTHTEENTEXTFONTSIZE;
        self.upLeavelL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.upLeavelL.userInteractionEnabled = YES;
        self.upLeavelL.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uplelveTap)];
        [self.upLeavelL addGestureRecognizer:tap];
        [self.view addSubview:self.upLeavelL];
    }
    
    self.errorL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backView.frame)+4, 300, 17)];
    self.errorL.font = TWOTEXTFONTSIZE;
    self.errorL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
    [self.view addSubview:self.errorL];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.canChoiceDate) {
        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
        if (!userM.level.integerValue) {
            NSString *colorStr = [NoticeTools getLocalStrWith:@"recoder.golv"];
            NSString *beginStr = [NoticeTools chinese:@"升级至Lv1，可使用整月音频打包下载功能" english:@"Upgrade to download by the month" japan:@"プロユーザーは月単位でダウンロード可能"];
            NSString *allStr = [NSString stringWithFormat:@"%@ %@",beginStr,colorStr];
            self.upLeavelL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:colorStr beginSize:allStr.length-colorStr.length];
        }else{
            NSString *colorStr = [NoticeTools chinese:@"去使用" english:@"Go" japan:@"行く"];
            NSString *beginStr = [NoticeTools chinese:@"一键打包下载" english:@"Download" japan:@"ダウンロード"];
            NSString *allStr = [NSString stringWithFormat:@"%@ %@",beginStr,colorStr];
            self.upLeavelL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:colorStr beginSize:allStr.length-colorStr.length];
        }
    }
}

- (void)downClick{
    if (!self.canChoiceDate) {
        if (!self.phoneView.text.length) {
            self.errorL.text = [NoticeTools chinese:@"请输入邮箱" english:@"Email address" japan:@"電子メールアドレス"];
            return;
        }
    }
    
    if (![self.phoneView.text hd_isValidEmail]) {
        self.errorL.text = [NoticeTools chinese:@"邮箱格式不正确" english:@"Incorrect email form" japan:@"間違ったメールフォーム"];
        return;
    }
    
    if (self.canChoiceDate) {
        
        if (!self.hasChoiceStartTime) {
            [self showToastWithText:[NoticeTools chinese:@"请选择开始日期" english:@"Select start date" japan:@"開始日を選択"]];
            return;
        }
        
        
        if (!self.hasChoiceEndTime) {
            [self showToastWithText:[NoticeTools chinese:@"请选择结束日期" english:@"Select end date" japan:@"終了日を選択"]];
            return;
        }
        
        if (self.isOverTime) {
            [self showToastWithText:[NoticeTools chinese:@"一次最多可选择发送一个月的心情" english:@"Max start-end range is 30 days" japan:@"開始と終了の最大範囲は 30 日です"]];
            return;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"请再次核实邮箱地址" english:@"Confirm email address" japan:@"メールアドレスを確認"] message:self.phoneView.text sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf sendEmile];
        }
    };
    [alerView showXLAlertView];
}

- (void)sendEmile{
    [self showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.startL.text forKey:@"startDate"];
    [parm setObject:self.endL.text forKey:@"endDate"];
    [parm setObject:self.phoneView.text forKey:@"email"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voice/sendVoiceFilesEmail" Accept:@"application/vnd.shengxi.v5.4.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"已下载" english:@"Sent" japan:@"送信済"] message:[NoticeTools chinese:@"文件稍后发送至相关邮箱，请注意查收，若有问题，请及时联系客服小二" english:@"Please check your email\nContact us if not received" japan:@"メールを確認してください\n届かない場合はお問い合わせください"] cancleBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"]];
            [alerView showXLAlertView];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)uplelveTap{
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if (!userM.level.integerValue) {
        NoticeCurentLeaveController *ctl = [[NoticeCurentLeaveController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeSendEmilController *ctl = [[NoticeSendEmilController alloc] init];
        ctl.canChoiceDate = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)refreshButton{
    if (!self.canChoiceDate) {
        if (self.phoneView.text.length) {
            self.downButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.downButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }else{
            self.downButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
            [self.downButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        }
    }else{
        if (self.hasChoiceEndTime && self.hasChoiceStartTime && self.phoneView.text.length) {
            self.downButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.downButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }else{
            self.downButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
            [self.downButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        }
    }

}

- (void)textFieldDidChange:(id) sender {
    [self refreshButton];
}

- (void)choiceStart{
    if (!self.canChoiceDate) {
        return;
    }
    NSString *formatStr = nil;
    NSString *titleStr = nil;
    CXDatePickerStyle style = 0;
    formatStr = @"yyyy-MM-dd";
    style = CXDateYearMonthDay;
    titleStr = [NoticeTools getLocalStrWith:@"intro.choiceday"];
    __weak typeof(self) weakSelf = self;
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:style completeBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate cx_stringWithFormat:formatStr];
        weakSelf.startL.text = dateString;
        weakSelf.startL.textColor = [UIColor colorWithHexString:@"#25262E"];
        weakSelf.hasChoiceStartTime = YES;
        
        if (weakSelf.hasChoiceEndTime) {
            [weakSelf isOverCanChoiceTime];
            [weakSelf refreshButton];
        }
    }];

    datepicker.headerTitle = titleStr;
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.datePickerFont = SIXTEENTEXTFONTSIZE;
    datepicker.datePickerSelectColor = [UIColor colorWithHexString:@"#25262E"];
    datepicker.datePickerColor = [UIColor colorWithHexString:@"#A1A7B3"];
    datepicker.datePickerSelectFont = XGEightBoldFontSize;
    [datepicker show];
}


- (void)isOverCanChoiceTime{
    //开始时间
    NSInteger startTime = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",self.startL.text]];
    //结束时间
    NSInteger endTime = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",self.endL.text]];
        
    NSInteger days = [NSString stringWithFormat:@"%ld",(long)(endTime-startTime)/86400].integerValue+1;
    if (days > 30 || days < 0) {
        self.isOverTime = YES;
    }else{
        self.isOverTime = NO;
    }
}

- (void)choiceEnd{
    if (!self.canChoiceDate) {
        return;
    }
    NSString *formatStr = nil;
    NSString *titleStr = nil;
    CXDatePickerStyle style = 0;
    formatStr = @"yyyy-MM-dd";
    style = CXDateYearMonthDay;
    titleStr = [NoticeTools getLocalStrWith:@"intro.choiceday"];
    __weak typeof(self) weakSelf = self;
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:style completeBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate cx_stringWithFormat:formatStr];
        weakSelf.endL.text = dateString;
        weakSelf.endL.textColor = [UIColor colorWithHexString:@"#25262E"];
        weakSelf.hasChoiceEndTime = YES;
        if (weakSelf.hasChoiceStartTime) {
            [weakSelf isOverCanChoiceTime];
            [weakSelf refreshButton];
        }
    }];

    datepicker.headerTitle = titleStr;
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.datePickerFont = SIXTEENTEXTFONTSIZE;
    datepicker.datePickerSelectColor = [UIColor colorWithHexString:@"#25262E"];
    datepicker.datePickerColor = [UIColor colorWithHexString:@"#A1A7B3"];
    datepicker.datePickerSelectFont = XGEightBoldFontSize;
    [datepicker show];
}

- (void)explainClick{
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"仅下载所选日期的语音心情(音频+图片)，会将文件夹打包压缩发送至对应邮箱" english:@"Downloaded content will be sent to your email under a .zip file" japan:@"ダウンロードしたコンテンツは、.zip ファイルで電子メールに送信されます"] message:nil cancleBtn:[NoticeTools chinese:@"好的" english:@"Ok" japan:@"わかった"]];
    [alerView showXLAlertView];
}

@end
