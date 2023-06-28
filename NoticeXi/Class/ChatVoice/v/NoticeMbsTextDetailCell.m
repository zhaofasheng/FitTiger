//
//  NoticeMbsTextDetailCell.m
//  NoticeXi
//
//  Created by li lei on 2022/2/22.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMbsTextDetailCell.h"
#import "BaseNavigationController.h"
#import "NoticerTopicSearchResultNewController.h"
#import "NoticeTabbarController.h"
#import "NoticeBingGanListView.h"
#import "NoticeMyBookController.h"
#import "NoticeMySongController.h"
#import "NoticeMyMovieController.h"
#import "NoticeMyMovieComController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeMbsTextDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.userInteractionEnabled = YES;
        
        self.backImageView = [[NoticeCustumBackImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.clipsToBounds = YES;
        self.backImageView.noNeedPaopao = YES;
        [self.contentView addSubview:self.backImageView];
        self.backImageView.userInteractionEnabled = YES;
        
        self.mbsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [self.backImageView addSubview:self.mbsView];
        self.mbsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        self.backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        [self.contentView addSubview:self.backView];
        self.backView.delegate = self;
        self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        self.labelBackView = [[UIView alloc] initWithFrame:CGRectMake(20,36, DR_SCREEN_WIDTH-40, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-36-125-50-BOTTOM_HEIGHT)];
        self.labelBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        self.labelBackView.layer.cornerRadius = 10;
        self.labelBackView.layer.masksToBounds = YES;
        [self.backView addSubview:self.labelBackView];
        self.labelBackView.userInteractionEnabled = YES;
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(15, 125, self.labelBackView.frame.size.width-30, self.labelBackView.frame.size.height-125-48)];
        self.contentL.numberOfLines = 0;
        self.contentL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        [self.labelBackView addSubview:self.contentL];
        
//        self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.labelBackView.frame.size.height-45, DR_SCREEN_WIDTH-40, 45)];
//        [self.moreButton setTitle:@"查看全文" forState:UIControlStateNormal];
//        [self.moreButton setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
//        self.moreButton.titleLabel.font = THRETEENTEXTFONTSIZE;
//        [self.labelBackView addSubview:self.moreButton];
//        [self.moreButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
                
        _mbView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-72)/2,0, 72, 72)];
        _mbView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.1];
        [self.backView addSubview:_mbView];
        _mbView.layer.cornerRadius = 72/2;
        _mbView.layer.masksToBounds = YES;
        _mbView.layer.borderWidth = 5;
        _mbView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
        _mbView.userInteractionEnabled = YES;
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 72, 72)];
        [self.mbView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
        self.iconMarkView.hidden = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3,3, 66, 66)];
        _iconImageView.layer.cornerRadius = 33;
        _iconImageView.layer.masksToBounds = YES;
        [_mbView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        self.careButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-52)/2, CGRectGetMaxY(_mbView.frame)-16,52, 20)];
        self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
        self.careButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.careButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.careButton.layer.cornerRadius = 20/2;
        self.careButton.layer.masksToBounds = YES;
        [self.backView addSubview:self.careButton];
        [self.careButton addTarget:self action:@selector(careClick) forControlEvents:UIControlEventTouchUpInside];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(0,50,DR_SCREEN_WIDTH-40, 28)];
        _nickNameL.font = XGEightBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.labelBackView addSubview:_nickNameL];
        _nickNameL.textAlignment = NSTextAlignmentCenter;
        
        //电影
        _movieView = [[NoticeMoivceInCell alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_nickNameL.frame)+20, DR_SCREEN_WIDTH-40-30-6-65, 78)];
        [self.labelBackView addSubview:_movieView];
        _movieView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.2];
        
        self.typeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_movieView.frame)+6,_movieView.frame.origin.y, 65, 78)];
        self.typeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.typeL.font = TWOTEXTFONTSIZE;
        self.typeL.textAlignment = NSTextAlignmentCenter;
        self.typeL.backgroundColor = _movieView.backgroundColor;
        self.typeL.layer.cornerRadius = 8;
        self.typeL.layer.masksToBounds = YES;
        self.typeL.numberOfLines = 2;
        self.typeL.hidden = YES;
        [self.labelBackView addSubview:self.typeL];
        self.typeL.userInteractionEnabled = YES;
        UITapGestureRecognizer *syyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mbyTap)];
        [self.typeL addGestureRecognizer:syyTap];
        //头像
        _smallIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(44,STATUS_BAR_HEIGHT+((NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-30))/2, 30, 30)];
        _smallIconImageView.layer.cornerRadius = 15;
        _smallIconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_smallIconImageView];
        _smallIconImageView.hidden = YES;
        _smallIconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_smallIconImageView addGestureRecognizer:iconTap1];
        
        //昵称
        _smallNickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_smallIconImageView.frame)+10,STATUS_BAR_HEIGHT,DR_SCREEN_WIDTH-50-10-30-50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        _smallNickNameL.font = XGSIXBoldFontSize;
        _smallNickNameL.textColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _smallNickNameL.hidden = YES;
        [self.contentView addSubview:_smallNickNameL];
        
        self.statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 24, 24)];
        [self.labelBackView addSubview:self.statusImageView];
        self.statusImageView.hidden = YES;
        
        //话题
        _topiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nickNameL.frame)+7,DR_SCREEN_WIDTH-40, 20)];
        _topiceLabel.font = FOURTHTEENTEXTFONTSIZE;
        _topiceLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _topiceLabel.userInteractionEnabled = YES;
        _topiceLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *taptop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTextClick)];
        [_topiceLabel addGestureRecognizer:taptop];
        [self.labelBackView addSubview:_topiceLabel];
        
        self.hsButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-36*2-123)/2, CGRectGetMaxY(self.labelBackView.frame)+40, 36, 36)];
        [self.hsButton setBackgroundImage:UIImageNamed(@"Image_gaolhs") forState:UIControlStateNormal];
        [self.backView addSubview:self.hsButton];
        [self.hsButton addTarget:self action:@selector(replayClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(self.hsButton.frame.origin.x-10, CGRectGetMaxY(self.hsButton.frame), 56, 17)];
        self.numL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.numL.textAlignment = NSTextAlignmentCenter;
        self.numL.font = TWOTEXTFONTSIZE;
        [self.backView addSubview:self.numL];
        
        self.sendBGBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hsButton.frame)+123, CGRectGetMaxY(self.labelBackView.frame)+40, 36, 36)];
        [self.sendBGBtn setBackgroundImage:UIImageNamed(@"Image_glbingg") forState:UIControlStateNormal];
        [self.backView addSubview:self.sendBGBtn];
        [self.sendBGBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.bgL = [[UILabel alloc] initWithFrame:CGRectMake(self.sendBGBtn.frame.origin.x-10, CGRectGetMaxY(self.sendBGBtn.frame), 56, 17)];
        self.bgL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.bgL.textAlignment = NSTextAlignmentCenter;
        self.bgL.font = TWOTEXTFONTSIZE;
        [self.backView addSubview:self.bgL];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fun2)];
        tap2.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap2];
        
        self.backImageView.image = UIImageNamed(@"voicedefault.jpg");
    }
    return self;
}

