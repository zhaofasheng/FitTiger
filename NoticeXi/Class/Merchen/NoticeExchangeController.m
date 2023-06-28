//
//  NoticeExchangeController.m
//  NoticeXi
//
//  Created by li lei on 2021/8/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeExchangeController.h"
#import "NoticePowerCell.h"
#import "NoticeRecoderStoryController.h"
#import "NoticeMerchantController.h"
#import "NoticeHasOrNoBuyTostView.h"
#import "NoticePayView.h"
@interface NoticeExchangeController ()<UITextFieldDelegate>
@property (nonatomic, strong) NoticePayView *payView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *currentNumL;
@property (nonatomic, strong) UITextField *numField;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UILabel *erroL;
@property (nonatomic, strong) NSString *points;

@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NoticeLelveImageView *currentLevelImagreView;
@property (nonatomic, strong) UILabel *levleL;
@property (nonatomic, strong) UIImageView *iconMarkView;
@end

@implementation NoticeExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"zb.duih"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
 
    self.navBarView.rightButton.frame = CGRectMake(DR_SCREEN_WIDTH-70-15, STATUS_BAR_HEIGHT, 70, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [self.navBarView.rightButton setTitle:[NoticeTools getLocalStrWith:@"zb.duihjilu"] forState:UIControlStateNormal];
    [self.navBarView.rightButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.navBarView.rightButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.navBarView.rightButton addTarget:self action:@selector(storyClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    self.tableView.tableHeaderView = self.headerView;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];


    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,(DR_SCREEN_WIDTH-40)/335*441+30)];
    footView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    UIImageView *footImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(20,0, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40)/335*441)];
    [footView addSubview:footImage2];
    footImage2.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"Image_marslevel"]);
    self.tableView.tableFooterView = footView;
    
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
}

- (void)storyClick{
    NoticeRecoderStoryController *ctl = [[NoticeRecoderStoryController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(BOOL) isChinese:(NSString *) str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4E00 && a < 0x9FFF)
        {
            return YES;
        }
    }
    return NO;
}

- (void)changeClick{
    
    self.erroL.text = @"";
    if (!self.numField.text.length) {
        self.erroL.text = [NoticeTools getLocalStrWith:@"zb.t1"];
        return;
    }
    if ([self isChinese:self.numField.text]) {
        self.erroL.text = [NoticeTools getLocalStrWith:@"zb.t2"];
        return;
    }
    [self showHUD];
    NSString *str = [NSString stringWithFormat:@"exchangeCode/check?code=%@",self.numField.text];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:str Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO needMsg:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            __weak typeof(self) weakSelf = self;
            NoticeAbout *aboutM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            self.points = aboutM.points;
            NSString *str = [NoticeTools getLocalType]?[NSString stringWithFormat:@"%@ EP included, sure to redeem it?",aboutM.points]:[NSString stringWithFormat:@"包含%@点发电值\n确认兑换吗？",aboutM.points];
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] cancleBtn:[NoticeTools getLocalStrWith:@"zb.t3"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    NSMutableDictionary *parm = [NSMutableDictionary new];
                    [parm setObject:weakSelf.numField.text forKey:@"code"];
                    [weakSelf showHUD];
                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"exchangeCode/convert" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                        if (success) {
                            [weakSelf requestUserInfo];
                        }
                        [weakSelf hideHUD];
                    } fail:^(NSError * _Nullable error) {
                        [weakSelf hideHUD];
                    }];
                }
            };
            [alerView showXLAlertView];
        }else{
            self.erroL.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dict[@"msg"]]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)requestUserInfo{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            self.currentNumL.text =[NSString stringWithFormat:@"%ld", userIn.points.integerValue];
            NoticeHasOrNoBuyTostView *tostView = [[NoticeHasOrNoBuyTostView alloc] initWithShowUser:userIn points:self.points];
            [tostView showChoiceView];
        }
        
    } fail:^(NSError *error) {
    }];
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH/375*219+(DR_SCREEN_WIDTH-40)/335*192-NAVIGATION_BAR_HEIGHT+192)];
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
        nextL.text = [NSString stringWithFormat:@"距Lv%d还需10点发电值",userM.level.intValue+1];
        nextL.font = TWOTEXTFONTSIZE;
        [zsImageView addSubview:nextL];

        backImageView.userInteractionEnabled = YES;
        _headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [zsImageView addGestureRecognizer:tap];
        
        UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(zsImageView.frame)+30, 100, 21)];
        markL.font = SIXTEENTEXTFONTSIZE;
        markL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        markL.text = [NoticeTools getLocalStrWith:@"zb.t1"];
        [_headerView addSubview:markL];
        
        self.numField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(markL.frame)+12, DR_SCREEN_WIDTH-40, 50)];
        self.numField.layer.cornerRadius = 8;
        self.numField.layer.masksToBounds = YES;
        self.numField.keyboardType = UIKeyboardTypeEmailAddress;
        self.numField.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.numField.font = FIFTHTEENTEXTFONTSIZE;
        self.numField.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.numField.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:self.numField];
        self.numField.delegate = self;
        self.numField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"zb.guakai"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5]}];
        
        self.erroL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.numField.frame)+8, DR_SCREEN_WIDTH-30, 17)];
        self.erroL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.erroL.font = TWOTEXTFONTSIZE;
        [_headerView addSubview:self.erroL];
        
        UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.numField.frame)+40, DR_SCREEN_WIDTH-40, 50)];
        changeBtn.backgroundColor = [UIColor colorWithHexString:@"#7477A7"];
        [changeBtn setTitle:[NoticeTools getLocalType]?[NoticeTools getLocalStrWith:@"sure.comgir"]:@"确认兑换" forState:UIControlStateNormal];
        [changeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        changeBtn.titleLabel.font = XGEightBoldFontSize;
        changeBtn.layer.cornerRadius = 8;
        changeBtn.layer.masksToBounds = YES;
        [_headerView addSubview:changeBtn];
        [changeBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _headerView;
}

- (void)tapClick{
    [self.payView show];
}

- (NoticePayView *)payView{
    if (!_payView) {
        _payView = [[NoticePayView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _payView;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

@end
