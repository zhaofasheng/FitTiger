//
//  NoticeUserCenter.m
//  NoticeXi
//
//  Created by li lei on 2019/12/19.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserCenter.h"
#import "DDHAttributedMode.h"
#import "NoticeUserInfoCenterController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"

@implementation NoticeUserCenter
{
    NSArray *imageArr;
    NSArray *noDataimageArr;
}

- (instancetype)initWithFrame:(CGRect)frame isOther:(BOOL)isOther{
    if (self = [super initWithFrame:frame]) {
        
        self.isOther = isOther;
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [NoticeTools getWhiteColor:@"#F9F9F9" NightColor:@"#12121F"];
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.contentView];
        

        NSArray *titArr = @[GETTEXTWITE(@"mine.jy"),GETTEXTWITE(@"mine.xc"),GETTEXTWITE(@"my.sgj"),[NoticeTools getTextWithSim:@"电影" fantText:@"電影"],[NoticeTools getTextWithSim:@"书籍" fantText:@"書籍"],@"音乐",[NoticeTools getLocalStrWith:@"py.py"],[NoticeTools getLocalStrWith:@"hh.h"]];
        for (int i = 0; i < 8; i++) {
            UIImageView *imageVeiw = [[UIImageView alloc] initWithFrame:CGRectMake(25+((DR_SCREEN_WIDTH-50-50*4)/3+50)*i, 10+ (self.isOther? 0 : CGRectGetMaxY(self.titleL.frame)), 50, 50)];
            if (i == 4) {
                imageVeiw.frame = CGRectMake(25, 20+(self.isOther? 0 : CGRectGetMaxY(self.titleL.frame))+50+10+12+15, 50, 50);
            }else if (i == 5){
                imageVeiw.frame = CGRectMake(25+((DR_SCREEN_WIDTH-50-50*4)/3+50), 20+(self.isOther? 0 : CGRectGetMaxY(self.titleL.frame))+50+10+12+15, 50, 50);
            }else if (i == 6){
                imageVeiw.frame = CGRectMake(25+((DR_SCREEN_WIDTH-50-50*4)/3+50)*2, 20+(self.isOther? 0 : CGRectGetMaxY(self.titleL.frame))+50+10+12+15, 50, 50);
            }else if (i == 7){
                imageVeiw.frame = CGRectMake(25+((DR_SCREEN_WIDTH-50-50*4)/3+50)*3, 20+(self.isOther? 0 : CGRectGetMaxY(self.titleL.frame))+50+10+12+15, 50, 50);
            }
            [self.contentView addSubview:imageVeiw];
            
            UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 13)];
            tLabel.textColor = GetColorWithName(VMainTextColor);
            tLabel.font = THRETEENTEXTFONTSIZE;
            tLabel.text = titArr[i];
            tLabel.textAlignment = NSTextAlignmentCenter;
            tLabel.center = CGPointMake(imageVeiw.center.x, imageVeiw.center.y+20+10+10);
            [self.contentView addSubview:tLabel];
            
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(imageVeiw.frame.origin.x,imageVeiw.frame.origin.y,50,50+10+12)];
            tapView.userInteractionEnabled = YES;
            tapView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chocieTap:)];
            [tapView addGestureRecognizer:tap];
            [self.contentView addSubview:tapView];
            
            if (i == 0) {
                self.voiceImageV = imageVeiw;
            }else if (i == 1){
                self.photoImageV = imageVeiw;
            }else if (i == 2){
                self.timeImageV = imageVeiw;
            }else if (i == 3){
                self.movieImageV = imageVeiw;
            }else if (i == 4){
                self.bookImageV = imageVeiw;
            }else if (i == 5){
                self.songImageV = imageVeiw;
            }else if (i == 6){
                self.pyImageV = imageVeiw;
            }else if (i == 7){
                self.drawImageV = imageVeiw;
            }
        }
        
        self.zjAll = [[NoticeZjView alloc] initWithFrame:CGRectMake(15,225-(self.isOther?20:0), DR_SCREEN_WIDTH-30, 49+32+(DR_SCREEN_WIDTH-60-16)/3+15) isOther:isOther];
        self.zjAll.titleL.text = [NoticeTools isSimpleLau]?@"语音专辑":@"語音專輯";
        [self.contentView addSubview:self.zjAll];
        
        self.zjText = [[NoticeZjView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.zjAll.frame)+10, DR_SCREEN_WIDTH-30, 49+32+(DR_SCREEN_WIDTH-60-16)/3+15) isText:YES isOther:isOther];
        NSString *str1 = [NoticeTools isSimpleLau]?@"文字专辑":@"文字專輯";
        self.zjText.titleL.text = str1;
        [self.contentView addSubview:self.zjText];
        
        if (!self.isOther) {
            self.zjLimit = [[NoticeZjView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.zjText.frame)+10, DR_SCREEN_WIDTH-30, 49+32+(DR_SCREEN_WIDTH-60-16)/3+15) isLimit:YES];
            NSString *str = [NoticeTools isSimpleLau]?@"悄悄话和交流专辑(私密)":@"回聲和交流專輯(私密)";
            self.zjLimit.titleL.attributedText = [DDHAttributedMode setSizeAndColorString:str setColor:GetColorWithName(VDarkTextColor) setSize:13 setLengthString:@"(私密)" beginSize:7];
            [self.contentView addSubview:self.zjLimit];
        }else{
            self.zjAll.titleL.text = [NoticeTools isSimpleLau]?@"ta创建的心情专辑":@"ta創建的心情專輯";
            NSString *str1 = [NoticeTools isSimpleLau]?@"ta创建的心情专辑(文字)":@"ta創建的心情專輯(文字)";
            self.zjText.titleL.attributedText = [DDHAttributedMode setSizeAndColorString:str1 setColor:GetColorWithName(VDarkTextColor) setSize:13 setLengthString:@"(文字)" beginSize:9];
        }
    }
    return self;
}

