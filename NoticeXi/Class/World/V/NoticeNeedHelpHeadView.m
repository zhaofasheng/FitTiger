//
//  NoticeNeedHelpHeadView.m
//  NoticeXi
//
//  Created by li lei on 2023/2/9.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeNeedHelpHeadView.h"
#import "NoticeHelpBaseController.h"
#import "NoticeHelpDetailController.h"
@implementation NoticeNeedHelpHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100,50)];
        titleL.text = [NoticeTools getLocalStrWith:@"help.qiuz"];
        titleL.font = XGSIXBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:titleL];
        
        UIButton *intoBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50-15, 10, 50, 50)];
        [intoBtn addTarget:self action:@selector(tielistClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:intoBtn];
        
        UIImageView *intoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(30,5, 20, 20)];
        intoImgV.image = UIImageNamed(@"Image_ddqin");
        [intoBtn addSubview:intoImgV];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, DR_SCREEN_WIDTH, frame.size.height-50-20)];
        [self addSubview:self.scrollView];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        
        self.hotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 155)];
        [self.scrollView addSubview:self.hotView];
        
        UIView *backHotV = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 255, 155)];
        backHotV.layer.cornerRadius = 8;
        backHotV.layer.masksToBounds = YES;
        [self.hotView addSubview:backHotV];
        
        /**
         *  1.通过CAGradientLayer 设置渐变的背景。
         */
        CAGradientLayer *layer = [CAGradientLayer new];
        //colors存放渐变的颜色的数组
        layer.colors=@[(__bridge id)[UIColor colorWithHexString:@"#FFF2F0"].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
        /**
         * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
         */
        layer.startPoint = CGPointMake(0.5, 0);
        layer.endPoint = CGPointMake(0.5, 1);
        layer.frame = backHotV.bounds;
        [backHotV.layer addSublayer:layer];
        
        self.hotL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15,225, 22)];
        self.hotL.font = EIGHTEENTEXTFONTSIZE;
        self.hotL.numberOfLines = 2;
        self.hotL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backHotV addSubview:self.hotL];
        
        self.hotView.userInteractionEnabled = YES;
        UITapGestureRecognizer *hotTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotDetail)];
        [self.hotView addGestureRecognizer:hotTap];
        
        self.hotImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,28, 28)];
        self.hotImg.image = UIImageNamed(@"Image_hotimg");
        [backHotV addSubview:self.hotImg];
        
        self.recentView = [[UIView alloc] initWithFrame:CGRectMake(285, 0, 270, 155)];
        [self.scrollView addSubview:self.recentView];
        
        UIView *backnewV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255, 155)];
        backnewV.layer.cornerRadius = 8;
        backnewV.layer.masksToBounds = YES;
        [self.recentView addSubview:backnewV];
        
        /**
         *  1.通过CAGradientLayer 设置渐变的背景。
         */
        CAGradientLayer *layer1 = [CAGradientLayer new];
        //colors存放渐变的颜色的数组
        layer1.colors=@[(__bridge id)[UIColor colorWithHexString:@"#FFF2E9"].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
        /**
         * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
         */
        layer1.startPoint = CGPointMake(0.5, 0);
        layer1.endPoint = CGPointMake(0.5, 1);
        layer1.frame = backHotV.bounds;
        [backnewV.layer addSublayer:layer1];

        self.helpL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15,225, 22)];
        self.helpL.font = EIGHTEENTEXTFONTSIZE;
        self.helpL.numberOfLines = 2;
        self.helpL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backnewV addSubview:self.helpL];
        self.recentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *helpTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpDetail)];
        [self.recentView addGestureRecognizer:helpTap];
        
        self.helpImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,28, 28)];
        self.helpImg.image = UIImageNamed(@"Image_newimg");
        [backnewV addSubview:self.helpImg];

        self.scrollView.contentSize = CGSizeMake(270*2, 0);
        
        self.hotFgIconView = [[NoticeIconFgView alloc] initWithFrame:CGRectMake(15, 74, 0, 24)];
        [backHotV addSubview:self.hotFgIconView];
        
        [backHotV addSubview:self.hotNumL];
        
        self.commentView = [[UIView alloc] initWithFrame:CGRectMake(15, 108,225, 32)];
        self.commentView.layer.cornerRadius = 4;
        self.commentView.layer.masksToBounds = YES;
        self.commentView.userInteractionEnabled = YES;
        self.commentView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        [backHotV addSubview:self.commentView];
        
        UIImageView *editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 20, 20)];
        editImageView.image = UIImageNamed(@"Image_huieditimgw");
        [self.commentView addSubview:editImageView];
        editImageView.layer.cornerRadius = 10;
        editImageView.layer.masksToBounds = YES;
        self.editImageView = editImageView;
        
        UILabel *comL = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 187, 32)];
        comL.font = TWOTEXTFONTSIZE;
        comL.text = [NoticeTools chinese:@"快给Ta出出主意吧" english:@"Offer your help" japan:@"助けを提供する"];
        comL.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        [self.commentView addSubview:comL];
        self.comL = comL;
        
        UITapGestureRecognizer *comTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCom)];
        [self.commentView addGestureRecognizer:comTap];
        
        self.recFgIconView = [[NoticeIconFgView alloc] initWithFrame:CGRectMake(15, 74, 0, 24)];
        [backnewV addSubview:self.recFgIconView];
        [backnewV addSubview:self.recNumL];
        
        self.commentView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 108,225, 32)];
        self.commentView1.layer.cornerRadius = 4;
        self.commentView1.layer.masksToBounds = YES;
        self.commentView1.userInteractionEnabled = YES;
        self.commentView1.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        [backnewV addSubview:self.commentView1];
        
        UIImageView *editImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 20, 20)];
        editImageView1.image = UIImageNamed(@"Image_huieditimgw");
        editImageView1.layer.cornerRadius = 10;
        editImageView1.layer.masksToBounds = YES;
        [self.commentView1 addSubview:editImageView1];
        self.editImageView1 = editImageView1;
        
        UILabel *comL1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 187, 32)];
        comL1.font = TWOTEXTFONTSIZE;
        comL1.text = @"快给Ta出处主意吧";
        comL1.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        [self.commentView1 addSubview:comL1];
        self.comL1 = comL1;
        
        UITapGestureRecognizer *comTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCom1)];
        [self.commentView1 addGestureRecognizer:comTap1];
    }
    return self;
}

