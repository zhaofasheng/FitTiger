//
//  NoticeNewSelfVoiceCell.m
//  NoticeXi
//
//  Created by li lei on 2021/4/10.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewSelfVoiceCell.h"
#import "BaseNavigationController.h"
#import "NoticerTopicSearchResultNewController.h"
#import "NoticeTabbarController.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticePlayerVideoController.h"
#import "NoticeBingGanListView.h"
#import "NoticeVoiceCommentView.h"
@implementation NoticeNewSelfVoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //160
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeleteChat:) name:@"DELETECHATENotification" object:nil];
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 145)];
        self.backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backView];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(15,0,self.backView.frame.size.width-48-30, 50)];
        _timeL.font = TWOTEXTFONTSIZE;
        _timeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        [self.backView addSubview:_timeL];
        
        self.otherMoreBtn = [[UIButton alloc] initWithFrame:self.statusImageView.frame];
        [self.backView addSubview:self.otherMoreBtn];
        self.otherMoreBtn.hidden = YES;
        [self.otherMoreBtn setImage:UIImageNamed(@"Image_sangedian") forState:UIControlStateNormal];
        [self.otherMoreBtn addTarget:self action:@selector(otherClick) forControlEvents:UIControlEventTouchUpInside];
        self.otherMoreBtn.hidden = YES;
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(15,50, 150, 40)];
        self.playerView.isThird = YES;
        self.playerView.hidden = YES;
        [self.playerView.playButton setImage:UIImageNamed(@"btn_play") forState:UIControlStateNormal];
        [self.backView addSubview:_playerView];
        
        self.playerView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.2];
        self.playerView.slieView.trackTintColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.2];
        self.playerView.slieView.progressTintColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];
        self.playerView.leftView.hidden = YES;
        self.playerView.rightView.hidden = YES;
        
        _rePlayView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), _playerView.frame.origin.y,_playerView.frame.size.height, _playerView.frame.size.height)];
        [_rePlayView addTarget:self action:@selector(playReplay) forControlEvents:UIControlEventTouchUpInside];
        [_rePlayView setImage:UIImageNamed(@"Imag_reply_img") forState:UIControlStateNormal];
        _rePlayView.hidden = YES;
        [self.backView addSubview:_rePlayView];
        
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView.frame.size.height-54, DR_SCREEN_WIDTH-40, 54)];
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
        [_topiceLabel addGestureRecognizer:taptop];
        [self.topicView addSubview:_topiceLabel];
        
        self.addZJImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-24- 15, 15, 24, 24)];
        [self.backView addSubview:self.addZJImageView];
        self.addZJImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToZjTap)];
        [self.addZJImageView addGestureRecognizer:addTap];
        self.addZJImageView.hidden = YES;
        
        self.statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 24, 24)];
        [self.backView addSubview:self.statusImageView];
        self.statusImageView.userInteractionEnabled = YES;
        self.statusImageView.hidden = YES;
        
        _playView = [[UIView alloc] initWithFrame:CGRectMake(-15, -3,_playerView.frame.size.height+15+5, _playerView.frame.size.height+6)];
        _playView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [_playView addGestureRecognizer:tap];
        [self.playerView addSubview:_playView];
        
        self.hsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width-105-24,self.buttonView.frame.size.height-24-15,24,24)];
        [self.hsButton setBackgroundImage:UIImageNamed(@"Image_newclickhs") forState:UIControlStateNormal];
        [self.buttonView addSubview:self.hsButton];
        [self.hsButton addTarget:self action:@selector(replayClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.dialNumL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hsButton.frame)+5, self.hsButton.frame.origin.y,42, 24)];
        self.dialNumL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.dialNumL.font = TWOTEXTFONTSIZE;
        [self.buttonView addSubview:self.dialNumL];
        self.dialNumL.userInteractionEnabled = YES;
        UITapGestureRecognizer *hsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replayClick)];
        [self.dialNumL addGestureRecognizer:hsTap];
        
        self.sendBGBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hsButton.frame)+45,self.buttonView.frame.size.height-24-15,24,24)];
        [self.sendBGBtn setBackgroundImage:UIImageNamed(@"Ima_sendbgn") forState:UIControlStateNormal];
        [self.buttonView addSubview:self.sendBGBtn];// Image_songbg
        [self.sendBGBtn addTarget:self action:@selector(clickBg) forControlEvents:UIControlEventTouchUpInside];
        
        self.bgL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sendBGBtn.frame)+5, self.hsButton.frame.origin.y,39, 24)];
        self.bgL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.bgL.font = TWOTEXTFONTSIZE;
        [self.buttonView addSubview:self.bgL];
        self.bgL.userInteractionEnabled = YES;
        UITapGestureRecognizer *bgT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBg)];
        [self.bgL addGestureRecognizer:bgT];
        
        self.comBackView = [[UIView alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width-105-24-70,0,70,54)];
        self.comBackView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        [self.buttonView addSubview:self.comBackView];
        self.comBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *comsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comTapList)];
        [self.comBackView addGestureRecognizer:comsTap];
        
        self.comImagV = [[UIImageView alloc] initWithFrame:CGRectMake(0,15,24,24)];
        self.comImagV.image = UIImageNamed(@"Image_pinglunv");
        [self.comBackView addSubview:self.comImagV];
        
        self.comNumL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.comImagV.frame)+5, 0, 39, 54)];
        self.comNumL.font = TWOTEXTFONTSIZE;
        self.comNumL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.comBackView addSubview:self.comNumL];
        
        self.commentView = [[UIView alloc] initWithFrame:CGRectMake(15, 11, self.buttonView.frame.size.width-15-105-24-10, 32)];
        self.commentView.layer.cornerRadius = 16;
        self.commentView.layer.masksToBounds = YES;
        self.commentView.userInteractionEnabled = YES;
        self.commentView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.2];
        
        UIImageView *editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 6, 20, 20)];
        editImageView.image = UIImageNamed(@"Image_huieditimg");
        [self.commentView addSubview:editImageView];
        
        UILabel *comL = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, self.commentView.frame.size.width-32, 32)];
        comL.font = TWOTEXTFONTSIZE;
        comL.text = [NoticeTools getLocalStrWith:@"ly.openis"];
        comL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        [self.commentView addSubview:comL];
        
        UITapGestureRecognizer *comTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCom)];
        [self.commentView addGestureRecognizer:comTap];
        
        [self.buttonView addSubview:self.commentView];
        
        self.contentTextL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-70, 13)];
        self.contentTextL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentTextL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentTextL.numberOfLines = 0;
        [self.backView addSubview:self.contentTextL];
        self.contentTextL.hidden = YES;
        
        self.imageViewS = [[NoticeVoiceImgList alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_playerView.frame)+15, DR_SCREEN_WIDTH, 0)];
        [self.backView addSubview:self.imageViewS];

        self.dragView = [[UIView alloc] initWithFrame:CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height)];
        self.dragView.userInteractionEnabled = YES;
        self.dragView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
        [self.playerView addSubview:self.dragView];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.0;
        [self.dragView addGestureRecognizer:longPress];
        
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(15, 0,15+GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.zdingd"], 12, 32), 32)];
        
        UIImageView *topImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 21/2, 11, 11)];
        topImageV.image = UIImageNamed(@"Image_zhdingxinq");
        [self.topView addSubview:topImageV];
        [self.backView addSubview:self.topView];
        self.topView.hidden = YES;
        
        UILabel *topL = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.zdingd"], 12, 32), 32)];
        topL.text = [NoticeTools getLocalStrWith:@"em.zdingd"];
        topL.font = TWOTEXTFONTSIZE;
        topL.textColor = [UIColor colorWithHexString:@"#E6C14D"];
        [self.topView addSubview:topL];
        
        self.shareL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.hasgx"], 12, 50), 50)];
        
        self.shareL.font = TWOTEXTFONTSIZE;
        self.shareL.textColor = [UIColor colorWithHexString:@"#E6C14D"];
        [self.backView addSubview:self.shareL];
        self.shareL.hidden = YES;
        
        //屏蔽别人心情
        self.pinbTools = [[NoticeVoicePinbi alloc] init];
        self.pinbTools.delegate = self;
        
        //电影
        _movieView = [[NoticeMoivceInCell alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_playerView.frame)+15, self.backView.frame.size.width-30, 78)];
        [self.backView addSubview:_movieView];
        
        self.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longDleTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longDeleteVoice:)];
        longDleTap.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longDleTap];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-8-24, 15, 24, 24)];
        [btn setBackgroundImage:UIImageNamed(@"Image_moreNew") forState:UIControlStateNormal];
        [self.backView addSubview:btn];
        [btn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        btn.hidden = YES;
        self.moreBtn = btn;
        
        //颜色设置
        self.timeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        self.topiceLabel.textColor = [[UIColor colorWithHexString:@"#456DA0"] colorWithAlphaComponent:1];

        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0];
        self.backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.08];
        
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