- (void)setNoticeM:(NoticeNoticenterModel *)noticeM{
    _noticeM = noticeM;
    if (!self.isFriend) {
        if (_noticeM.strange_view.intValue == 0) {
            self.voiceImageV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_UserCenter_lockb":@"Image_UserCenter_locky");
            self.photoImageV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_UserCenter_lockb":@"Image_UserCenter_locky");
            self.timeImageV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_UserCenter_lockb":@"Image_UserCenter_locky");
        }else{
            self.voiceImageV.image = imageArr[0];
            self.photoImageV.image = imageArr[1];
            self.timeImageV.image = imageArr[2];
        }

        self.movieImageV.image = noticeM.movie_voice_visibility.intValue == 2 ? UIImageNamed([NoticeTools isWhiteTheme]?@"Image_UserCenter_lockb":@"Image_UserCenter_locky"):imageArr[3];
        self.bookImageV.image = noticeM.book_voice_visibility.intValue == 2 ? UIImageNamed([NoticeTools isWhiteTheme]?@"Image_UserCenter_lockb":@"Image_UserCenter_locky"):imageArr[4];
        self.songImageV.image = noticeM.song_voice_visibility.intValue == 2 ? UIImageNamed([NoticeTools isWhiteTheme]?@"Image_UserCenter_lockb":@"Image_UserCenter_locky"):imageArr[5];
        self.pyImageV.image = (noticeM.dubbing_visibility.intValue == 2 || noticeM.dubbing_visibility.intValue == 3) ? UIImageNamed([NoticeTools isWhiteTheme]?@"Image_UserCenter_lockb":@"Image_UserCenter_locky"):imageArr[6];
        self.drawImageV.image = (noticeM.artwork_visibility.intValue == 2 || noticeM.artwork_visibility.intValue == 3) ? UIImageNamed([NoticeTools isWhiteTheme]?@"Image_UserCenter_lockb":@"Image_UserCenter_locky"):imageArr[7];
        
    }else{
        self.pyImageV.image = noticeM.dubbing_visibility.intValue == 3 ? UIImageNamed([NoticeTools isWhiteTheme]?@"Image_UserCenter_lockb":@"Image_UserCenter_locky"):imageArr[6];
        self.drawImageV.image = noticeM.artwork_visibility.intValue == 3 ? UIImageNamed([NoticeTools isWhiteTheme]?@"Image_UserCenter_lockb":@"Image_UserCenter_locky"):imageArr[7];
    }
}

