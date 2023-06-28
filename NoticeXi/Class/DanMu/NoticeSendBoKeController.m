//
//  NoticeSendBoKeController.m
//  NoticeXi
//
//  Created by li lei on 2022/9/21.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendBoKeController.h"
#import "NoticeRecoderBoKeVoiceView.h"
#import "NoticeBokeTosatView.h"
#import "NoticeOneToOne.h"
#import "NoticeSaveVoiceTools.h"
#import "NoticeBBSComentInputView.h"
#import "NoticeDanMuController.h"
@interface NoticeSendBoKeController ()<TZImagePickerControllerDelegate,UITextViewDelegate,NoticeBBSComentInputDelegate>
@property (nonatomic, strong) UITextView *nameField1;
@property (nonatomic, strong) UITextView *nameField2;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) BOOL hasCHoice;
@property (nonatomic, assign) BOOL hasCHoiceVoice;
@property (nonatomic, assign) BOOL canSend;
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) UIView *choiceButton;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) NSString *filepath;
@property (nonatomic, strong) UIImage *cutsumeImg;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *bucketId;
@property (nonatomic, strong) UILabel *numL1;
@property (nonatomic, strong) UILabel *numL2;
@property (nonatomic, strong) UILabel *plaL1;

@property (nonatomic, strong) UILabel *plaL2;
@property (nonatomic, strong) NSMutableAttributedString *attStr1;
@property (nonatomic, strong) NSMutableAttributedString *attStr2;
@property (nonatomic, assign) BOOL hasVoice;//已录制音频
@property (nonatomic, strong) UIButton *recoButton;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) NoticeRecoderBoKeVoiceView *recovoiceView;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) NSString *locaPath;
@property (nonatomic, strong) NSString *timeLen;
@property (nonatomic, strong) NoticeBBSComentInputView *inputV;
@property (nonatomic, strong) UIButton *agereeBtn;
@property (nonatomic, strong) UIButton *noBtn;
@property (nonatomic, strong) UIButton *whiteBtn;
@property (nonatomic, strong) UIButton *sourceBtn;
@property (nonatomic, strong) UILabel *speedL;
@end

@implementation NoticeSendBoKeController

