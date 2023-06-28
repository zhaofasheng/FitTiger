//
//  NoticeVoiceChoiceView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/16.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceChoiceView.h"

@implementation NoticeVoiceChoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 20)];
        timeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        timeL.font = FOURTHTEENTEXTFONTSIZE;
        timeL.text = [NoticeTools getLocalStrWith:@"mineme.sj"];
        [self addSubview:timeL];
        
        NSArray *arr = @[[NoticeTools getLocalStrWith:@"mineme.year"],[NoticeTools getLocalStrWith:@"mineme.mon"],[NoticeTools getLocalStrWith:@"mineme.day"]];
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+((DR_SCREEN_WIDTH-40-30)/3+15)*i, CGRectGetMaxY(timeL.frame)+10, (DR_SCREEN_WIDTH-40-30)/3, 35)];
            btn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            btn.layer.cornerRadius = 35/2;
            btn.layer.masksToBounds = YES;
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
            [self addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(timeChoiceClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                self.yearBbn = btn;
            }else if (i == 1){
                self.monBtn = btn;
            }else{
                self.dayBtn = btn;
            }
        }
        
        self.timeButton = [[UIButton alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(self.yearBbn.frame)+15, DR_SCREEN_WIDTH-40, 35)];
        self.timeButton.layer.cornerRadius = 4;
        self.timeButton.layer.masksToBounds = YES;
        self.timeButton.layer.borderWidth = 1;
        self.timeButton.layer.borderColor = [UIColor colorWithHexString:@"#25262E"].CGColor;
        self.timeButton.titleLabel.font = XGSIXBoldFontSize;
        [self.timeButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        [self addSubview:self.timeButton];
        [self.timeButton addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.timeButton.hidden = YES;
        
        self.tofromView = [[UIView alloc] initWithFrame:self.timeButton.frame];
        [self addSubview:self.tofromView];
        self.tofromView.hidden = YES;
        
        self.timeButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0,0, (DR_SCREEN_WIDTH-40-34)/2, 35)];
        self.timeButton2.layer.cornerRadius = 4;
        self.timeButton2.layer.masksToBounds = YES;
        self.timeButton2.layer.borderWidth = 1;
        self.timeButton2.layer.borderColor = [UIColor colorWithHexString:@"#25262E"].CGColor;
        self.timeButton2.titleLabel.font = XGSIXBoldFontSize;
        [self.timeButton2 setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        [self.tofromView addSubview:self.timeButton2];
        [self.timeButton2 addTarget:self action:@selector(time2Click) forControlEvents:UIControlEventTouchUpInside];
        
        self.timeButton3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeButton2.frame)+34,0, (DR_SCREEN_WIDTH-40-34)/2, 35)];
        self.timeButton3.layer.cornerRadius = 4;
        self.timeButton3.layer.masksToBounds = YES;
        self.timeButton3.layer.borderWidth = 1;
        self.timeButton3.layer.borderColor = [UIColor colorWithHexString:@"#25262E"].CGColor;
        self.timeButton3.titleLabel.font = XGSIXBoldFontSize;
        [self.timeButton3 setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        [self.tofromView addSubview:self.timeButton3];
        [self.timeButton3 addTarget:self action:@selector(time3Click) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeButton2.frame)+5, 34/2, 24, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [self.tofromView addSubview:line];
        
        UILabel *gsL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.timeButton.frame)+30, 100, 20)];
        gsL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        gsL.font = FOURTHTEENTEXTFONTSIZE;
        gsL.text = [NoticeTools getLocalStrWith:@"mineme.geshi"];
        [self addSubview:gsL];
        
        NSArray *arr1 = @[[NoticeTools getLocalStrWith:@"search.voice"],[NoticeTools getLocalStrWith:@"search.text"]];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+((DR_SCREEN_WIDTH-40-30)/3+20)*i, CGRectGetMaxY(gsL.frame)+10, (DR_SCREEN_WIDTH-40-30)/3, 35)];
            btn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            btn.layer.cornerRadius = 35/2;
            btn.layer.masksToBounds = YES;
            [btn setTitle:arr1[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
            [self addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(gsClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                self.voiceBbn = btn;
            }else if (i == 1){
                self.textBtn = btn;
            }
        }
        
        self.buttonView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.voiceBbn.frame)+30, DR_SCREEN_WIDTH, 65)];
        [self addSubview:self.buttonView1];
        self.buttonView1.hidden = YES;
        
        UILabel *shareL = [[UILabel alloc] initWithFrame:CGRectMake(20,0, 200, 20)];
        shareL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        shareL.font = FOURTHTEENTEXTFONTSIZE;
        shareL.text = @"心情可见范围(语音心情)";
        [self.buttonView1 addSubview:shareL];
        
        NSArray *arr2 = @[[NoticeTools getLocalStrWith:@"n.open"],[NoticeTools getLocalStrWith:@"n.tpkjian"],[NoticeTools getLocalStrWith:@"n.onlyself"]];
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+((DR_SCREEN_WIDTH-40-30)/3+20)*i, CGRectGetMaxY(shareL.frame)+10, (DR_SCREEN_WIDTH-40-30)/3, 35)];
            btn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            btn.layer.cornerRadius = 35/2;
            btn.layer.masksToBounds = YES;
            [btn setTitle:arr2[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
            [self.buttonView1 addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                self.shareBbn = btn;
            }else if (i == 1){
                self.noshareBbn = btn;
            }else{
                self.noshareBbn1 = btn;
            }
        }
        
        self.buttonView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.voiceBbn.frame)+30, DR_SCREEN_WIDTH, 65+45)];
        [self addSubview:self.buttonView2];
        self.buttonView2.hidden = YES;
        
        UILabel *statusL = [[UILabel alloc] initWithFrame:CGRectMake(20,0, 200, 20)];
        statusL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        statusL.font = FOURTHTEENTEXTFONTSIZE;
        statusL.text = [NoticeTools getLocalStrWith:@"mineme.status"];
        [self.buttonView2 addSubview:statusL];

 
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+((DR_SCREEN_WIDTH-40-30)/3+20)*i, CGRectGetMaxY(statusL.frame)+10, (DR_SCREEN_WIDTH-40-30)/3, 35)];
            btn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            btn.layer.cornerRadius = 35/2;
            btn.layer.masksToBounds = YES;
            [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
            [self.buttonView2 addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(statusClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                self.kxBbn = btn;
            }else if (i == 1){
                self.sqBbn = btn;
            }else if (i == 2){
                self.pdBbn = btn;
            }
        }
        self.ngBbn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.sqBbn.frame)+10, (DR_SCREEN_WIDTH-40-30)/3, 35)];
        self.ngBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.ngBbn.layer.cornerRadius = 35/2;
        self.ngBbn.layer.masksToBounds = YES;
        [self.ngBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.ngBbn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self addSubview:self.ngBbn];
        self.ngBbn.tag = 3;
        [self.ngBbn addTarget:self action:@selector(statusClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView2 addSubview:self.ngBbn];
        
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        self.year = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy"];
        self.day = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy-MM-dd"];
        self.month = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy-MM"];
        
        [self request];
    }
    return self;
}

