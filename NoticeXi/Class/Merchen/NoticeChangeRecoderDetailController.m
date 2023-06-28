//
//  NoticeChangeRecoderDetailController.m
//  NoticeXi
//
//  Created by li lei on 2022/7/18.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeRecoderDetailController.h"
#import "NoticeSCViewController.h"
@interface NoticeChangeRecoderDetailController ()

@end

@implementation NoticeChangeRecoderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    self.navBarView.titleL.text = @"账单详情";
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView removeFromSuperview];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+20, DR_SCREEN_WIDTH-40, 286)];
    colorView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:colorView];
    colorView.layer.cornerRadius = 10;
    colorView.layer.masksToBounds = YES;
    
    UILabel *statusL = [[UILabel alloc] initWithFrame:CGRectMake(15, 30,200, 22)];
    statusL.textColor = [UIColor colorWithHexString:@"#25262E"];
    statusL.font = [UIFont systemFontOfSize:16];
    [colorView addSubview:statusL];
    statusL.text = self.recoModel.title;
    
    UIImageView *backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 85, DR_SCREEN_WIDTH-80, 1)];
    backImageV.image = UIImageNamed(@"shop_xuxian");
    [colorView addSubview:backImageV];
    backImageV.userInteractionEnabled = YES;
    
    UILabel *moneyL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-160-15, 30,160, 28)];
    moneyL.textColor = [UIColor colorWithHexString:@"#25262E"];
    moneyL.font = [UIFont systemFontOfSize:20];
    [colorView addSubview:moneyL];
    moneyL.textAlignment = NSTextAlignmentRight;
    moneyL.text = self.recoModel.money;
    
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"transactionRecord/%@",self.recoModel.recodId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            NoticeChangeRecoderModel *model = [NoticeChangeRecoderModel mj_objectWithKeyValues:dict[@"data"]];
            self.recoModel.order_sn = model.order_sn;
            for (int i = 0; i < 4; i++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 111+32*i, 62, 17)];
                label.font = TWOTEXTFONTSIZE;
                label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
                [colorView addSubview:label];
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 111+32*i, 220, 17)];
                label1.font = TWOTEXTFONTSIZE;
                label1.textColor = [UIColor colorWithHexString:@"#25262E"];
                [colorView addSubview:label1];
                if (i==0) {
                    label.text = @"当前状态：";
                    label1.text = self.recoModel.mark;
                }else if (i == 1){
                    label.text = @"下单时间：";
                    label1.text = model.created_at;
                }else if (i == 2){
                    label.text = @"订单编号：";
                    label1.text = model.order_sn;
                }else if (i == 3){
                    label.text = @"交易单号：";
                    label1.text = model.transaction_no;
                }
            }
            
            UILabel *kfL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(colorView.frame)+40,DR_SCREEN_WIDTH, 40)];
            kfL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            kfL.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:kfL];
            kfL.textAlignment = NSTextAlignmentCenter;
            kfL.attributedText = [DDHAttributedMode setColorString:@"对订单有疑惑，点这里「声昔客服小二」" setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:@"「声昔客服小二」" beginSize:10];
            kfL.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kefutap)];
            [kfL addGestureRecognizer:tap];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)kefutap{
    NoticeSCViewController *ctl = [[NoticeSCViewController alloc] init];
    ctl.navigationItem.title = @"声昔小二";
    ctl.toUser = [NSString stringWithFormat:@"%@1",socketADD];
    ctl.toUserId = @"1";
    ctl.recoModel = self.recoModel;
    [self.navigationController pushViewController:ctl animated:NO];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;

}

@end
