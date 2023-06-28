//
//  NoticeChatStyleSetController.m
//  NoticeXi
//
//  Created by li lei on 2020/5/9.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeChatStyleSetController.h"
#import "NoticeNoticenterModel.h"
#import "NoticrChatLike.h"
@interface NoticeChatStyleSetController ()
@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, strong) UILabel *headL;
@property (nonatomic, strong) UILabel *subheadL1;
@property (nonatomic, strong) UISwitch* switchButton;
@property (nonatomic, strong) UILabel *subheadL2;
@property (nonatomic, strong) UILabel *subheadL3;
@property (nonatomic, strong) UILabel *subheadL4;
@property (nonatomic, strong) NSMutableArray *hobbyArr;
@property (nonatomic, strong) NSMutableArray *tipsArr;
@property (nonatomic, strong) NSMutableArray *tipsModelArr;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSString *strValeue;
@property (nonatomic, strong) NSString *oldValeue;
@property (nonatomic, strong) UIColor *oldThumColor;
@property (nonatomic, strong) UIColor *oldThinColor;
@property (nonatomic, strong) NSString *isAuto;
@property (nonatomic, assign) BOOL oldTips1;
@property (nonatomic, assign) BOOL oldTips2;
@property (nonatomic, assign) BOOL oldTips3;
@property (nonatomic, assign) BOOL oldTips4;
@property (nonatomic, strong) UIButton *autoButton;
@end