- (void)request{
    NSString *url = nil;
    url = @"voice/state";
    self.dataArr = [NSMutableArray new];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {

        if (success) {
   
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceStatusModel *model = [NoticeVoiceStatusModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                [self.kxBbn setTitle:[self.dataArr[0] category_name] forState:UIControlStateNormal];
            }
            if (self.dataArr.count > 1) {
                [self.sqBbn setTitle:[self.dataArr[1] category_name] forState:UIControlStateNormal];
            }
            if (self.dataArr.count >2) {
                [self.pdBbn setTitle:[self.dataArr[2] category_name] forState:UIControlStateNormal];
            }
            if (self.dataArr.count >3) {
                [self.ngBbn setTitle:[self.dataArr[3] category_name] forState:UIControlStateNormal];
            }
       
        }
    } fail:^(NSError * _Nullable error) {

    }];
}

- (void)timeChoiceClick:(UIButton *)btn{
    self.type = btn.tag;
    [self.timeButton setTitle:self.type==1?self.month: self.year forState:UIControlStateNormal];
    [self.timeButton2 setTitle:self.day forState:UIControlStateNormal];
    [self.timeButton3 setTitle:self.day forState:UIControlStateNormal];
    if (btn.tag == 0) {
        [self.yearBbn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.yearBbn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.monBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.monBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.dayBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.dayBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else if(btn.tag == 1){
        [self.monBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.monBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.yearBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.yearBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.dayBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.dayBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else{
        [self.dayBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.dayBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.monBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.monBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.yearBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.yearBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    if (btn.tag == 2) {
        self.tofromView.hidden = NO;
        self.timeButton.hidden = YES;
    }else{
        self.tofromView.hidden = YES;
        self.timeButton.hidden = NO;
    }
    if (self.choiceClickBlock) {
        self.choiceClickBlock(btn.tag);
    }
}

- (void)timeClick{
    if (self.choiceTimeBlock) {
        self.choiceTimeBlock(self.type);
    }
}

- (void)time2Click{
    self.type = 3;
    if (self.choiceTimeBlock) {
        self.choiceTimeBlock(self.type);
    }
}

- (void)time3Click{
    self.type = 4;
    if (self.choiceTimeBlock) {
        self.choiceTimeBlock(self.type);
    }
}

- (void)gsClick:(UIButton *)btn{
    self.gsType = btn.tag;
    if (self.voiceTypeBlock) {
        self.voiceTypeBlock(btn.tag+1);
    }
    if (btn.tag == 0) {
        self.buttonView1.hidden = NO;
        self.buttonView2.hidden = YES;
        [self.voiceBbn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.voiceBbn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.textBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.textBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else{
        [self.textBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.textBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.voiceBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.voiceBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.buttonView1.hidden = YES;
        self.buttonView2.hidden = NO;
    }
}

- (void)shareClick:(UIButton *)btn{
    self.shareType = btn.tag;
    if (self.shareClickBlock) {
        self.shareClickBlock(btn.tag+1);
    }
    if (btn.tag == 0) {
        [self.shareBbn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.shareBbn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.noshareBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.noshareBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.noshareBbn1 setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.noshareBbn1.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else if(btn.tag == 1){
        [self.noshareBbn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.noshareBbn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.shareBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.shareBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.noshareBbn1 setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.noshareBbn1.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else{
        [self.noshareBbn1 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.noshareBbn1.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.shareBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.shareBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.noshareBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.noshareBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
}

- (void)statusClick:(UIButton *)btn{
    self.statusType = btn.tag;
    if (btn.tag == 0) {
        [self.kxBbn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.kxBbn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.sqBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.sqBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.pdBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.pdBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.ngBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.ngBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else if(btn.tag == 1){
        [self.sqBbn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.sqBbn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.kxBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.kxBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.pdBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.pdBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.ngBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.ngBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else if(btn.tag == 2){
        [self.pdBbn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.pdBbn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.sqBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.sqBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.kxBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.kxBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.ngBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.ngBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else{
        [self.ngBbn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.ngBbn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.sqBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.sqBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.pdBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.pdBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.kxBbn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.kxBbn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    if (self.dataArr.count-1 >= btn.tag) {
        if (self.statusClickBlock) {
            self.statusClickBlock([self.dataArr[btn.tag] category_id]);
        }
    }
}
@end
