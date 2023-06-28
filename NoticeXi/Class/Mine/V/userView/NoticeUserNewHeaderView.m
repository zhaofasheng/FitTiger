//
//  NoticeUserNewHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserNewHeaderView.h"
#import "NoticeCarePeopleController.h"
#import "NoticeCenterInfoTostView.h"
#import "NoticeSeasonViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMyOwnMusicListController.h"
#import "NoticeCurentLeaveController.h"
#import "NoticeFriendAcdModel.h"
#import "NoticeCurentLeaveController.h"
#import "NoticerClockController.h"
#import "NoticeWhiteVoiceController.h"
#import "NoticeTieTieSignController.h"
#import "NoticeChangeSkinListController.h"
#import "NoticeMyBokeController.h"
#import "NoticeMyHelpListController.h"
#import "NoticeImageViewController.h"
#import "NoticeReadBookController.h"
#import "NoticeWorldVoiceListViewController.h"
#import "NoticeEditViewController.h"
#import "NoticeCaoGaoController.h"
#import "NoticeSysViewController.h"
#import "NoticeXi-Swift.h"
#import "NoticeDepartureController.h"
#import "NoticeMyBookController.h"
#import "NoticeMyLikeSongController.h"
#import "NoticeVoiceAlbumAndChatAlbumController.h"
#import "NoticeMusicLikeModel.h"
#import "NoticeVoiceCommentNewsController.h"
#import "NoticeVoiceChatAndDepartController.h"
@implementation NoticeUserNewHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20,60, 60)];
        [self addSubview:self.iconMarkView];
        _iconMarkView.layer.cornerRadius = _iconMarkView.frame.size.height/2;
        _iconMarkView.layer.masksToBounds = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17,22, 56, 56)];
        _iconImageView.layer.cornerRadius = 56/2;
        _iconImageView.layer.masksToBounds = YES;
        [self addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *itap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoTap)];
        [_iconImageView addGestureRecognizer:itap];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,24,DR_SCREEN_WIDTH-22-10-48, 22)];
        _nickNameL.font = XGSIXBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:_nickNameL];
        
        self.lelveImageView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(19,64, 52, 16)];
        [self addSubview:self.lelveImageView];
        self.lelveImageView.noTap = YES;
                
        self.userInteractionEnabled = YES;
        
        NSArray *arr = @[[NoticeTools getLocalStrWith:@"minee.x1s"],[NoticeTools getLocalStrWith:@"minee.bxs"]];
        CGFloat width = GET_STRWIDTH([NoticeTools getLocalStrWith:@"minee.bxs"], 12, 17)*2;
        for (int i = 0; i < 2; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconMarkView.frame)+10+width*i,58,GET_STRWIDTH(arr[i], 12, 20), 17)];
            label.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
            label.font = TWOTEXTFONTSIZE;
            [self addSubview:label];
            label.text = arr[i];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+2,56,50, 20)];
            label1.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
            label1.font = XGTWOBoldFontSize;
            [self addSubview:label1];
            label1.text = @"0";
            
            if (i == 0) {
                self.careL = label1;
            }else if(i == 1){
                self.bCareL = label1;
            }
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y,label.frame.size.width+48, 17)];
     
            tapView.userInteractionEnabled = YES;
            tapView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInfoFun:)];
            [tapView addGestureRecognizer:tap];
            [self addSubview:tapView];
        }
        
        self.redView = [[UIView alloc] initWithFrame:CGRectMake(self.careL.frame.size.width-2, -2, 4, 4)];
        self.redView.layer.cornerRadius = 2;
        self.redView.layer.masksToBounds = YES;
        self.redView.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        [self.careL addSubview:self.redView];
        self.redView.hidden = YES;
        
        FSCustomButton *infBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-88, 32, 93, 36)];
        infBtn.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.1];
        infBtn.buttonImagePosition = FSCustomButtonImagePositionRight;
        infBtn.layer.cornerRadius = 5;
        infBtn.layer.masksToBounds = YES;
        [infBtn setTitle:[NoticeTools getLocalStrWith:@"set.cell1"] forState:UIControlStateNormal];
        infBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [infBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [infBtn setImage:UIImageNamed(@"Image_wrinto") forState:UIControlStateNormal];
        [self addSubview:infBtn];
        [infBtn addTarget:self action:@selector(infoClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *vipBackView = [[UIView alloc] initWithFrame:CGRectMake(15, 100, DR_SCREEN_WIDTH-30, 47)];
        [self addSubview:vipBackView];
        vipBackView.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.1];
        
        /**
         参数：
         
         rect        :  被传入View的bounds
         corners     :  圆角的位置（枚举值：左上、左下、右上、右下，可用“|”符号组合使用）
         cornerRadii :  圆角大小（CGSize）
         */
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:vipBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.frame = vipBackView.bounds;
        shapeLayer.path = bezierPath.CGPath;
        vipBackView.layer.mask = shapeLayer;
        
        UIImageView *vipLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 33, 15)];
        
        vipLogoImageView.image = UIImageNamed(@"vipLogo");
        [vipBackView addSubview:vipLogoImageView];
        
        NSArray *listArr = @[[NoticeTools getLocalStrWith:@"e.sx"],[NoticeTools getLocalStrWith:@"skin.gxchange"],[NoticeTools chinese:@"特色歌单" english:@"BGM List" japan:@"BGMリスト"]];
        NSArray *listImgeArr = @[@"Image_zuanshi",@"Image_zuanshi1",@"Image_zuanshi2"];
        CGFloat vipbtnwidth = (vipBackView.frame.size.width-16-33-16)/3;
        for (int i = 0; i < 3; i++) {
            UIButton *listView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(vipLogoImageView.frame)+16+vipbtnwidth*i,0,vipbtnwidth, 47)];
            listView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
            [vipBackView addSubview:listView];
       
            [listView setTitle:[NSString stringWithFormat:@" %@",listArr[i]] forState:UIControlStateNormal];
            [listView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            listView.titleLabel.font = XGTWOBoldFontSize;
            [listView setImage:UIImageNamed(listImgeArr[i]) forState:UIControlStateNormal];
            listView.tag = i;
            [listView addTarget:self action:@selector(listClick:) forControlEvents:UIControlEventTouchUpInside];
      
        }
        
        NSArray *typeArr = @[[NoticeTools getLocalStrWith:@"yl.xinqing"],[NoticeTools getLocalStrWith:@"main.bk"],[NoticeTools getLocalStrWith:@"help.qiuz"],[NoticeTools chinese:@"专辑" english:@"Album" japan:@"写真"]];
        for (int i = 0; i < 4; i++) {
            UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(15+(DR_SCREEN_WIDTH-30)/4*i, CGRectGetMaxY(vipBackView.frame), (DR_SCREEN_WIDTH-30)/4, 90)];
            [self addSubview:dataView];
            dataView.userInteractionEnabled = YES;
            dataView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dataViewTap:)];
            [dataView addGestureRecognizer:tap];
            
            UILabel *dataL = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, dataView.frame.size.width, 25)];
            dataL.font = XGEightBoldFontSize;
            dataL.textColor = [UIColor whiteColor];
            dataL.textAlignment = NSTextAlignmentCenter;
            dataL.text = @"0";
            [dataView addSubview:dataL];
            
            if (i==0) {
                self.timeMarkL = dataL;
            }else if (i==1){
                self.bkNumL = dataL;
            }else if (i==2){
                self.helpNumL = dataL;
            }else if (i==3){
                self.zjNumL = dataL;
            }
            
            UILabel *datamL = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, dataView.frame.size.width, 17)];
            datamL.font = TWOTEXTFONTSIZE;
            datamL.textColor = [UIColor whiteColor];
            datamL.textAlignment = NSTextAlignmentCenter;
            datamL.text = typeArr[i];
            [dataView addSubview:datamL];
            
            if (i != 3) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(dataView.frame.size.width-1, 41, 1, 14)];
                line.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
                [dataView addSubview:line];
            }
        }
        
        UIView *themView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(vipBackView.frame)+90, DR_SCREEN_WIDTH-30, 87)];
        themView.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.1];
        themView.layer.cornerRadius = 10;
        themView.layer.masksToBounds = YES;
        [self addSubview:themView];
        
        NSArray *imgarr1 = @[@"mine_mypy",@"readImgClick_img",@"artclick_img",@"Image_mxq"];
        NSArray *textArr1 = @[[NoticeTools getLocalStrWith:@"main.py"],[NoticeTools getLocalStrWith:@"read.title"],[NoticeTools getLocalStrWith:@"message.artcle"],[NoticeTools getLocalStrWith:@"my.tlingyu"]];
        for (int i = 0; i < 4; i++) {
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(themView.frame.size.width/4*i,0, themView.frame.size.width/4, 87)];
            tapView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFun1:)];
            [tapView addGestureRecognizer:tap];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((tapView.frame.size.width-40)/2, 15,40, 40)];
            imageView.image = UIImageNamed(imgarr1[i]);
            [tapView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 55,tapView.frame.size.width, 17)];
            label.textColor = [UIColor whiteColor];
            label.font = TWOTEXTFONTSIZE;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = textArr1[i];
            [tapView addSubview:label];
            [themView addSubview:tapView];
        }
        
        UIView *themView2 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(themView.frame)+15, DR_SCREEN_WIDTH-30, 126)];
        themView2.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.1];
        themView2.layer.cornerRadius = 10;
        themView2.layer.masksToBounds = YES;
        [self addSubview:themView2];
        
        UILabel *eachL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
        eachL.font = FOURTHTEENTEXTFONTSIZE;
        eachL.textColor = [UIColor whiteColor];
        eachL.text = [NoticeTools chinese:@"互动中心" english:@"Connections" japan:@"通信"];
        [themView2 addSubview:eachL];
        
        UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(themView2.frame.size.width-15-20, 15, 20, 20)];
        [clearBtn setBackgroundImage:UIImageNamed(@"img_clearnewimg") forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
        [themView2 addSubview:clearBtn];
        
        NSArray *imgarr2 = @[@"img_push1",@"img_push2",@"img_push3",@"img_push4"];
        NSArray *textArr2 = @[[NoticeTools chinese:@"贴贴和点赞" english:@"Likes" japan:@"気に入った"],[NoticeTools getLocalStrWith:@"cao.liiuyan"],[NoticeTools chinese:@"心情回应" english:@"Replies" japan:@"返信"],[NoticeTools getLocalStrWith:@"push.ce9"]];
        for (int i = 0; i < 4; i++) {
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(themView2.frame.size.width/4*i,50, themView2.frame.size.width/4, 76)];
            tapView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFun2:)];
            [tapView addGestureRecognizer:tap];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((tapView.frame.size.width-40)/2, 0,40, 40)];
            imageView.image = UIImageNamed(imgarr2[i]);
            [tapView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+4,tapView.frame.size.width, 17)];
            label.textColor = [UIColor whiteColor];
            label.font = TWOTEXTFONTSIZE;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = textArr2[i];
            [tapView addSubview:label];
            [themView2 addSubview:tapView];
            
            UILabel *numReadL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)-7, imageView.frame.origin.y-7, 14, 14)];
            numReadL.layer.cornerRadius = 7;
            numReadL.layer.masksToBounds = YES;
            numReadL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
            numReadL.textAlignment = NSTextAlignmentCenter;
            numReadL.font = [UIFont systemFontOfSize:9];
            numReadL.textColor = [UIColor whiteColor];
            [tapView addSubview:numReadL];
            numReadL.hidden = YES;
            if (i == 0) {
                self.num1L = numReadL;
            }else if (i == 1){
                self.num2L = numReadL;
            }else if (i == 2){
                self.num3L = numReadL;
            }else if (i == 3){
                self.num4L = numReadL;
            }
        }
        
        UIView *themView4 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(themView2.frame)+15, DR_SCREEN_WIDTH-30, 97)];
        themView4.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.1];
        themView4.layer.cornerRadius = 10;
        themView4.layer.masksToBounds = YES;
        [self addSubview:themView4];
        
        UILabel *songL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
        songL.font = FOURTHTEENTEXTFONTSIZE;
        songL.textColor = [UIColor whiteColor];
        songL.text = [NoticeTools getLocalStrWith:@"minee.mysonglist"];
        [themView4 addSubview:songL];
        
        self.recFgIconView = [[NoticeIconFgView alloc] initWithFrame:CGRectMake(15, 0, 0, 24)];
        [themView4 addSubview:self.recFgIconView];
        self.recFgIconView.hidden = YES;
        UITapGestureRecognizer *tapr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeListClick)];
        [self.recFgIconView addGestureRecognizer:tapr];
        
        [themView4 addSubview:self.recNumL];
        self.recNumL.hidden = YES;
        
        UIImageView *playIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 50, 32, 32)];
        playIconImageView.image = UIImageNamed(@"mygedanlogog_img");
        playIconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playTap)];
        [playIconImageView addGestureRecognizer:playTap];
        self.playIconImageView = playIconImageView;
        [themView4 addSubview:playIconImageView];
        
        self.playImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 12, 12)];
        self.playImgV.image = UIImageNamed(@"playmygedan_img");
        [self.playIconImageView addSubview:self.playImgV];
        
        SPActivityIndicatorView *activityIndicatorView = [[SPActivityIndicatorView alloc] initWithType:SPActivityIndicatorAnimationTypeLineScale tintColor:[UIColor colorWithHexString:@"#E6C14D"]];
        activityIndicatorView.frame = CGRectMake(16,6,20,20);
        activityIndicatorView.left = YES;
        [self.playIconImageView addSubview:activityIndicatorView];
        activityIndicatorView.userInteractionEnabled = YES;
        self.leftAct = activityIndicatorView;
        self.leftAct.hidden = YES;
        
        UIButton *songlistBtn = [[UIButton alloc] initWithFrame:CGRectMake(themView4.frame.size.width-24-15, 54, 24, 24)];
        [songlistBtn setBackgroundImage:UIImageNamed(@"whitemygedan_img") forState:UIControlStateNormal];
        [themView4 addSubview:songlistBtn];
        [songlistBtn addTarget:self action:@selector(likeListClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.songNameL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(55, 55, themView4.frame.size.width-55-15-24-4, 22)];
        self.songNameL.font = SIXTEENTEXTFONTSIZE;
        self.songNameL.text = [NoticeTools chinese:@"主页还没有背景音乐噢～" english:@"Make a playlist now" japan:@"今すぐプレイリストを作成"];
        self.songNameL.textColor = [UIColor whiteColor];
        self.songNameL.userInteractionEnabled = YES;
        UITapGestureRecognizer *playT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playTap)];
        [self.songNameL addGestureRecognizer:playT];
        [themView4 addSubview:self.songNameL];
        
        UIView *themView3 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(themView.frame)+268, DR_SCREEN_WIDTH-30, 129)];
        themView3.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.1];
        themView3.layer.cornerRadius = 10;
        themView3.layer.masksToBounds = YES;
        [self addSubview:themView3];
        
        UILabel *otherL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
        otherL.font = FOURTHTEENTEXTFONTSIZE;
        otherL.textColor = [UIColor whiteColor];
        otherL.text = [NoticeTools chinese:@"其他" english:@"Others" japan:@"その他"];
        [themView3 addSubview:otherL];
        NSArray *imgarr3 = @[@"Image_bazaos",@"Image_minemyhelp",@"Image_gegnd"];
        NSArray *textArr3 = @[[NoticeTools getLocalStrWith:@"bz.mine"],[NoticeTools getLocalStrWith:@"cao.title"],[NoticeTools getLocalType]==1?@"Past": ([NoticeTools getLocalType]==2?@"過去": @"书影音画")];
        for (int i = 0; i < 3; i++) {
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(themView2.frame.size.width/4*i,50, themView2.frame.size.width/4, 76)];
            tapView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFun3:)];
            [tapView addGestureRecognizer:tap];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((tapView.frame.size.width-40)/2, 0,40, 40)];
            imageView.image = UIImageNamed(imgarr3[i]);
            [tapView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+4,tapView.frame.size.width, 17)];
            label.textColor = [UIColor whiteColor];
            label.font = TWOTEXTFONTSIZE;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = textArr3[i];
            [tapView addSubview:label];
            [themView3 addSubview:tapView];
        }
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.0];
        
        self.iconArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)requestLike{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"music/getLikePeople" Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self.iconArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                [self.iconArr addObject:[NoticeMusicLikeModel mj_objectWithKeyValues:dic]];
            }
            if (self.iconArr.count) {
                CGFloat textWidth = GET_STRWIDTH(self.recNumL.text, 12, 20);
                self.recFgIconView.hidden = NO;
                self.recNumL.hidden = NO;
                self.recFgIconView.iconSongArr = self.iconArr;
                if (self.iconArr.count == 1) {
                    self.recFgIconView.frame = CGRectMake(DR_SCREEN_WIDTH-30-textWidth-24-15, 13, 24, 24);
                }else if (self.iconArr.count == 2){
                    self.recFgIconView.frame = CGRectMake(DR_SCREEN_WIDTH-30-textWidth-(24*2-8)-15, 13, 24*2-8, 24);
                }else if (self.iconArr.count >= 3){
                    self.recFgIconView.frame = CGRectMake(DR_SCREEN_WIDTH-30-textWidth-(24*3-16)-15, 13, 24*3-16, 24);
                }
                self.recNumL.frame = CGRectMake(CGRectGetMaxX(self.recFgIconView.frame)+2,15, textWidth, 20);

            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)setMessageModel:(NoticeStaySys *)messageModel{
    _messageModel = messageModel;
    [self refreNewsNum:messageModel];
}

