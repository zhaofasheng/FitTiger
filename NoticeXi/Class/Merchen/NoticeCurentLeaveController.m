//
//  NoticeCurentLeaveController.m
//  NoticeXi
//
//  Created by li lei on 2021/8/6.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCurentLeaveController.h"
#import "NoticeCurrentLeaveCell.h"
#import "NoticeWebViewController.h"
#import "NoticeExchangeController.h"
#import "NoticeLelveImageView.h"
#import "NoticeMerchantController.h"
#import "NoticeOpenTbModel.h"
#import "NoticePayView.h"
#import "NoticeSendPointsView.h"
@interface NoticeCurentLeaveController ()
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NoticeLelveImageView *currentLevelImagreView;
@property (nonatomic, strong) NoticeLelveImageView *nextLeveLImageView;
@property (nonatomic, strong) UILabel *levleL;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) NoticeOpenTbModel *opTaoBao;
@property (nonatomic, strong) NoticePayView *payView;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) NoticeSendPointsView *sendPointsView;
@end

@implementation NoticeCurentLeaveController

- (NoticeSendPointsView *)sendPointsView{
    if (!_sendPointsView) {
        _sendPointsView = [[NoticeSendPointsView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _sendPointsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.tableView.frame = CGRectMake(0, 0,DR_SCREEN_WIDTH , DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-5-40);
    self.tableView.rowHeight = 54;
    [self.tableView registerClass:[NoticeCurrentLeaveCell class] forCellReuseIdentifier:@"cell"];
    

    self.tableView.tableHeaderView = self.headerView;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH-40)/335*286+(DR_SCREEN_WIDTH-40)/335*441+30+30+30+(DR_SCREEN_WIDTH-40)/335*204)];
    self.tableView.tableFooterView = footView;
    
    UIImageView *footImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(20,0, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40)/335*286)];
    [footView addSubview:footImage1];
    footImage1.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"Image_tqlevel"]);
    
    UIImageView *footImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(footImage1.frame)+ 30, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40)/335*204)];
    [footView addSubview:footImage3];
    footImage3.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"Image_tqm"]);
    footImage3.userInteractionEnabled = YES;
    UITapGestureRecognizer *xTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(merchantTap)];
    [footImage3 addGestureRecognizer:xTap];
    
    UIImageView *footImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(footImage3.frame)+ 30, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40)/335*441)];
    [footView addSubview:footImage2];
    footImage2.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"Image_marslevel"]);
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-5-40, DR_SCREEN_WIDTH, BOTTOM_HEIGHT+20+40+5)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:backView];
        
    UIButton *dhBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,5,(DR_SCREEN_WIDTH-55)/3, 40)];
    dhBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    dhBtn.layer.cornerRadius = 8;
    dhBtn.layer.masksToBounds = YES;
    [dhBtn setTitle:[NoticeTools getLocalStrWith:@"send.friendup"] forState:UIControlStateNormal];
    [dhBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    dhBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [dhBtn addTarget:self action:@selector(tqClick) forControlEvents:UIControlEventTouchUpInside];
    [dhBtn setImage:UIImageNamed(@"Image_aiixin") forState:UIControlStateNormal];
    [backView addSubview:dhBtn];
    
    UIButton *goTbBtn = [[UIButton alloc] initWithFrame:CGRectMake(20+(DR_SCREEN_WIDTH-55)/3+15,5,(DR_SCREEN_WIDTH-55)/3*2, 40)];
    goTbBtn.backgroundColor = [UIColor colorWithHexString:@"#E5749D"];
    goTbBtn.layer.cornerRadius = 8;
    goTbBtn.layer.masksToBounds = YES;
    [goTbBtn setTitle:[NoticeTools getLocalStrWith:@"recoder.golv"] forState:UIControlStateNormal];
    [goTbBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    goTbBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [goTbBtn addTarget:self action:@selector(gotoClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:goTbBtn];
    
    self.navBarView.hidden = NO;
    
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"skipTaobao" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.opTaoBao = [NoticeOpenTbModel mj_objectWithKeyValues:dict[@"data"]];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
    
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50-10, STATUS_BAR_HEIGHT, 50, (NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT))];
    [changeBtn setImage:UIImageNamed(@"Image_zbcentert") forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(dhClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
}

- (void)merchantTap{
    NoticeMerchantController *ctl = [[NoticeMerchantController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NoticePayView *)payView{
    if (!_payView) {
        _payView = [[NoticePayView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _payView;
}

- (void)tqClick{
    [self.sendPointsView show];
}


- (void)dhClick{
    NoticeExchangeController *ctl = [[NoticeExchangeController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y > NAVIGATION_BAR_HEIGHT) {
        self.navBarView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.8];
        self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"zb.mylv"];
    }else{
        self.navBarView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.0];
        self.navBarView.titleL.text = @"";
    }
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH/375*219+(DR_SCREEN_WIDTH-40)/335*192-NAVIGATION_BAR_HEIGHT)];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH/375*219)];
        backImageView.contentMode = UIViewContentModeScaleAspectFill;
        backImageView.clipsToBounds = YES;
        [_headerView addSubview:backImageView];
        backImageView.image = UIImageNamed(@"Image_bigbackcode");
        
        UIImageView *zsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40)/335*192)];
        zsImageView.contentMode = UIViewContentModeScaleAspectFill;
        zsImageView.clipsToBounds = YES;
        zsImageView.image = UIImageNamed(@"Image_bigbacksubcode");
        [_headerView addSubview:zsImageView];
        zsImageView.userInteractionEnabled = YES;
        
        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(20,50, 48, 48)];
        [zsImageView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = 24;
        self.iconMarkView.layer.masksToBounds = YES;
        self.iconMarkView.image = UIImageNamed(userM.levelImgIconName);
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2,2, 44, 44)];
        self.iconImageView.layer.cornerRadius = 22;
        self.iconImageView.layer.masksToBounds = YES;
        
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:userM.avatar_url]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageRefreshCached];
        [self.iconMarkView addSubview:_iconImageView];

    
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(72,50,GET_STRWIDTH(userM.nick_name, 16, 21), 21)];
        _nickNameL.font = FIFTHTEENTEXTFONTSIZE;
        _nickNameL.text = userM.nick_name;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [zsImageView addSubview:_nickNameL];
        
        self.currentLevelImagreView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nickNameL.frame),53, 52, 16)];
        self.currentLevelImagreView.image = UIImageNamed(userM.levelImgName);
        [zsImageView addSubview:self.currentLevelImagreView];
        self.currentLevelImagreView.noTap = YES;
                
        self.levleL = [[UILabel alloc] initWithFrame:CGRectMake(72, 78, zsImageView.frame.size.width-75, 17)];
        self.levleL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        self.levleL.text = [NSString stringWithFormat:@"%@：%@   %@：%@",[NoticeTools getLocalStrWith:@"zb.current"],userM.levelName,[NoticeTools getLocalStrWith:@"zb.curfdadz"],userM.points];
        self.levleL.font = TWOTEXTFONTSIZE;
        [zsImageView addSubview:_levleL];
        

        UIView *backLine = [[UIView alloc] initWithFrame:CGRectMake(20, zsImageView.frame.size.height-28-10,156,10)];
        backLine.backgroundColor = [UIColor colorWithHexString:@"#8F96D9"];
        backLine.layer.cornerRadius = 5;
        backLine.layer.masksToBounds = YES;
        [zsImageView addSubview:backLine];
        
        UIView *fontLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backLine.frame.size.width/2,10)];
        fontLine.backgroundColor = [UIColor colorWithHexString:@"#C3C8FF"];
        fontLine.layer.cornerRadius = 5;
        fontLine.layer.masksToBounds = YES;
        [backLine addSubview:fontLine];
        
        UILabel *nextL = [[UILabel alloc] initWithFrame:CGRectMake(20, backLine.frame.origin.y-25, zsImageView.frame.size.width-20, 17)];
        nextL.textColor = [[UIColor colorWithHexString:@"#C3C8FF"] colorWithAlphaComponent:1];
        if ([NoticeTools getLocalType] == 1) {
            nextL.text = [NSString stringWithFormat:@"10 exp needed to Lv%d",userM.level.intValue+1];
        }else if ([NoticeTools getLocalType] == 2){
            nextL.text = [NSString stringWithFormat:@"Lv%d に10expが必要",userM.level.intValue+1];
        }else{
            nextL.text = [NSString stringWithFormat:@"距Lv%d还需10点发电值",userM.level.intValue+1];
        }
        
        nextL.font = TWOTEXTFONTSIZE;
        [zsImageView addSubview:nextL];

        backImageView.userInteractionEnabled = YES;
        _headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [zsImageView addGestureRecognizer:tap];
        
    }
    return _headerView;
}

- (void)tapClick{
    [self gotoClick];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)gotoClick{
    [self.payView show];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


@end
