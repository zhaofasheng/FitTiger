//
//  NoticeVoiceChatOfJuBaoController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceChatOfJuBaoController.h"
#import "NoticeUserInfoCenterController.h"
@interface NoticeVoiceChatOfJuBaoController ()
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@end

@implementation NoticeVoiceChatOfJuBaoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarView.titleL.text = self.jubaoM.resource_type.intValue == 2 ? @"被举报的店铺":@"被举报的买家";
    [self jubaoButton];
    
    UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+73, DR_SCREEN_WIDTH, 22)];
    textL.textColor = [UIColor colorWithHexString:@"#25262E"];
    textL.font = FOURTHTEENTEXTFONTSIZE;
    textL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textL];
    textL.text = [NSString stringWithFormat:@"%@鲸币/分钟 通话",self.jubaoM.unit_price];
    
    UILabel *textL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+103, DR_SCREEN_WIDTH, 22)];
    textL1.textColor = [UIColor colorWithHexString:@"#25262E"];
    textL1.font = XGTWOBoldFontSize;
    textL1.textAlignment = NSTextAlignmentCenter;
    textL1.text = [self getMMSSFromSS:self.jubaoM.second];
    [self.view addSubview:textL1];
    
    for (int i = 0; i < 2; i++) {
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/2*i, NAVIGATION_BAR_HEIGHT+185, DR_SCREEN_WIDTH/2, 55+80)];
        tapView.userInteractionEnabled = YES;
        tapView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTap:)];
        [tapView addGestureRecognizer:tap];
        [self.view addSubview:tapView];
        
        UILabel *textL3 = [[UILabel alloc] initWithFrame:CGRectMake(0,87, DR_SCREEN_WIDTH/2, 22)];
        textL3.textColor = [UIColor colorWithHexString:@"#25262E"];
        textL3.font = XGSIXBoldFontSize;
        textL3.textAlignment = NSTextAlignmentCenter;
        [tapView addSubview:textL3];
        
        UILabel *textL4 = [[UILabel alloc] initWithFrame:CGRectMake(0,80+33, DR_SCREEN_WIDTH/2, 22)];
        textL4.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        textL4.font = FOURTHTEENTEXTFONTSIZE;
        textL4.textAlignment = NSTextAlignmentCenter;
        [tapView addSubview:textL4];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH/2-80)/2, 0, 80, 80)];
        iconImageView.layer.cornerRadius = 40;
        iconImageView.layer.masksToBounds = YES;
        [tapView addSubview:iconImageView];
        iconImageView.userInteractionEnabled = YES;
        
        if(self.jubaoM.resource_type.intValue == 2){//用户举报店铺
            if(i == 0){
                textL3.text = @"店铺";
                textL4.text = [NSString stringWithFormat:@"已被举报%@次",self.jubaoM.to_report_num];
                [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.jubaoM.toUserM.avatar_url]];
            }else{
                textL3.text = @"买家";
                textL4.text = [NSString stringWithFormat:@"已被举报%@次",self.jubaoM.from_report_num];
                [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.jubaoM.fromeUserM.avatar_url]];
            }

        }else{//店铺举报用户
            if(i == 0){
                textL3.text = @"买家";
                textL4.text = [NSString stringWithFormat:@"已被举报%@次",self.jubaoM.to_report_num];
                [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.jubaoM.toUserM.avatar_url]];
            }else{
                textL3.text = @"店铺";
                textL4.text = [NSString stringWithFormat:@"已被举报%@次",self.jubaoM.from_report_num];
                [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.jubaoM.fromeUserM.avatar_url]];
            }

        }
    }
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
 
    NSInteger seconds = [totalTime integerValue];
 
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
 
    return format_time;
 
}

- (void)userTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    if(tapV.tag == 0){
        ctl.userId = self.jubaoM.toUserM.userId;
    }else{
        ctl.userId = self.jubaoM.fromeUserM.userId;
    }
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)jubaoButton{
    NSArray *arr1 = @[@"忽略",@"停一天",@"停三天",@"关店"];
    NSArray *arr2 = @[@"忽略",@"禁1天",@"永久禁用",@""];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+((DR_SCREEN_WIDTH-100)/4+20)*i, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-10-40, (DR_SCREEN_WIDTH-100)/4, 40)];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [btn setTitle:self.jubaoM.resource_type.intValue==1?arr2[i]:arr1[i] forState:UIControlStateNormal];
        btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        btn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(chuliClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (i==0) {
            self.button1 = btn;
        }else if (i==1){
            self.button2 = btn;
        }else if (i==2){
            self.button3 = btn;
        }else{
            self.button4 = btn;
        }
    }
    if (self.jubaoM.resource_type.intValue == 1) {
        self.button4.hidden = YES;
    }
    [self refreshM];
}

- (void)chuliClick:(UIButton *)btn{
    if (self.jubaoM.report_status.intValue > 1) {//已处理
        return;
    }
    
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定这样该项处理吗？" message:nil sureBtn:@"再想想" cancleBtn:@"确定" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            NSString *str = @"";
            if (btn.tag == 0) {
                str = @"7";
            }else if (btn.tag == 1){
                str = weakSelf.jubaoM.resource_type.intValue==1?@"5":@"2";
            }else if (btn.tag == 2){
                str = weakSelf.jubaoM.resource_type.intValue==1?@"6":@"3";
            }else{
                str = @"4";
            }
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:weakSelf.jubaoM.jubaiId forKey:@"id"];
            [parm setObject:str forKey:@"reportStatus"];
            [parm setObject:weakSelf.mangagerCode forKey:@"confirmPasswd"];
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/shopReportOrder" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    weakSelf.jubaoM.report_status = str;
                    [weakSelf refreshM];
                }
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
}

- (void)refreshM{
    if (self.jubaoM.report_status.intValue > 1) {
        self.button1.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.button1 setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.button2.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.button2 setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.button3.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.button3 setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.button4.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.button4 setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        
        if (self.jubaoM.report_status.intValue==7) {
            self.button1.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.button1 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }else if (self.jubaoM.report_status.intValue==2 || self.jubaoM.report_status.intValue==5){
            self.button2.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.button2 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }else if (self.jubaoM.report_status.intValue==3 || self.jubaoM.report_status.intValue==6){
            self.button3.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.button3 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }else if (self.jubaoM.report_status.intValue==4){
            self.button4.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.button4 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }
    }
}
@end
