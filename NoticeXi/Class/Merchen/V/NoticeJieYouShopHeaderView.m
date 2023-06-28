//
//  NoticeJieYouShopHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeJieYouShopHeaderView.h"
#import "NoticeChangeRoleIconView.h"
#import "NoticeEditShopInfoController.h"
#import "NoticeShopMyWallectController.h"
#import "NoticeHasServeredController.h"
#import "NoticeHasServeredController.h"
#import "NoticeXi-Swift.h"
@implementation NoticeJieYouShopHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 80, 80)];
        self.iconImageView.layer.cornerRadius = 4;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.image = UIImageNamed(@"setshoprole_img");
        self.iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRoleTap)];
        [self.iconImageView addGestureRecognizer:tap];
        [self addSubview:self.iconImageView];
        
        self.shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(107, 22, DR_SCREEN_WIDTH-107, 25)];
        self.shopNameL.font = XGEightBoldFontSize;
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.shopNameL];
        
        self.noVoiceL = [[FSCustomButton alloc] initWithFrame:CGRectMake(107, 57, GET_STRWIDTH(@"还没有介绍录制一个吧", 14, 20)+20, 20)];
        [self.noVoiceL setTitle:@"还没有介绍录制一个吧" forState:UIControlStateNormal];
        self.noVoiceL.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        self.noVoiceL.buttonImagePosition = FSCustomButtonImagePositionRight;
        [self.noVoiceL setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        [self.noVoiceL setImage:UIImageNamed(@"blackintoimg") forState:UIControlStateNormal];
        [self.noVoiceL addTarget:self action:@selector(recoderClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.noVoiceL];
        
        self.playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(107, 54, 72, 28)];
        [self addSubview:self.playImageView];
        self.playImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [self.playImageView addGestureRecognizer:tapp];
        self.playImageView.image = UIImageNamed(@"playshopvoiceimg");
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(23,0,72-23-5, 28)];
        self.timeL.font = [UIFont systemFontOfSize:9];
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.playImageView addSubview:self.timeL];
        
        self.playImageView.hidden = YES;
        
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-62-15, 40, 62, 24)];
        editBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        editBtn.layer.cornerRadius = 12;
        editBtn.layer.masksToBounds = YES;
        [editBtn setTitle:@"编辑信息" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        [self addSubview:editBtn];
        editBtn.titleLabel.font = ELEVENTEXTFONTSIZE;
        [editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.iconImageView.frame)+20, DR_SCREEN_WIDTH-30, 94)];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:backView];
        
        for (int i = 0; i < 2; i++) {
            UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(104*i, 0, 104, 94)];
            tapV.tag = i;
            tapV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapOrder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderTap:)];
            [tapV addGestureRecognizer:tapOrder];
            [backView addSubview:tapV];
            
            UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 104, 26)];
            numL.font = XGTwentyTwoBoldFontSize;
            numL.textColor = [UIColor colorWithHexString:@"#25262E"];
            numL.textAlignment = NSTextAlignmentCenter;
            numL.text = @"0";
            [tapV addSubview:numL];
  
            
            UILabel *numL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 104, 20)];
            numL1.font = FOURTHTEENTEXTFONTSIZE;
            numL1.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            numL1.textAlignment = NSTextAlignmentCenter;
            [tapV addSubview:numL1];
            
            if(i == 0){
                numL1.text = @"订单数";
                self.orderNumL = numL;
            }else{
                numL1.text = @"收入(鲸币)";
                self.jingbNumL = numL;
            }
        }
        
        UIButton *tixBtn = [[UIButton alloc] initWithFrame:CGRectMake(backView.frame.size.width-15-60, 31, 60, 32)];
        tixBtn.backgroundColor = [UIColor colorWithHexString:@"#FF68A3"];
        tixBtn.layer.cornerRadius = 16;
        tixBtn.layer.masksToBounds = YES;
        [tixBtn setTitle:@"提现" forState:UIControlStateNormal];
        [tixBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tixBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [tixBtn addTarget:self action:@selector(tixianClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:tixBtn];
        
        self.isReplay = YES;
    }
    return self;
}