- (NoticeRecoderBoKeVoiceView *)recovoiceView{
    if (!_recovoiceView) {
        _recovoiceView = [[NoticeRecoderBoKeVoiceView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [self.view addSubview:_recovoiceView];
        _recovoiceView.hidden = YES;
    }
    return _recovoiceView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;

    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.navBarView.backgroundColor = self.view.backgroundColor;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+20, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-20-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-20-40);
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 533+20)];
    
    self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-305)/2, 20, 305, 203)];
    self.choiceImageView.backgroundColor = [UIColor whiteColor];
    self.choiceImageView.layer.cornerRadius = 10;
    self.choiceImageView.layer.masksToBounds = YES;
    self.choiceImageView.userInteractionEnabled = YES;
    [self.headerView addSubview:self.choiceImageView];
    
    if (self.bokeModel) {
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigTap)];
        [self.choiceImageView addGestureRecognizer:tap1];
    }

    
    self.choiceButton = [[UIView alloc] initWithFrame:CGRectMake((305-100)/2, (203-100)/2, 100, 100)];
    self.choiceButton.userInteractionEnabled = YES;
    [self.choiceImageView addSubview:self.choiceButton];
    
    UIImageView *addImageV = [[UIImageView alloc] initWithFrame:CGRectMake(76/2,46/2, 24, 24)];
    addImageV.image = UIImageNamed(@"addicon_Image");
    [self.choiceButton addSubview:addImageV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addImageV.frame)+10, 100, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    [self.choiceButton addSubview:label];
    label.text = [NoticeTools getLocalStrWith:@"b.setcover"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceTap)];
    [self.choiceButton addGestureRecognizer:tap];
    
    self.changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.choiceImageView.frame.size.width-60-10, self.choiceImageView.frame.size.height-10-29, 60, 29)];
    [self.changeBtn addTarget:self action:@selector(choiceTap) forControlEvents:UIControlEventTouchUpInside];
    [self.choiceImageView addSubview:self.changeBtn];
    self.changeBtn.hidden = YES;
    [self.changeBtn setBackgroundImage:UIImageNamed(@"changeicon_Image") forState:UIControlStateNormal];
    
    UIView *inputBackView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.choiceImageView.frame)+20, DR_SCREEN_WIDTH-40, 240)];
    inputBackView.layer.cornerRadius = 8;
    inputBackView.layer.masksToBounds = YES;
    inputBackView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:inputBackView];
    
    NSArray *arr = @[[NoticeTools getLocalStrWith:@"b.title"],[NoticeTools getLocalStrWith:@"bk.jjjie"]];
    NSArray *arr1 = @[[NoticeTools getLocalStrWith:@"b.cleartitle"],[NoticeTools getLocalStrWith:@"b.sayou"]];
    for (int i = 0; i < 2; i++) {
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 120*i, 150, 40)];
        titleL.font = SIXTEENTEXTFONTSIZE;
        titleL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        titleL.text = arr[i];
        [inputBackView addSubview:titleL];
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(inputBackView.frame.size.width-10-60,120*i,60, 40)];
        numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        numL.textAlignment = NSTextAlignmentRight;
        numL.font = TWOTEXTFONTSIZE;
        NSString *allStr = [NSString stringWithFormat:@"%@/%@",@"0",i==0?@"50":@"80"];
        numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#5C5F66"] setLengthString:@"/20" beginSize:allStr.length-3];
        [inputBackView addSubview:numL];
        
        UITextView *nameField = [[UITextView alloc] initWithFrame:CGRectMake(10, 40+120*i, inputBackView.frame.size.width-20, 80)];
        nameField.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        nameField.tintColor = [UIColor colorWithHexString:@"#0099E6"];
        nameField.delegate = self;
        nameField.backgroundColor = inputBackView.backgroundColor;
        nameField.font =FIFTHTEENTEXTFONTSIZE;
        nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
        [inputBackView addSubview:nameField];
        
       UILabel *_plaL = [[UILabel alloc] initWithFrame:CGRectMake(12, 40+120*i, inputBackView.frame.size.width-20, 16)];
        _plaL.font = FIFTHTEENTEXTFONTSIZE;
        _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [inputBackView addSubview:_plaL];
        _plaL.text = arr1[i];
        if (i==0) {
            self.numL1 = numL;
            self.nameField1 = nameField;
            self.plaL1 = _plaL;
        }else{
            self.numL2 = numL;
            self.nameField2 = nameField;
            self.plaL2 = _plaL;
        }
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 120, inputBackView.frame.size.width-20, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [inputBackView addSubview:line];
    
    self.tableView.tableHeaderView = self.headerView;
    
    UIView *voiceView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(inputBackView.frame)+20, DR_SCREEN_WIDTH-40, 50)];
    voiceView.layer.cornerRadius = 8;
    voiceView.layer.masksToBounds = YES;
    voiceView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:voiceView];
    
    UILabel *vtitleL = [[UILabel alloc] initWithFrame:CGRectMake(10,0, 150, 50)];
    vtitleL.font = SIXTEENTEXTFONTSIZE;
    vtitleL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    vtitleL.text = [NoticeTools getLocalType] == 1?@"Audio":([NoticeTools getLocalType]==2?@"オーディオ":@"音频");
    [voiceView addSubview:vtitleL];
    if (self.isCheck || self.isJuBao) {
        vtitleL.text = @"音频  倍速";
        vtitleL.userInteractionEnabled = YES;
        UITapGestureRecognizer *speedtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beisutAP)];
        [vtitleL addGestureRecognizer:speedtap];
        self.speedL = vtitleL;
    }
    
    self.recoButton = [[UIButton alloc] initWithFrame:CGRectMake(voiceView.frame.size.width-74-10, 15, 74, 20)];
    [self.recoButton setImage:UIImageNamed([NoticeTools getLocalImageNameCN:@"Image_recoboke"]) forState:UIControlStateNormal];
    [self.recoButton addTarget:self action:@selector(recoClick) forControlEvents:UIControlEventTouchUpInside];
    [voiceView addSubview:self.recoButton];
    
    self.playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(voiceView.frame.size.width-42-145,10,145, 30)];
    UIView *dragView = [[UIView alloc] initWithFrame:CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height)];
    dragView.userInteractionEnabled = YES;
    self.playerView.isSendBoke = YES;
    dragView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
    [self.playerView addSubview:dragView];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    longPress.minimumPressDuration = 0.17;
    [dragView addGestureRecognizer:longPress];
    [voiceView addSubview:self.playerView];
    self.playerView.hidden = YES;
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-40,DR_SCREEN_WIDTH-40,40)];
    sendBtn.layer.cornerRadius = 20;
    sendBtn.layer.masksToBounds = YES;
    sendBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [sendBtn setTitle:[NoticeTools getLocalStrWith:@"py.send"] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    self.sendBtn = sendBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
    
    [self isIsCheck];
}

- (void)bigTap{
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.choiceImageView;
    item.largeImageURL     = [NSURL URLWithString:self.bokeModel.cover_url];

    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [photoView presentFromImageView:self.choiceImageView toContainer:toView animated:YES completion:nil];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

    [self resginKeyBored];
}