- (UIButton *)hadAddBtn{
    if (!_hadAddBtn) {
        _hadAddBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-54, 4, 54, 24)];
        _hadAddBtn.layer.cornerRadius = 12;
        _hadAddBtn.layer.masksToBounds = YES;
        _hadAddBtn.layer.borderWidth = 1;
        _hadAddBtn.layer.borderColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1].CGColor;
        [_hadAddBtn setTitleColor:[[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1] forState:UIControlStateNormal];
        _hadAddBtn.titleLabel.font = ELEVENTEXTFONTSIZE;
        [_hadAddBtn setTitle:[NoticeTools getLocalStrWith:@"movie.aladd"] forState:UIControlStateNormal];
        [self.backView addSubview:_hadAddBtn];
    }
    return _hadAddBtn;
}

- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    
    self.timeL.text = voiceM.creatTime;

    self.topView.hidden = YES;
    
    if (!voiceM.resource && voiceM.isSelf){
        if (!self.isAddToZj && !self.noShowTop) {
            self.topView.hidden = !voiceM.is_top.boolValue;
        }
        if (!self.topView.hidden) {
            self.topView.frame = CGRectMake(15, 0,15+GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.zdingd"], 12, 32), 32);
        }
        self.timeL.frame = CGRectMake(15,32,self.backView.frame.size.width-48-30-6-self.shareL.frame.size.width, 50);
        self.moreBtn.frame = CGRectMake(self.backView.frame.size.width-15-22, 6, 24, 24);

    }else{
        if (!self.isAddToZj && !self.noShowTop) {
            self.topView.hidden = !voiceM.is_top.boolValue;
        }
        if (!self.topView.hidden) {
            self.topView.frame = CGRectMake(15, 9,15+GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.zdingd"], 12, 32), 32);
            self.timeL.frame = CGRectMake(CGRectGetMaxX(self.topView.frame),0,self.backView.frame.size.width-48-30-6-self.topView.frame.size.width, 50);
        }else{
            self.timeL.frame = CGRectMake(15,0,self.backView.frame.size.width-48-30-6-self.shareL.frame.size.width, 50);
        }
        self.moreBtn.frame = CGRectMake(self.backView.frame.size.width-15-22, 15, 24, 24);
    }
        
    if (voiceM.content_type.integerValue == 1) {
        self.playerView.hidden = NO;
        self.playerView.timeLen = voiceM.nowTime.integerValue?voiceM.nowTime: voiceM.voice_len;
        self.playerView.voiceUrl = voiceM.voice_url;
        self.playerView.slieView.progress = voiceM.nowPro >0 ?voiceM.nowPro:0;
        if (!voiceM.resource && voiceM.isSelf){
            //位置
            if (voiceM.voice_len.integerValue < 5) {
                self.playerView.frame = CGRectMake(15,82, 130, 40);
            }else if (voiceM.voice_len.integerValue >= 5 && voiceM.voice_len.integerValue <= 105){
                self.playerView.frame = CGRectMake(15, 82, 130+voiceM.voice_len.integerValue, 40);
            }else if (voiceM.voice_len.integerValue >= 120){
                self.playerView.frame = CGRectMake(15,82, 130+120, 40);
            }
            else{
                self.playerView.frame = CGRectMake(15,82, 130+voiceM.voice_len.integerValue, 40);
            }
        }else{
            //位置
            if (voiceM.voice_len.integerValue < 5) {
                self.playerView.frame = CGRectMake(15,50, 130, 40);
            }else if (voiceM.voice_len.integerValue >= 5 && voiceM.voice_len.integerValue <= 105){
                self.playerView.frame = CGRectMake(15, 50, 130+voiceM.voice_len.integerValue, 40);
            }else if (voiceM.voice_len.integerValue >= 120){
                self.playerView.frame = CGRectMake(15,50, 130+120, 40);
            }
            else{
                self.playerView.frame = CGRectMake(15,50, 130+voiceM.voice_len.integerValue, 40);
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
        
    self.imageViewS.hidden = (voiceM.img_list.count && _voiceM.attr_type.intValue != 2) ? NO  : YES;
    
    if (voiceM.content_type.intValue == 2) {
        self.contentTextL.attributedText = voiceM.isMoreFiveLines?voiceM.fiveAttTextStr:voiceM.allTextAttStr;
        
        if (!voiceM.resource && voiceM.isSelf){
            self.contentTextL.frame = CGRectMake(15,82, DR_SCREEN_WIDTH-70, voiceM.isMoreFiveLines?voiceM.fiveTextHeight:voiceM.textHeight);
        }else{
            self.contentTextL.frame = CGRectMake(15,50, DR_SCREEN_WIDTH-70, voiceM.isMoreFiveLines?voiceM.fiveTextHeight:voiceM.textHeight);
        }
    }
    
    if (voiceM.img_list.count && _voiceM.attr_type.intValue == 2) {
        self.player.hidden = NO;
        if (!voiceM.resource && voiceM.isSelf){
            self.player.frame = CGRectMake(0, _voiceM.content_type.intValue!=2? (CGRectGetMaxY(_playerView.frame)+15):(CGRectGetMaxY(_contentTextL.frame)+15), 200,200);
        }else{
            self.player.frame = CGRectMake(0, _voiceM.content_type.intValue!=2? (CGRectGetMaxY(_playerView.frame)+15):(CGRectGetMaxY(_contentTextL.frame)+15), 200,200);
        }
        self.videoImageView.center = self.player.center;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            self.player.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:voiceM.video_url[0]]];
            self.player.player = [AVPlayer playerWithPlayerItem:self.player.playerItem];
            self.player.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player.player];
        });

    }else{
        _player.hidden = YES;
    }
    
    self.videoImageView.hidden = _player.hidden;
    if (!voiceM.resource && voiceM.isSelf){
        if (_voiceM.img_list.count == 1) {
            self.imageViewS.frame = CGRectMake(0, voiceM.content_type.intValue!=2? (CGRectGetMaxY(_playerView.frame)+15):(CGRectGetMaxY(_contentTextL.frame)+15), DR_SCREEN_WIDTH-60,200);
        }else if (_voiceM.img_list.count == 2){
            self.imageViewS.frame = CGRectMake(0, voiceM.content_type.intValue!=2? (CGRectGetMaxY(_playerView.frame)+15):(CGRectGetMaxY(_contentTextL.frame)+15), DR_SCREEN_WIDTH-60,(DR_SCREEN_WIDTH-68)/2);
        }else if (_voiceM.img_list.count == 3){
            self.imageViewS.frame = CGRectMake(0, voiceM.content_type.intValue!=2? (CGRectGetMaxY(_playerView.frame)+15):(CGRectGetMaxY(_contentTextL.frame)+15), DR_SCREEN_WIDTH-60, (DR_SCREEN_WIDTH-60-18)/3);
        }
    }else{
        if (_voiceM.img_list.count == 1) {
            self.imageViewS.frame = CGRectMake(0, voiceM.content_type.intValue!=2? (CGRectGetMaxY(_playerView.frame)+15):(CGRectGetMaxY(_contentTextL.frame)+15), DR_SCREEN_WIDTH-60,200);
        }else if (_voiceM.img_list.count == 2){
            self.imageViewS.frame = CGRectMake(0, voiceM.content_type.intValue!=2? (CGRectGetMaxY(_playerView.frame)+15):(CGRectGetMaxY(_contentTextL.frame)+15), DR_SCREEN_WIDTH-60,(DR_SCREEN_WIDTH-68)/2);
        }else if (_voiceM.img_list.count == 3){
            self.imageViewS.frame = CGRectMake(0, voiceM.content_type.intValue!=2? (CGRectGetMaxY(_playerView.frame)+15):(CGRectGetMaxY(_contentTextL.frame)+15), DR_SCREEN_WIDTH-60, (DR_SCREEN_WIDTH-60-18)/3);
        }
    }

    if (!self.imageViewS.hidden) {
        self.imageViewS.imgArr = voiceM.img_list;
    }
    
    [self.sendBGBtn setBackgroundImage:UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbg": @"Ima_sendbgn") forState:UIControlStateNormal];
    //书影音类型
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
    
    if (voiceM.content_type.intValue ==1) {
        self.contentTextL.hidden = YES;
        if (!voiceM.resource && voiceM.isSelf){
            if (_voiceM.img_list.count) {//有图片
                self.backView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 145 + self.imageViewS.frame.size.height+15+32+voiceM.topicHeight+voiceM.bgmHeight);
            }else{
                //纯音频心情
                self.backView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 145+32+voiceM.topicHeight+voiceM.bgmHeight);
            }
        }else{
            if (_voiceM.img_list.count) {//有图片
                self.backView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 145 + self.imageViewS.frame.size.height+15+voiceM.topicHeight+voiceM.bgmHeight);
            }else{
                //纯音频心情
                self.backView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 145+voiceM.topicHeight+voiceM.bgmHeight);
            }
        }
    
    }else{
        self.contentTextL.hidden = NO;
        if (!voiceM.resource && voiceM.isSelf){
            self.backView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 145+self.contentTextL.frame.size.height+(voiceM.img_list.count?self.imageViewS.frame.size.height:0)-40+15+32+voiceM.topicHeight+voiceM.bgmHeight);
        }else{
            self.backView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 145+self.contentTextL.frame.size.height+(voiceM.img_list.count?self.imageViewS.frame.size.height:0)-40+15+voiceM.topicHeight+voiceM.bgmHeight);
        }
    }
    
    //书影音
    if (voiceM.resource) {
        if (voiceM.content_type.intValue !=2) {
            self.playerView.hidden = NO;
            self.contentTextL.hidden = YES;
            self.backView.frame = CGRectMake(15,0, DR_SCREEN_WIDTH-30, 145+78+15);
            self.buttonView.frame = CGRectMake(0, self.backView.frame.size.height-54, self.backView.frame.size.width, 54);
            self.buttonView.hidden = NO;
            self.movieView.frame = CGRectMake(15, CGRectGetMaxY(self.playerView.frame)+15, self.backView.frame.size.width-30,78);
        }else{
            self.buttonView.hidden = YES;
            self.playerView.hidden = YES;
            self.contentTextL.hidden = NO;
            self.contentTextL.attributedText = voiceM.isMoreFiveLines?voiceM.fiveAttTextStr:voiceM.allTextAttStr;
            self.movieView.frame = CGRectMake(15,50, self.backView.frame.size.width-30,78);
            self.contentTextL.frame = CGRectMake(15,CGRectGetMaxY(self.movieView.frame)+15, DR_SCREEN_WIDTH-70, voiceM.isMoreFiveLines?voiceM.fiveTextHeight:voiceM.textHeight);
            self.backView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 145+78+15+self.contentTextL.frame.size.height-54-40+15);
        }
    }
    
    //对话或者悄悄话数量
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.chat_num.integerValue > 0) {
            self.dialNumL.text = _voiceM.chat_num;
        }else{
            self.dialNumL.text = [NoticeTools getLocalStrWith:@"em.hs"];
        }
        if (_voiceM.zaned_num.intValue) {
            self.bgL.text = _voiceM.zaned_num;
        }else{
            self.bgL.text = [NoticeTools getLocalStrWith:@"py.bg"];
        }
        self.otherMoreBtn.hidden = YES;
    }else{
        self.bgL.text = [NoticeTools getLocalStrWith:@"py.bg"];
        if (_voiceM.dialog_num.integerValue > 0) {
            self.dialNumL.text = _voiceM.dialog_num;
        }else{
            self.dialNumL.text = [NoticeTools getLocalStrWith:@"em.hs"];
        }
        if (!_voiceM.statusM) {
            self.statusImageView.hidden = YES;
        }
        
        self.otherMoreBtn.hidden = NO;
    }
    
    _statusView.hidden = YES;
    if (!voiceM.resource && voiceM.isSelf) {
        self.statusView.hidden = NO;
        
        if (voiceM.voiceIdentity.intValue == 1) {
            self.statusL.text = [NoticeTools getLocalStrWith:@"n.open"];
            self.statsImgV.image = UIImageNamed(@"Image_vost1");
        }else if (voiceM.voiceIdentity.intValue == 2){
            self.statusL.text = [NoticeTools getLocalStrWith:@"n.tpkjian"];
            self.statsImgV.image = UIImageNamed(@"Image_vost2");
        }else{
            self.statusL.text = [NoticeTools getLocalStrWith:@"n.onlyself"];
            self.statsImgV.image = UIImageNamed(@"Image_vost3");
        }
        self.statusL.frame = CGRectMake(17, 0, 130, 32);
        self.statsImgV.hidden = NO;
        if (!self.topView.hidden) {
            self.statsImgV.hidden = YES;
            if (voiceM.voiceIdentity.intValue == 1) {
                self.statusL.text = [NSString stringWithFormat:@"(%@)",[NoticeTools getLocalStrWith:@"n.open"]];
            }else if (voiceM.voiceIdentity.intValue == 2){
                self.statusL.text = [NSString stringWithFormat:@"(%@)",[NoticeTools getLocalStrWith:@"n.tpkjian"]];
            }else{
                self.statusL.text = [NSString stringWithFormat:@"(%@)",[NoticeTools getLocalStrWith:@"n.onlyself"]];
            }
            self.statusL.frame = CGRectMake(13+GET_STRWIDTH([NoticeTools getLocalStrWith:@"em.zdingd"], 12, 32), 0, 130, 32);
        }
    }
    
    self.buttonView.frame = CGRectMake(0, self.backView.frame.size.height-54, self.backView.frame.size.width, 54);
    if (voiceM.content_type.intValue == 2) {
        if (voiceM.statusM) {
            self.statusImageView.hidden = NO;
            self.statusImageView.frame = CGRectMake(15, self.buttonView.frame.origin.y-50+15, 20, 20);
            [self.statusImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.statusM.picture_url]];
        }else{
            self.statusImageView.hidden = YES;
        }
    }else{
        self.statusImageView.hidden = YES;
    }
    
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
    
    if (voiceM.bgm_name && voiceM.bgm_name.length) {
        self.bgmChoiceView.hidden = NO;
        self.bgmChoiceView.title = voiceM.bgm_name;
        self.bgmChoiceView.frame = CGRectMake(15, (!self.topicView.hidden?(CGRectGetMaxY(self.topicView.frame)+5):(self.buttonView.frame.origin.y-25)), DR_SCREEN_WIDTH-30-40, 20);
    }else{
        _bgmChoiceView.hidden = YES;
    }
    
    if (voiceM.first_comment.count) {
        self.commentView.hidden = YES;
    }else{
        self.commentView.hidden = NO;
    }
    
    self.comBackView.hidden = voiceM.first_comment.count?NO:YES;
    self.comNumL.text = voiceM.comment_count;
    
    self.moreBtn.hidden = NO;
    
    if (self.isAddToZj) {

        [self.moreBtn setBackgroundImage:UIImageNamed(@"adzj_hadadd") forState:UIControlStateNormal];
        
        if (_voiceM.hasCurrentJion) {
            self.hadAddBtn.hidden = NO;
            self.moreBtn.hidden = YES;
        }else{
            _hadAddBtn.hidden = YES;
            self.moreBtn.hidden = NO;
        }
    }
}

