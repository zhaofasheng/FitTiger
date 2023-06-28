//
//  NoticeWhiteNewListCell.m
//  NoticeXi
//
//  Created by li lei on 2022/11/10.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeWhiteNewListCell.h"

#import "NoticeMineViewController.h"
#import "NoticeShareTostView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticerTopicSearchResultNewController.h"
#import "NoticeBackVoiceViewController.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeBingGanListView.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMyMovieController.h"
#import "NoticeMyMovieComController.h"
#import "NoticeMyBookController.h"
#import "NoticeMySongController.h"
#import "NoticePlayerVideoController.h"
#import "NoticeVoiceCommentView.h"

@implementation NoticeWhiteNewListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
  
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 124)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backView];
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 44, 44)];
        [self.backView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
      
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
        [self.backView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-9, CGRectGetMaxY(_iconImageView.frame)-14,14, 14)];
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
        [self.backView addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 15,self.backView.frame.size.width-40-15-10-40, 22)];
        _nickNameL.font = XGSIXBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:_nickNameL];
        
        self.lelveImageView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nickNameL.frame)+2, 15, 46, 21)];
        [self.backView addSubview:self.lelveImageView];
   
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, CGRectGetMaxY(_nickNameL.frame), 200, 18)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [self.backView addSubview:_timeL];
                
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(15,70, 150, 40)];
        self.playerView.delegate = self;
        self.playerView.isThird = YES;
        [self.playerView.playButton setImage:UIImageNamed(@"Image_newplay") forState:UIControlStateNormal];
        [self.backView addSubview:_playerView];

        _playView = [[UIView alloc] initWithFrame:CGRectMake(-15, -3,_playerView.frame.size.height+15+5, _playerView.frame.size.height+6)];
        _playView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [_playView addGestureRecognizer:tap];
        [self.playerView addSubview:_playView];
        
        _rePlayView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), _playerView.frame.origin.y,_playerView.frame.size.height, _playerView.frame.size.height)];
        [_rePlayView addTarget:self action:@selector(playReplay) forControlEvents:UIControlEventTouchUpInside];
        [_rePlayView setImage:UIImageNamed(@"Imag_reply_img") forState:UIControlStateNormal];
        _rePlayView.hidden = YES;
        [self.backView addSubview:_rePlayView];
        
        self.dragView = [[UIView alloc] initWithFrame:CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height)];
        self.dragView.userInteractionEnabled = YES;
        self.dragView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
        [self.playerView addSubview:self.dragView];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.17;
        [self.dragView addGestureRecognizer:longPress];
        
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView.frame.size.height-54, self.backView.frame.size.width, 54)];
        [self.backView addSubview:self.buttonView];
        
        //话题
        
        _topicView = [[UIView alloc] initWithFrame:CGRectMake(15, self.buttonView.frame.origin.y-40, 0, 20)];
        _topicView.backgroundColor = [[UIColor colorWithHexString:@"#456DA0"] colorWithAlphaComponent:0.1];
        _topicView.layer.cornerRadius = 10;
        _topicView.layer.masksToBounds = YES;
        _topicView.userInteractionEnabled = YES;
        [self.backView addSubview:_topicView];
        
        UILabel *yuanL = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 12, 12)];
        yuanL.layer.cornerRadius = 6;
        yuanL.layer.masksToBounds = YES;
        yuanL.backgroundColor = [UIColor colorWithHexString:@"#456DA0"];
        yuanL.text = @"#";
        yuanL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        yuanL.textAlignment = NSTextAlignmentCenter;
        yuanL.font = [UIFont systemFontOfSize:7];
        [_topicView addSubview:yuanL];
        
        _topiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0, GET_STRWIDTH(@"#神奇难受和快乐的的的的的#", 12, 50), 50)];
        _topiceLabel.font = [UIFont systemFontOfSize:11];
        _topiceLabel.textColor = [UIColor colorWithHexString:@"#456DA0"];
        _topiceLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *taptop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTextClick)];
        [_topicView addGestureRecognizer:taptop];
        [self.topicView addSubview:_topiceLabel];
        
        CGFloat btnWidth = GET_STRWIDTH(@"悄悄话", 12, 54) + 24 +5;
        self.btnWdth = btnWidth;
        self.hsBackView = [[UIView alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width-15-10-btnWidth*2,0,btnWidth,54)];
        self.hsBackView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        [self.buttonView addSubview:self.hsBackView];
        self.hsBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *hsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replayClick)];
        [self.hsBackView addGestureRecognizer:hsTap];
        
        self.hsButton = [[UIImageView alloc] initWithFrame:CGRectMake(0,15,24,24)];
        self.hsButton.image = UIImageNamed(@"Image_newclickhsw");
        [self.hsBackView addSubview:self.hsButton];
        
        self.hsL = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, btnWidth-24-3, 54)];
        self.hsL.font = TWOTEXTFONTSIZE;
        self.hsL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.hsL.text = [NoticeTools getLocalStrWith:@"em.hs"];
        [self.hsBackView addSubview:self.hsL];
    
        self.statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 34/2, 20, 20)];
        [self.backView addSubview:self.statusImageView];
        self.statusImageView.hidden = YES;
        
        self.bgBackView = [[UIView alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width-10-btnWidth,0,btnWidth,54)];
        self.bgBackView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        [self.buttonView addSubview:self.bgBackView];
        self.hsBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [self.bgBackView addGestureRecognizer:bgTap];
        
        self.sendBGBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0,15,24,24)];
        self.sendBGBtn.image = UIImageNamed(@"Ima_sendbgnw");
        [self.bgBackView addSubview:self.sendBGBtn];
        
        self.bingGL = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, btnWidth-24-3, 54)];
        self.bingGL.font = TWOTEXTFONTSIZE;
        self.bingGL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.bingGL.text = [NoticeTools getLocalStrWith:@"py.bg"];
        [self.bgBackView addSubview:self.bingGL];
              
        self.comBackView = [[UIView alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width-15-10-btnWidth*3,0,btnWidth,54)];
        self.comBackView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        [self.buttonView addSubview:self.comBackView];
        self.comBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *comsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comTapList)];
        [self.comBackView addGestureRecognizer:comsTap];
        
        self.comImagV = [[UIImageView alloc] initWithFrame:CGRectMake(0,15,24,24)];
        self.comImagV.image = UIImageNamed(@"Image_pinglunvw");
        [self.comBackView addSubview:self.comImagV];
        
        self.comNumL = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, btnWidth-24-3, 54)];
        self.comNumL.font = TWOTEXTFONTSIZE;
        self.comNumL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.comBackView addSubview:self.comNumL];
        
        self.commentView = [[UIView alloc] initWithFrame:CGRectMake(15, 11, self.buttonView.frame.size.width-15-self.hsBackView.frame.origin.x, 32)];
        self.commentView.layer.cornerRadius = 16;
        self.commentView.layer.masksToBounds = YES;
        self.commentView.userInteractionEnabled = YES;
        self.commentView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        
        UIImageView *editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 6, 20, 20)];
        editImageView.image = UIImageNamed(@"Image_huieditimgw");
        [self.commentView addSubview:editImageView];
        
        UILabel *comL = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, self.commentView.frame.size.width-32, 32)];
        comL.font = TWOTEXTFONTSIZE;
        comL.text = [NoticeTools getLocalStrWith:@"ly.openis"];
        comL.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        [self.commentView addSubview:comL];
        
        UITapGestureRecognizer *comTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCom)];
        [self.commentView addGestureRecognizer:comTap];
        
        [self.buttonView addSubview:self.commentView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-22, 15, 24, 24)];
        [btn setBackgroundImage:UIImageNamed(@"Image_moreNeww") forState:UIControlStateNormal];
        [self.backView addSubview:btn];
        [btn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        self.moreBtn = btn;
        
        //屏蔽别人心情
        self.pinbTools = [[NoticeVoicePinbi alloc] init];
        self.pinbTools.delegate = self;
        
        //电影
        _movieView = [[NoticeMoivceInCell alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_playerView.frame)+15, self.backView.frame.size.width-30, 78)];
        [self.backView addSubview:_movieView];
        
        self.contentTextL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_movieView.frame)+15, DR_SCREEN_WIDTH-70, 13)];
        self.contentTextL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentTextL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentTextL.numberOfLines = 0;
        [self.backView addSubview:self.contentTextL];
        self.contentTextL.hidden = YES;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentNotice:) name:@"NOTICEREEDITVOICECOMMENT" object:nil];
    }
    return self;
}

