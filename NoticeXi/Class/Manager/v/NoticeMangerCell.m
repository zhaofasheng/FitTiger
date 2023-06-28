//
//  NoticeMangerCell.m
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMangerCell.h"

@implementation NoticeMangerCell
{
    UIView *_playView;//播放点击
    UIButton *_rePlayView;//重播点击,点击重播，就重头开始播放
    UIButton *_button;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.userInteractionEnabled = YES;
        self.contView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 140)];
        self.contView.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
        [self.contentView addSubview:self.contView];
        self.contView.userInteractionEnabled = YES;
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,15, 40, 40)];
        self.iconImageView.layer.cornerRadius = 20;
        self.iconImageView.layer.masksToBounds = YES;
        [self.contView addSubview:self.iconImageView];
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10, 22, DR_SCREEN_WIDTH-15-66-10-CGRectGetMaxX(self.iconImageView.frame), 13)];
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.nickNameL.font = THRETEENTEXTFONTSIZE;
        [self.contView addSubview:self.nickNameL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(self.nickNameL.frame.origin.x, CGRectGetMaxY(self.nickNameL.frame)+10, self.nickNameL.frame.size.width, 9)];
        self.timeL.textColor = GetColorWithName(VDarkTextColor);
        self.timeL.font = [UIFont systemFontOfSize:9];
        [self.contView addSubview:self.timeL];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-66-15, 20, 66, 20)];
        [button setTitle:@"查看心情" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:9];
        [button setTitleColor:[UIColor colorWithHexString:@"#828282"] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor colorWithHexString:@"#828282"].CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        _button = button;
        [button addTarget:self action:@selector(otherClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contView addSubview:button];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.iconImageView.frame)+20, 150, 40)];
        self.playerView.isThird = YES;
        [self.playerView.playButton setImage:UIImageNamed(@"btn_play") forState:UIControlStateNormal];
        [self.contentView addSubview:_playerView];
        
        _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,60, _playerView.frame.size.height)];
        _playView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [_playView addGestureRecognizer:tap];
        [self.playerView addSubview:_playView];
        
        _rePlayView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), _playerView.frame.origin.y,_playerView.frame.size.height, _playerView.frame.size.height)];
        [_rePlayView addTarget:self action:@selector(playReplay) forControlEvents:UIControlEventTouchUpInside];
        [_rePlayView setImage:UIImageNamed(@"Imag_reply_img") forState:UIControlStateNormal];
        _rePlayView.hidden = YES;
        [self.contView addSubview:_rePlayView];
        
        self.chatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.iconImageView.frame)+20, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
        [self.contView addSubview:self.chatImageView];
        self.chatImageView.hidden = YES;
        self.chatImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.chatImageView.clipsToBounds = YES;
        self.chatImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapf = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookBig)];
        [self.chatImageView addGestureRecognizer:tapf];
        
        self.contentVL = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_rePlayView.frame)+15, DR_SCREEN_WIDTH-30, 0)];
        self.contentVL.backgroundColor = [UIColor colorWithHexString:@"#ECF0F3"];
        self.contentVL.layer.cornerRadius = 5;
        self.contentVL.layer.masksToBounds = YES;
        [self.contView addSubview:self.contentVL];

        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(10,0,self.contentVL.frame.size.width-20, self.contentVL.frame.size.height)];
        self.contentL.numberOfLines = 0;
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentVL addSubview:self.contentL];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)longPressGestureRecognized:(id)sender{
    if (self.noTap) {
        return;
    }
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    if (longPress.state == UIGestureRecognizerStateBegan) {//执行一次
        if (self.delegate && [self.delegate respondsToSelector:@selector(pointSetsuccessindex:)]) {
            [self.delegate pointSetsuccessindex:self.index];
        }
    }
}


- (void)otherClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(otherHeaderWith:)]) {
        [self.delegate otherHeaderWith:_mangerModel];
    }
}

- (void)setChatModel:(NoticeGroupChatModel *)chatModel{
    _chatModel = chatModel;
    [_button setTitle:@"查看社团" forState:UIControlStateNormal];
    self.playerView.hidden = YES;
    self.timeL.text = chatModel.showTime;
    self.nickNameL.text = chatModel.nick_name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chatModel.user_avatar_url]]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    if (chatModel.type.intValue == 2) {
        _chatImageView.hidden = NO;
        [_chatImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chatModel.resource_url]] placeholderImage:GETUIImageNamed(@"img_empty")];
    }else{
        _contentVL.hidden = NO;
        _contentVL.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, DR_SCREEN_WIDTH-30, chatModel.contentHeight);
        _contentL.frame = CGRectMake(0,0, DR_SCREEN_WIDTH-30, chatModel.contentHeight);
        _contentL.text = chatModel.content;
    }
}