@implementation NoticeChatStyleSetController
{
    NSMutableArray *_btnArr1;
    NSMutableArray *_btnArr2;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    UIButton *tipbtn1 = _btnArr2[0];
    UIButton *tipbtn2 = _btnArr2[1];
    if (!(self.oldTips1 == tipbtn1.selected && self.oldTips2 == tipbtn2.selected)) {
        [self setTips];
    }
    
    if (self.strValeue && ![self.oldValeue isEqualToString:self.strValeue]) {
        [self setHobby];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.navigationItem.title = [NoticeTools getTextWithSim:@"交流习惯设置" fantText:@"交流習慣設置"];
    
    self.actionView = [[UIView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.actionView.backgroundColor = [NoticeTools isWhiteTheme]?[UIColor whiteColor]:[UIColor colorWithHexString:@"#181828"];
    [self.view addSubview:self.actionView];
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    backV.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
    [self.actionView addSubview:backV];
    self.subheadL4 = [[UILabel alloc] initWithFrame:CGRectMake(15,0,DR_SCREEN_WIDTH,40)];
    self.subheadL4.numberOfLines = 0;
    self.subheadL4.font = FOURTHTEENTEXTFONTSIZE;
    self.subheadL4.textColor = GetColorWithName(VDarkTextColor);
    self.subheadL4.text = [NoticeTools isSimpleLau]?@"选中后他人可以在悄悄话和私聊时了解你的交流习惯":@"選中後他人可以在回聲和私聊時了解妳的交流習慣";
    [backV addSubview:self.subheadL4];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(15,68,21, 21);
    [btn1 setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"online_img":@"online_imgy") forState:UIControlStateNormal];
    [self.actionView addSubview:btn1];
    
    CGFloat titiWidth = GET_STRWIDTH(@"不方便立刻回复", 17, 17);
    self.headL = [[UILabel alloc] initWithFrame:CGRectMake(50,50+20,titiWidth, 17)];
    self.headL.textColor = GetColorWithName(VMainTextColor);
    self.headL.textAlignment = NSTextAlignmentCenter;
    self.headL.font = SEVENTEENTEXTFONTSIZE;
    self.headL.text = [NoticeTools isSimpleLau] ? @"不方便立刻回复":@"不方便立刻回復";
    [self.actionView addSubview:self.headL];
    
    CGFloat titleHeight = GET_STRHEIGHT(GETTEXTWITE(@"newlxp.titl1"), 14, DR_SCREEN_WIDTH-48)+6;
    
    self.subheadL1 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.headL.frame)+25,DR_SCREEN_WIDTH-48,titleHeight)];
    self.subheadL1.numberOfLines = 0;
    self.subheadL1.font = FOURTHTEENTEXTFONTSIZE;
    self.subheadL1.textColor = GetColorWithName(VMainTextColor);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:GETTEXTWITE(@"newlxp.titl1")];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [GETTEXTWITE(@"newlxp.titl1") length])];
    self.subheadL1.attributedText = attributedString;
    [self.actionView addSubview:self.subheadL1];
    
    self.subheadL2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.subheadL1.frame)+51,DR_SCREEN_WIDTH-30,14)];
    self.subheadL2.numberOfLines = 0;
    self.subheadL2.font = FOURTHTEENTEXTFONTSIZE;
    self.subheadL2.textColor = GetColorWithName(VMainTextColor);
    self.subheadL2.text = [NoticeTools isSimpleLau]?@"我喜欢的沟通方式(单选)：":@"我喜歡的溝通方式(單選)：";
    [self.actionView addSubview:self.subheadL2];
    
    _btnArr1 = [NSMutableArray new];
    NSArray *buttonTitleArr1 = @[[NoticeTools isSimpleLau]?@"语音拆成小段":@"語音拆成小段",[NoticeTools isSimpleLau]?@"单条长语音":@"单条长語音"];
    for (int i = 0; i < 2; i++) {
        UIButton *voiceLenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceLenBtn.frame = CGRectMake(15+120*i, CGRectGetMaxY(self.subheadL2.frame)+25, 100, 25);
        voiceLenBtn.tag = i;
        [voiceLenBtn setTitle:buttonTitleArr1[i] forState:UIControlStateNormal];
        
        [voiceLenBtn setTitleColor:[NoticeTools isWhiteTheme]?[UIColor whiteColor]:[UIColor colorWithHexString:@"#B2B2B2"] forState:UIControlStateSelected];
        [voiceLenBtn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#D0D0D0":@"#3E3E4A"] forState:UIControlStateNormal];
        
        voiceLenBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        voiceLenBtn.layer.cornerRadius = 25/2;
        voiceLenBtn.layer.masksToBounds = YES;
        voiceLenBtn.backgroundColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
        [voiceLenBtn addTarget:self action:@selector(setLongVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArr1 addObject:voiceLenBtn];
        [self.actionView addSubview:voiceLenBtn];
    }
    
    self.subheadL3 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.subheadL2.frame)+51+50,DR_SCREEN_WIDTH-30,14)];
    self.subheadL3.numberOfLines = 0;
    self.subheadL3.font = FOURTHTEENTEXTFONTSIZE;
    self.subheadL3.textColor = GetColorWithName(VMainTextColor);
    self.subheadL3.text = [NoticeTools isSimpleLau]?@"请尊重我，私聊时(多选)：":@"請尊重我，私聊時(多選)：";
    [self.actionView addSubview:self.subheadL3];
    
    _btnArr2 = [NSMutableArray new];
    NSArray *buttonTitleArr2 = @[@"NO联系方式",[NoticeTools isSimpleLau]?@"NO查户口":@"NO查戶口"];
    CGFloat btnWidth = (DR_SCREEN_WIDTH-70)/4;
    for (int i = 0; i < buttonTitleArr2.count; i++) {
        UIButton *voiceLenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceLenBtn.frame = CGRectMake(20+(btnWidth+10)*i, CGRectGetMaxY(self.subheadL3.frame)+25, btnWidth, 25);
        if (i == 0) {
            voiceLenBtn.tag = 0;
        }else{
            voiceLenBtn.tag = 3;
        }
        [voiceLenBtn setTitle:buttonTitleArr2[i] forState:UIControlStateNormal];
        
        [voiceLenBtn setTitleColor:[NoticeTools isWhiteTheme]?[UIColor whiteColor]:[UIColor colorWithHexString:@"#B2B2B2"] forState:UIControlStateSelected];
        [voiceLenBtn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#D0D0D0":@"#3E3E4A"] forState:UIControlStateNormal];
        voiceLenBtn.backgroundColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
        voiceLenBtn.titleLabel.font = TWOTEXTFONTSIZE;
        voiceLenBtn.layer.cornerRadius = 25/2;
        voiceLenBtn.layer.masksToBounds = YES;
        [voiceLenBtn addTarget:self action:@selector(setNOVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArr2 addObject:voiceLenBtn];
        [self.actionView addSubview:voiceLenBtn];
    }
    
    
    UISwitch* switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headL.frame)+7, self.headL.frame.origin.y-7,30,17)];
    switchButton.onTintColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
    self.oldThumColor = switchButton.thumbTintColor;
    self.oldThinColor = switchButton.tintColor;
    [switchButton addTarget:self action:@selector(changeOnVale:) forControlEvents:UIControlEventValueChanged];
    switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [self.actionView addSubview:switchButton];
    _switchButton = switchButton;
    
    [self requestSet];
}