- (void)commentNotice:(NSNotification*)notification{
    NSDictionary *Dictionary = [notification userInfo];
    NSDictionary *voiceDic = Dictionary[@"data"];
    NoticeVoiceListModel *voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:voiceDic];
    if ([voiceM.voice_id isEqualToString:self.voiceM.voice_id]) {
        self.voiceM.comment_count = voiceM.comment_count;
        self.voiceM.first_comment = voiceM.first_comment;
        if (self.voiceM.first_comment.count) {
            self.commentView.hidden = YES;
        }else{
            self.commentView.hidden = NO;
        }
        
        self.comBackView.hidden = self.voiceM.first_comment.count?NO:YES;
        self.comNumL.text = self.voiceM.comment_count;
    }
}

- (NoticeBBSComentInputView *)inputView{
    if (!_inputView) {
        _inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        _inputView.delegate = self;
        _inputView.isRead = YES;
        _inputView.isVoiceComment = YES;
        _inputView.limitNum = 100;
        _inputView.plaStr = [NoticeTools getLocalStrWith:@"ly.openis"];
        _inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        _inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
    return _inputView;
}

- (UILabel *)topL{
    if (!_topL) {
        _topL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y-6, 23, 14)];
        _topL.layer.cornerRadius = 3;
        _topL.layer.masksToBounds = YES;
        _topL.backgroundColor = [UIColor colorWithHexString:@"#A361F2"];
        _topL.font = [UIFont systemFontOfSize:9];
        _topL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _topL.textAlignment = NSTextAlignmentCenter;
        _topL.text = @"Pick";
        [self.contentView addSubview:_topL];
        _topL.hidden = YES;
    }
    return _topL;
}