- (void)setHasDataModel:(NoticeHasCenterData *)hasDataModel{
    _hasDataModel = hasDataModel;
    noDataimageArr = @[UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centerjyno":@"Image_centerjyyno"),UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centerxcno":@"Image_centerxcyno"),UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centersgjno":@"Image_centersgjyno"),UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centerdyno":@"Image_centerdyyno"),UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centersjno":@"Image_centersjyno"),UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centeryyno":@"Image_centeryyyno"),UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centerpyb":@"Image_centerpyy")];
    
    if (self.isFriend) {
        self.voiceImageV.image = _hasDataModel.hasVoice?imageArr[0]:noDataimageArr[0];
        self.photoImageV.image = _hasDataModel.hasPhoto?imageArr[1]:noDataimageArr[1];
        self.timeImageV.image = _hasDataModel.hasTime?imageArr[2]:noDataimageArr[2];
        self.movieImageV.image = _hasDataModel.hasMovie?imageArr[3]:noDataimageArr[3];
        self.bookImageV.image = _hasDataModel.hasBook?imageArr[4]:noDataimageArr[4];
        self.songImageV.image = _hasDataModel.hasSong?imageArr[5]:noDataimageArr[5];
        if (_noticeM.dubbing_visibility.intValue != 3) {
            self.pyImageV.image = _hasDataModel.hasPy?UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centerpyb":@"Image_centerpyy"):UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centerpybno":@"Image_centerpyyno");
            //Image_drawintonoda_b
        }
        if (_noticeM.artwork_visibility.intValue != 3) {
            self.drawImageV.image = _hasDataModel.hasDraw?imageArr[7]:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_drawintonoda_b":@"Image_drawintonoda_y");
        }
    }else{//如果不是朋友，优先展示隐私设置
        if (_noticeM.strange_view.intValue != 0) {
            self.voiceImageV.image = _hasDataModel.hasVoice?imageArr[0]:noDataimageArr[0];
            self.photoImageV.image = _hasDataModel.hasPhoto?imageArr[1]:noDataimageArr[1];
            self.timeImageV.image = _hasDataModel.hasTime?imageArr[2]:noDataimageArr[2];
        }
        if (_noticeM.movie_voice_visibility.intValue != 2) {
            self.movieImageV.image = _hasDataModel.hasMovie?imageArr[3]:noDataimageArr[3];
        }
        if (_noticeM.book_voice_visibility.intValue != 2) {
            self.bookImageV.image = _hasDataModel.hasBook?imageArr[4]:noDataimageArr[4];
        }
        if (_noticeM.song_voice_visibility.intValue != 2) {
            self.songImageV.image = _hasDataModel.hasSong?imageArr[5]:noDataimageArr[5];
        }
        if (_noticeM.dubbing_visibility.intValue != 2 && _noticeM.dubbing_visibility.intValue != 3) {
            self.pyImageV.image = _hasDataModel.hasPy?UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centerpyb":@"Image_centerpyy"):UIImageNamed([NoticeTools isWhiteTheme]?@"Image_centerpybno":@"Image_centerpyyno");
        }
        if (_noticeM.artwork_visibility.intValue != 2 && _noticeM.artwork_visibility.intValue != 3) {
            self.drawImageV.image = _hasDataModel.hasDraw?imageArr[7]:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_drawintonoda_b":@"Image_drawintonoda_y");
        }
    }
}

- (void)gotoPeopleTap{
    if (!self.peopleUserId) {
        return;
    }
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.userId = self.peopleUserId;
    ctl.isOther = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

-(void)requestVisitors{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/visitors",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.haPeople = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                if (self.haPeople) {
                    return ;
                }
                NoticeUserInfoModel *userInfo = [NoticeUserInfoModel mj_objectWithKeyValues:dic];
                NSString *allStr = [NSString stringWithFormat:@"%@ 最近参观了你的心情簿",userInfo.nick_name];
                self.peopleUserId = userInfo.user_id;
                self.titleL.attributedText = [DDHAttributedMode setColorString:allStr setColor:GetColorWithName(VMainThumeColor) setLengthString:userInfo.nick_name beginSize:0];
                self.haPeople = YES;
            }
            
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}


- (void)setUserId:(NSString *)userId{
    _userId = userId;
    self.zjAll.userId = userId;
    self.zjText.userId = userId;
}

- (void)chocieTap:(UITapGestureRecognizer *)tap{
    UIView *tapView = (UIView *)tap.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushControllerWithType:)]) {
        [self.delegate pushControllerWithType:tapView.tag];
    }
}

@end
