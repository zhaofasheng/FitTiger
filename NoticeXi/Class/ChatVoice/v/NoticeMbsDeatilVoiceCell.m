//
//  NoticeMbsDeatilVoiceCell.m
//  NoticeXi
//
//  Created by li lei on 2022/2/22.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMbsDeatilVoiceCell.h"
#import "NoticeNewVoiceListCell.h"
#import "BaseNavigationController.h"
#import "NoticerTopicSearchResultNewController.h"
#import "NoticeTabbarController.h"
#import "NoticeBackVoiceViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMyMovieController.h"
#import "NoticeMyBookController.h"
#import "NoticeMySongController.h"
#import "NoticeMyMovieComController.h"
#import "NoticeBingGanListView.h"
//获取全局并发队列和主队列的宏定义
#define globalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define mainQueue dispatch_get_main_queue()
@implementation NoticeMbsDeatilVoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.contentView.userInteractionEnabled = YES;
        
        self.backImageView = [[NoticeCustumBackImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.noNeedPaopao = YES;
        self.backImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.backImageView];
        self.backImageView.userInteractionEnabled = YES;
        self.backImageView.image = UIImageNamed(@"voicedefault.jpg");
        
        self.mbsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [self.backImageView addSubview:self.mbsView];
        
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 148-5, DR_SCREEN_WIDTH, 114+22+27)];
        self.headerView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        [self.contentView addSubview:self.headerView];
        
        _mbView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-114)/2,0, 114, 114)];
        _mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self.headerView addSubview:_mbView];
        _mbView.layer.cornerRadius = 114/2;
        _mbView.layer.masksToBounds = YES;
        _mbView.userInteractionEnabled = YES;
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 114, 114)];
        [_mbView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
        self.iconMarkView.hidden = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,5, 104, 104)];
        _iconImageView.layer.cornerRadius = 104/2;
        _iconImageView.layer.masksToBounds = YES;
        [_mbView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        self.careButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-62)/2, CGRectGetMaxY(_mbView.frame)-16,62, 24)];
        self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
        self.careButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.careButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.careButton.layer.cornerRadius = 24/2;
        self.careButton.layer.masksToBounds = YES;
        [self.headerView addSubview:self.careButton];
        [self.careButton addTarget:self action:@selector(careClick) forControlEvents:UIControlEventTouchUpInside];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_mbView.frame)+27,DR_SCREEN_WIDTH, 22)];
        _nickNameL.font = XGEightBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.headerView addSubview:_nickNameL];
        _nickNameL.textAlignment = NSTextAlignmentCenter;
        

        //话题
        _topiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame)+3,DR_SCREEN_WIDTH, 28)];
        _topiceLabel.font = FOURTHTEENTEXTFONTSIZE;
        _topiceLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _topiceLabel.userInteractionEnabled = YES;
        _topiceLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *taptop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTextClick)];
        [_topiceLabel addGestureRecognizer:taptop];
        [self.contentView addSubview:_topiceLabel];
        
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-100, DR_SCREEN_WIDTH, 100)];
        self.buttonView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        [self.contentView addSubview:self.buttonView];
        
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-70)/2, 0, 70, 70)];
       
        [self.playButton setBackgroundImage:UIImageNamed(@"Image_detailPlay") forState:UIControlStateNormal];
        self.playButton.layer.cornerRadius = 35;
        self.playButton.layer.masksToBounds = YES;
        [self.buttonView addSubview:self.playButton];
        [self.playButton addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;

        
        self.hsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.playButton.frame.origin.x-48-36, self.playButton.frame.origin.y+18, 36, 36)];
        [self.hsButton setBackgroundImage:UIImageNamed(@"Image_gaolhs") forState:UIControlStateNormal];
        [self.buttonView addSubview:self.hsButton];
        [self.hsButton addTarget:self action:@selector(replayClick:) forControlEvents:UIControlEventTouchUpInside];
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(self.hsButton.frame.origin.x-10, CGRectGetMaxY(self.hsButton.frame), 56, 17)];
        self.numL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.numL.textAlignment = NSTextAlignmentCenter;
        self.numL.font = TWOTEXTFONTSIZE;
        [self.buttonView addSubview:self.numL];
        
        self.sendBGBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame)+48, self.playButton.frame.origin.y+18, 36, 36)];
        [self.sendBGBtn setBackgroundImage:UIImageNamed(@"Image_glbingg") forState:UIControlStateNormal];
        [self.buttonView addSubview:self.sendBGBtn];
        [self.sendBGBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.bgL = [[UILabel alloc] initWithFrame:CGRectMake(self.sendBGBtn.frame.origin.x-10, CGRectGetMaxY(self.sendBGBtn.frame), 56, 17)];
        self.bgL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.bgL.textAlignment = NSTextAlignmentCenter;
        self.bgL.font = TWOTEXTFONTSIZE;
        [self.buttonView addSubview:self.bgL];
        
        self.spectrumView = [[SpectrumView alloc] initWithFrame:CGRectMake(20,self.buttonView.frame.origin.y-200,DR_SCREEN_WIDTH-40, 100)];
        [self.contentView addSubview:self.spectrumView];
        self.spectrumView.color = [UIColor colorWithHexString:@"#F7F8FC"];
        self.spectrumView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        self.spectrumView1 = [[SpectrumView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(self.spectrumView.frame)+2,DR_SCREEN_WIDTH-40, 100)];
        [self.contentView addSubview:self.spectrumView1];
        self.spectrumView1.transform = CGAffineTransformMakeScale(1.0,-1.0);
        self.spectrumView1.color = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0.4];
        self.spectrumView1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        //电影
        _movieView = [[NoticeMoivceInCell alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_headerView.frame)+20, DR_SCREEN_WIDTH-40-65-6, 78)];
        [self.contentView addSubview:_movieView];
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
        [self.contentView addSubview:self.typeL];
        self.typeL.userInteractionEnabled = YES;
        UITapGestureRecognizer *syyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mbyTap)];
        [self.typeL addGestureRecognizer:syyTap];
        
        UITapGestureRecognizer *playT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause)];
        [self addGestureRecognizer:playT];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fun2)];
        tap2.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap2];
        [playT requireGestureRecognizerToFail:tap2];
        
        self.otherMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [self.contentView addSubview:self.otherMoreBtn];
        self.otherMoreBtn.hidden = YES;
        [self.otherMoreBtn setImage:UIImageNamed(@"Image_sangedian") forState:UIControlStateNormal];
        [self.otherMoreBtn addTarget:self action:@selector(otherClick) forControlEvents:UIControlEventTouchUpInside];
        self.otherMoreBtn.hidden = YES;
        
        //屏蔽别人心情
        self.pinbTools = [[NoticeVoicePinbi alloc] init];
        self.pinbTools.delegate = self;
        
        UISwipeGestureRecognizer  *downSwipeGestureRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureRecognizer:)];
        downSwipeGestureRecognizer.direction=UISwipeGestureRecognizerDirectionDown;
        [self.contentView addGestureRecognizer:downSwipeGestureRecognizer];
        
        UISwipeGestureRecognizer  *upSwipeGestureRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureRecognizer:)];
        upSwipeGestureRecognizer.direction=UISwipeGestureRecognizerDirectionUp;
        [self.contentView addGestureRecognizer:upSwipeGestureRecognizer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin) name:@"NOTICECHANGESKINNOTICIONHS" object:nil];

    }
    return self;
}