- (void)setDanMu:(NoticeDanMuListModel *)danMu{
    _danMu = danMu;
    _button.hidden = YES;
    self.playerView.hidden = YES;
    self.timeL.text = danMu.created_at;
    self.nickNameL.text = danMu.userM.nick_name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:danMu.userM.avatar_url]]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
     _contentVL.hidden = NO;
     _contentVL.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, DR_SCREEN_WIDTH-30,60);
     _contentL.frame = CGRectMake(0,0, DR_SCREEN_WIDTH-30, 60);
     _contentL.text = danMu.barrage_content;
}

- (void)setMangerModel:(NoticeManagerModel *)mangerModel{
    _mangerModel = mangerModel;

    [_button setTitle:self.ishs? @"查看心情":@"查看对象" forState:UIControlStateNormal];
    
    self.timeL.text = mangerModel.created_at;
    self.nickNameL.text = mangerModel.nick_name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:mangerModel.avatar_url]]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    
    self.playerView.timeLen = mangerModel.resource_len;
    self.playerView.voiceUrl = mangerModel.resource_url;
    self.playerView.slieView.progress = mangerModel.nowPro >0 ?mangerModel.nowPro:0;
    
    if (mangerModel.resource_len.integerValue < 5) {
        self.playerView.frame = CGRectMake(15,CGRectGetMaxY(self.iconImageView.frame)+20, 130, 40);
    }else if (mangerModel.resource_len.integerValue >= 5 && mangerModel.resource_len.integerValue <= 105){
        self.playerView.frame = CGRectMake(15,CGRectGetMaxY(self.iconImageView.frame)+20, 130+mangerModel.resource_len.integerValue, 40);
    }else if (mangerModel.resource_len.integerValue >= 120){
        self.playerView.frame = CGRectMake(15,CGRectGetMaxY(self.iconImageView.frame)+20, 130+120, 40);
    }
    else{
        self.playerView.frame = CGRectMake(15,CGRectGetMaxY(self.iconImageView.frame)+20, 130+mangerModel.resource_len.integerValue, 40);
    }
    [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_img":@"Imag_reply_img_ye") forState:UIControlStateNormal];
    _rePlayView.hidden = mangerModel.isPlaying? NO:YES;
    _rePlayView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame),self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
    _playView.frame = CGRectMake(0,0, self.playerView.frame.size.width, self.playerView.frame.size.height);
    [self.playerView refreWithFrame];
    

    if ([mangerModel.resource_type isEqualToString:@"1"]) {
        self.contentVL.hidden = mangerModel.resource_content.length? NO:YES;
        self.contentL.text = mangerModel.resource_content;
        self.contentVL.frame = CGRectMake(15, CGRectGetMaxY(_rePlayView.frame)+15, DR_SCREEN_WIDTH-30, mangerModel.contentHeight);
        self.contentL.frame = CGRectMake(10,0,self.contentVL.frame.size.width-20, self.contentVL.frame.size.height);
        self.chatImageView.hidden = YES;
        self.playerView.hidden = NO;
        self.contView.frame =  CGRectMake(0, 0, DR_SCREEN_WIDTH, 140+mangerModel.contentHeight);
        
    }else{
        self.contentL.hidden = YES;
        [_chatImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:mangerModel.resource_url]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        self.chatImageView.hidden = NO;
        self.playerView.hidden = YES;
        self.contView.frame =  CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH+80);
        self.chatImageView.frame = CGRectMake(0,CGRectGetMaxY(self.iconImageView.frame)+20, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    }
    self.line.frame = CGRectMake(0,CGRectGetMaxY(self.contView.frame), DR_SCREEN_WIDTH, 1);
}

//点击播放
- (void)playNoReplay{
    if ([_mangerModel.resource_type isEqualToString:@"2"]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(userstartPlayAndStop:)]) {
        [self.delegate userstartPlayAndStop:self.index];
    }
}

//点击重新播放
- (void)playReplay{
    if ([_mangerModel.resource_type isEqualToString:@"2"]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(userstartRePlayer:)]) {
        [self.delegate userstartRePlayer:self.index];
    }
}

- (void)lookBig{

    NSArray *array = self.chatModel?[_chatModel.resource_url componentsSeparatedByString:@"?"]: [_mangerModel.resource_url componentsSeparatedByString:@"?"];
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.chatImageView;
    item.largeImageURL     = [NSURL URLWithString:array[0]];
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:self.chatImageView
                   toContainer:toView
                      animated:YES completion:nil];
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