- (SelVideoPlayer *)player{
    if (!_player) {

        _player = [[SelVideoPlayer alloc] initWithFrame:CGRectMake(0, _voiceM.content_type.intValue!=2? (CGRectGetMaxY(_playerView.frame)+15):50, 200,200)];
        _player.playbackControls.hidden = YES;
        [self.backView addSubview:_player];
        _player.layer.cornerRadius = 10;
        _player.layer.masksToBounds = YES;
        _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _videoImageView.image = UIImageNamed(@"Image_videoimg");
        [self.backView addSubview:_videoImageView];
        _videoImageView.center = _player.center;
        _player.playerLayer.videoGravity = AVLayerVideoGravityResize;
        _player.userInteractionEnabled = YES;
        _player.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoTap)];
        [_player addGestureRecognizer:tap];
    }
    return _player;
}

- (void)videoTap{
    if (!_voiceM.video_url.count) {
        return;
    }
    NoticePlayerVideoController *ctl = [[NoticePlayerVideoController alloc] init];
    ctl.videoUrl = _voiceM.video_url[0];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

- (NoticeVoiceImgList *)imageViewS{
    if (!_imageViewS) {
        self.imageViewS = [[NoticeVoiceImgList alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_playerView.frame)+15, 0, 0)];
        [self.backView addSubview:self.imageViewS];
    }
    return _imageViewS;
}


- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    self.videoImageView.hidden = YES;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.subUserModel.avatar_url]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageRefreshCached];
    self.markImage.hidden = voiceM.subUserModel.userId.intValue == 1?NO:YES;
    
    self.timeL.text = voiceM.creatTime;
    if (self.isHotLove && voiceM.is_mark.boolValue && [NoticeTools isManager]) {
        self.nickNameL.text = [NSString stringWithFormat:@"%@(已标记)",voiceM.subUserModel.nick_name];
    }else{
        self.nickNameL.text = voiceM.subUserModel.nick_name;
    }

    if (!voiceM.resource && voiceM.isSelf){
        self.iconMarkView.frame = CGRectMake(13, 13+32, 44, 44);
        self.iconImageView.frame = CGRectMake(15, 15+32, 40, 40);
        self.moreBtn.frame = CGRectMake(self.backView.frame.size.width-15-22, 6, 24, 24);
    }else{
        self.iconMarkView.frame = CGRectMake(13, 13, 44, 44);
        self.iconImageView.frame = CGRectMake(15, 15, 40, 40);
        self.moreBtn.frame = CGRectMake(self.backView.frame.size.width-15-22, 15, 24, 24);
    }
    
    
    self.markImage.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)-9, CGRectGetMaxY(_iconImageView.frame)-14,14, 14);
    
    if (voiceM.topAt.intValue) {
        self.topL.hidden = NO;
    }else{
        _topL.hidden = YES;
    }
    
    //对话或者悄悄话数量
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.chat_num.integerValue) {
            self.hsL.text = _voiceM.chat_num;
        }else{
            self.hsL.text = [NoticeTools getLocalStrWith:@"em.hs"];
        }
        if (_voiceM.zaned_num.intValue) {
            self.bingGL.text = _voiceM.zaned_num;
        }else{
            self.bingGL.text = [NoticeTools getLocalStrWith:@"py.bg"];
        }
    }else{
        if (_voiceM.dialog_num.integerValue) {
            self.hsL.text = _voiceM.dialog_num;
        }else{
            self.hsL.text = [NoticeTools getLocalStrWith:@"em.hs"];
        }
        self.bingGL.text = [NoticeTools getLocalStrWith:@"py.bg"];
    }
    
    if (voiceM.content_type.integerValue == 1) {
        self.playerView.hidden = NO;
        self.playerView.timeLen = voiceM.nowTime.integerValue?voiceM.nowTime: voiceM.voice_len;
        self.playerView.voiceUrl = voiceM.voice_url;
        self.playerView.slieView.progress = voiceM.nowPro >0 ?voiceM.nowPro:0;
        if (!voiceM.resource && voiceM.isSelf){
            //位置
            if (voiceM.voice_len.integerValue < 5) {
                self.playerView.frame = CGRectMake(15,102, 130, 40);
            }else if (voiceM.voice_len.integerValue >= 5 && voiceM.voice_len.integerValue <= 105){
                self.playerView.frame = CGRectMake(15, 102, 130+voiceM.voice_len.integerValue, 40);
            }else if (voiceM.voice_len.integerValue >= 120){
                self.playerView.frame = CGRectMake(15,102, 130+120, 40);
            }
            else{
                self.playerView.frame = CGRectMake(15,102, 130+voiceM.voice_len.integerValue, 40);
            }
        }else{
            //位置
            if (voiceM.voice_len.integerValue < 5) {
                self.playerView.frame = CGRectMake(15,70, 130, 40);
            }else if (voiceM.voice_len.integerValue >= 5 && voiceM.voice_len.integerValue <= 105){
                self.playerView.frame = CGRectMake(15, 70, 130+voiceM.voice_len.integerValue, 40);
            }else if (voiceM.voice_len.integerValue >= 120){
                self.playerView.frame = CGRectMake(15,70, 130+120, 40);
            }
            else{
                self.playerView.frame = CGRectMake(15,70, 130+voiceM.voice_len.integerValue, 40);
            }
        }
 
   
        self.dragView.frame =  CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height);
        [self.playerView refreWithFrame];
        
        _rePlayView.hidden = voiceM.isPlaying? NO:YES;
        _rePlayView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame),self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
    }else{
        self.playerView.hidden = YES;
        _rePlayView.hidden = self.playerView.hidden;
    }
        
    if (voiceM.content_type.intValue == 2) {
        self.contentTextL.hidden = NO;
        self.contentTextL.attributedText = voiceM.isMoreFiveLines?voiceM.fiveAttTextStr:voiceM.allTextAttStr;
        if (!voiceM.resource && voiceM.isSelf) {//自己的心情
            self.contentTextL.frame = CGRectMake(15,(65+32), DR_SCREEN_WIDTH-70, voiceM.isMoreFiveLines?voiceM.fiveTextHeight:voiceM.textHeight);
           
        }else{
            self.contentTextL.frame = CGRectMake(15,65, DR_SCREEN_WIDTH-70, voiceM.isMoreFiveLines?voiceM.fiveTextHeight:voiceM.textHeight);
        }
    }else{
        self.contentTextL.hidden = YES;
    }
    
    if (_voiceM.img_list.count) {//有图片
        if (!voiceM.resource && voiceM.isSelf){
            if (_voiceM.img_list.count == 1) {
                self.imageViewS.frame = CGRectMake(0,_voiceM.content_type.intValue==2?(CGRectGetMaxY(_contentTextL.frame)+10): (CGRectGetMaxY(_playerView.frame)+15), DR_SCREEN_WIDTH-60,200);
            }else if (_voiceM.img_list.count == 2){
                self.imageViewS.frame = CGRectMake(0, _voiceM.content_type.intValue==2?(CGRectGetMaxY(_contentTextL.frame)+10): (CGRectGetMaxY(_playerView.frame)+15), DR_SCREEN_WIDTH-60,(DR_SCREEN_WIDTH-68)/2);
            }else if (_voiceM.img_list.count == 3){
                self.imageViewS.frame = CGRectMake(0, _voiceM.content_type.intValue==2?(CGRectGetMaxY(_contentTextL.frame)+10): (CGRectGetMaxY(_playerView.frame)+15), DR_SCREEN_WIDTH-60, (DR_SCREEN_WIDTH-60-18)/3);
            }
            //纯音频心情
            self.backView.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 164 + self.imageViewS.frame.size.height+15+32+voiceM.topicHeight+voiceM.bgmHeight);
            
        }else{
            if (_voiceM.img_list.count == 1) {
                self.imageViewS.frame = CGRectMake(0,_voiceM.content_type.intValue==2?(CGRectGetMaxY(_contentTextL.frame)+10): (CGRectGetMaxY(_playerView.frame)+15), DR_SCREEN_WIDTH-60,200);
            }else if (_voiceM.img_list.count == 2){
                self.imageViewS.frame = CGRectMake(0, _voiceM.content_type.intValue==2?(CGRectGetMaxY(_contentTextL.frame)+10): (CGRectGetMaxY(_playerView.frame)+15), DR_SCREEN_WIDTH-60,(DR_SCREEN_WIDTH-68)/2);
            }else if (_voiceM.img_list.count == 3){
                self.imageViewS.frame = CGRectMake(0, _voiceM.content_type.intValue==2?(CGRectGetMaxY(_contentTextL.frame)+10): (CGRectGetMaxY(_playerView.frame)+15), DR_SCREEN_WIDTH-60, (DR_SCREEN_WIDTH-60-18)/3);
            }
            self.backView.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 164 + self.imageViewS.frame.size.height+15+voiceM.topicHeight+voiceM.bgmHeight);
        }
    }else{

        if (!voiceM.resource && voiceM.isSelf){
            //纯音频心情
            self.backView.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 164+32+voiceM.topicHeight+voiceM.bgmHeight);
        }else{
            //纯音频心情
            self.backView.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 164+voiceM.topicHeight+voiceM.bgmHeight);
        }
    }
    
    if (voiceM.content_type.intValue == 2) {
        if (!voiceM.resource && voiceM.isSelf) {//自己的心情
            self.backView.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 55+54+10+self.contentTextL.frame.size.height +(_voiceM.img_list.count?(self.imageViewS.frame.size.height+10):0)+32+voiceM.topicHeight+voiceM.bgmHeight);
        }else{
            self.backView.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 55+54+10+self.contentTextL.frame.size.height +(_voiceM.img_list.count?(self.imageViewS.frame.size.height+10):0)+voiceM.topicHeight+voiceM.bgmHeight);
        }
    }
    
    self.imageViewS.hidden = (voiceM.img_list.count && voiceM.attr_type.intValue != 2) ? NO  : YES;
    if (!self.imageViewS.hidden) {
        self.imageViewS.imgArr = voiceM.img_list;
    }
    
    if (_voiceM.img_list.count && _voiceM.attr_type.intValue == 2) {
        self.player.hidden = NO;
        self.videoImageView.hidden = NO;
        self.player.frame = CGRectMake(0,_voiceM.content_type.intValue==2? (CGRectGetMaxY(_contentTextL.frame)+10): (CGRectGetMaxY(_playerView.frame)+15), 200,200);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            self.player.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_voiceM.video_url[0]]];
            self.player.player = [AVPlayer playerWithPlayerItem:self.player.playerItem];
            self.player.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player.player];
        });
        self.videoImageView.center = _player.center;
    }else{
        self.videoImageView.hidden = YES;
        _player.hidden = YES;
    }
    
    //电影
    self.movieView.hidden = (voiceM.resource)? NO:YES;
    self.movieView.type = voiceM.resource_type;
    if ([voiceM.resource_type isEqualToString:@"1"]) {
        self.movieView.movie = voiceM.movieM;
        self.movieView.userScro = voiceM.user_score;
    }else if ([voiceM.resource_type isEqualToString:@"2"]){//书籍
        self.movieView.userScro = voiceM.user_score;
        self.movieView.book = voiceM.bookM;
    }else if ([voiceM.resource_type isEqualToString:@"3"]){//歌曲
        self.movieView.songScro = voiceM.user_score;
        self.movieView.song = voiceM.songM;
    }
    
    //书影音
    if (voiceM.resource) {
        if (self.isNoShowResouce) {//电影词条不现实书影音数据
            self.movieView.hidden = YES;
        }else{
            self.movieView.hidden = NO;
        }
        if (voiceM.content_type.intValue !=2) {
            self.playerView.hidden = NO;
            self.contentTextL.hidden = YES;
            self.backView.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 164+(self.isNoShowResouce?(-0): 78)+15);
            self.buttonView.frame = CGRectMake(0, self.backView.frame.size.height-54, self.backView.frame.size.width, 54);
            self.buttonView.hidden = NO;
            self.movieView.frame = CGRectMake(15, CGRectGetMaxY(self.playerView.frame)+15, self.backView.frame.size.width-30, (self.isNoShowResouce?0: 78));
        }else{
            self.buttonView.hidden = YES;
            self.playerView.hidden = YES;
            self.contentTextL.hidden = NO;
            self.contentTextL.attributedText = voiceM.isMoreFiveLines?voiceM.fiveAttTextStr:voiceM.allTextAttStr;
            self.movieView.frame = CGRectMake(15, self.playerView.frame.origin.y, self.backView.frame.size.width-30,(self.isNoShowResouce?0: 78));
            self.contentTextL.frame = CGRectMake(15,CGRectGetMaxY(self.movieView.frame)+15, DR_SCREEN_WIDTH-70, voiceM.isMoreFiveLines?voiceM.fiveTextHeight:voiceM.textHeight);
            self.backView.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 164+(self.isNoShowResouce?0: 78)+15+self.contentTextL.frame.size.height-54-40+15);
        }
        self.bgBackView.frame = CGRectMake(15,0,self.btnWdth,54);
        self.hsBackView.frame = CGRectMake(self.buttonView.frame.size.width-10-self.btnWdth,0,self.btnWdth,54);
        self.hsButton.image = UIImageNamed( @"Image_newclickhsw");
        
        if (_voiceM.zaned_num.intValue) {
            self.bingGL.text = _voiceM.zaned_num;
        }else{
            self.bingGL.text = [NoticeTools getLocalStrWith:@"py.bg"];
        }
        self.comBackView.hidden = YES;
        self.commentView.hidden = YES;
    }else{
        
        if (voiceM.first_comment.count) {
            self.commentView.hidden = YES;
        }else{
            self.commentView.hidden = NO;
        }
        
        self.comBackView.hidden = voiceM.first_comment.count?NO:YES;
        self.comNumL.text = voiceM.comment_count;
        
        self.hsButton.image = UIImageNamed(@"Image_newclickhsw");
        self.bgBackView.frame = CGRectMake(self.buttonView.frame.size.width-10-self.btnWdth,0,self.btnWdth,54);
    }
    

    self.sendBGBtn.image = UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbg": @"Ima_sendbgnw");
    self.buttonView.frame = CGRectMake(0, self.backView.frame.size.height-54, self.backView.frame.size.width, 54);

    _statusView.hidden = YES;
    if (!voiceM.resource && voiceM.isSelf) {
        self.statusView.hidden = NO;
        self.nickNameL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 15+32, GET_STRWIDTH(self.nickNameL.text, 17, 22)+10, 22);
        self.lelveImageView.frame = CGRectMake(CGRectGetMaxX(_nickNameL.frame), 15+32+2.5, 52, 15);
        if (voiceM.voiceIdentity.intValue == 1) {
            self.statusL.text = [NoticeTools getLocalStrWith:@"n.open"];
            self.statsImgV.image = UIImageNamed(@"Image_vost1w");
        }else if (voiceM.voiceIdentity.intValue == 2){
            self.statusL.text = [NoticeTools getLocalStrWith:@"n.tpkjian"];
            self.statsImgV.image = UIImageNamed(@"Image_vost2w");
        }else{
            self.statusL.text = [NoticeTools getLocalStrWith:@"n.onlyself"];
            self.statsImgV.image = UIImageNamed(@"Image_vost3w");
        }

        
    }else{
        self.nickNameL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 15, GET_STRWIDTH(self.nickNameL.text, 17, 22)+10, 22);
        self.lelveImageView.frame = CGRectMake(CGRectGetMaxX(_nickNameL.frame), 15+2.5, 52, 16);
        self.redNumL.hidden = YES;

    }
    self.lineView.hidden = _statusView.hidden;
    _timeL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, CGRectGetMaxY(_nickNameL.frame), 200, 18);
    
    self.lelveImageView.image = UIImageNamed(_voiceM.subUserModel.levelImgName);
    self.iconMarkView.image = UIImageNamed(_voiceM.subUserModel.levelImgIconName);
    
    if (voiceM.statusM) {
        self.statusImageView.hidden = NO;
        self.statusImageView.frame = CGRectMake(15, self.buttonView.frame.origin.y-25, 20, 20);
        [self.statusImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.statusM.picture_url]];
    }else{
        self.statusImageView.hidden = YES;
    }
    
    //话题
    if (voiceM.topic_name && voiceM.topic_name.length) {
        self.topiceLabel.text = [voiceM.topicName stringByReplacingOccurrencesOfString:@"#" withString:@""];
        self.topicView.hidden = NO;
        if (self.statusImageView.hidden) {
            if (voiceM.bgm_name) {
                self.topicView.frame = CGRectMake(15, self.buttonView.frame.origin.y-25-35, GET_STRWIDTH(self.topiceLabel.text, 12, 20)+30, 20);
            }else{
                self.topicView.frame = CGRectMake(15, self.buttonView.frame.origin.y-25, GET_STRWIDTH(self.topiceLabel.text, 12, 20)+30, 20);
            }
        }else{
            if (voiceM.bgm_name) {
                self.topicView.frame = CGRectMake(15+20+5, self.buttonView.frame.origin.y-25-35, GET_STRWIDTH(self.topiceLabel.text, 12, 20)+30, 20);
            }else{
                self.topicView.frame = CGRectMake(15+20+5, self.buttonView.frame.origin.y-25, GET_STRWIDTH(self.topiceLabel.text, 12, 20)+30, 20);
            }
        }
        self.topiceLabel.frame = CGRectMake(20,0, GET_STRWIDTH(voiceM.topicName, 12, 20), 20);
    }else{
        self.topicView.hidden = YES;
    }
    
    if (voiceM.bgm_name) {
        self.bgmChoiceView.hidden = NO;
        self.bgmChoiceView.title = voiceM.bgm_name;
        self.bgmChoiceView.frame = CGRectMake(15, (!self.topicView.hidden?(CGRectGetMaxY(self.topicView.frame)+5):(self.buttonView.frame.origin.y-25)), DR_SCREEN_WIDTH-30-40, 20);
    }else{
        _bgmChoiceView.hidden = YES;
    }
}