- (void)refreNewsNum:(NoticeStaySys *)messageModel{
    self.num1L.hidden = messageModel.likeModel.num.intValue?NO:YES;
    self.num2L.hidden = messageModel.other_commentModel.num.intValue?NO:YES;
    self.num3L.hidden = (messageModel.voice_whisperModel.num.intValue || messageModel.comModel.num.intValue)?NO:YES;
    self.num4L.hidden = messageModel.sysM.num.intValue?NO:YES;
    
    self.num1L.text = [NSString stringWithFormat:@"%d",messageModel.likeModel.num.intValue];
    self.num2L.text = [NSString stringWithFormat:@"%d",messageModel.other_commentModel.num.intValue];
    self.num3L.text = [NSString stringWithFormat:@"%d",messageModel.comModel.num.intValue+messageModel.voice_whisperModel.num.intValue];
    self.num4L.text = [NSString stringWithFormat:@"%d",messageModel.sysM.num.intValue];
    
    CGFloat width1 = GET_STRWIDTH(self.num1L.text, 9, 14)+4;
    if (width1 < 14) {
        width1 = 14;
    }
    
    CGFloat width2 = GET_STRWIDTH(self.num2L.text, 9, 14)+4;
    if (width2 < 14) {
        width2 = 14;
    }
    
    CGFloat width3 = GET_STRWIDTH(self.num3L.text, 9, 14)+4;
    if (width3 < 14) {
        width3 = 14;
    }
    
    CGFloat width4 = GET_STRWIDTH(self.num4L.text, 9, 14)+4;
    if (width4 < 14) {
        width4 = 14;
    }
    
    self.num1L.frame = CGRectMake(self.num1L.frame.origin.x, self.num1L.frame.origin.y, width1, 14);
    self.num2L.frame = CGRectMake(self.num2L.frame.origin.x, self.num2L.frame.origin.y, width2, 14);
    self.num3L.frame = CGRectMake(self.num3L.frame.origin.x, self.num3L.frame.origin.y, width3, 14);
    self.num4L.frame = CGRectMake(self.num4L.frame.origin.x, self.num4L.frame.origin.y, width4, 14);
}

