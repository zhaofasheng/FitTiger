//
//  NoticeManagerWorldCell.m
//  NoticeXi
//
//  Created by li lei on 2019/9/4.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerWorldCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMineViewController.h"
#import "NoticeTopiceVoicesListViewController.h"
@implementation NoticeManagerWorldCell
{
    UIView *_playView;//播放点击
    UIButton *_rePlayView;//重播点击,点击重播，就重头开始播放
    UIView *_mbView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 17, 160, 15)];
        _nickNameL.font = THRETEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:_nickNameL];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+6, 160, 12)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:_timeL];
        
        //话题
        _topiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeL.frame), CGRectGetMaxY(_nickNameL.frame), 0, 12+12)];
        _topiceLabel.font = ELEVENTEXTFONTSIZE;
        _topiceLabel.textColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        _topiceLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *taptop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTextClick)];
        [_topiceLabel addGestureRecognizer:taptop];
        [self.contentView addSubview:_topiceLabel];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, 150, 40)];
        self.playerView.delegate = self;
        self.playerView.isThird = YES;
        [self.playerView.playButton setImage:UIImageNamed(@"btn_play") forState:UIControlStateNormal];
        [self.contentView addSubview:_playerView];
        
        _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,_playerView.frame.size.width, _playerView.frame.size.height)];
        _playView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [_playView addGestureRecognizer:tap];
        [self.playerView addSubview:_playView];
        
        _rePlayView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), _playerView.frame.origin.y,_playerView.frame.size.height, _playerView.frame.size.height)];
        [_rePlayView addTarget:self action:@selector(playReplay) forControlEvents:UIControlEventTouchUpInside];
        [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_img":@"Imag_reply_img_ye") forState:UIControlStateNormal];
        _rePlayView.hidden = YES;
        [self.contentView addSubview:_rePlayView];
        
        self.imgListView = [[NoticeManagerImgList alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerView.frame)+20, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH-12)/3)];
        [self.contentView addSubview:self.imgListView];
        self.imgListView.hidden = YES;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.12;
        [self.playerView addGestureRecognizer:longPress];
        
        //电影
        _movieView = [[NoticeMoivceInCell alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_playerView.frame)+20, DR_SCREEN_WIDTH-30, 83)];
        [self.contentView addSubview:_movieView];
        
        self.contentVL = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_rePlayView.frame)+15, DR_SCREEN_WIDTH-30, 0)];
        self.contentVL.backgroundColor = [UIColor colorWithHexString:@"#ECF0F3"];
        self.contentVL.layer.cornerRadius = 5;
        self.contentVL.layer.masksToBounds = YES;
        [self.contentView addSubview:self.contentVL];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(10,0,self.contentVL.frame.size.width-20, self.contentVL.frame.size.height)];
        self.contentL.numberOfLines = 0;
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentVL addSubview:self.contentL];

        
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        [self.contentView addSubview:self.buttonView];
        
        NSArray *arr = @[@"从操场撤回",@"隐藏",[NoticeTools getLocalStrWith:@"groupManager.del"]];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/3*i, 0, DR_SCREEN_WIDTH/3, 50)];
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            button.tag = i;
            [button addTarget:self action:@selector(managerClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonView addSubview:button];
        }
        
        self.buttonEditView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        self.buttonEditView.hidden = YES;
        [self.contentView addSubview:self.buttonEditView];
        NSArray *arr1 = @[@"隐藏",[NoticeTools getLocalStrWith:@"groupManager.del"]];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/2*i, 0, DR_SCREEN_WIDTH/2, 50)];
            [button setTitle:arr1[i] forState:UIControlStateNormal];
            [button setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            button.tag = i;
            [button addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                self.priBtn = button;
            }else{
                self.deleteBtn = button;
            }
            [self.buttonEditView addSubview:button];
        }
        
        UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized1:)];
        longPress1.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress1];
        
        self.textContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_iconImageView.frame)+15, DR_SCREEN_WIDTH-30,40)];
        self.textContentLabel.numberOfLines = 0;
        self.textContentLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.textContentLabel.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.textContentLabel];
        self.textContentLabel.hidden = YES;
    }
    return self;
}

- (void)managerClick:(UIButton *)button{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseNavigationController *nav = nil;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.code forKey:@"confirmPasswd"];
    NSArray *arr = @[@"操作确认：从操场撤回心情",@"操作确认：隐藏心情",@"操作确认：删除心情"];
    LCActionSheet *sheet2 = [[LCActionSheet alloc] initWithTitle:arr[button.tag] cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex2) {
        
        if (buttonIndex2 == 1) {
            if (button.tag == 0) {
                [nav.topViewController showHUD];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/voicesShare/%@",self->_worldM.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        [self actionSuccess];
                        [nav showToastWithText:@"已把该心情从操场撤回"];
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }else if (button.tag == 1){
                [nav.topViewController showHUD];
                [parm setObject:@"1" forKey:@"isHidden"];
                [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/voices/%@",self->_worldM.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        [self actionSuccess];
                        [nav showToastWithText:@"已隐藏该心情"];
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }else{
                [nav.topViewController showHUD];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/voices/%@",self->_worldM.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        [self actionSuccess];
                        [nav showToastWithText:[NoticeTools getLocalStrWith:@"emtion.deleSuc"]];
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }
        }
    } otherButtonTitleArray:@[@"确认执行"]];
    [sheet2 show];
}