- (NoticeBgmHasChoiceShowView *)bgmChoiceView{
    if (!_bgmChoiceView) {
        _bgmChoiceView = [[NoticeBgmHasChoiceShowView alloc] initWithFrame:CGRectMake(15, (self.topicView.hidden?CGRectGetMaxY(self.topicView.frame):(self.buttonView.frame.origin.y-25)), DR_SCREEN_WIDTH-30-40, 20)];
        [self.backView addSubview:_bgmChoiceView];
        _bgmChoiceView.isShow = YES;
        _bgmChoiceView.closeBtn.hidden = YES;
        _bgmChoiceView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        _bgmChoiceView.hidden = YES;
    }
    return _bgmChoiceView;
}


- (UIView *)statusView{
    if (!_statusView) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 150, 32)];
        _statusView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        _statsImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 16, 16)];
        [_statusView addSubview:_statsImgV];
        _statusL = [[UILabel alloc] initWithFrame:CGRectMake(17, 2, 130, 32)];
        _statusL.font = ELEVENTEXTFONTSIZE;
        _statusL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:0.6];
        _statusView.hidden = YES;
        [_statusView addSubview:_statusL];
        [self.backView addSubview:_statusView];
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, self.backView.frame.size.width, 1)];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.backView addSubview:self.lineView];
    }
    return _statusView;
}
- (void)comTapList{

    NoticeVoiceCommentView *comView = [[NoticeVoiceCommentView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    comView.voiceM = self.voiceM;
    [comView show];
}
//点击留言
- (void)tapCom{
    [self.inputView.contentView becomeFirstResponder];
    [self.inputView showJustComment:nil];
}

//点击发送
- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    NoticeVoiceCommentView *comView = [[NoticeVoiceCommentView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    comView.noRequest = YES;
    comView.voiceM = self.voiceM;
    [comView sendCommentWithText:comment voiceId:self.voiceM.voice_id subId:@""];
    [comView show];
    [self.inputView.contentView resignFirstResponder];

}

//点击播放
- (void)playNoReplay{
    DRLog(@"点击播放区域");
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop:)]) {
        [self.delegate startPlayAndStop:self.index];
    }
}