- (void)changeSkin{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.mbsView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"]colorWithAlphaComponent:appdel.alphaValue>0?appdel.alphaValue:0.3];
    if ([_voiceM.subUserModel.userId isEqualToString:[NoticeTools getuserId]]) {
        
        if (appdel.backImg) {
            self.backImageView.image = [UIImage boxblurImage:appdel.backImg withBlurNumber:appdel.effect];
            self.mbsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:appdel.alphaValue>0.80?0.2:appdel.alphaValue];
        }else{
            self.backImageView.image = UIImageNamed(@"voicedefault.jpg");
        }
        return;
    }

    [self.backImageView.svagPlayer pauseAnimation];
    self.backImageView.svagPlayer.hidden = YES;
    if (_voiceM.subUserModel.spec_bg_type.intValue ==1) {//默认背景
        if (appdel.backDefaultImg) {
            self.backImageView.image = [UIImage boxblurImage:appdel.backDefaultImg withBlurNumber:appdel.effect];
        }else{
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_voiceM.subUserModel.spec_bg_default_photo] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                
                if (data) {
                    UIImage *gqImage = [UIImage imageWithData:data];
                    self.backImageView.image = [UIImage boxblurImage:gqImage withBlurNumber:appdel.effect];
                }
            }];
        
        }
        [self.backImageView.svagPlayer stopAnimation];
        self.backImageView.svagPlayer.hidden = YES;
    }else if(_voiceM.subUserModel.spec_bg_type.intValue == 2 || _voiceM.subUserModel.spec_bg_type.intValue == 4){//自定义背景
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_voiceM.subUserModel.spec_bg_type.intValue == 2?_voiceM.subUserModel.spec_bg_photo_url:_voiceM.subUserModel.spec_bg_skin_url] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            
            if (data) {
                UIImage *gqImage = [UIImage imageWithData:data];
                self.backImageView.image = [UIImage boxblurImage:gqImage withBlurNumber:appdel.effect];
            }
        }];
    }else{
        self.backImageView.image = UIImageNamed(@"voicedefault.jpg");
    }
}

