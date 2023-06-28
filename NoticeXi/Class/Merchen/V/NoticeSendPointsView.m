//
//  NoticeSendPointsView.m
//  NoticeXi
//
//  Created by li lei on 2022/6/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendPointsView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeFriendAcdModel.h"
#import "NoticePayAndSendRecoderController.h"
#import "NoticeSureSendUserTostView.h"

@interface NoticeSendPointsView()
@property (nonatomic, strong) NoticeSureSendUserTostView *sureView;
@end

@implementation NoticeSendPointsView


- (NoticeSureSendUserTostView *)sureView{
    if (!_sureView) {
        _sureView = [[NoticeSureSendUserTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _sureView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-30)];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.backView];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        self.markL.textColor = [UIColor colorWithHexString:@"#E5749D"];
        self.markL.font = SIXTEENTEXTFONTSIZE;
        self.markL.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:self.markL];
        
        self.userInteractionEnabled = YES;
        self.backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popTap)];
        [self addGestureRecognizer:tap];
        
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, 12, 24, 24)];
        [cancelBtn setImage:UIImageNamed(@"Image_blackX") forState:UIControlStateNormal];
        [self.backView addSubview:cancelBtn];
        cancelBtn.userInteractionEnabled = NO;
        
        NSArray *titleArr = @[@"10点发电值",@"20点发电值",@"30点发电值"];
        if ([NoticeTools getLocalType]) {
            titleArr = @[[NSString stringWithFormat:@"10 %@",[NoticeTools getLocalStrWith:@"zb.fdz"]],[NSString stringWithFormat:@"20 %@",[NoticeTools getLocalStrWith:@"zb.fdz"]],[NSString stringWithFormat:@"30 %@",[NoticeTools getLocalStrWith:@"zb.fdz"]]];
        }
        NSArray *moneyArr = @[@"¥28",@"¥50",@"¥78"];
        for (int i = 0; i < 3; i++) {
            
            UIView *tapViw = [[UIView alloc] initWithFrame:CGRectMake(15+((DR_SCREEN_WIDTH-50)/3+10)*i, 50, (DR_SCREEN_WIDTH-50)/3, (DR_SCREEN_WIDTH-50)/3)];
            tapViw.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
            tapViw.layer.cornerRadius = 8;
            tapViw.layer.masksToBounds = YES;
            tapViw.layer.borderWidth = 1;
            tapViw.layer.borderColor = [UIColor colorWithHexString:@"#F7F8FC"].CGColor;
            [self.backView addSubview:tapViw];
            
            UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, tapViw.frame.size.width, 20)];
            numL.textAlignment = NSTextAlignmentCenter;
            numL.font = FOURTHTEENTEXTFONTSIZE;
            numL.textColor = [UIColor colorWithHexString:@"#25262E"];
            numL.text = titleArr[i];
            [tapViw addSubview:numL];
            
            UILabel *moneyL = [[UILabel alloc] initWithFrame:CGRectMake(0, tapViw.frame.size.height-50, tapViw.frame.size.width, 20)];
            moneyL.textAlignment = NSTextAlignmentCenter;
            moneyL.font = XGTwentyTwoBoldFontSize;
            moneyL.textColor = [UIColor colorWithHexString:@"#1D1E24"];
            moneyL.attributedText = [DDHAttributedMode setString:moneyArr[i] setSize:10 setLengthString:@"¥" beginSize:0];
            [tapViw addSubview:moneyL];
            
            tapViw.tag = i;
            tapViw.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choicetap:)];
            [tapViw addGestureRecognizer:tap];
        }
        
        UIView *inputBackView = [[UIView alloc] initWithFrame:CGRectMake(15,80+(DR_SCREEN_WIDTH-50)/3, DR_SCREEN_WIDTH-30, 50)];
        inputBackView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        inputBackView.layer.cornerRadius = 8;
        inputBackView.layer.masksToBounds = YES;
        [_backView addSubview:inputBackView];
        
        UILabel *sendL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,70, 50)];
        sendL.textAlignment = NSTextAlignmentCenter;
        sendL.font = FIFTHTEENTEXTFONTSIZE;
        sendL.textColor = [UIColor colorWithHexString:@"#25262E"];
        sendL.text = [NoticeTools getLocalStrWith:@"lelve.sendto"];
        [inputBackView addSubview:sendL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(70, 15, 1, 20)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E1E4F0"];
        [inputBackView addSubview:line];
        
        self.phoneView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+5, 0, inputBackView.frame.size.width-CGRectGetMaxX(line.frame)-5, 50)];
        self.phoneView.keyboardType = UIKeyboardTypePhonePad;
        [self.phoneView setupToolbarToDismissRightButton];
        self.phoneView.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.phoneView.font = FIFTHTEENTEXTFONTSIZE;
        self.phoneView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        self.phoneView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"lelve.intonum"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
        [inputBackView addSubview:self.phoneView];
   
        self.phoneView.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.nimingButton = [[UIButton alloc] initWithFrame:CGRectMake(15, self.backView.frame.size.height-BOTTOM_HEIGHT-20-40-10-10-30, DR_SCREEN_WIDTH-30, 30)];
        [self.nimingButton setTitle:[NoticeTools getLocalStrWith:@"levelv.niming"] forState:UIControlStateNormal];
        self.nimingButton.titleLabel.font = THRETEENTEXTFONTSIZE;
        [self.nimingButton setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        [self.nimingButton setImage:UIImageNamed(@"Image_agreereg_nomol") forState:UIControlStateNormal];
        [self.backView addSubview:self.nimingButton];
        [self.nimingButton addTarget:self action:@selector(nimingClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *dhBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(self.nimingButton.frame)+10,(DR_SCREEN_WIDTH-55)/3, 40)];
        dhBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        dhBtn.layer.cornerRadius = 8;
        dhBtn.layer.masksToBounds = YES;
        [dhBtn setTitle:[NoticeTools getLocalStrWith:@"zb.chjilu"] forState:UIControlStateNormal];
        [dhBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        dhBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [dhBtn addTarget:self action:@selector(tqClick) forControlEvents:UIControlEventTouchUpInside];
        [dhBtn setImage:UIImageNamed(@"Image_aiixin") forState:UIControlStateNormal];
        [_backView addSubview:dhBtn];
        
        UIButton *goTbBtn = [[UIButton alloc] initWithFrame:CGRectMake(20+(DR_SCREEN_WIDTH-55)/3+15,CGRectGetMaxY(self.nimingButton.frame)+10,(DR_SCREEN_WIDTH-55)/3*2, 40)];
        goTbBtn.backgroundColor = [UIColor colorWithHexString:@"#E5749D"];
        goTbBtn.layer.cornerRadius = 8;
        goTbBtn.layer.masksToBounds = YES;
        [goTbBtn setTitle:[NoticeTools getLocalStrWith:@"chant.sendss"] forState:UIControlStateNormal];
        [goTbBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        goTbBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [goTbBtn addTarget:self action:@selector(gotoClick) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:goTbBtn];
    }
    return self;
}

- (void)gotoClick{
    if (!self.phoneView.text.length) {
        self.markL.text = [NoticeTools getLocalStrWith:@"lelve.intonum"];
        return;
    }
    
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if ([userM.frequency_no isEqualToString:self.phoneView.text]) {
        
        if ([NoticeTools getLocalType] == 1) {
            self.markL.text = @"For others only";
        }else if ([NoticeTools getLocalType] == 2){
            self.markL.text = @"他人専用";
        }else{
            self.markL.text = @"获赠人不可以是自己哦~";
        }
        return;
    }
    
    if (!self.prouctId) {
        if ([NoticeTools getLocalType] == 1) {
            self.markL.text = @"Please select quantity";
        }else if ([NoticeTools getLocalType] == 2){
            self.markL.text = @"数量を選択してください";
        }else{
            self.markL.text = @"请选择赠送发电值数量";
        }
        
        return;
    }

    NSString *url = nil;
    url = [NSString stringWithFormat:@"users/search?searchValue=%@",[self.phoneView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]]];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
    
        if (success) {
            
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [arr addObject:model];
            }
            
            if (arr.count) {
                NoticeFriendAcdModel *userM = arr[0];
                [self.sureView.iconImageView sd_setImageWithURL:[NSURL URLWithString:userM.avatar_url]];
                self.sureView.nameL.text = userM.nick_name;
                self.sureView.numL.text = [NSString stringWithFormat:@"学号：%@",self.phoneView.text];
                [self.sureView show];
                __weak typeof(self) weakSelf = self;
                self.sureView.sureBlock = ^(BOOL sure) {
                    [NoticeSaveModel clearPayInfo];
                    NoticePaySaveModel *saveModel = [[NoticePaySaveModel alloc] init];
                    saveModel.userNum = weakSelf.phoneView.text;
                    if ([weakSelf.prouctId isEqualToString:@"smallPoints"]) {
                        saveModel.money = @"2800";
                    }else if ([weakSelf.prouctId isEqualToString:@"middlePoints"]){
                        saveModel.money = @"5000";
                    }else{
                        saveModel.money = @"7800";
                    }
                    saveModel.userId = userM.userId;
                    saveModel.isNiming = weakSelf.isNiming?@"1":@"0";
                    saveModel.productId = weakSelf.prouctId;
                    [NoticeSaveModel savePayInfo:saveModel];
                    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    // iTunesConnect 苹果后台配置的产品ID
//                    [appdel.payManager startPurchWithID:saveModel.productId completeHandle:^(SIAPPurchType type,NSData *data) {
//                        //请求事务回调类型，返回的数据
//
//                    }];
                    [appdel.payManager startPurchWithID:weakSelf.prouctId money:saveModel.money toUserId:userM.userId userNum:saveModel.userNum isNiming:saveModel.isNiming completeHandle:^(SIAPPurchType type, NSData *data) {
                                            
                    }];
                };
            }else{
                self.markL.text = @"没有搜索到该学号，请核对学号";
            }
        }
    } fail:^(NSError *error) {
    }];
}

- (void)tqClick{
    [self popTap];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticePayAndSendRecoderController *ctl = [[NoticePayAndSendRecoderController alloc] init];
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

- (void)nimingClick{
    self.isNiming = !self.isNiming;
    [self.nimingButton setImage:UIImageNamed(!self.isNiming?@"Image_agreereg_nomol":@"Image_choiceadd_b") forState:UIControlStateNormal];
}

- (void)choicetap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
     
    if (self.oldView) {
        self.oldView.layer.borderColor = [UIColor colorWithHexString:@"#F7F8FC"].CGColor;
    }
    tapV.layer.borderColor = [UIColor colorWithHexString:@"#E5749D"].CGColor;
    self.oldView = tapV;
    
    self.prouctId = tapV.tag==0?@"smallPoints":(tapV.tag==1?@"middlePoints":@"morePoints");
}

- (void)show{
 
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.backView.frame.size.height+20, DR_SCREEN_WIDTH, self.backView.frame.size.height);
    }];
}

- (void)popTap{
    if (self.isNiming) {
        [self nimingClick];
    }
    self.markL.text = @"";
    [self.phoneView resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.backView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