- (void)setLongVoice:(UIButton *)btn{
    UIButton *button1 = _btnArr1[0];
    UIButton *button2 = _btnArr1[1];
    
    NSString *strVal = nil;
    
    if (btn.tag == 0) {
        button1.selected = !button1.selected;
        strVal = button1.selected? @"1":@"0";
        button2.selected = NO;
        button1.backgroundColor = button1.selected? [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"]:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
        button2.backgroundColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
    }else{
        button2.selected = !button2.selected;
        strVal = button2.selected? @"2":@"0";
        button1.selected = NO;
        button2.backgroundColor = button2.selected? [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"]:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
        button1.backgroundColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
    }

    self.strValeue = strVal;

}

- (void)setNOVoice:(UIButton *)btn{

    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
    }else{
        btn.backgroundColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
    }
}

- (void)setTips{
    self.selectArr = [NSMutableArray new];
    for (int i = 0; i < self->_btnArr2.count; i++) {
        UIButton *tipBtn = self->_btnArr2[i];
        if (tipBtn.selected) {
            [self.selectArr addObject:[NSString stringWithFormat:@"%@",i == 0?@"1":@"4"]];
        }
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:[NoticeTools convertToJsonData:self.selectArr] forKey:@"chatTips"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self refreshSet];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
    
    if (!self.strValeue) {
        return;
    }
    if ([self.strValeue isEqualToString:self.oldValeue]) {
        return;
    }

}

- (void)setHobby{
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:self.strValeue forKey:@"chatHobby"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm1 page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.oldValeue = self.strValeue;
            [self refreshSet];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)requestSet{

    self.tipsModelArr = [NSMutableArray new];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeNoticenterModel*noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            self.isAuto = noticeM.auto_reply;
            [self->_switchButton setOn:self.isAuto.integerValue];
            self.isAuto = noticeM.auto_reply;
            if (!self.isAuto.intValue) {
                [self.autoButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"online_img":@"online_imgy") forState:UIControlStateNormal];
            }else{
                [self.autoButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"no_online_img":@"no_online_imgy") forState:UIControlStateNormal];
            }
            NoticeNull *nullM = [NoticeNull mj_objectWithKeyValues:dict[@"data"]];
            
            NoticrChatLike *likem = [NoticrChatLike new];
            if (!nullM.chat_hobby) {
            }else{
                likem = [NoticrChatLike mj_objectWithKeyValues:dict[@"data"][@"chat_hobby"]];
            }
            
            UIButton *button1 = self->_btnArr1[0];
            UIButton *button2 = self->_btnArr1[1];
            self.strValeue = likem.likeId;
            self.oldValeue = self.strValeue;
            if ([likem.likeId isEqualToString:@"1"]) {
                button1.selected = YES;
                button2.selected = NO;
                button1.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
                button2.backgroundColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
            }else if ([likem.likeId isEqualToString:@"2"]){
                button2.selected = YES;
                button1.selected = NO;
                button2.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
                button1.backgroundColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
            }
            
            if (nullM.chat_tips.count) {
                for (NSDictionary *dic in dict[@"data"][@"chat_tips"]) {
                    NoticrChatLike *tipM = [NoticrChatLike mj_objectWithKeyValues:dic];
                    if (tipM) {
                        [self.tipsModelArr addObject:tipM];
                    }
                }
            }
            
            for (int i = 0; i < self->_btnArr2.count; i++) {
                UIButton *tipBtn = self->_btnArr2[i];
                tipBtn.selected = NO;
            }
            
            for (NoticrChatLike *tipM in self.tipsModelArr) {
                if ([tipM.likeId isEqualToString:@"1"]) {
                    UIButton *tipBtn = self->_btnArr2[0];
                    tipBtn.selected = YES;
                }else if ([tipM.likeId isEqualToString:@"4"]){
                    UIButton *tipBtn = self->_btnArr2[1];
                    tipBtn.selected = YES;
                }
               
            }
            for (int i = 0; i < self->_btnArr2.count; i++) {
                UIButton *tipBtn = self->_btnArr2[i];
                if (i == 0) {
                    self.oldTips1 = tipBtn.selected;
                }else if (i == 1){
                    self.oldTips2 = tipBtn.selected;
                }
            }
            [self refreshButton];
            
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)refreshSet{
    [self showHUD];
    self.tipsModelArr = [NSMutableArray new];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeNoticenterModel*noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            NoticeNull *nullM = [NoticeNull mj_objectWithKeyValues:dict[@"data"]];
            self.isAuto = noticeM.auto_reply;
            [self->_switchButton setOn:self.isAuto.integerValue];
            NoticrChatLike *likem = [NoticrChatLike new];
            if (!nullM.chat_hobby) {
            }else{
                likem = [NoticrChatLike mj_objectWithKeyValues:dict[@"data"][@"chat_hobby"]];
            }
      
            UIButton *button1 = self->_btnArr1[0];
            UIButton *button2 = self->_btnArr1[1];
            
            self.strValeue = likem.likeId;
            self.oldValeue = self.strValeue;
            
            if ([likem.likeId isEqualToString:@"1"]) {
                button1.selected = YES;
                button2.selected = NO;
                button1.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
                button2.backgroundColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
            }else if([likem.likeId isEqualToString:@"2"]){
                button2.selected = YES;
                button1.selected = NO;
                button2.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
                button1.backgroundColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
            }
            
            if (nullM.chat_tips.count) {
                for (NSDictionary *dic in dict[@"data"][@"chat_tips"]) {
                    NoticrChatLike *tipM = [NoticrChatLike mj_objectWithKeyValues:dic];
                    if (tipM) {
                        [self.tipsModelArr addObject:tipM];
                    }
                }
            }
            
            for (int i = 0; i < self->_btnArr2.count; i++) {
                UIButton *tipBtn = self->_btnArr2[i];
                tipBtn.selected = NO;
            }
            
            for (NoticrChatLike *tipM in self.tipsModelArr) {
                if ([tipM.likeId isEqualToString:@"1"]) {
                    UIButton *tipBtn = self->_btnArr2[0];
                    tipBtn.selected = YES;
                }else if ([tipM.likeId isEqualToString:@"4"]){
                    UIButton *tipBtn = self->_btnArr2[1];
                    tipBtn.selected = YES;
                }
            }
            
            for (int i = 0; i < self->_btnArr2.count; i++) {
                UIButton *tipBtn = self->_btnArr2[i];
                if (i == 0) {
                    self.oldTips1 = tipBtn.selected;
                }else if (i == 1){
                    self.oldTips2 = tipBtn.selected;
                }else if (i == 2){
                    self.oldTips3 = tipBtn.selected;
                }else{
                    self.oldTips4 = tipBtn.selected;
                }
            }
            
            [self refreshButton];
            
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)refreshButton{
    for (UIButton *button in _btnArr2) {
        [button setTitleColor:[NoticeTools isWhiteTheme]?[UIColor whiteColor]:[UIColor colorWithHexString:@"#B2B2B2"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#D0D0D0":@"#3E3E4A"] forState:UIControlStateNormal];
        if (button.selected) {
            button.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
        }else{
            button.backgroundColor =  [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
        }
    }
}

- (void)changeOnVale:(UISwitch *)switchbutton{

    NSString *strVal = nil;
    if (switchbutton.isOn) {
        strVal = @"1";
    }else{
        strVal = @"0";
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:strVal forKey:@"autoReply"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {

          
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}
@end
