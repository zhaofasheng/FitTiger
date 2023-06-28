//
//  NoticeSendTCController.m
//  NoticeXi
//
//  Created by li lei on 2019/10/22.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendTCController.h"
#import "DDHAttributedMode.h"
#import "NoticeManagerModel.h"
#import "AFHTTPSessionManager.h"
#import "NoticeCllockTagView.h"
#import "NoticeClockTcTag.h"

@interface NoticeSendTCController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *nameField;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, assign) NSInteger strNum;
@property (nonatomic, assign) BOOL isNiming;
@property (nonatomic, assign) BOOL isOverHeight;
@property (nonatomic, strong) UILabel *sendBtn;
@property (nonatomic, strong) UIView *faBackView;
@property (nonatomic, strong) UIView *titleHeadView;
@property (nonatomic, strong) NSMutableArray *wordArr;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, assign) NSInteger tcTag;
@property (nonatomic, strong) UIButton *requestBtn;
@property (nonatomic, strong) UIButton *refreshBtn;
@end

@implementation NoticeSendTCController
{
    UILabel *_plaL;
    CGFloat allHeight;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tcTag = 2;
    [self downWarnWord];
    
    if ([NoticeTools isFirstTcOnThisDeveice]) {
        [self.view addSubview:self.titleHeadView];
    }
    

    self.tagView = [[UIView alloc] initWithFrame:CGRectMake(0,([NoticeTools isFirstTcOnThisDeveice]?80:20)+NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH,32)];
    [self.view addSubview:self.tagView];
    
    self.requestBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 84, 32)];
    [self.requestBtn setTitle:[NoticeTools getLocalStrWith:@"py.tag1"] forState:UIControlStateNormal];
    self.requestBtn.layer.cornerRadius = 32/2;
    self.requestBtn.layer.masksToBounds = YES;
    self.requestBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.requestBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.requestBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [self.tagView addSubview:self.requestBtn];
    self.requestBtn.tag = 2;
    [self.requestBtn addTarget:self action:@selector(choiceTag:) forControlEvents:UIControlEventTouchUpInside];
    
    self.refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.requestBtn.frame)+15,0,100, 32)];
    [self.refreshBtn setTitle:[NoticeTools getLocalStrWith:@"py.tag2"] forState:UIControlStateNormal];
    self.refreshBtn.layer.cornerRadius = 32/2;
    self.refreshBtn.layer.masksToBounds = YES;
    self.refreshBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.refreshBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    self.refreshBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0];
    [self.tagView addSubview:self.refreshBtn];
    self.refreshBtn.tag = 3;
    [self.refreshBtn addTarget:self action:@selector(choiceTag:) forControlEvents:UIControlEventTouchUpInside];
    
    self.faBackView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.tagView.frame)+20, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-100)];
    self.faBackView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.faBackView];
    
    
    UILabel *btn = [[UILabel alloc] init];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-15-60, STATUS_BAR_HEIGHT,60,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    btn.text = [NoticeTools getLocalStrWith:@"py.send"];
    btn.font = SIXTEENTEXTFONTSIZE;
    btn.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
    btn.userInteractionEnabled = YES;
    btn.textAlignment = NSTextAlignmentRight;
    UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendClick)];
    [btn addGestureRecognizer:sendTap];
    _sendBtn = btn;
    [self.view addSubview:btn];
    
    UILabel *backBtn = [[UILabel alloc] initWithFrame:CGRectMake(15, STATUS_BAR_HEIGHT,60, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    backBtn.text = [NoticeTools getLocalStrWith:@"main.cancel"];
    backBtn.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    backBtn.font = SIXTEENTEXTFONTSIZE;
    backBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToPageAction)];
    [backBtn addGestureRecognizer:backTap];
    [self.view addSubview:backBtn];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(60,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-120, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    titleL.font = XGTwentyBoldFontSize;
    titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    titleL.text = [NoticeTools getLocalStrWith:@"py.sendtc"];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleL];


    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 12, DR_SCREEN_WIDTH-30, 140)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.faBackView addSubview:backView];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *firTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginFirst)];
    [backView addGestureRecognizer:firTap];
    
    self.nameField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-30, 30)];
    self.nameField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.nameField.backgroundColor = backView.backgroundColor;
    self.nameField.delegate = self;
    self.nameField.font =FIFTHTEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
    [backView addSubview:self.nameField];
    
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 200, 14)];
    _plaL.text = [NoticeTools getLocalStrWith:@"py.inpttc"];
    
    self.strNum = 100;
    
    _plaL.font = FOURTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [backView addSubview:_plaL];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(backView.frame)+10,70, 13)];
    self.numL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.numL.font = THRETEENTEXTFONTSIZE;
    self.numL.text = @"0/100";
    [self.faBackView addSubview:self.numL];

    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    
}