- (void)mbyTap{
    if (self.voiceM.resource) {
        if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
            
            NoticeMyMovieComController *ctl = [[NoticeMyMovieComController alloc] init];
            ctl.userId = _voiceM.subUserModel.userId;
            if (self.voiceM.resource_type.intValue == 1) {
                ctl.type = 1;
            }else if(self.voiceM.resource_type.intValue == 2){
                ctl.type = 2;
            }else{
                ctl.type = 3;
            }
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
     
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            }
        }else{
            UIViewController *ctl = nil;
            if (self.voiceM.resource_type.intValue == 1) {
                ctl = [[NoticeMyMovieController alloc] init];
            }else if(self.voiceM.resource_type.intValue == 2){
                ctl = [[NoticeMyBookController alloc] init];
            }else{
                ctl = [[NoticeMySongController alloc] init];
            }
     
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
   
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            }
        }
        return;
    }
}
- (void)deleteCare{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    //_voiceM.subUserModel.userId
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admires/%@",_voiceM.subUserModel.userId] Accept:@"application/vnd.shengxi.v5.1.0+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self.voiceM.is_myadmire = @"0";
            if (self.voiceM.is_myadmire.intValue) {
                self.careButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
                [self.careButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
            }else{
                self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                [self.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}
//欣赏
- (void)careClick{

    if (self.voiceM.is_myadmire.intValue) {
        
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"xs.surecanxs"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf deleteCare];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    //_voiceM.subUserModel.userId
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:_voiceM.subUserModel.userId forKey:@"toUserId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admires" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeMJIDModel *idM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            self.voiceM.is_myadmire = idM.allId;
            if (self.voiceM.is_myadmire.intValue) {
                self.careButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
                [self.careButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
                [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"xs.xssus"]];
            }else{
                self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                [self.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
            }
        }
        [nav.topViewController hideHUD];
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}


- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    
    self.numL.hidden = NO;
    self.hsButton.hidden = NO;
    self.sendBGBtn.hidden = NO;
    
    if (voiceM.statusM) {
        self.statusImageView.hidden = NO;
        [self.statusImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.statusM.picture_url]];
        self.topiceLabel.frame = CGRectMake(24, CGRectGetMaxY(_nickNameL.frame)+7,DR_SCREEN_WIDTH-40-24, 20);
    }else{
        self.statusImageView.hidden = YES;
        self.topiceLabel.frame = CGRectMake(0, CGRectGetMaxY(_nickNameL.frame)+7,DR_SCREEN_WIDTH-40, 20);
    }
    
    //话题
    if (voiceM.topic_name && voiceM.topic_name.length) {
        self.topiceLabel.text = voiceM.topicName;
        self.statusImageView.frame = CGRectMake((DR_SCREEN_WIDTH-GET_STRWIDTH(self.topiceLabel.text, 14, 28)-24-40)/2-10, self.topiceLabel.frame.origin.y, 24, 24);
    }else{
        self.statusImageView.frame = CGRectMake((DR_SCREEN_WIDTH-24-40)/2, self.topiceLabel.frame.origin.y+2, 24, 24);
    }
    
    self.nickNameL.text = voiceM.subUserModel.nick_name;

    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.subUserModel.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    
    self.smallNickNameL.text = voiceM.subUserModel.nick_name;

    [_smallIconImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.subUserModel.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    
    //对话或者回声数量
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.chat_num.integerValue) {
            self.numL.text = _voiceM.chat_num;
        }else{
            self.numL.text = @"";
        }
        if (_voiceM.zaned_num.intValue) {
            self.bgL.text = _voiceM.zaned_num;
        }else{
            self.bgL.text = @"";
        }
        self.careButton.hidden = YES;
    }else{
        self.bgL.text = @"";
        if (!_voiceM.resource) {
            self.careButton.hidden = NO;
        }
        if (_voiceM.dialog_num.integerValue) {
            self.numL.text = _voiceM.dialog_num;
        }else{
            self.numL.text = @"";
        }
        if (_voiceM.is_myadmire.intValue) {
            self.careButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
            [self.careButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
        }else{
            self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
        }
    }
        
    self.contentL.attributedText = voiceM.allTextAttStr;
    if (voiceM.isMoreHeight) {
        self.moreButton.hidden = NO;
        self.contentL.frame = CGRectMake(15, 125, self.labelBackView.frame.size.width-30, self.labelBackView.frame.size.height-125-48);
        [self moreClick];
    }else{
        self.moreButton.hidden = YES;
        self.contentL.frame = CGRectMake(15, 125, self.labelBackView.frame.size.width-30, voiceM.textHeight);
    }
 
    if (voiceM.resource) {
        
        if (voiceM.isMoreSYYHeight) {
            self.moreButton.hidden = NO;
            [self moreClick];
            self.contentL.frame = CGRectMake(15,191, self.labelBackView.frame.size.width-30, self.labelBackView.frame.size.height-191-48);
        }else{
            self.moreButton.hidden = YES;
            self.contentL.frame = CGRectMake(15, 191, self.labelBackView.frame.size.width-30, voiceM.textHeight);
        }
        self.bgL.hidden = YES;
        self.numL.hidden = YES;
        self.hsButton.hidden = YES;
        self.sendBGBtn.hidden = YES;
        self.movieView.hidden = NO;

        self.movieView.type = voiceM.resource_type;
        if ([voiceM.resource_type isEqualToString:@"1"]) {
            self.movieView.movie = voiceM.movieM;
            self.movieView.userScro = voiceM.user_score;
            self.typeL.text = @"Ta的\n影评";
            if ([NoticeTools getLocalType]) {
                self.typeL.text = @"Movie";
            }
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.movieM.movie_poster]];
        }else if ([voiceM.resource_type isEqualToString:@"2"]){//书籍
            self.movieView.userScro = voiceM.user_score;
            self.movieView.book = voiceM.bookM;
            self.typeL.text = @"Ta的\n书评";
            if ([NoticeTools getLocalType]) {
                self.typeL.text = @"Book";
            }
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.bookM.book_cover]];
        }else if ([voiceM.resource_type isEqualToString:@"3"]){//歌曲
            self.movieView.songScro = voiceM.user_score;
            self.movieView.song = voiceM.songM;
            self.typeL.text = @"Ta的\n歌曲";
            if ([NoticeTools getLocalType]) {
                self.typeL.text = @"Song";
            }
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.songM.song_cover]];
        }
        self.typeL.hidden = NO;
        if (_voiceM.content_type.intValue == 2) {
            self.careButton.hidden = YES;
        }
        
    }else{
        [self changeSkin];
        if (voiceM.is_private.boolValue) {
            self.bgL.hidden = YES;
            self.numL.hidden = YES;
            self.hsButton.hidden = YES;
            self.sendBGBtn.hidden = YES;
        }else{
            self.bgL.hidden = NO;
            self.numL.hidden = NO;
            self.hsButton.hidden = NO;
            self.sendBGBtn.hidden = NO;
        }
        
        self.movieView.hidden = YES;

    }

    [self.sendBGBtn setBackgroundImage:UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbg": @"Image_glbingg") forState:UIControlStateNormal];
    

    self.iconMarkView.image = UIImageNamed(_voiceM.subUserModel.levelImgIconName);
    
}

