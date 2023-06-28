//
//  NoticeChatsCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChatsCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeChatsCell
{
    UILabel *_markL;
    UIButton *_rePlayView;//重播点击,点击重播，就重头开始播放
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0];
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
        self.timeL.backgroundColor = self.backgroundColor;
        self.timeL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.6];
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:self.timeL];
        self.timeL.hidden = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,45, 35, 35)];
        _iconImageView.layer.cornerRadius = 35/2;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        [self.contentView addSubview:_iconImageView];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(22+_iconImageView.frame.origin.x, 22+_iconImageView.frame.origin.y,15, 15)];
        self.markImage.image = UIImageNamed(@"jlzb_img");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        _sendImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12,45, 100, 138)];
        _sendImageView.contentMode = UIViewContentModeScaleAspectFill;
        _sendImageView.clipsToBounds = YES;
        _sendImageView.userInteractionEnabled = YES;
        _sendImageView.layer.cornerRadius = 5;
        _sendImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigTag)];
        [_sendImageView addGestureRecognizer:tapImg];
        [self.contentView addSubview:_sendImageView];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 45,125, 35)];
        _playerView.delegate = self;
        _playerView.isThird = YES;
        [_playerView.playButton setImage:UIImageNamed(@"Image_newplay") forState:UIControlStateNormal];
        [self.contentView addSubview:_playerView];
        
        _rePlayView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), _playerView.frame.origin.y,_playerView.frame.size.height, _playerView.frame.size.height)];
        [_rePlayView addTarget:self action:@selector(playReplay) forControlEvents:UIControlEventTouchUpInside];
        [_rePlayView setImage:UIImageNamed(@"Imag_reply_img") forState:UIControlStateNormal];
        
        _rePlayView.hidden = YES;
        [self.contentView addSubview:_rePlayView];
        
        self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        self.redView.backgroundColor = [UIColor redColor];
        self.redView.layer.cornerRadius = 2;
        self.redView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.redView];
        self.redView.hidden = YES;
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(0, 27+45+15, DR_SCREEN_WIDTH, 11)];
        _markL.textColor = [NoticeTools isWhiteTheme] ? [UIColor colorWithHexString:@"#B5B5B5"]:[UIColor colorWithHexString:@"#72727F"];
        _markL.textAlignment = NSTextAlignmentCenter;
        _markL.font = ELEVENTEXTFONTSIZE;
        _markL.text = [NoticeTools isSimpleLau]? @"对方可能不方便立刻回复":@"對方可能不方便立刻回復";
        [self.contentView addSubview:_markL];
        _markL.hidden = YES;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.3;
        [self.playerView addGestureRecognizer:longPress];
        
        UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized1:)];
        longPress1.minimumPressDuration = 0.3;
        [_sendImageView addGestureRecognizer:longPress1];
        
        self.failButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.failButton setImage:UIImageNamed(@"Image_failimg") forState:UIControlStateNormal];
        [self.contentView addSubview:self.failButton];
        [self.failButton addTarget:self action:@selector(failClick) forControlEvents:UIControlEventTouchUpInside];
        self.failButton.hidden = YES;
    }
    return self;
}

- (NoticeShareLinkCell *)linkView{
    if (!_linkView) {
        _linkView = [[NoticeShareLinkCell alloc] initWithFrame:CGRectMake(0, 0, 205, 53)];
        __weak typeof(self) weakSelf = self;
        _linkView.dissMissTapBlock = ^(BOOL diss) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(dissMissTap)]) {
                [weakSelf.delegate dissMissTap];
            }
        };
        [self.contentView addSubview:_linkView];
        _linkView.hidden = YES;
        UILongPressGestureRecognizer *longPressDeleT3 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized1:)];
        longPressDeleT3.minimumPressDuration = 0.5;
        [_linkView addGestureRecognizer:longPressDeleT3];
    }
    return _linkView;
}