- (void)likeListClick{
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if (!userM.level.intValue) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.lvsj"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.golv"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {

                NoticeCurentLeaveController *ctl = [[NoticeCurentLeaveController alloc] init];
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    NoticeMyLikeSongController *ctl = [[NoticeMyLikeSongController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (UILabel *)recNumL{
    if (!_recNumL) {
        _recNumL = [[UILabel alloc] initWithFrame:CGRectMake(15, 76, 120, 20)];
        _recNumL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _recNumL.font = TWOTEXTFONTSIZE;
        _recNumL.text = [NoticeTools getLocalStrWith:@"each.likeyourSong"];
        _recNumL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeListClick)];
        [_recNumL addGestureRecognizer:tap];
    }
    return _recNumL;
}

- (void)playTap{

    if (self.musicArr.count && self.currentModel) {
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.floatView.isPlaying) {
            appdel.floatView.noRePlay = YES;
            [appdel.floatView.audioPlayer stopPlaying];
        }
        
        if (self.currentModel.status < 1) {
            if (self.currentModel.playUrl) {
                [self.musicPlayer startPlayWithUrl:self.currentModel.playUrl isLocalFile:NO];
            }else{
                [[NoticeTools getTopViewController] showHUD];
                
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"parsingMusic/%@/1",self.currentModel.songId] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if (success) {
                        NoticeCustumMusiceModel *cuM = [NoticeCustumMusiceModel mj_objectWithKeyValues:dict[@"data"]];
                        self.currentModel.playUrl = cuM.songUrl;
                        [self.musicPlayer startPlayWithUrl:self.currentModel.playUrl isLocalFile:NO];
                      
                    }
                    [[NoticeTools getTopViewController] hideHUD];
                } fail:^(NSError * _Nullable error) {
                    [[NoticeTools getTopViewController] hideHUD];
                }];
            }

        }else if (self.currentModel.status == 1){
            [self.leftAct stopAnimating];
            self.leftAct.hidden = YES;
            self.playImgV.hidden = NO;
            self.currentModel.status = 2;
            [self.musicPlayer pause:YES];
        }else if(self.currentModel.status == 2){
            self.currentModel.status = 1;
            [self.leftAct startAnimating];
            self.leftAct.hidden = NO;
            self.playImgV.hidden = YES;
            [self.musicPlayer pause:NO];
        }
    }
}