- (void)beginFirst{
    [self.nameField becomeFirstResponder];
}

- (void)choiceTag:(UIButton *)btn{
    self.tcTag = btn.tag;
    if (btn.tag == 2) {
        [self.refreshBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
        self.refreshBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0];
        [self.requestBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.requestBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    }else{
        [self.requestBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
        self.requestBtn.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0];
        [self.refreshBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.refreshBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    }
}

- (void)viewTapped{
    [self.nameField resignFirstResponder];
}

//下载敏感词库
- (void)downWarnWord{
    [[NSFileManager defaultManager] removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/line-sensitive.txt"] error:nil];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/lines/sensitive" Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeManagerModel *model = [NoticeManagerModel mj_objectWithKeyValues:dict[@"data"]];
            if (model.sensitive_url) {
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:model.sensitive_url]];
                //返回一个下载任务对象
                NSURLSessionDownloadTask *loadTask = [manager downloadTaskWithRequest:requset progress:^(NSProgress * _Nonnull downloadProgress) {

                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/line-sensitive.txt"];

                    //这个block 需要返回一个目标 地址 存储下载的文件
                    return  [NSURL fileURLWithPath:fullPath];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[string stringByAppendingFormat:@"/line-sensitive.txt"]];
                    NSData *data = [fileHandle readDataToEndOfFile];
                    [fileHandle closeFile];
                    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    DRLog(@"新的网络敏感词库:%@\n%@",text,model.sensitive_url);
                    if (text) {
                        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSArray *arr = [text componentsSeparatedByString:@","];
                        self.wordArr = [NSMutableArray arrayWithArray:arr];
                    }
                }];

                //启动下载任务--开始下载
                [loadTask resume];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)refreshWarnWord{
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[string stringByAppendingFormat:@"/line-sensitive.txt"]];
    NSData *data = [fileHandle readDataToEndOfFile];
    [fileHandle closeFile];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DRLog(@"已经存在的敏感词库:%@",text);
    if (text) {
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *arr = [text componentsSeparatedByString:@","];
        self.wordArr = [NSMutableArray arrayWithArray:arr];
    }
}

- (void)backToPageAction{
    if (self.nameField.text.length) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"xl.suregp"] message:[NoticeTools getLocalStrWith:@"xl.nosavenr"] sureBtn:[NoticeTools getLocalStrWith:@"xl.suresure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureSend{

    NSString *warnString = [NoticeComTools deleteCharacters:self.nameField.text];//去除标点符号和特俗字符
    warnString = [warnString stringByReplacingOccurrencesOfString:@" " withString:@""];//去除空格
    warnString = [warnString stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去除换行符
    
    for (NSString *warnWord in self.wordArr) {
        if ([warnWord isEqualToString:@""] || [warnWord isEqualToString:@","]) {
            break;
        }
        DRLog(@"敏感词汇总：%@",warnWord);
        if ([warnString containsString:warnWord]) {
            NoticePinBiView *warnView = [[NoticePinBiView alloc] initWithWarnWord:warnWord];
            [warnView showTostView];
            return;
        }
    }
    NSString *str = self.nameField.text.length > 100 ? [self.nameField.text substringToIndex:100] : self.nameField.text;
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:str forKey:@"lineContent"];
    [parm setObject:@"0" forKey:@"isAnonymous"];
    [parm setValue:self.tcTag == 2? @"1":@"2" forKey:@"tagId"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"lines" Accept:@"application/vnd.shengxi.v4.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGETHEROOTSELECTARTTC" object:nil];
            [UIView animateWithDuration:1 animations:^{
                [self showToastWithText:[NoticeTools getLocalStrWith:@"py.sendsus"]];
            } completion:^(BOOL finished) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)sendClick{
    if (!self.tcTag) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"py.inputtag"]];
        return;
    }
    if ([self strLines:self.nameField.text] > 10) {
        DRLog(@"%d",[self strLines:self.nameField.text]);
        [self showToastWithText:[NoticeTools getLocalStrWith:@"py.tcline"]];
        return;
    }
    if (!self.nameField.text.length) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"py.inpttc"]];
        return;
    }
    [self.nameField resignFirstResponder];
    [self sureSend];