- (void)failClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(failReSendchatM:)]) {
        [self.delegate failReSendchatM:self.chat];
    }
}
- (void)longPressGestureRecognized1:(id)sender{
    if (self.chat.isSaveCace) {
        return;
    }
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    if (longPress.state == UIGestureRecognizerStateBegan) {//执行一次
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteWithIndex:section:)]) {
            [self.delegate deleteWithIndex:self.index section:self.section];
        }
    }
}

- (void)longPressGestureRecognized:(id)sender{
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    if (!_chat.isPlaying) {//只有在播放或者暂停的时候才可以拖拽
        if (self.chat.isSaveCace) {
            return;
        }
        if (longPress.state == UIGestureRecognizerStateBegan) {//执行一次
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteWithIndex:section:)]) {
                [self.delegate deleteWithIndex:self.index section:self.section];
            }
        }
        return;
    }
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginDrag: section:)]) {
                [self.delegate beginDrag:self.tag section:self.section];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragingFloat: index: section:)]) {
                [self.delegate dragingFloat:(_chat.resource_len.floatValue/self.playerView.frame.size.width)*p.x index:self.tag section:self.section];
            }
            break;
        }
        default: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag: section:)]) {
                [self.delegate endDrag:self.tag section:self.section];
            }
            break;
        }
    }
}

//查看大图
- (void)bigTag{
    NSArray *array = [_chat.resource_url componentsSeparatedByString:@"?"];
    if (!array.count) {
        return;
    }
    if (_chat.garbage_type.intValue) {
        return;
    }
    if (_chat.content_type.intValue == 2 && !_chat.isSelf) {
        self.chat.read_at = [NoticeTools getNowTimeTimestamp];

        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:[NoticeTools getNowTimeTimestamp] forKey:@"readAt"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"chats/%@/%@",self.chat.chat_id,self.chat.dialog_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                self.sendImageView.image = UIImageNamed(@"Image_otherxinfengyidu");
            }
        } fail:^(NSError *error) {
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickBigImageDelegete)]) {
            [self.delegate clickBigImageDelegete];
        }
  
    }
    YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];
    if (self.chat.content_type.intValue != 2) {
        item.thumbView = _sendImageView;
    }
    
    item.largeImageURL = [NSURL URLWithString:self.chat.isSaveCace?self.chat.resource_url: array[0]];
    NSArray *arr = @[item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    photoView.isNeedChangeSaveImage = YES;
    UIView *toView         = [UIApplication sharedApplication].keyWindow;
    [photoView presentFromImageView:_sendImageView toContainer:toView animated:YES completion:nil];
    

}
//点击了播放按钮
- (void)startPlay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop: section:)]) {
        [self.delegate startPlayAndStop:self.index section:self.section];
    }
}
//点击重播按钮
- (void)playReplay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRePlayAndStop: section:)]) {
        [self.delegate startRePlayAndStop:self.index section:self.section];
    }
}

//点击头像
- (void)userInfoTap{
    if (self.isLead) {
        return;
    }
    if (_chat.is_self.integerValue) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
            
        }
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _chat.from_user_id;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dissMissTap)]) {
        [self.delegate dissMissTap];
    }
}

- (void)setChat:(NoticeChats *)chat{
    _chat = chat;
    self.failButton.hidden = YES;
    self.timeL.text = chat.showTime;
    self.timeL.hidden = !chat.isShowTime;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.avatar_url]]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    _playerView.voiceUrl = chat.resource_url;
    _playerView.timeLen = chat.resource_len;
    
    _playerView.hidden = chat.content_type.intValue == 1?NO:YES;
    _sendImageView.hidden = (chat.content_type.intValue ==3 || chat.content_type.intValue ==2)?NO:YES;
    
    if (chat.is_self.intValue) {
        _iconImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35, 44, 35, 35);
    }else{
        _iconImageView.frame = CGRectMake(15, 44, 35, 35);
    }
    
    
    [self refreshImg:chat];
    [self refreshVoice:chat];
    [self refreshLink:chat];
    
    self.linkView.hidden = chat.content_type.intValue == 5?NO:YES;
    
    self.markImage.frame = CGRectMake(22+_iconImageView.frame.origin.x, 22+_iconImageView.frame.origin.y,15, 15);
    
    if ([_chat.from_user_id isEqualToString:@"1"]) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_guanfang_b":@"Image_guanfang_y");
    }
    else{
        self.markImage.hidden = YES;
    }
    
    
    if (chat.needMarkAuto) {
        _markL.hidden = NO;
        _markL.frame = CGRectMake(0,chat.resource_type.intValue == 2? CGRectGetMaxY(_sendImageView.frame)+10: (44+35+15), DR_SCREEN_WIDTH, 11);
    }else{
        _markL.hidden = YES;
    }
}