- (void)isIsCheck{

    if (self.bokeModel) {
        
        if (!self.isCheckReSend) {
            UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-45, DR_SCREEN_WIDTH, BOTTOM_HEIGHT+20+40+5)];
            backV.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:backV];
        }else{
            [self.sendBtn setTitle:[NoticeTools chinese:@"重新投稿" english:@"Repost" japan:@"再投稿"] forState:UIControlStateNormal];
        }
        

        self.nameField1.text = self.bokeModel.podcast_title;
        self.nameField2.text = self.bokeModel.podcast_intro;
        [self getVoice:self.bokeModel.audio_url timeL:self.bokeModel.total_time];
        if (!self.isCheckReSend) {
            [self.choiceImageView setImageURL:[NSURL URLWithString:self.bokeModel.cover_url]];
            self.changeBtn.hidden = YES;
            self.nameField1.editable = NO;
            self.nameField2.editable = NO;
            self.sendBtn.hidden = YES;
        }else{
            [self.choiceImageView sd_setImageWithURL:[NSURL URLWithString:self.bokeModel.cover_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                self.choiceButton.hidden = YES;
                self.changeBtn.hidden = NO;
                self.cutsumeImg = image;
                [self refreshSendButton];
            }];
        
        }
        self.choiceButton.hidden = YES;
        self.playerView.isLocal = NO;
        
        if (!self.isCheck && !self.isJuBao) {
            return;
        }
        
        if (self.isJuBao) {
            self.navBarView.titleL.text = @"被举报的播客";
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,GET_STRHEIGHT(self.jubModel.reason, 14, DR_SCREEN_WIDTH)+30)];
            label.numberOfLines = 0;
            label.font = FOURTHTEENTEXTFONTSIZE;
            label.textColor = [UIColor redColor];
            self.tableView.tableFooterView = label;
            label.text = [NSString stringWithFormat:@"举报理由:%@",self.jubModel.reason];
        }
        
        self.recoButton.hidden = YES;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-40, 65, 40)];
        [button setTitle:@"通过" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button addTarget:self action:@selector(agreeClick) forControlEvents:UIControlEventTouchUpInside];
        self.agereeBtn = button;
        button.backgroundColor = [UIColor colorWithHexString:@"#7ACC6B"];
        button.layer.cornerRadius = 20;
        button.layer.masksToBounds = YES;
        [self.view addSubview:button];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.agereeBtn.frame)+10, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-40, 65, 40)];
        [button1 setTitle:@"拒绝" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button1.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button1 addTarget:self action:@selector(noClick) forControlEvents:UIControlEventTouchUpInside];
        self.noBtn = button1;
        button1.backgroundColor = [UIColor colorWithHexString:@"#DB6E6E"];
        button1.layer.cornerRadius = 20;
        button1.layer.masksToBounds = YES;
        [self.view addSubview:button1];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-112, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-40, 112, 40)];
        [button2 setTitle:@"加入白名单" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        button2.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button2 addTarget:self action:@selector(whiteClick) forControlEvents:UIControlEventTouchUpInside];
        self.whiteBtn = button2;
        button2.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        button2.layer.cornerRadius = 20;
        button2.layer.masksToBounds = YES;
        button2.layer.borderWidth = 0;
        button2.layer.borderColor = [UIColor colorWithHexString:@"#0099E6"].CGColor;
        [self.view addSubview:button2];
        
        UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(15, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-40, 112, 40)];
        [button3 setTitle:@"查看源播客" forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        button3.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button3 addTarget:self action:@selector(sourceClick) forControlEvents:UIControlEventTouchUpInside];
        self.sourceBtn = button3;
        button3.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        button3.layer.cornerRadius = 20;
        button3.layer.masksToBounds = YES;
        button3.layer.borderWidth = 0;
        button3.layer.borderColor = [UIColor colorWithHexString:@"#0099E6"].CGColor;
        [self.view addSubview:button3];
        self.sourceBtn.hidden = YES;
                
        [self refreshTitle];
    }
}

//查看原博客
- (void)sourceClick{
    NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];
    ctl.bokeModel = self.bokeModel;
    [self.navigationController pushViewController:ctl animated:YES];
}