//点击重新播放
- (void)playReplay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRePlayer:)]) {
        [self.delegate startRePlayer:self.index];
    }
}

- (void)longPressGestureRecognized:(id)sender{

    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    if (!_voiceM.isPlaying) {
        if (longPressState == UIGestureRecognizerStateEnded) {
            [self playNoReplay];
        }
        return;
    }
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            DRLog(@"开始%.f",p.x);
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginDrag:)]) {
                [self.delegate beginDrag:self.tag];
            }
            [self dragWithPoint:p];
            break;
        }
        case UIGestureRecognizerStateChanged:{
     
            [self dragWithPoint:p];
            break;
        }
        default: {
     
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag: progross:)]) {
                [self.delegate endDrag:self.tag progross:p.x/self.playerView.frame.size.width];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag:)]) {
                [self.delegate endDrag:self.tag];
            }
            break;
        }
    }
}

- (void)dragWithPoint:(CGPoint)p{
    self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;
    if (_voiceM.moveSpeed > 0) {
        //每像素代表多少秒，等同于时间
        CGFloat beishuNum = _voiceM.voice_len.intValue/self.playerView.frame.size.width;
        [self.playerView refreshMoveFrame:beishuNum*_voiceM.moveSpeed*p.x];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragingFloat: index:)]) {
        if ((_voiceM.voice_len.floatValue/self.playerView.frame.size.width)*p.x < _voiceM.voice_len.length/5) {
            return;
        }
        [self.delegate dragingFloat:(_voiceM.voice_len.floatValue/self.playerView.frame.size.width)*p.x index:self.tag];
    }
}