//提现
- (void)tixianClick{
    NoticeShopMyWallectController *ctl = [[NoticeShopMyWallectController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

//订单数量，收入
- (void)orderTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if(tapV.tag == 0){
        NoticeHasServeredController *ctl = [[NoticeHasServeredController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else{
        if(self.myShopModel.myShopM.income.intValue <= 0){
            [YZC_AlertView showViewWithTitleMessage:@"店铺还没有收入哦~"];
            return;
        }
        NoticeShopChangeRecoderController *ctl = [[NoticeShopChangeRecoderController alloc] init];
        ctl.isShouRuDetail = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

//编辑信息
- (void)editClick{
    if(!self.myShopModel){
        return;
    }
    NoticeEditShopInfoController *ctl = [[NoticeEditShopInfoController alloc] init];
    ctl.myShopModel = self.myShopModel;
    __weak typeof(self) weakSelf = self;
    ctl.refreshShopModel = ^(BOOL refresh) {
        if(weakSelf.refreshShopModel){
            weakSelf.refreshShopModel(YES);
        }
    };
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

//录制语音简介
- (void)recoderClick{
    NoticeRecoderView * recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    recodeView.needCancel = YES;
    recodeView.delegate = self;
    recodeView.isDb = YES;
    recodeView.titleL.text = @"";
    [recodeView show];
}


//重新上传语音
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]],[locaPath pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"85" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    

    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:Message forKey:@"introduce"];
            [parm setObject:timeLength forKey:@"introduce_len"];
            [[NoticeTools getTopViewController] showHUD];
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",self.myShopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
                [[NoticeTools getTopViewController] hideHUD];
                if (success1) {
                    if(self.refreshShopModel){
                        self.refreshShopModel(YES);
                    }
                }
            } fail:^(NSError * _Nullable error) {
                [[NoticeTools getTopViewController] hideHUD];
            }];
        }else{
            [[NoticeTools getTopViewController] showToastWithText:Message];
            [[NoticeTools getTopViewController] hideHUD];
        }
    }];
    
}

- (void)setMyShopModel:(NoticeMyShopModel *)myShopModel{
    _myShopModel = myShopModel;
        
    self.shopNameL.text = myShopModel.myShopM.shop_name;
    if(myShopModel.myShopM.role.integerValue > 0){
        for (int i = 0; i < myShopModel.role_listArr.count; i++) {
            NoticeMyShopModel *roleM = myShopModel.role_listArr[i];
            if([roleM.role isEqualToString:myShopModel.myShopM.role]){
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:roleM.role_img_url]];
                break;
            }
        }
    }else{
        self.iconImageView.image = UIImageNamed(@"setshoprole_img");
    }
    
    if(myShopModel.myShopM.introduce_len.intValue){
        self.playImageView.hidden = NO;
        self.timeL.text = [NSString stringWithFormat:@"%@s",myShopModel.myShopM.introduce_len];
        self.noVoiceL.hidden = YES;
    }else{
        self.playImageView.hidden = YES;
        self.noVoiceL.hidden = NO;
    }
    
    self.orderNumL.text = myShopModel.myShopM.order_num.intValue?myShopModel.myShopM.order_num:@"0";
    self.jingbNumL.text = myShopModel.myShopM.income.intValue?[NSString stringWithFormat:@"%.2f",myShopModel.myShopM.income.floatValue]:@"0";
}

//设置角色
- (void)changeRoleTap{
    if(!self.myShopModel){
        return;
    }
    __weak typeof(self) weakSelf = self;
    NoticeChangeRoleIconView *changeView = [[NoticeChangeRoleIconView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    changeView.myShopModel = self.myShopModel;
    changeView.refreshRoleBlock = ^(NSString * _Nonnull role, NSString * _Nonnull url) {
        [weakSelf.iconImageView sd_setImageWithURL:[NSURL URLWithString:url]];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        weakSelf.myShopModel.myShopM.role = role;
        [parm setObject:role forKey:@"role"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",weakSelf.myShopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            
        } fail:^(NSError * _Nullable error) {
            
        }];
    };
    [changeView showChoiceView];
    //13760229356

}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

- (void)stopPlay{
    self.isReplay = YES;
    [self.audioPlayer stopPlaying];
}

- (void)playNoReplay{
    
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:self.myShopModel.myShopM.introduce_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        [self.audioPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;

    self.audioPlayer.playComplete = ^{
        weakSelf.timeL.text = [NSString stringWithFormat:@"%@s",weakSelf.myShopModel.myShopM.introduce_len];
        weakSelf.isReplay = YES;

    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] >weakSelf.myShopModel.myShopM.introduce_len.integerValue) {
            currentTime = weakSelf.myShopModel.myShopM.introduce_len.integerValue;
        }

        if ([[NSString stringWithFormat:@"%.f",weakSelf.myShopModel.myShopM.introduce_len.integerValue-currentTime] isEqualToString:@"0"] ||  ((weakSelf.myShopModel.myShopM.introduce_len.integerValue-currentTime)<1) || [[NSString stringWithFormat:@"%.f",weakSelf.myShopModel.myShopM.introduce_len.integerValue-currentTime] isEqualToString:@"-0"]) {
            weakSelf.isReplay = YES;
  
            if ((weakSelf.myShopModel.myShopM.introduce_len.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
            }
        }
        weakSelf.timeL.text = [[NSString stringWithFormat:@"%.fs",weakSelf.myShopModel.myShopM.introduce_len.integerValue-currentTime] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    };
}
@end