- (void)editClick:(UIButton *)button{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.code forKey:@"confirmPasswd"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseNavigationController *nav = nil;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (button.tag == 0) {
    
        [parm setObject:_worldM.hide_at.integerValue?@"0":@"1" forKey:@"isHidden"];
        [nav.topViewController showHUD];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/voices/%@",self->_worldM.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                [nav showToastWithText:self->_worldM.hide_at.integerValue? @"已取消隐藏":@"已隐藏"];
                [button setTitle:self->_worldM.hide_at.integerValue? @"隐藏":@"已隐藏" forState:UIControlStateNormal];
                self->_worldM.hide_at = self->_worldM.hide_at.integerValue?@"0":@"6879";
            
            }
        } fail:^(NSError *error) {
            [nav.topViewController hideHUD];
        }];
    }else{
        if ([_worldM.voice_status isEqualToString:@"1"]) {
            [nav.topViewController showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/voices/%@",self->_worldM.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [nav.topViewController hideHUD];
                if (success) {
                    [nav showToastWithText:[NoticeTools getLocalStrWith:@"emtion.deleSuc"]];
                    [button setTitle:[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
                    self->_worldM.voice_status = @"5";
                }
            } fail:^(NSError *error) {
                [nav.topViewController hideHUD];
            }];
        }else{
            [parm setObject:@"1" forKey:@"voiceStatus"];
            [nav.topViewController showHUD];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/voices/%@",self->_worldM.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [nav.topViewController hideHUD];
                if (success) {
                    [nav showToastWithText:@"已取消删除"];
                    [button setTitle:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
                    self->_worldM.voice_status = @"1";
                    
                }
            } fail:^(NSError *error) {
                [nav.topViewController hideHUD];
            }];
        }
    }
}

- (void)actionSuccess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editSuccess:)]) {
        [self.delegate editSuccess:self.index];
    }
}

- (void)longPressGestureRecognized1:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    if (longPress.state == UIGestureRecognizerStateBegan) {//执行一次
        if (self.delegate && [self.delegate respondsToSelector:@selector(readPointSetSuccess:)]) {
            [self.delegate readPointSetSuccess:_index];
        }
    }
}

//点击播放
- (void)playNoReplay{
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
    if (!_worldM.isPlaying) {//只有在播放或者暂停的时候才可以拖拽
        return;
    }
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginDrag:)]) {
                [self.delegate beginDrag:self.tag];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragingFloat: index:)]) {
                if ((_worldM.voice_len.floatValue/self.playerView.frame.size.width)*p.x < _worldM.voice_len.length/5) {
                    return;
                }
                [self.delegate dragingFloat:(_worldM.voice_len.floatValue/self.playerView.frame.size.width)*p.x index:self.tag];
            }
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