- (void)likeClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    //判断是否是自己,不是自己则为点击「有启发」
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){

        if (_voiceM.is_collected.boolValue) {//取消「有启发」
  
            _voiceM.likeNoMove = YES;
        
            _voiceM.canTapLike = YES;
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    self->_voiceM.is_collected = @"0";

                    self.voiceM.zaned_num = [NSString stringWithFormat:@"%d",self.voiceM.zaned_num.intValue-1];
                    if (self.voiceM.zaned_num.intValue < 0) {
                        self.voiceM.zaned_num = @"0";
                    }
                    if (self.voiceM.resource) {
                        if (self->_voiceM.zaned_num.intValue) {
                            self.bingGL.text = self->_voiceM.zaned_num;
                        }else{
                            self.bingGL.text = [NoticeTools getLocalStrWith:@"py.bg"];
                        }
                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelCollectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
                }
                self->_voiceM.canTapLike = NO;
            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
            }];
        }else{//「有启发」
   
            _voiceM.canTapLike = YES;
           
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:@"5" forKey:@"needDelay"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    self->_voiceM.canTapLike = NO;
                    self->_voiceM.is_collected = @"1";
                    self.voiceM.zaned_num = [NSString stringWithFormat:@"%d",self.voiceM.zaned_num.intValue+1];
                    [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"em.senbgt"]];
                    
                    if (self.voiceM.resource) {
                        if (self->_voiceM.zaned_num.intValue) {
                            self.bingGL.text = self->_voiceM.zaned_num;
                        }else{
                            self.bingGL.text = [NoticeTools getLocalStrWith:@"py.bg"];
                        }
                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
                }
            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
                [nav.topViewController hideHUD];
            }];
        }
        return;
    }
    if (!self.voiceM.zaned_num.intValue) {
        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"py.noBg"]];
        return;
    }
    NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    listView.voiceM = self.voiceM;
    [listView showTost];
}