- (void)refreshLink:(NoticeChats *)chat{
    if (self.chat.content_type.intValue == 5) {
        
        NSString *urlStr = self.chat.share_url;
        if (![NoticeTools isWhetherNoUrl:urlStr]) {//存在中文字的话
            NSArray *arr = [NoticeTools getURLFromStr:urlStr];
            if (arr.count) {
                 urlStr = arr[0];
            
            }else{
                return;
            }
        }
        
        self.linkView.shareUrl = urlStr;
        self.linkView.hidden = NO;
        _chat.imgCellHeight = 53;
        if (self.chat.is_self.integerValue) {
            self.linkView.frame = CGRectMake(_iconImageView.frame.origin.x-12-205, _iconImageView.frame.origin.y, 205, 53);
        }else{
            self.linkView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, _iconImageView.frame.origin.y, 205, 53);
        }
    }else{
        _linkView.hidden = YES;
    }
}

- (void)refreshImg:(NoticeChats *)chat{
    if (!_sendImageView.hidden) {
        self.redView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        if (chat.is_self.intValue) {
            _sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35-12-100,44, 100, 138);
        }else{
            _sendImageView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12,44, 100, 138);
        }
        
        if (chat.content_type.intValue == 2) {//信封
            if (self.chat.is_self.integerValue) {
                self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-12-40,44, 40, 40);
                self.sendImageView.image = UIImageNamed(@"Image_selfXinfeng");
            }else{
                self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12,_iconImageView.frame.origin.y,40,40);
                if (chat.read_at.intValue) {
                    self.sendImageView.image = UIImageNamed(@"Image_otherxinfengyidu");
                }else{
                    self.sendImageView.image = UIImageNamed(@"Image_otherxinfengweidu");
                }
            }
            if (_chat.isSaveCace) {
                self.failButton.hidden = NO;
                self.failButton.frame = CGRectMake(self.sendImageView.frame.origin.x-35, self.sendImageView.frame.origin.y+(self.sendImageView.frame.size.height-35)/2, 35, 35);
            }
        }else{
            if (_chat.isSaveCace) {
                NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:chat.resource_url];
                NSData *data = [fileHandle readDataToEndOfFile];
                [fileHandle closeFile];
                UIImage *image  = [[UIImage alloc] initWithData:data];
                _sendImageView.image = image;
                [self setImageViewFrame:image];
            }else{
                if ([chat.resource_url containsString:@".gif"] || [chat.resource_url containsString:@".GIF"]){
                    [_sendImageView setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.resource_url]] placeholder:GETUIImageNamed(@"img_empty") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                        
                        [weakSelf setImageViewFrame:image];
                    }];
                }else{
                    [_sendImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.resource_url]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        [weakSelf setImageViewFrame:image];
                    }];
                }
            }
        }
    }
}