- (void)topicTextClick{
    if (_voiceM.topic_name && _voiceM.topic_name.length) {

        NoticerTopicSearchResultNewController *ctl = [[NoticerTopicSearchResultNewController alloc] init];
        ctl.topicName = _voiceM.topic_name;
        ctl.topicId = _voiceM.topic_id;
        if (_voiceM.content_type.intValue == 2) {
            ctl.isTextVoice = YES;
        }
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

- (void)moreClick{
    self.showMore = YES;
 
    if (self.showMore) {
        self.labelBackView.frame = CGRectMake(20,36, DR_SCREEN_WIDTH-40, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-36-125-50-BOTTOM_HEIGHT+self.voiceM.moreHeight);
        self.contentL.frame = CGRectMake(15, 125, self.labelBackView.frame.size.width-30, _voiceM.textHeight);
        self.backView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT+self.voiceM.moreHeight-NAVIGATION_BAR_HEIGHT);
    }else{
        self.labelBackView.frame = CGRectMake(20,36, DR_SCREEN_WIDTH-40, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-36-125-50-BOTTOM_HEIGHT);
        self.contentL.frame = CGRectMake(15, 125, self.labelBackView.frame.size.width-30, self.labelBackView.frame.size.height-125-48);
        self.backView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    }
    self.hsButton.frame = CGRectMake((DR_SCREEN_WIDTH-36*2-123)/2, CGRectGetMaxY(self.labelBackView.frame)+40, 36, 36);
    self.sendBGBtn.frame = CGRectMake(CGRectGetMaxX(self.hsButton.frame)+123, CGRectGetMaxY(self.labelBackView.frame)+40, 36, 36);
    self.numL.frame = CGRectMake(self.hsButton.frame.origin.x-10, CGRectGetMaxY(self.hsButton.frame), 56, 17);
    self.bgL.frame  =CGRectMake(self.sendBGBtn.frame.origin.x-10, CGRectGetMaxY(self.sendBGBtn.frame), 56, 17);
    if (self.voiceM.resource) {
        if (self.showMore) {
            self.labelBackView.frame = CGRectMake(20,36, DR_SCREEN_WIDTH-40, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-36-125-50-BOTTOM_HEIGHT+self.voiceM.moreHeight+66);
            self.contentL.frame = CGRectMake(15, 191, self.labelBackView.frame.size.width-30, _voiceM.textHeight);
            self.backView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT+self.voiceM.moreHeight-NAVIGATION_BAR_HEIGHT);
        }else{
            self.labelBackView.frame = CGRectMake(20,36, DR_SCREEN_WIDTH-40, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-36-125-50-BOTTOM_HEIGHT);
            self.contentL.frame = CGRectMake(15, 191, self.labelBackView.frame.size.width-30, self.labelBackView.frame.size.height-191-48);
            self.backView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        }
    }

}