- (LGAudioPlayer *)musicPlayer
{
    if (!_musicPlayer) {
        _musicPlayer = [[LGAudioPlayer alloc] init];
        _musicPlayer.playType = NOTICEPLAYCENTERMUSIC;
        __weak typeof(self) weakSelf = self;

        _musicPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (status == AVPlayerItemStatusFailed) {
                
            }else{
                weakSelf.currentModel.status = 1;
                [weakSelf.leftAct startAnimating];
                weakSelf.leftAct.hidden = NO;
                weakSelf.playImgV.hidden = YES;
            }
        };
        _musicPlayer.playComplete = ^{
            if (!weakSelf.musicArr.count) {
                return;
            }
            [weakSelf.leftAct stopAnimating];
            weakSelf.leftAct.hidden = YES;
            weakSelf.playImgV.hidden = NO;
            weakSelf.currentModel.status = 0;
            if (!weakSelf.isRefresh) {
                weakSelf.currentIndex++;
                if (weakSelf.currentIndex > weakSelf.musicArr.count-1) {
                    weakSelf.currentIndex = 0;
                }
                weakSelf.currentModel = weakSelf.musicArr[weakSelf.currentIndex];
                weakSelf.currentModel.status = 0;
                weakSelf.songNameL.text =  weakSelf.currentModel.song_tile;
           
                [weakSelf playTap];
            }else{
                weakSelf.isRefresh = NO;
            }
        };
    }
    return _musicPlayer;
}