- (void)changeSkin{
    
    if (self.voiceM.resource) {
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.mbsView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"]colorWithAlphaComponent:appdel.alphaValue>0?(appdel.alphaValue >=0.8?0.8:appdel.alphaValue):0.3];
    if ([_voiceM.subUserModel.userId isEqualToString:[NoticeTools getuserId]]) {
        
        if (appdel.backImg) {
            self.backImageView.image = [UIImage boxblurImage:appdel.backImg withBlurNumber:appdel.effect];
            self.mbsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:appdel.alphaValue>0.8?0.8:appdel.alphaValue];
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
            
            dispatch_async(globalQueue,^{
              //子线程下载图片
                  NSURL *url=[NSURL URLWithString:_voiceM.subUserModel.spec_bg_default_photo];
                  NSData *data=[NSData dataWithContentsOfURL:url];
              //将网络数据初始化为UIImage对象
                  UIImage *images = [UIImage imageWithData:data];
                  if(images!=nil){
                  //回到主线程设置图片，更新UI界面s
                      dispatch_async(mainQueue,^{
                          UIImage *gqImage = images;
                          self.backImageView.image = [UIImage boxblurImage:gqImage withBlurNumber:appdel.effect];
                      });
                  }
              });
        }
        [self.backImageView.svagPlayer stopAnimation];
        self.backImageView.svagPlayer.hidden = YES;
    }else if(_voiceM.subUserModel.spec_bg_type.intValue == 2 || _voiceM.subUserModel.spec_bg_type.intValue == 4){//自定义背景

        dispatch_async(globalQueue,^{
          //子线程下载图片
              NSURL *url=[NSURL URLWithString:_voiceM.subUserModel.spec_bg_type.intValue == 2?_voiceM.subUserModel.spec_bg_photo_url:_voiceM.subUserModel.spec_bg_skin_url];
              NSData *data=[NSData dataWithContentsOfURL:url];
          //将网络数据初始化为UIImage对象
              UIImage *images = [UIImage imageWithData:data];
              if(images!=nil){
              //回到主线程设置图片，更新UI界面s
                  dispatch_async(mainQueue,^{
                      UIImage *gqImage = images;
                      self.backImageView.image = [UIImage boxblurImage:gqImage withBlurNumber:appdel.effect];
                  });
              }
          });
    }else{
        self.backImageView.image = UIImageNamed(@"voicedefault.jpg");
    }
}