- (void)userInfoTap{
    if (self.noPushToUserCenter) {
        return;
    }
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    
    __weak typeof(self) weakSelf = self;
    ctl.careClickBlock = ^(NSString * _Nonnull careId, NSString * _Nonnull userId) {
        weakSelf.voiceM.is_myadmire = careId;
        if (weakSelf.voiceM.is_myadmire.intValue) {
            weakSelf.careButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
            [weakSelf.careButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
        }else{
            weakSelf.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [weakSelf.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
        }
    };
    
    
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        ctl.isOther = YES;
        ctl.userId = _voiceM.subUserModel.userId;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        
    }
}

- (void)replayClick{
    if (self.noPush) {
        if (self.replyClickBlock) {
            self.replyClickBlock(YES);
        }
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.voiceM.content_type.intValue == 2) {
        if ([_voiceM.subUserModel.userId isEqualToString:[NoticeTools getuserId]]) {//如果是自己的心情，则跳转到查看回声列表
            NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
            ctl.isSelfHs = YES;
            ctl.voiceM = _voiceM;
            __weak typeof(self) weakSelf = self;
            ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
                weakSelf.voiceM.dialog_num = dilaNum;
            };
            CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                            withSubType:kCATransitionFromLeft
                                                                               duration:0.3f
                                                                         timingFunction:kCAMediaTimingFunctionLinear
                                                                                   view:nav.topViewController.view];
            [nav.topViewController.view.layer addAnimation:test forKey:@"pushanimation"];
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
            return;
        }
        NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
        ctl.isHs = YES;
        ctl.voiceM = _voiceM;
        __weak typeof(self) weakSelf = self;
        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            weakSelf.voiceM.dialog_num = dilaNum;
        };
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:nav.topViewController.view];
        [nav.topViewController.view.layer addAnimation:test forKey:@"pushanimation"];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        return;
    }
}