- (void)tapCom{
    
}

- (void)tapCom1{
    
}

- (void)hotDetail{
    if (!self.hotModel || !self.hotModel.title.length) {
        return;
    }
    if(self.hotModel.is_dislike.boolValue){
        [[NoticeTools getTopViewController] showToastWithText:[NoticeTools chinese:@"你已将此帖子设为不喜欢的内容" english:@"You have unliked this post" japan:@"この投稿を非表示にしました"]];
        return;
    }
    NoticeHelpDetailController *ctl = [[NoticeHelpDetailController alloc] init];
    ctl.helpModel = self.hotModel;
    __weak typeof(self) weakSelf = self;
    ctl.noLikeBlock = ^(NoticeHelpListModel * _Nonnull helpM) {
        [weakSelf noLikeTiezi:helpM];
    };
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)helpDetail{
    if (!self.recentModel) {
        return;
    }
    if(self.recentModel.is_dislike.boolValue){
        [[NoticeTools getTopViewController] showToastWithText:[NoticeTools chinese:@"你已将此帖子设为不喜欢的内容" english:@"You have unliked this post" japan:@"この投稿を非表示にしました"]];
        return;
    }
    NoticeHelpDetailController *ctl = [[NoticeHelpDetailController alloc] init];
    ctl.helpModel = self.recentModel;
    __weak typeof(self) weakSelf = self;
    ctl.noLikeBlock = ^(NoticeHelpListModel * _Nonnull helpM) {
        [weakSelf noLikeTiezi:helpM];
    };
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)noLikeTiezi:(NoticeHelpListModel *)helpModel{
    if([helpModel.tieId isEqualToString:self.hotModel.tieId]){
        self.hotModel = helpModel;
    }else if ([helpModel.tieId isEqualToString:self.recentModel.tieId]){
        self.recentModel = helpModel;
    }else{
        return;
    }
    [[NoticeTools getTopViewController] showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"invitationDislike/%@/%@",helpModel.tieId,helpModel.is_dislike.boolValue?@"2":@"1"] Accept:@"application/vnd.shengxi.v5.5.1+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            [[NoticeTools getTopViewController] hideHUD];
        [[NoticeTools getTopViewController]showToastWithText:[NoticeTools chinese:@"谢谢你的反馈" english:@"Thanks for helping" japan:@"助けてくれてありがとう"]];
            helpModel.is_dislike = helpModel.is_dislike.boolValue?@"2":@"1";
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}