-(void)swipeGestureRecognizer:(UISwipeGestureRecognizer *)recongnizer{
    if (recongnizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(begTapIsUp:)]) {
            [self.delegate begTapIsUp:YES];
        }
    }
    
    if (recongnizer.direction==UISwipeGestureRecognizerDirectionDown) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(begTapIsUp:)]) {
            [self.delegate begTapIsUp:NO];
        }
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

- (void)fun2{
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

- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
  
    //话题
    if (voiceM.topic_name && voiceM.topic_name.length) {
        self.topiceLabel.text = voiceM.topicName;
        self.topiceLabel.hidden = NO;
    }else{
        self.topiceLabel.hidden = YES;
    }
        
   // [self showName];
    
    self.nickNameL.text = voiceM.subUserModel.nick_name;
    [self.sendBGBtn setBackgroundImage:UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbg": @"Image_glbingg") forState:UIControlStateNormal];

    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.subUserModel.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    

    if (voiceM.resource) {
        self.movieView.hidden = NO;
        self.headerView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 114+22+27);
        self.movieView.frame = CGRectMake(20, CGRectGetMaxY(_headerView.frame)+20, DR_SCREEN_WIDTH-40-6-65, 78);
        self.typeL.frame = CGRectMake(CGRectGetMaxX(_movieView.frame)+6,_movieView.frame.origin.y, 65, 78);
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
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.bookM.book_cover]
                              placeholderImage:GETUIImageNamed(@"img_empty")
                                       options:SDWebImageRefreshCached];
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
    }else{
        //背景图
        [self changeSkin];
        self.movieView.hidden = YES;
        self.headerView.frame = CGRectMake(0, 148-5, DR_SCREEN_WIDTH, 114+22+27);
    }
    
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.chat_num.integerValue) {
            self.numL.text = _voiceM.chat_num;
        }else{
            self.numL.text = @"";
        }
    }else{
        if (_voiceM.dialog_num.integerValue) {
            self.numL.text = _voiceM.dialog_num;
        }else{
            self.numL.text = @"";
        }
    }
    
    self.spectrumView.hidden = !voiceM.isPlaying;
    self.spectrumView1.hidden = self.spectrumView.hidden;
    if (voiceM.isbeiy) {
        self.spectrumView.hidden = YES;
        self.spectrumView1.hidden = YES;
    }else{
        self.spectrumView.hidden = NO;
        self.spectrumView1.hidden = NO;
    }
    if (voiceM.isPlaying) {
        [self.playButton setBackgroundImage:UIImageNamed(voiceM.isPasue? @"Image_detailPlay":@"Image_detailStop") forState:UIControlStateNormal];
    
    }else{
        [self.playButton setBackgroundImage:UIImageNamed(voiceM.isPlaying? @"Image_detailStop":@"Image_detailPlay") forState:UIControlStateNormal];
     
    }
    
    //对话或者回声数量
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.chat_num.integerValue) {
            self.numL.text = _voiceM.chat_num;
        }else{
            self.numL.text = @"";
        }
        self.careButton.hidden = YES;
        if (_voiceM.zaned_num.intValue) {
            self.bgL.text = _voiceM.zaned_num;
        }else{
            self.bgL.text = @"";
        }
        self.otherMoreBtn.hidden = YES;
    }else{
        self.bgL.text = @"";
        if (!_voiceM.resource) {
            self.careButton.hidden = NO;
        }else{
            self.careButton.hidden = YES;
        }
        
        
        if (_voiceM.is_myadmire.intValue) {
            self.careButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
            [self.careButton setTitle:[NoticeTools getLocalStrWith:@"intro.yilike"] forState:UIControlStateNormal];
        }else{
            self.careButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.careButton setTitle:[NoticeTools getLocalStrWith:@"minee.xs"] forState:UIControlStateNormal];
        }
        if (self.needMoreBtn) {
            self.otherMoreBtn.hidden = NO;
        }
    }
    
    if (voiceM.is_private.boolValue) {
        self.numL.hidden = YES;
        self.hsButton.hidden = YES;
        self.sendBGBtn.hidden = YES;
        self.bgL.hidden = YES;
    }else{
        self.bgL.hidden = NO;
        self.numL.hidden = NO;
        self.hsButton.hidden = NO;
        self.sendBGBtn.hidden = NO;
    }
    
    //测试题相关
    if (_voiceM.subUserModel.hasTest) {

    }else{
        _noticeView.hidden = YES;
        [_noticeView.timer invalidate];
    }
    

    self.iconMarkView.image = UIImageNamed(_voiceM.subUserModel.levelImgIconName);
  
  
}