- (void)fun2{
    if (self.voiceM.resource) {
        return;
    }
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        [self likeClick];
    }
}

- (void)likeClick{
    //判断是否是自己,不是自己则为点击「有启发」
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){

        if (_voiceM.is_collected.boolValue) {//取消「有启发」
            if (_voiceM.canTapLike) {//防止多次点击
                return;
            }
            _voiceM.likeNoMove = YES;
            _voiceM.is_collected = @"0";
            [self.sendBGBtn setBackgroundImage:UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbg": @"Ima_sendbgn") forState:UIControlStateNormal];

            [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelCollectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
            
            _voiceM.canTapLike = YES;
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    self->_voiceM.canTapLike = NO;
                    self->_voiceM.is_collected = @"0";
                    [self.sendBGBtn setBackgroundImage:UIImageNamed(self->_voiceM.is_collected.intValue?@"Image_songbg": @"Ima_sendbgn") forState:UIControlStateNormal];
                }

            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
            }];
        }else{//「有启发」
      
            if (_voiceM.canTapLike) {
                return;
            }
            [self.sendBGBtn setBackgroundImage:UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbg": @"Ima_sendbgn") forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
            _voiceM.is_collected = @"1";
            _voiceM.canTapLike = YES;
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:@"5" forKey:@"needDelay"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    self->_voiceM.canTapLike = NO;
                    self->_voiceM.is_collected = @"1";
                    [self.sendBGBtn setBackgroundImage:UIImageNamed(self->_voiceM.is_collected.intValue?@"Image_songbg": @"Ima_sendbgn") forState:UIControlStateNormal];
                    [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"em.senbgt"]];
                }
         
            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
                [nav.topViewController hideHUD];
            }];
        }
        return;
    }
    if (!self.voiceM.zaned_num.intValue) {
        [nav.topViewController showToastWithText:@"还没有收到小饼干哦~"];
        return;
    }
    NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    listView.voiceM = self.voiceM;
    [listView showTost];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y > 78+36) {
        self.smallNickNameL.hidden = NO;
        self.smallIconImageView.hidden = NO;
        self.mbView.hidden = YES;
        self.nickNameL.hidden = YES;
    }else{
        self.smallNickNameL.hidden = YES;
        self.smallIconImageView.hidden = YES;
        self.mbView.hidden = NO;
        self.nickNameL.hidden = NO;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