- (void)refreshVoice:(NoticeChats *)chat{
    if (chat.content_type.intValue == 1) {
        if (!chat.is_self.integerValue) {
            [self.playerView.playButton setImage:UIImageNamed(chat.isPlaying ? @"Image_nnoplaay" : @"Image_nplaay") forState:UIControlStateNormal];
            if (chat.resource_len.integerValue < 5) {
                self.playerView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 44, 120, 35);
                [self.playerView refreWithFrame];
            }else if (chat.resource_len.integerValue >= 5 && chat.resource_len.integerValue <= 105){
                self.playerView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 44, 120+chat.resource_len.integerValue, 35);
                [self.playerView refreWithFrame];
            }else{
                self.playerView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 44, 120+chat.resource_len.integerValue, 35);
                [self.playerView refreWithFrame];
            }
            if (chat.read_at.integerValue || !_sendImageView.hidden) {
                self.redView.hidden = YES;
            }else{
                self.redView.hidden = NO;
                self.redView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame)+5, self.playerView.frame.origin.y+30/2, 4, 4);
            }
            _rePlayView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame)+5, self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
            if (chat.isPlaying) {
                _rePlayView.hidden = NO;
            }else{
                _rePlayView.hidden = YES;
            }
            [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_img":@"Imag_reply_img_ye") forState:UIControlStateNormal];
            self.playerView.slieView.progress = chat.nowPro >0 ?chat.nowPro:0;

        }else{
            [self.playerView.playButton setImage:UIImageNamed(!chat.isPlaying ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
            self.redView.hidden = YES;
            self.playerView.layer.borderWidth = 0;
            
            if (chat.resource_len.integerValue < 5) {
                self.playerView.frame = CGRectMake(DR_SCREEN_WIDTH-50-12-120, 44, 120, 35);
                [self.playerView refreWithFrame];
            }else if (chat.resource_len.integerValue >= 5 && chat.resource_len.integerValue <= 105){
                self.playerView.frame = CGRectMake(DR_SCREEN_WIDTH-50-12-120-chat.resource_len.integerValue, 44, 120+chat.resource_len.integerValue, 35);
                [self.playerView refreWithFrame];
            }else{
                self.playerView.frame = CGRectMake(DR_SCREEN_WIDTH-50-12-120-chat.resource_len.integerValue,44, 120+chat.resource_len.integerValue, 35);
                [self.playerView refreWithFrame];
            }
            
            [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_imgRight":@"Imag_reply_imgRight_ye") forState:UIControlStateNormal];
            _rePlayView.frame = CGRectMake(self.playerView.frame.origin.x-self.playerView.frame.size.height-5, self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
            if (chat.isPlaying) {
                _rePlayView.hidden = NO;
            }else{
                _rePlayView.hidden = YES;
            }
            
            self.playerView.timeLen = chat.nowTime.integerValue?chat.nowTime: chat.resource_len;
            self.playerView.slieView.progress = chat.nowPro >0 ?chat.nowPro:0;
            if (chat.isSaveCace && _sendImageView.hidden) {
                _rePlayView.hidden = YES;
                self.failButton.hidden = NO;
                self.failButton.frame = CGRectMake(self.playerView.frame.origin.x-self.playerView.frame.size.height-5, self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
            }
        }
        self.playerView.isGroupChatSelf = chat.is_self.boolValue;
    }
}

//根据图片尺寸设置图片比例
- (void)setImageViewFrame:(UIImage *)image{
    CGFloat imageWidth = CGImageGetWidth(image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(image.CGImage);
    if (imageHeight/imageWidth < 0.86){
        if (_chat.is_self.integerValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-15-172,44, 172, 172*imageHeight/imageWidth);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, 44,172,172*imageHeight/imageWidth);
        }
    }else if (imageHeight/imageWidth <= 1.15 && imageHeight/imageWidth > 0.95) {
        if (_chat.is_self.integerValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-15-120,44, 120, 120*imageHeight/imageWidth);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12,44,120,120*imageHeight/imageWidth);
        }
    }else if (imageHeight/imageWidth >= 2.76) {
        if (_chat.is_self.integerValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-15-50,44, 50, 138);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, 44,50,138);
        }
    }
    else if (imageHeight/imageWidth <= 1.38) {
        if (_chat.is_self.integerValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-15-100,44, 100, 100*imageHeight/imageWidth);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, 44,100,100*imageHeight/imageWidth);
        }
    }
    if (_chat.isSaveCace) {
        self.failButton.hidden = NO;
        self.failButton.frame = CGRectMake(self.sendImageView.frame.origin.x-35-5, self.sendImageView.frame.origin.y+(self.sendImageView.frame.size.height-35)/2, 35, 35);
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