//设置黑白名单
- (void)whiteClick{
    if (self.isJuBao) {//举报模块
        if (self.bokeModel.role.intValue == 1) {//如果用户在白名单
            __weak typeof(self) weakSelf = self;
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"当前用户在白名单，确定移到黑名单?" message:nil sureBtn:@"确定" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                    [weakSelf setWhiteOrBlackOrNomer:@"2"];
                }
            };
            [alerView showXLAlertView];
        }else if (self.bokeModel.role.intValue == 2){
            __weak typeof(self) weakSelf = self;
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定移出黑名单吗?" message:nil sureBtn:@"确定" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                    [weakSelf setWhiteOrBlackOrNomer:@"0"];
                }
            };
            [alerView showXLAlertView];
        }else{
            [self setWhiteOrBlackOrNomer:@"2"];
        }
    }else{
        if (self.bokeModel.role.intValue == 1) {//如果用户在白名单
            __weak typeof(self) weakSelf = self;
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定移出白名单?" message:nil sureBtn:@"确定" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                    [weakSelf setWhiteOrBlackOrNomer:@"0"];
                }
            };
            [alerView showXLAlertView];
        }else if (self.bokeModel.role.intValue == 2){
            __weak typeof(self) weakSelf = self;
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"当前用户在黑名单，确定移到白名单吗?" message:nil sureBtn:@"确定" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                    [weakSelf setWhiteOrBlackOrNomer:@"1"];
                }
            };
            [alerView showXLAlertView];
        }else{
            [self setWhiteOrBlackOrNomer:@"1"];
        }
    }
}

//设置名单状态
- (void)setWhiteOrBlackOrNomer:(NSString *)type{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat: @"admin/podcast/role/%@/%@?confirmPasswd=%@",self.bokeModel.user_id,type,self.managerCode] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.bokeModel.role = type;
            [self refreshTitle];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}


- (void)agreeClick{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.managerCode forKey:@"confirmPasswd"];
    [parm setObject:@"1" forKey:@"type"];

    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/podcast/%@",self.bokeModel.podcast_no] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.bokeModel.podcast_type = @"1";
            [self refreshTitle];
            if (self.refreshDataBlock) {
                self.refreshDataBlock(YES);
            }
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}


- (void)noClick{
    if (self.isJuBao && self.jubModel.podModel.podcast_status.intValue == 3) {
        return;
    }
    if (!self.inputV) {
        NoticeBBSComentInputView *inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        inputView.delegate = self;
        inputView.isRead = YES;
        inputView.ismanager = YES;
        inputView.limitNum = 100;
        inputView.needClear = YES;
        inputView.plaStr = @"输入拒绝理由";
        inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [inputView.sendButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [inputView showJustComment:nil];
        if (self.isJuBao) {
            inputView.plaStr = @"输入下架理由";
            [inputView.sendButton setTitle:@"下架" forState:UIControlStateNormal];
        }
        self.inputV = inputView;
    }
    [self.inputV showJustComment:nil];
    [self.inputV.contentView becomeFirstResponder];
    [self.inputV.backView removeFromSuperview];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self.inputV.backView];
    self.inputV.backView.hidden = NO;
}

- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.managerCode forKey:@"confirmPasswd"];
    if (!self.isJuBao) {
        [parm setObject:@"2" forKey:@"type"];
    }
    
    [parm setObject:comment forKey:@"remarks"];
    [self showHUD];
    if (self.isJuBao) {
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/podcast/%@",self.jubModel.podModel.podcast_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                self.jubModel.podModel.podcast_status = @"3";
                [self refreshTitle];
            }
            [self hideHUD];
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }else{
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/podcast/%@",self.bokeModel.podcast_no] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                self.bokeModel.podcast_type = @"3";
                [self refreshTitle];
                if (self.refreshDataBlock) {
                    self.refreshDataBlock(YES);
                }
            }
            [self hideHUD];
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }

    [self.inputV clearView];
}