- (void)setWorldM:(NoticeVoiceListModel *)worldM{
    _worldM = worldM;
    _nickNameL.text = worldM.subUserModel.nick_name;
    _timeL.text = worldM.sharedTime;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:worldM.subUserModel.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    
   self.timeL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+6,GET_STRWIDTH(worldM.sharedTime, 12, 12), 12);
    //话题
    if (worldM.topic_name && worldM.topic_name.length) {
        self.topiceLabel.text = worldM.topicName;
        self.topiceLabel.frame = CGRectMake(CGRectGetMaxX(_timeL.frame), _timeL.frame.origin.y,DR_SCREEN_WIDTH-CGRectGetMaxX(_timeL.frame)-15, 12);
    }else{
        self.topiceLabel.text = @"";
        self.topiceLabel.frame = CGRectMake(CGRectGetMaxX(_timeL.frame)+5, _timeL.frame.origin.y,0, 0);
    }
    
    self.playerView.timeLen = worldM.nowTime.integerValue?worldM.nowTime: worldM.voice_len;
    self.playerView.voiceUrl = worldM.voice_url;
    self.playerView.slieView.progress = worldM.nowPro >0 ?worldM.nowPro:0;
    [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_img":@"Imag_reply_img_ye") forState:UIControlStateNormal];
    _rePlayView.hidden = worldM.isPlaying? NO:YES;
  
    _playView.frame = CGRectMake(0, 0,_playerView.frame.size.width, _playerView.frame.size.height);
    _rePlayView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame),self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
    //位置
    if (worldM.voice_len.integerValue < 5) {
        self.playerView.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, 130, 40);
    }else if (worldM.voice_len.integerValue >= 5 && worldM.voice_len.integerValue <= 105){
        self.playerView.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, 130+worldM.voice_len.integerValue, 40);
    }else if (worldM.voice_len.integerValue >= 120){
        self.playerView.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, 130+120, 40);
    }
    else{
        self.playerView.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, 130+worldM.voice_len.integerValue, 40);
    }
    
    [self.playerView refreWithFrame];
    
    self.imgListView.imgArr = worldM.img_list;
    self.imgListView.hidden = worldM.img_list.count ? NO:YES;

    //电影
    self.movieView.hidden = (worldM.resource)? NO:YES;
    self.movieView.type = worldM.resource_type;
    if ([worldM.resource_type isEqualToString:@"1"]) {
        self.movieView.movie = worldM.movieM;
        self.movieView.userScro = worldM.user_score;
    }else if ([worldM.resource_type isEqualToString:@"2"]){//书籍
        self.movieView.userScro = worldM.user_score;
        self.movieView.book = worldM.bookM;
    }else if ([worldM.resource_type isEqualToString:@"3"]){//歌曲
        self.movieView.songScro = worldM.user_score;
        self.movieView.song = worldM.songM;
    }
    
    self.playerView.hidden = worldM.content_type.intValue == 2?YES:NO;
    self.textContentLabel.hidden = !self.playerView.hidden;
    self.textContentLabel.attributedText = worldM.allTextAttStr;

    self.contentL.text = worldM.resource_content;
    if (worldM.img_list.count) {
        self.contentVL.frame = CGRectMake(15, CGRectGetMaxY(self.imgListView.frame)+(worldM.resource_content.length?15:0), DR_SCREEN_WIDTH-30,worldM.resource_content.length? worldM.contentHeight : 0);
    }else if (worldM.resource){
        self.contentVL.frame = CGRectMake(15, CGRectGetMaxY(self.movieView.frame)+(worldM.resource_content.length?15:0), DR_SCREEN_WIDTH-30,worldM.resource_content.length? worldM.contentHeight : 0);
    }else{
        self.contentVL.frame = CGRectMake(15, CGRectGetMaxY(self.playerView.frame)+(worldM.resource_content.length?15:0), DR_SCREEN_WIDTH-30,worldM.resource_content.length? worldM.contentHeight : 0);
    }
    
    if (!self.textContentLabel.hidden) {
        _textContentLabel.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, DR_SCREEN_WIDTH-30, worldM.textHeight);
        self.imgListView.frame = CGRectMake(0, CGRectGetMaxY(_textContentLabel.frame)+15, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH-12)/3);
        self.movieView.frame = CGRectMake(15, CGRectGetMaxY(self.textContentLabel.frame)+15, DR_SCREEN_WIDTH-30, 83);
        if (worldM.img_list.count) {
            self.contentVL.frame = CGRectMake(15, CGRectGetMaxY(self.imgListView.frame)+(worldM.resource_content.length?15:0), DR_SCREEN_WIDTH-30,worldM.resource_content.length? worldM.contentHeight : 0);
        }else if (worldM.resource){
            self.contentVL.frame = CGRectMake(15, CGRectGetMaxY(self.movieView.frame)+(worldM.resource_content.length?15:0), DR_SCREEN_WIDTH-30,worldM.resource_content.length? worldM.contentHeight : 0);
        }else{
            self.contentVL.frame = CGRectMake(15, CGRectGetMaxY(self.textContentLabel.frame)+(worldM.resource_content.length?15:0), DR_SCREEN_WIDTH-30,worldM.resource_content.length? worldM.contentHeight : 0);
        }
    }
    
    self.contentL.frame = CGRectMake(10,0,self.contentVL.frame.size.width-20, self.contentVL.frame.size.height);
    
    self.buttonView.frame = CGRectMake(0, CGRectGetMaxY(self.contentVL.frame), DR_SCREEN_WIDTH, 50);
    self.buttonEditView.frame = self.buttonView.frame;

    [self.priBtn setTitle:worldM.hide_at.integerValue? @"已隐藏" : @"隐藏" forState:UIControlStateNormal];
    [self.deleteBtn setTitle:[worldM.voice_status isEqualToString:@"1"]? [NoticeTools getLocalStrWith:@"groupManager.del"] : [NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
}

- (void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (isEdit) {
        self.buttonEditView.hidden = NO;
        self.buttonView.hidden = YES;
    }
}

//点击话题
- (void)topicTextClick{
    
    if (_worldM.topic_name && _worldM.topic_name.length) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(stopPlay)]) {
            [self.delegate stopPlay];
        }
        NoticeTopiceVoicesListViewController *ctl = [[NoticeTopiceVoicesListViewController alloc] init];
        ctl.topicName = _worldM.topic_name;
        ctl.topicId = _worldM.topic_id;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

//点击头像
- (void)userInfoTap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stopPlay)]) {
        [self.delegate stopPlay];
    }
    if ([_worldM.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
      
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _worldM.user_id;
        ctl.isOther = YES;
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