- (NoticeBgmHasChoiceShowView *)bgmChoiceView{
    if (!_bgmChoiceView) {
        _bgmChoiceView = [[NoticeBgmHasChoiceShowView alloc] initWithFrame:CGRectMake(15, (!self.topicView.hidden?CGRectGetMaxY(self.topicView.frame):(self.buttonView.frame.origin.y-25)), DR_SCREEN_WIDTH-30-40, 20)];
        [self.backView addSubview:_bgmChoiceView];
        _bgmChoiceView.isShow = YES;
        _bgmChoiceView.closeBtn.hidden = YES;
        _bgmChoiceView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        _bgmChoiceView.hidden = YES;
    }
    return _bgmChoiceView;
}

- (NoticeBBSComentInputView *)inputView{
    if (!_inputView) {
        _inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        _inputView.delegate = self;
        _inputView.isRead = YES;
        _inputView.isVoiceComment = YES;
        _inputView.limitNum = 100;
        _inputView.plaStr = [NoticeTools getLocalStrWith:@"ly.openis"];
        _inputView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        _inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
    return _inputView;
}

- (void)comTapList{

    NoticeVoiceCommentView *comView = [[NoticeVoiceCommentView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    comView.voiceM = self.voiceM;
    [comView show];
}

//点击留言
- (void)tapCom{
    self.inputView.saveKey = [NSString stringWithFormat:@"voicecom%@%@",[NoticeTools getuserId],self.voiceM.voice_id];
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

- (void)changeSkin{

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.backImg) {
        self.needTouMing = YES;
    }else{
        self.needTouMing = NO;
    }
}

//点击更多
- (void)moreClick{
    if (self.isAddToZj) {
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.voiceM.voice_id forKey:@"voiceId"];
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController showHUD];
        NSString *url = nil;
        url = [NSString stringWithFormat:@"user/%@/albumVoice/%@",[[NoticeSaveModel getUserInfo] user_id],self.albumId];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                self.voiceM.hasCurrentJion = YES;
                self.moreBtn.hidden = YES;
                self.hadAddBtn.hidden = NO;
            }
        } fail:^(NSError *error) {
            [nav.topViewController hideHUD];
        }];
        return;
    }
    if (!_voiceM.isSelf){
        [self.pinbTools pinbiWithModel:_voiceM];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(hasClickMoreWith:)]) {//更多点击
            [self.delegate hasClickMoreWith:self.index];
        }
    }
}