- (void)refreshTitle{
    if (self.isJuBao) {
        self.sourceBtn.hidden = NO;
        if (self.bokeModel.role.intValue == 2) {
            [self.whiteBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
            self.whiteBtn.layer.borderWidth = 1;
            [self.whiteBtn setTitle:@"移出黑名单" forState:UIControlStateNormal];
            self.whiteBtn.backgroundColor = [UIColor whiteColor];
        }else{
            [self.whiteBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            self.whiteBtn.layer.borderWidth = 0;
            [self.whiteBtn setTitle:@"加入黑名单" forState:UIControlStateNormal];
            self.whiteBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        }
        
        self.agereeBtn.hidden = YES;
        self.noBtn.frame = CGRectMake(CGRectGetMaxX(self.sourceBtn.frame)+5, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-40, 65, 40);
        if (self.jubModel.podModel.podcast_status.intValue == 3) {
            [self.noBtn setTitle:@"已下架" forState:UIControlStateNormal];
            self.noBtn.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
            [self.noBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        }else{
            [self.noBtn setTitle:@"下架" forState:UIControlStateNormal];
            self.noBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
            [self.noBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        }
        
        return;
    }
    
    if (self.bokeModel.podcast_type.intValue == 1) {
        self.navBarView.titleL.text = @"已通过的播客";
    }else if (self.bokeModel.podcast_type.intValue == 2) {
        self.navBarView.titleL.text = @"待审核的播客";
    }else if (self.bokeModel.podcast_type.intValue == 3) {
        self.navBarView.titleL.text = @"已拒绝的播客";
    }
    
    if (self.bokeModel.role.intValue == 1) {
        [self.whiteBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        self.whiteBtn.layer.borderWidth = 1;
        [self.whiteBtn setTitle:@"移出白名单" forState:UIControlStateNormal];
        self.whiteBtn.backgroundColor = [UIColor whiteColor];
    }else{
        [self.whiteBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.whiteBtn.layer.borderWidth = 0;
        [self.whiteBtn setTitle:@"加入白名单" forState:UIControlStateNormal];
        self.whiteBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    }

    if (self.bokeModel.podcast_type.intValue == 1) {
        self.agereeBtn.hidden = YES;
        self.noBtn.hidden = YES;
        self.sourceBtn.hidden = NO;
    }else if (self.bokeModel.podcast_type.intValue == 3){
        self.agereeBtn.hidden = YES;
        self.noBtn.hidden = YES;
        self.sourceBtn.hidden = YES;
    }else if (self.bokeModel.podcast_type.intValue == 2){
        self.agereeBtn.hidden = NO;
        self.noBtn.hidden = NO;
        self.sourceBtn.hidden = YES;
    }
}

- (void)sendClick{

    if (!self.canSend) {
        return;
    }
    
    if (self.nameField1.text.length > 50) {
        [self showToastWithText:[NoticeTools chinese:@"标题或简介字数超限" english:@"Title or description exceeds limit" japan:@"題名または説明が制限を超えています"]];
        return;
    }
    
    if (self.nameField1.text.length > 80) {
        [self showToastWithText:[NoticeTools chinese:@"标题或简介字数超限" english:@"Title or description exceeds limit" japan:@"題名または説明が制限を超えています"]];
        return;
    }
    
    if (self.isCheckReSend) {
        if (self.hasCHoice) {//更换了图片
            [self upLoadHeader:self.cutsumeImg path:nil];
        }else{
            [self updateVoice];
        }
        return;
    }
    [self upLoadHeader:self.cutsumeImg path:nil];
}

- (void)saveTocaogao{
    NSString *timeS = [NoticeSaveVoiceTools getNowTmp];
    
    if ([NoticeSaveVoiceTools copyItemAtPath:self.locaPath toPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",timeS,[self.locaPath pathExtension]]]]) {
        NSMutableArray *alreadyArr = [NoticeSaveVoiceTools getbokepArrary];
        NoticeVoiceSaveModel *saveM = [[NoticeVoiceSaveModel alloc] init];
        saveM.sendTime = [NoticeSaveVoiceTools getTimeString];
        saveM.textContent = self.nameField2.text;
        saveM.titleName = self.nameField1.text;
        saveM.pathName = [NSString stringWithFormat:@"%@.%@",timeS,[self.locaPath pathExtension]];
        saveM.voiceTimeLen = self.timeLen;
        UIImage * imgsave = self.cutsumeImg;
        NSString *pathName = [NSString stringWithFormat:@"/%@",self.filepath];
        NSString * Pathimg = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:pathName];
        [UIImagePNGRepresentation(imgsave) writeToFile:Pathimg atomically:YES];
        saveM.img1Path = self.filepath;
        
        [alreadyArr insertObject:saveM atIndex:0];
        [NoticeSaveVoiceTools savebokeArr:alreadyArr];
        
        saveM.voiceFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[NoticeSaveVoiceTools getNowTmp],[self.locaPath pathExtension]]];
    }
}

- (void)recoClick{
    if (self.hasVoice) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"确定删除当前音频吗？" english:@"Delete current audio?" japan:@"現在の音声を削除しますか?"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"py.dele"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                AppDelegate *apple = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [apple.audioPlayer stopPlaying];
                weakSelf.hasVoice = NO;
                [weakSelf refreshSendButton];
                weakSelf.playerView.hidden = YES;
                weakSelf.recoButton.frame = CGRectMake(DR_SCREEN_WIDTH-40-74-10, 15, 74, 20);
                [weakSelf.recoButton setImage:UIImageNamed(@"Image_recoboke") forState:UIControlStateNormal];
            }
        };
        [alerView showXLAlertView];
    }else{
        
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
}

- (void)recoders{
    __weak typeof(self) weakSelf = self;
    [self resginKeyBored];
    if (_recovoiceView) {
        _recovoiceView = nil;
    }
    self.recovoiceView.hidden = NO;
    self.recovoiceView.sureFinishBlock = ^(NSString * _Nonnull path, NSString * _Nonnull tiemLength) {
        weakSelf.hasCHoiceVoice = YES;
        [weakSelf getVoice:path timeL:tiemLength];
    };
    [self.recovoiceView show];
}

- (void)setRedColor:(NSString *)redString sourceString:(NSString *)sourchString textView:(UITextView*)textView att:(NSMutableAttributedString *)att{
    if (!att) {
        att =  [[NSMutableAttributedString alloc]initWithString:sourchString];
        if (textView == self.nameField1) {
            self.attStr1 = att;
        }else{
            self.attStr2 = att;
        }
    }
    NSMutableAttributedString *nameString =  att;
    for (int i = 0; i < sourchString.length; i++) {
        if ((sourchString.length - i) < redString.length) {  //防止遍历剩下的字符少于搜索条件的字符而崩溃
            
        }else {
            NSString *str = [sourchString substringWithRange:NSMakeRange(i, redString.length)];
            if ([redString isEqualToString:str]) {
                [nameString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, redString.length)];
                
                i = i + (int)(redString.length) - 1;
            }
        }
    }
    [nameString addAttribute:NSFontAttributeName value:FIFTHTEENTEXTFONTSIZE range:NSMakeRange(0, textView.text.length)];
    textView.attributedText = nameString;
}

- (void)getVoice:(NSString *)path timeL:(NSString *)tiemLength{
    self.hasVoice = YES;
    self.timeLen = tiemLength;
    self.playerView.isLocal = YES;
    self.playerView.timeLen = tiemLength;
    self.playerView.voiceUrl = path;
    self.locaPath = path;
    self.playerView.hidden = NO;
    self.recoButton.frame = CGRectMake(DR_SCREEN_WIDTH-40-40, 5, 40, 40);
    [self.recoButton setImage:UIImageNamed(@"Image_closerecoder") forState:UIControlStateNormal];
    [self refreshSendButton];
}

- (void)longPressGestureRecognized:(id)sender{

    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    if (!self.playerView.isPlaying) {
  
        return;
    }
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
        
            [self beginDrag:0];
            [self dragWithPoint:p];
            break;
        }
        case UIGestureRecognizerStateChanged:{
        
            [self dragWithPoint:p];
            break;
        }
        default: {
            [self endDrag:0 progross:p.x/self.playerView.frame.size.width];

            break;
        }
    }
}