- (void)requestMusicList{
    NSString *url = @"";
    url = [NSString stringWithFormat:@"myMusic/%@?pageNo=1",[NoticeTools getuserId]];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {

        if (success) {
            [self.musicArr removeAllObjects];
            self.isRefresh = YES;
            [self.musicPlayer stopPlaying];
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeCustumMusiceModel *model = [NoticeCustumMusiceModel mj_objectWithKeyValues:dic];
                [self.musicArr addObject:model];
            }
            if (self.musicArr.count) {
                int musixTag = arc4random()%self.musicArr.count;
                self.currentIndex = musixTag;
                self.playImgV.hidden = NO;
                self.songNameL.text = [self.musicArr[musixTag] song_tile];
                self.currentModel = self.musicArr[musixTag];
            }else{
                self.songNameL.text = [NoticeTools chinese:@"主页还没有背景音乐噢～" english:@"Make a playlist now" japan:@"今すぐプレイリストを作成"];
            }

        }
    } fail:^(NSError * _Nullable error) {
 
    }];
    
    [self requestLike];
}

- (NSMutableArray *)musicArr{
    if (!_musicArr) {
        _musicArr = [[NSMutableArray alloc] init];
    }
    return _musicArr;
}

- (void)dataViewTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:[NoticeTools getTopViewController].navigationController.view];
    [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    if (tapV.tag == 0) {
        NoticeTieTieSignController *ctl = [[NoticeTieTieSignController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }else if (tapV.tag == 1) {//我的播客
        NoticeMyBokeController *ctl = [[NoticeMyBokeController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }else if (tapV.tag == 2){
        NoticeMyHelpListController *ctl = [[NoticeMyHelpListController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }else if (tapV.tag == 3){
        NoticeVoiceAlbumAndChatAlbumController *ctl = [[NoticeVoiceAlbumAndChatAlbumController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }
}

- (void)infoClick{
    NoticeEditViewController *ctl = [[NoticeEditViewController alloc] init];
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:[NoticeTools getTopViewController].navigationController.view];
    [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
}

- (void)listClick:(UIButton *)btn{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:[NoticeTools getTopViewController].navigationController.view];
    [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    if (btn.tag == 0) {
        NoticeCurentLeaveController *ctl = [[NoticeCurentLeaveController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }else if (btn.tag == 2){
        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
        if (!userM.level.intValue) {
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.lvsj"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.golv"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    NoticeCurentLeaveController *ctl = [[NoticeCurentLeaveController alloc] init];
                    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
                }
            };
            [alerView showXLAlertView];
            return;
        }
        NoticeMyOwnMusicListController *ctl = [[NoticeMyOwnMusicListController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }else if (btn.tag == 1){
        NoticeChangeSkinListController *ctl = [[NoticeChangeSkinListController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }
}

- (void)leaveTap{

    NoticeCurentLeaveController *ctl = [[NoticeCurentLeaveController alloc] init];
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:[NoticeTools getTopViewController].navigationController.view];
    [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
}

- (void)clearClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"确定清除所有未读消息吗？" english:@"Sure to clear all unreads?" japan:@"すべての未読をクリアですか？"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf clearUnreadNews];
        }
    };
    [alerView showXLAlertView];
}

- (void)clearUnreadNews{
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"messages/%@",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v5.4.9+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.messageModel.likeModel.num = @"0";
            self.messageModel.other_commentModel.num = @"";
            self.messageModel.comModel.num = @"0";
            self.messageModel.voice_whisperModel.num = @"0";
            self.messageModel.sysM.num = @"0";
            [self refreNewsNum:self.messageModel];
            if(self.hasRedViewBlock){
                self.hasRedViewBlock(NO);
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)tapInfoFun:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;

    if (tapV.tag <= 1) {
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:[NoticeTools getTopViewController].navigationController.view];
        [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        NoticeCarePeopleController *ctl = [[NoticeCarePeopleController alloc] init];
        ctl.isOfCared = tapV.tag == 1? YES:NO;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
        return;
    }

    NoticeCenterInfoTostView *userInfoV = [[NoticeCenterInfoTostView alloc] initWithShowUserInfo];
    userInfoV.userM = self.userM;
    [userInfoV showChoiceView];
}

- (void)infoTap{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:[NoticeTools getTopViewController].navigationController.view];
    [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)tapFun1:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:[NoticeTools getTopViewController].navigationController.view];
    [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    if (tapV.tag == 0) {
        NoticerClockController *ctl = [[NoticerClockController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }
    else if (tapV.tag == 1) {//每日一阅
        NoticeImageViewController *ctl = [[NoticeImageViewController alloc] init];
        ctl.isReadEveryDay = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }else if(tapV.tag == 2){//文章
        NoticeReadBookController *ctl = [[NoticeReadBookController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }else if (tapV.tag == 3){//同频域
        NoticeWorldVoiceListViewController *ctl = [[NoticeWorldVoiceListViewController alloc] init];
        ctl.fromMain = YES;
        ctl.isSame = YES;
        ctl.isPager = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }
}

- (void)tapFun2:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:[NoticeTools getTopViewController].navigationController.view];
    [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    if (tapV.tag == 0) {//
        NoticeVoiceCommentNewsController *ctl = [[NoticeVoiceCommentNewsController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }
    else if (tapV.tag == 3) {//
        NoticeSysViewController *ctl = [[NoticeSysViewController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }else if (tapV.tag == 1){
        NoticeDepartureController *ctl = [[NoticeDepartureController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }else if (tapV.tag == 2){
        NoticeVoiceChatAndDepartController *ctl = [[NoticeVoiceChatAndDepartController alloc] init];
        ctl.messageModel = self.messageModel;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }
}

- (void)tapFun3:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
   
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:[NoticeTools getTopViewController].navigationController.view];
    [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    if (tapV.tag == 0) {
        NoticeWhiteVoiceController  *ctl = [[NoticeWhiteVoiceController  alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }
    else if (tapV.tag == 1) {
        NoticeCaoGaoController  *ctl = [[NoticeCaoGaoController  alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }else if(tapV.tag == 2){
        NoticeMyBookController *ctl = [[NoticeMyBookController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }
}


- (void)setUserM:(NoticeUserInfoModel *)userM{
    _userM = userM;
    self.isReplay = YES;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:userM.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    self.nickNameL.text = userM.nick_name;
    self.careL.text = [NSString stringWithFormat:@"%ld",userM.enjoy_num.integerValue];
    self.bCareL.text = [NSString stringWithFormat:@"%ld",userM.be_enjoy_num.integerValue];
    self.timeL.text = userM.allVoiceTime;
    self.redView.frame = CGRectMake(GET_STRWIDTH(self.careL.text, 22, 30)-4, 2, 4, 4);
    self.lelveImageView.image = UIImageNamed(userM.levelImgName);
    self.iconMarkView.image = UIImageNamed(userM.levelImgIconName);
}

- (void)setNumberDataM:(NoticeUserInfoModel *)numberDataM{
    _numberDataM = numberDataM;
    self.timeMarkL.text = [NSString stringWithFormat:@"%d",numberDataM.voiceNum.intValue];
    self.bkNumL.text = [NSString stringWithFormat:@"%d",numberDataM.podcastNum.intValue];
    self.helpNumL.text = [NSString stringWithFormat:@"%d",numberDataM.invitationNum.intValue];
    self.zjNumL.text = [NSString stringWithFormat:@"%d",numberDataM.albumNum.intValue];
    
}
@end
