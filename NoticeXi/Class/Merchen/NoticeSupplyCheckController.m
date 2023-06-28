//
//  NoticeSupplyCheckController.m
//  NoticeXi
//
//  Created by li lei on 2022/7/4.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeSupplyCheckController.h"
#import "NoticeSupplyNicknameController.h"
#import "NoticeSureSendUserTostView.h"
@interface NoticeSupplyCheckController ()
@property (nonatomic, strong) UIImageView *choiceImage1;
@property (nonatomic, strong) UIImageView *choiceImage2;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *payId;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatAvurl;
@property (nonatomic, strong) NoticeSureSendUserTostView *sureView;
@end

@implementation NoticeSupplyCheckController
- (NoticeSureSendUserTostView *)sureView{
    if (!_sureView) {
        _sureView = [[NoticeSureSendUserTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _sureView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.needBackGroundView = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.navBarView.titleL.text = @"申请开通店铺";
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, 50)];
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
    label.numberOfLines = 0;
    label.text = @"认证信息将用于店铺的收益提现，与帐号唯一绑定，我们会对信息进行严格保密。";
    [self.view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-306)/2, 60+NAVIGATION_BAR_HEIGHT, 306, 41)];
    imageView.image = UIImageNamed(@"Image_shoptwo");
    [self.view addSubview:imageView];
    
    for (int i = 0; i < 2; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(imageView.frame)+10+71*i, DR_SCREEN_WIDTH-40, 56)];
        backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        backView.layer.cornerRadius = 8;
        backView.layer.masksToBounds = YES;
        [self.view addSubview:backView];
        
        UIImageView *titleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 32, 32)];
        [backView addSubview:titleImageV];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(52, 0, 180, 56)];
        titleL.font = SIXTEENTEXTFONTSIZE;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:titleL];
        
        UIImageView *subImageV = [[UIImageView alloc] initWithFrame:CGRectMake(backView.frame.size.width-20-20, 18, 20, 20)];
        [backView addSubview:subImageV];
        subImageV.image = UIImageNamed(@"Image_nochoicesh");
        
        backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceTap:)];
        [backView addGestureRecognizer:tap];
        backView.tag = i;
        
        if (i == 0) {
            titleL.text = @"微信";
            titleImageV.image = UIImageNamed(@"wechat");
            self.choiceImage1 = subImageV;
        }else{
  
            titleL.text = @"支付宝";
            titleImageV.image = UIImageNamed(@"Image_alipay");
            self.choiceImage2 = subImageV;
        }
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(68,CGRectGetMaxY(imageView.frame)+71*2+40,DR_SCREEN_WIDTH-68*2, 56);
    [btn setTitle:[NoticeTools getLocalStrWith:@"photo.next"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    btn.layer.cornerRadius = 56/2;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [btn addTarget:self action:@selector(upDataClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.nextButton = btn;
}

- (void)choiceTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (tapV.tag == 0) {
      
        __weak typeof(self) weakSelf = self;
        [NoticeTools getWeChatsuccess:^(NSString * _Nonnull payId, NSInteger type,NSString *name,NSString *iconUrl) {
            weakSelf.payId = payId;
            weakSelf.type = type;
            weakSelf.nickname = name;
            weakSelf.avatAvurl = iconUrl;
            weakSelf.nextButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [weakSelf.nextButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            self.choiceImage1.image = UIImageNamed(@"Image_choicesh");
            self.choiceImage2.image = UIImageNamed(@"Image_nochoicesh");
        }];
    }else{
        __weak typeof(self) weakSelf = self;
  
        [NoticeTools getAlisuccess:^(NoticeMJIDModel *aliModel) {
            
            weakSelf.payId = aliModel.user_id;
            weakSelf.authCode = aliModel.auth_code;
            weakSelf.type = 2;
            
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"authorizeUser/2?auth_code=%@",weakSelf.authCode] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    weakSelf.choiceImage2.image = UIImageNamed(@"Image_choicesh");
                    weakSelf.choiceImage1.image = UIImageNamed(@"Image_nochoicesh");
                    NoticeMJIDModel *model = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
                    weakSelf.nickname = model.identity_name;
                    weakSelf.avatAvurl = model.identity_img_url;
                    
                    weakSelf.nextButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                    [weakSelf.nextButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                }
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
        }];
    }
}

- (void)upDataClick{
    
    if (self.type <= 0 || !self.payId) {
        return;
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if (self.type == 1) {
        [parm setObject:@"1" forKey:@"pay_type"];
    }else{
        [parm setObject:@"2" forKey:@"pay_type"];
    }
    [parm setObject:self.payId forKey:@"identity_id"];
    [parm setObject:self.avatAvurl forKey:@"identity_img_url"];
    [parm setObject:self.nickname forKey:@"identity_name"];
    
    [self.sureView.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.avatAvurl]];
    self.sureView.nameL.text = self.nickname;
    self.sureView.titleLabel.text = @"请核对信息";
    self.sureView.nameL.frame = CGRectMake(self.sureView.nameL.frame.origin.x, self.sureView.iconImageView.frame.origin.y, self.sureView.nameL.frame.size.width, self.sureView.iconImageView.frame.size.height);
    [self.sureView show];
    __weak typeof(self) weakSelf = self;
    self.sureView.sureBlock = ^(BOOL sure) {
        [weakSelf showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/bindPaymentMethod" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [weakSelf hideHUD];
            if (success) {
                NoticeSupplyNicknameController *ctl = [[NoticeSupplyNicknameController alloc] init];
                [weakSelf.navigationController pushViewController:ctl animated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [weakSelf hideHUD];
        }];
    };
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
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


@end