//点击更多
- (void)moreClick{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasClickMoreWith:)]) {//更多点击
        [self.delegate hasClickMoreWith:self.index];
    }
    
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        [self.pinbTools pinbiWithModel:_voiceM];
    }
}

//屏蔽成功回调
- (void)pinbiSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(otherPinbSuccess)]) {
        [self.delegate otherPinbSuccess];
    }
}

- (void)markSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreMarkSuccess)]) {
        [self.delegate moreMarkSuccess];
    }
}

- (void)userInfoTap{
    if (self.voiceM.resource && self.isGoToMovie) {
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
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
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

//点击话题
- (void)topicTextClick{
    if (self.noPushTopic) {
        return;
    }
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

//点击悄悄话
- (void)replayClick{

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHS:)]) {
        [self.delegate clickHS:self.voiceM];
    }
}

- (void)longTapToSendText{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 3000;
    inputView.delegate = self;
    inputView.isReply = YES;
    inputView.titleL.text = [NSString stringWithFormat:@"致 %@",self.voiceM.subUserModel.nick_name];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

- (void)sendTextDelegate:(NSString *)str{
    if ([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.voiceM.subUserModel.nick_name]) {
        NSString *pathMd5 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
        [self upLoadHeader:UIImageJPEGRepresentation([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.voiceM.subUserModel.nick_name], 0.9) path:pathMd5 text:str];
    }
}
- (void)upLoadHeader:(NSData *)image path:(NSString *)path text:(NSString *)text{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    //__weak typeof(self) weakSelf = self;
   // [_topController showHUD];
    [[XGUploadDateManager sharedManager] noShowuploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self->_voiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:@"2" forKey:@"dialogContentType"];
            [messageDic setObject:errorMessage forKey:@"dialogContentUri"];
            [messageDic setObject:[NSString stringWithFormat:@"%ld",text.length] forKey:@"dialogContentLen"];
            [messageDic setObject:text forKey:@"dialogContentText"];
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            appdel.canRefresDialNum = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self->_voiceM.voice_id}];
        }
    }];
}
//悄悄话
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]],[locaPath pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"4" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    //__weak typeof(self) weakSelf = self;
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self->_voiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
            [messageDic setObject:timeLength forKey:@"dialogContentLen"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            [nav.topViewController hideHUD];
            appdel.canRefresDialNum = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self->_voiceM.voice_id}];
        }else{
            [nav.topViewController showToastWithText:Message];
            [nav.topViewController hideHUD];
        }
    }];
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