- (void)setIsDisappear:(BOOL)isDisappear{
    _isDisappear = isDisappear;
    if (isDisappear) {
        DRLog(@"关闭计时器");
        [_noticeView.timer invalidate];
    }
}

- (LXAdvertScrollview *)noticeView{
    if (!_noticeView) {
        _noticeView = [[LXAdvertScrollview alloc]initWithFrame:CGRectMake((DR_SCREEN_WIDTH-200)/2, CGRectGetMaxY(self.topiceLabel.frame)+30, 200, 30)];
    
        _noticeView.layer.cornerRadius = 15;
        _noticeView.isStr = YES;
        _noticeView.layer.masksToBounds = YES;
        _noticeView.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0.2];
        [self.backImageView addSubview:_noticeView];
        _noticeView.userInteractionEnabled = YES;
    }
    return _noticeView;
}


- (void)otherClick{
    [self.pinbTools pinbiWithModel:_voiceM];
}

//屏蔽成功回调
- (void)pinbiSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(otherPinbSuccess)]) {
        [self.delegate otherPinbSuccess];
    }
}

//点击回声
- (void)replayClick:(UIButton *)button{
//    if (self.voiceM.resource) {//如果是书音乐，则执行分享操作
//        NoticeShareGroupView *shareGroupView = [[NoticeShareGroupView alloc] initWithShareVoiceToGroup];
//        shareGroupView.voiceM = self.voiceM;
//        [shareGroupView showShareView];
//        return;
//    }
    if (self.noPush) {
        if (self.replyClickBlock) {
            self.replyClickBlock(YES);
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHS:)]) {
        [self.delegate clickHS:self.voiceM];
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

- (void)playOrPause{
    if (self.isMoving) {
        self.isMoving = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(endTouchPointY:)]) {
            [self.delegate endTouchPointY:self.movIngPointY];
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPlayeButton:)]) {
        [self.delegate clickPlayeButton:self.index];
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

- (void)topicTextClick{
    if (_voiceM.topic_name && _voiceM.topic_name.length) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(stopPlay)]) {
            [self.delegate stopPlay];
        }
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