- (void)beginDrag:(NSInteger)tag{

    AppDelegate *apple = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [apple.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro{
    AppDelegate *apple = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [apple.audioPlayer pause:YES];

    [apple.audioPlayer pause:NO];
    [self.playerView.playButton setImage:UIImageNamed(@"newbtnplay") forState:UIControlStateNormal];
    [apple.audioPlayer.player seekToTime:CMTimeMake(self.draFlot, 1) completionHandler:^(BOOL finished) {
     
    }];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    
    self.draFlot = dratNum;
}

- (void)dragWithPoint:(CGPoint)p{
    self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;
    if ((self.timeLen.floatValue/self.playerView.frame.size.width)*p.x < self.timeLen.length/5) {
        return;
    }
    [self dragingFloat:(self.timeLen.floatValue/self.playerView.frame.size.width)*p.x index:0];
}


-(void)keyboardWillChangeFrame:(NSNotification *)notification{

    self.tableView.contentOffset = CGPointMake(0, 0);
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+20-203-40, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-20-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-20-40);
}

- (void)keyboardDiddisss{
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+20, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-20-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-20-40);

}

- (void)keyboardDidShow{
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+20-203-40, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-20-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-20-40);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
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
    if (height > 80) {
        height = 80;
    }
    
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        textView.frame = frame;
    } completion:nil];
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    self.attStr1 = nil;
    self.attStr2 = nil;
    if (textView == self.nameField1) {
        if (textView.text.length) {
            _plaL1.text = @"";
        }else{
            _plaL1.text = [NoticeTools getLocalStrWith:@"b.cleartitle"];
        }
        
        if (textView.text.length > 50) {
            self.numL1.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/50",textView.text.length] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",textView.text.length] beginSize:0];
            
        }else{
            NSString *allStr = [NSString stringWithFormat:@"%lu/50",textView.text.length];
            self.numL1.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#5C5F66"] setLengthString:@"50" beginSize:allStr.length-3];
        }
    }else{
        if (textView.text.length) {
            _plaL2.text = @"";
        }else{
            _plaL2.text = [NoticeTools getLocalStrWith:@"b.sayou"];
        }
        
        if (textView.text.length > 80) {
            self.numL2.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/80",textView.text.length] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",textView.text.length] beginSize:0];
            
        }else{
            NSString *allStr = [NSString stringWithFormat:@"%lu/80",textView.text.length];
            self.numL2.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#5C5F66"] setLengthString:@"50" beginSize:allStr.length-3];
        }
    }
    [self refreshSendButton];
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