//屏蔽成功回调
- (void)pinbiSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(otherPinbSuccess)]) {
        [self.delegate otherPinbSuccess];
    }
}


- (UIView *)statusView{
    if (!_statusView) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 150, 32)];
        _statusView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        _statsImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 16, 16)];
        [_statusView addSubview:_statsImgV];
        _statusL = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 130, 32)];
        _statusL.font = ELEVENTEXTFONTSIZE;
        _statusL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _statusView.hidden = YES;
        [_statusView addSubview:_statusL];
        [self.backView addSubview:_statusView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 31, DR_SCREEN_WIDTH, 1)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.05];
        [_statusView addSubview:line];
    }
    return _statusView;
}

- (void)replayClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHS:)]) {
        [self.delegate clickHS:self.voiceM];
    }
}

- (void)clickBg{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    if (![_voiceM.subUserModel.userId isEqualToString:[NoticeTools getuserId]]) {//如果不是自己的心情
        //判断是否是自己,不是自己则为点击「有启发」
        if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
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

- (SelVideoPlayer *)player{
    if (!_player) {
        _player = [[SelVideoPlayer alloc] initWithFrame:CGRectMake(0, _voiceM.content_type.intValue!=2? (CGRectGetMaxY(_playerView.frame)+15):50, 200,200)];
        _player.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
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

- (void)getDeleteChat:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *voiceId = nameDictionary[@"voiceId"];
    if ([_voiceM.voice_id isEqualToString:voiceId]) {
      
        if (![_voiceM.subUserModel.userId isEqualToString:[NoticeTools getuserId]]) {//不是自己的心情
            if (self.voiceM.dialog_num.intValue) {
                self.voiceM.dialog_num = [NSString stringWithFormat:@"%d",self.voiceM.dialog_num.intValue-1];
            }
            if (_voiceM.dialog_num.integerValue > 0) {
                self.dialNumL.text = _voiceM.dialog_num;
            }else{
                self.dialNumL.text = [NoticeTools getLocalStrWith:@"em.hs"];
            }
        }
    }
}

//别人的心情点击更多
- (void)otherClick{
    [self.pinbTools pinbiWithModel:_voiceM];
}

- (void)cancelPri{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }

    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.voiceM.is_private.integerValue ? @"0" : @"1" forKey:@"privateStatus"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/voices/%@",[[NoticeSaveModel getUserInfo] user_id],self.voiceM.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            [nav.topViewController showToastWithText:@"已取消仅自己可见"];
            self.voiceM.is_private = @"0";
            self.addZJImageView.hidden = YES;
        }
        [nav.topViewController hideHUD];
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

//添加到专辑
- (void)addToZjTap{
    if (self.voiceM.is_private.boolValue) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"是否取消仅自己可见?" message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"main.sure"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf cancelPri];
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
  
    NSString *url = nil;
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.voiceM.voice_id forKey:@"voiceId"];
    url = [NSString stringWithFormat:@"user/%@/albumVoice/%@",[[NoticeSaveModel getUserInfo] user_id],self.zjmodelId];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self.voiceM.hasCurrentJion = YES;

            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"em.joinsus"]];
            if (self.joinSuccessBlock) {
                self.joinSuccessBlock(YES);
            }
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)topicTextClick{
    if (self.noPushToToice) {
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
- (void)longDeleteVoice:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    if (!self.needlongTap) {
        return;
    }
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"em.yc"],[NoticeTools getLocalStrWith:@"em.jiaru"]]];
            sheet.delegate = self;
            [sheet show];
            break;
        }
        default:
            break;
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.deleteVoiceFromZj) {
            self.deleteVoiceFromZj(self.voiceM);
        }
    }else if(buttonIndex == 2){
        NoticeZjListView* _listView = [[NoticeZjListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _listView.choiceM = self.voiceM;
 
        [_listView show];
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

- (NoticeShareToWorld *)shareWorld{
    if (!_shareWorld) {
        //分享到世界
        _shareWorld = [[NoticeShareToWorld alloc] init];
        _shareWorld.delegate = self;
    }
    return _shareWorld;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