//    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:self.titleMessage message:nil sureBtn:@"去发布" cancleBtn:@"再等等"];
//    alerView.resultIndex = ^(NSInteger index) {
//        if (index == 1) {
//            [self sureSend];
//        }
//    };
//    [alerView showXLAlertView];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    CGRect frame = textView.frame;
    float height;
    if ([text isEqual:@""]) {
        
        if (![textView.text isEqualToString:@""]) {
            
            height = [self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
            
        }else{
            
            height = [self heightForTextView:textView WithText:textView.text];
        }
    }else{
        
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    if (height > 130) {
        height = 130;
    }

    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        
        textView.frame = frame;
        
    } completion:nil];

    return YES;
}


- (int)strLines:(NSString *)str{
    int targetTextViewWidth=self.nameField.frame.size.width;
    NSString *msgStr=str;
    UIFont *tableCellMsgFont=self.nameField.font;
    UITextView *textView = [[UITextView alloc] init];
    [textView setFont:tableCellMsgFont];
    textView.text=msgStr;
    CGSize sizeThatFitsTextView = [textView sizeThatFits:CGSizeMake(targetTextViewWidth, MAXFLOAT)];
    int lines = (int)lroundf(sizeThatFitsTextView.height) / (int)lroundf(tableCellMsgFont.lineHeight);
    
    return lines;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length) {
        _plaL.text = @"";
        self.sendBtn.textColor = [UIColor colorWithHexString:@"#0099E6"];
    }else{
       _plaL.text = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"py.inpttc"]:@"請輸入臺詞";
        self.sendBtn.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
    
    if (textView.text.length > self.strNum) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/%ld",textView.text.length,self.strNum] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",textView.text.length] beginSize:0];
    }else{
        self.numL.text = [NSString stringWithFormat:@"%lu/%ld",textView.text.length,(long)self.strNum];
    }
}

- (float)heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
        
    return textHeight;
}


- (UIView *)titleHeadView{
    if (!_titleHeadView) {
        _titleHeadView = [[UIView alloc] initWithFrame:CGRectMake(20,20+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, 41)];
        _titleHeadView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleHeadView.layer.cornerRadius = 5;
        _titleHeadView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,DR_SCREEN_WIDTH-50, 40)];
        label.font = TWOTEXTFONTSIZE;
        label.text = [NoticeTools getLocalStrWith:@"py.rul"];
        label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        label.numberOfLines = 0;

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_titleHeadView.frame.size.width-5-40, 0, 43, 40)];
        [button setImage:UIImageNamed(@"Image_sendXXw") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickXX) forControlEvents:UIControlEventTouchUpInside];
        [_titleHeadView addSubview:button];
        [_titleHeadView addSubview:label];
    }
    return _titleHeadView;
}

- (void)clickXX{
    [NoticeTools setMarkForTc];
    [UIView animateWithDuration:0.6 animations:^{
        self->_titleHeadView.frame = CGRectMake(-DR_SCREEN_WIDTH,20+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, 41);
        self.tagView.frame = CGRectMake(0,20+NAVIGATION_BAR_HEIGHT, 84+36+88+80,32);
        self.faBackView.frame = CGRectMake(0,CGRectGetMaxY(self.tagView.frame)+20, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-100);
        
    } completion:^(BOOL finished) {
        [self->_titleHeadView removeFromSuperview];
    }];
}
@end