- (void)choiceTap{
    
    [self resginKeyBored];
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = false;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = false;
    imagePicker.allowCrop = true;
    imagePicker.cropRect = CGRectMake(0,(DR_SCREEN_HEIGHT-(DR_SCREEN_WIDTH*203/305))/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*203/305);
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (void)resginKeyBored{
    [self.nameField1 resignFirstResponder];
    [self.nameField2 resignFirstResponder];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    self.cutsumeImg = choiceImage;
    self.choiceImageView.image = self.cutsumeImg;
    self.choiceButton.hidden = YES;
    self.changeBtn.hidden = NO;
    self.hasCHoice = YES;
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99999999999];
        }
        self.filepath = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]];
    }];
    [self refreshSendButton];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path{
    if (!path) {

        path = [NSString stringWithFormat:@"%@_%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99999999999];
    }
    
    [self showHUD];
    self.sendBtn.enabled = NO;
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"80" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            self.imgUrl = Message;
            if (bucketId) {
                self.bucketId = bucketId;
            }else{
                self.bucketId = @"0";
            }
            [self updateVoice];
            
        }else{
            [self hideHUD];
            self.sendBtn.enabled = YES;
            if (self.isCheckReSend) {
                if (self.isCheckReSend) {
                    [self showToastWithText:@"投稿失败，请检查网络"];
                    
                    return;
                }
                return;
            }
            [self ifSafe];
        }
    }];
}

- (void)updateVoice{
    [self hideHUD];
    [self showHUD];
    if (!self.hasCHoiceVoice && self.isCheckReSend) {//重新投稿没有改变音频
        [self reSend:self.bokeModel.audio_url timeLen:self.bokeModel.total_time];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,self.locaPath]],[self.locaPath pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"81" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];
    [[XGUploadDateManager sharedManager] uploadNoToastVoiceWithVoicePath:self.locaPath parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            if (bucketId) {
                self.bucketId = bucketId;
            }else{
                self.bucketId = @"0";
            }
     
            if (self.isCheckReSend) {
                [self reSend:Message timeLen:self.timeLen];
                return;
            }
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:self.nameField1.text forKey:@"podcastTitle"];
            [parm setObject:self.nameField2.text forKey:@"podcastIntro"];
            [parm setObject:self.imgUrl forKey:@"coverUri"];
            [parm setObject:Message forKey:@"audioUri"];
            [parm setObject:self.timeLen forKey:@"totalTime"];
            [parm setObject:@"0" forKey:@"bucketId"];
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"podcast" Accept:@"application/vnd.shengxi.v5.4.4+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    if ([dict[@"data"] isEqual:[NSNull null]]) {
                        return ;
                    }
                    __weak typeof(self) weakSelf = self;
                    NoticeBokeTosatView *tostView = [[NoticeBokeTosatView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
                    tostView.refreshDataBlock = ^(BOOL refresh) {
                        if (weakSelf.refreshDataBlock) {
                            weakSelf.refreshDataBlock(YES);
                        }
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    };
                    [tostView showChoiceView];
                }else{
                    NoticeOneToOne *msgModel = [NoticeOneToOne mj_objectWithKeyValues:dict];
          
                    if (msgModel.chatM.keyword.count) {
                        for (NSString *str in msgModel.chatM.keyword) {
                            [self setRedColor:str sourceString:self.nameField1.text textView:self.nameField1 att:self.attStr1];
                            [self setRedColor:str sourceString:self.nameField2.text textView:self.nameField2 att:self.attStr2];
                        }
                    }
                }
                self->_sendBtn.enabled = YES;
            } fail:^(NSError *error) {
                [self hideHUD];
                self->_sendBtn.enabled = YES;
                [self ifSafe];
            }];
        }
        else{
            self->_sendBtn.enabled = YES;
            [self hideHUD];
            if (self.isCheckReSend) {
                [self showToastWithText:@"投稿失败，请检查网络"];
                return;
            }
            [self ifSafe];
        }
    }];
}