- (void)tielistClick{
    NoticeHelpBaseController *ctl = [[NoticeHelpBaseController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)request{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"invitation/top" Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeHelpListModel *model = [NoticeHelpListModel mj_objectWithKeyValues:dict[@"data"]];
            self.hotModel = [NoticeHelpListModel mj_objectWithKeyValues:model.hot_invitation];
            self.hotModel.isHot = YES;
           
            if (model.recent_invitation.count) {
                self.recentModel = [NoticeHelpListModel mj_objectWithKeyValues:model.recent_invitation[0]];
            }
            if (self.hotModel) {
                self.scrollView.contentSize = CGSizeMake(270*2, 0);
                self.hotView.hidden = NO;
                self.recentView.frame = CGRectMake(285, 0, 270, 155);
            }else{
                self.scrollView.contentSize = CGSizeMake(270, 0);
                self.hotView.hidden = YES;
                self.recentView.frame = CGRectMake(0, 0, 270, 155);
            }
            
            [self requestComHot:model];
            [self requestComNew:model];
            
            self.hotL.text = self.hotModel.title?self.hotModel.title:@"";
            self.helpL.text = self.recentModel.title?self.recentModel.title:@"";
            
            CGFloat hotheight = GET_STRHEIGHT(self.hotL.text, 18, 225);
            if (hotheight > 48) {
                hotheight = 48;
            }
            self.hotL.frame = CGRectMake(15, 15, 225, hotheight);
            
            CGFloat newheight = GET_STRHEIGHT(self.helpL.text, 18, 225);
            if (newheight > 48) {
                newheight = 48;
            }
            self.helpL.frame = CGRectMake(15, 15, 225, newheight);
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)requestComHot:(NoticeHelpListModel *)hotM{
    if (!hotM.hotRecentData.count) {
        self.editImageView.layer.cornerRadius = 0;
        self.editImageView.image = UIImageNamed(@"Image_huieditimgw");
        self.comL.text = [NoticeTools chinese:@"快给Ta出出主意吧" english:@"Offer your help" japan:@"助けを提供する"];
        self.hotNumL.text = [NoticeTools getLocalStrWith:@"help.nojinayi"];
        self.hotFgIconView.hidden = YES;
        self.hotNumL.frame = CGRectMake(15, 76, 120, 20);
        self.hotNumL.frame = CGRectMake(CGRectGetMaxX(self.hotFgIconView.frame)+2, 76, 187, 20);
    }else{
        self.editImageView.layer.cornerRadius = 10;
        self.comL.text = hotM.giveHotModel.content;
        [self.editImageView sd_setImageWithURL:[NSURL URLWithString:hotM.giveHotModel.avatar_url]];
        
        self.hotFgIconView.hidden = NO;
        self.hotFgIconView.iconArr = hotM.hotRecentData;
        if (hotM.hotRecentData.count == 1) {
            self.hotFgIconView.frame = CGRectMake(15, 74, 24, 24);
        }else if (hotM.hotRecentData.count == 2){
            self.hotFgIconView.frame = CGRectMake(15, 74, 24*2-8, 24);
        }else if (hotM.hotRecentData.count == 3){
            self.hotFgIconView.frame = CGRectMake(15, 74, 24*3-16, 24);
        }else if (hotM.hotRecentData.count == 4){
            self.hotFgIconView.frame = CGRectMake(15, 74, 24*4-24, 24);
        }else if (hotM.hotRecentData.count >= 5){
            self.hotFgIconView.frame = CGRectMake(15, 74, 24*5-32, 24);
        }
        self.hotNumL.frame = CGRectMake(CGRectGetMaxX(self.hotFgIconView.frame)+2, 76, 120, 20);
        if ([NoticeTools getLocalType]==1) {
            self.hotNumL.text = [NSString stringWithFormat:@"%@ comments",hotM.proposeHotNum];
        }else if ([NoticeTools getLocalType]==2){
            self.hotNumL.text = [NSString stringWithFormat:@"%@個の提案",hotM.proposeHotNum];
        }else{
            self.hotNumL.text = [NSString stringWithFormat:@"%@个建议",hotM.proposeHotNum];
        }
    }
}

- (void)requestComNew:(NoticeHelpListModel *)newM{
    if (!newM.recentData.count) {
        self.editImageView1.layer.cornerRadius = 0;
        self.editImageView1.image = UIImageNamed(@"Image_huieditimgw");
        self.comL1.text = [NoticeTools chinese:@"快给Ta出出主意吧" english:@"Offer your help" japan:@"助けを提供する"];
        self.recNumL.text = [NoticeTools getLocalStrWith:@"help.nojinayi"];
        self.recFgIconView.hidden = YES;
        self.recNumL.frame = CGRectMake(15, 76, 120, 20);
        self.recNumL.frame = CGRectMake(CGRectGetMaxX(self.recFgIconView.frame)+2, 76, 187, 20);
        return;
    }else{
        self.editImageView1.layer.cornerRadius = 10;
        self.comL1.text = newM.giveModel.content;
        [self.editImageView1 sd_setImageWithURL:[NSURL URLWithString:newM.giveModel.avatar_url]];
        
        self.recFgIconView.hidden = NO;
        self.recFgIconView.iconArr = newM.recentData;
        if (newM.recentData.count == 1) {
            self.recFgIconView.frame = CGRectMake(15, 74, 24, 24);
        }else if (newM.recentData.count == 2){
            self.recFgIconView.frame = CGRectMake(15, 74, 24*2-8, 24);
        }else if (newM.recentData.count == 3){
            self.recFgIconView.frame = CGRectMake(15, 74, 24*3-16, 24);
        }else if (newM.recentData.count == 4){
            self.recFgIconView.frame = CGRectMake(15, 74, 24*4-24, 24);
        }else if (newM.recentData.count >= 5){
            self.recFgIconView.frame = CGRectMake(15, 74, 24*5-32, 24);
        }
        self.recNumL.frame = CGRectMake(CGRectGetMaxX(self.recFgIconView.frame)+2, 76, 120, 20);
        
        if ([NoticeTools getLocalType]==1) {
            self.recNumL.text = [NSString stringWithFormat:@"%@ comments",newM.proposeNum];
        }else if ([NoticeTools getLocalType]==2){
            self.recNumL.text = [NSString stringWithFormat:@"%@個の提案",newM.proposeNum];
        }else{
            self.recNumL.text = [NSString stringWithFormat:@"%@个建议",newM.proposeNum];
        }
    }
}

- (UILabel *)hotNumL{
    if (!_hotNumL) {
        _hotNumL = [[UILabel alloc] initWithFrame:CGRectMake(15, 76, 120, 20)];
        _hotNumL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _hotNumL.font = FOURTHTEENTEXTFONTSIZE;
    }
    return _hotNumL;
}

- (UILabel *)recNumL{
    if (!_recNumL) {
        _recNumL = [[UILabel alloc] initWithFrame:CGRectMake(15, 76, 120, 20)];
        _recNumL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _recNumL.font = FOURTHTEENTEXTFONTSIZE;
    }
    return _recNumL;
}
@end