- (void)reSend:(NSString *)voicePath timeLen:(NSString *)timeLen{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];

    [parm setObject:self.nameField1.text forKey:@"podcastTitle"];
    [parm setObject:self.nameField2.text forKey:@"podcastIntro"];
    [parm setObject:self.imgUrl?self.imgUrl:self.bokeModel.cover_url forKey:@"coverUri"];
    [parm setObject:voicePath forKey:@"audioUri"];
    [parm setObject:timeLen forKey:@"totalTime"];

    [parm setObject:self.bucketId?self.bucketId: @"0" forKey:@"bucketId"];
  
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"podcast/%@",self.bokeModel.podcast_no] Accept:@"application/vnd.shengxi.v5.4.4+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            __weak typeof(self) weakSelf = self;
            NoticeBokeTosatView *tostView = [[NoticeBokeTosatView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            tostView.refreshDataBlock = ^(BOOL refresh) {
                if (weakSelf.refreshDataBlock) {
                    weakSelf.refreshDataBlock(YES);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [tostView showChoiceView];
        }else{
            NoticeOneToOne *msgModel = [NoticeOneToOne mj_objectWithKeyValues:dict];
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"投稿失败" english:@"Failed" japan:@"失敗した"] message:msgModel.msg cancleBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"]];
            [alerView showXLAlertView];
            if (msgModel.chatM.keyword.count) {
                for (NSString *str in msgModel.chatM.keyword) {
                    [self setRedColor:str sourceString:self.nameField1.text textView:self.nameField1 att:self.attStr1];
                    [self setRedColor:str sourceString:self.nameField2.text textView:self.nameField2 att:self.attStr2];
                }
            }
        }
    } fail:^(NSError * _Nullable error) {
    
        [self hideHUD];
        [self showToastWithText:@"投稿失败，请检查网络"];
    }];
}

- (void)ifSafe{
    [self saveTocaogao];
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"投稿失败" english:@"Failed" japan:@"失敗した"] message:[NoticeTools chinese:@"内容已保存到「我的播客-稿件中心」" english:@"Podcast saved at My Podcast-List" japan:@"私のポッドキャスト-リスト に保存された"] cancleBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"]];
    alerView.resultIndex = ^(NSInteger index) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [alerView showXLAlertView];
}

- (void)backClick{
    [self resginKeyBored];

    if (self.isCheckReSend) {
        if (self.hasCHoice || self.hasCHoiceVoice || ![self.bokeModel.podcast_intro isEqualToString:self.nameField2.text] || ![self.bokeModel.podcast_title isEqualToString:self.nameField1.text]) {
            __weak typeof(self) weakSelf = self;
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"确定放弃投稿吗？" english:@"Discard changes?" japan:@"変更を破棄？"] message:self.isCheckReSend?[NoticeTools chinese:@"内容将不会保存 " english:@"Content won't be saved" japan:@"コンテンツは保存されません"] :[NoticeTools getLocalStrWith:@"xl.nosavenr"] sureBtn:[NoticeTools getLocalStrWith:@"xl.suresure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            };
            [alerView showXLAlertView];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    
    if ((self.cutsumeImg || self.nameField1.text.length || self.nameField2.text.length || self.hasVoice) && !self.isCheck && !self.isJuBao) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"确定放弃投稿吗？" english:@"Discard changes?" japan:@"変更を破棄？"] message:self.isCheckReSend?[NoticeTools chinese:@"内容将不会保存 " english:@"Content won't be saved" japan:@"コンテンツは保存されません"] :[NoticeTools getLocalStrWith:@"xl.nosavenr"] sureBtn:[NoticeTools getLocalStrWith:@"xl.suresure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
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

- (void)refreshSendButton{
    if (self.cutsumeImg && self.nameField1.text.length && self.nameField2.text.length && self.hasVoice) {
        self.sendBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.canSend = YES;
    }else{
        self.canSend = NO;
        self.sendBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.sendBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    appdel.noPop = YES;

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.isCheck || self.isJuBao) {
        self.speedL.text = @"音频  倍速";
        [NoticeTools voicePlayRate:@"1"];
    }
    
    [self resginKeyBored];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    appdel.noPop = NO;
    [appdel.audioPlayer stopPlaying];
}

- (void)beisutAP{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex > 0) {
            [NoticeTools voicePlayRate:[NSString stringWithFormat:@"%ld",buttonIndex]];
            if ([NoticeTools voicePlayRate] == 1) {
                self.speedL.text = @"音频  倍速";
            }else if ([NoticeTools voicePlayRate] == 2){
                self.speedL.text = @"音频  1.25x";
            }else if ([NoticeTools voicePlayRate] == 3){
                self.speedL.text = @"音频  1.5x";
            }else if ([NoticeTools voicePlayRate] == 4){
                self.speedL.text = @"音频  2.0x";
            }
            else{
                self.speedL.text = @"音频  倍速";
            }
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.audioPlayer setPlayRate];
        }
    } otherButtonTitleArray:@[@"1.0x",@"1.25x",@"1.5x",@"2.0x"]];
    [sheet show];

}
@end
