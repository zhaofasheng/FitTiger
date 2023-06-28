//
//  NoticeQiaoCell.m
//  NoticeXi
//
//  Created by li lei on 2023/3/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeQiaoCell.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeQiaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
  
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.line];
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 32, 32)];
        [self.contentView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17, 28, 28)];
        _iconImageView.layer.cornerRadius = 14;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.image = UIImageNamed(@"Image_jynohe");
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-7, CGRectGetMaxY(_iconImageView.frame)-14,14, 14)];
        self.markImage.image = UIImageNamed(@"jlzb_img");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 12, DR_SCREEN_WIDTH-55-68, 21)];
        _nickNameL.font = XGFifthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];
        

        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, CGRectGetMaxY(self.nickNameL.frame)+11, DR_SCREEN_WIDTH-55-48-15, 16)];
        self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.timeL.font = TWOTEXTFONTSIZE;
        [self.contentView addSubview:self.timeL];
    
        self.chatIntoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40, 86, 20, 20)];
        [self.contentView addSubview:self.chatIntoImageView];
        
        self.readNumL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-150, 86, 150, 17)];
        self.readNumL.font = TWOTEXTFONTSIZE;
        self.readNumL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.readNumL];
        
        _sendImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12,45, 100, 138)];
        _sendImageView.contentMode = UIViewContentModeScaleAspectFill;
        _sendImageView.clipsToBounds = YES;
        _sendImageView.userInteractionEnabled = YES;
        _sendImageView.layer.cornerRadius = 4;
        _sendImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigTag)];
        [_sendImageView addGestureRecognizer:tapImg];
        [self.contentView addSubview:_sendImageView];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(55, 43,125, 35)];
        _playerView.delegate = self;
        _playerView.isThird = YES;
        [self.contentView addSubview:_playerView];
        self.playerView.playButton.frame = CGRectMake(4,9/2+1,24, 24);
        [_playerView refreWithFrame];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.12;
        [self.playerView addGestureRecognizer:longPress];
        
    }
    return self;
}

- (UIImageView *)helpImageView{
    if (!_helpImageView) {
        _helpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-68, 15, 48, 48)];
        _helpImageView.layer.cornerRadius = 4;
        _helpImageView.layer.masksToBounds = YES;
        _helpImageView.contentMode = UIViewContentModeScaleAspectFill;
        _helpImageView.clipsToBounds = YES;
        [self.contentView addSubview:_helpImageView];
    }
    return _helpImageView;
}

- (NoticeShareLinkCell *)linkView{
    if (!_linkView) {
        _linkView = [[NoticeShareLinkCell alloc] initWithFrame:CGRectMake(55, 43, 205, 53)];
        [self.contentView addSubview:_linkView];
        _linkView.hidden = YES;
    }
    return _linkView;
}


- (void)setQiaoModel:(NoticeStaySys *)qiaoModel{
    _qiaoModel = qiaoModel;
    
    if ([qiaoModel.with_user_id isEqualToString:@"1"] || qiaoModel.with_user_id.intValue == 684699 || qiaoModel.with_user_id.intValue == 1125) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
    }else{
        self.markImage.hidden = YES;
    }
    
    _nickNameL.text = qiaoModel.with_user_name;

    self.iconMarkView.image = UIImageNamed(qiaoModel.levelImgIconName);
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:qiaoModel.with_user_avatar_url]
     placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
              options:SDWebImageRefreshCached];
    
    self.chatIntoImageView.image = UIImageNamed(qiaoModel.un_read_num.intValue?@"chantinun_into":@"chat_into");
    self.readNumL.textColor = [UIColor colorWithHexString:qiaoModel.un_read_num.intValue?@"#EE4B4E":@"#8A8F99"];
    
    if (qiaoModel.voice_cover_img.length > 10) {
        [self.helpImageView sd_setImageWithURL:[NSURL URLWithString:qiaoModel.voice_cover_img]];
    }else{
        ;
        if ([qiaoModel.voice_user_id isEqualToString:[NoticeTools getuserId]]) {//自己的心情
            [self.helpImageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]]];
        }else{
            [self.helpImageView sd_setImageWithURL:[NSURL URLWithString:qiaoModel.with_user_avatar_url]];
        }
    }

    
    
    if (qiaoModel.un_read_num.intValue) {
        self.readNumL.text =  [NSString stringWithFormat:@"%@条未读对话",qiaoModel.un_read_num];
        if ([NoticeTools getLocalType] == 1) {
            self.readNumL.text =  [NSString stringWithFormat:@"%@ unread",qiaoModel.un_read_num];
        }else if ([NoticeTools getLocalType] ==2){
            self.readNumL.text =  [NSString stringWithFormat:@"未读会話内容 %@",qiaoModel.un_read_num];
        }
    }else{
        self.readNumL.text =  [NSString stringWithFormat:@"%@条对话",qiaoModel.dialog_num];
        if ([NoticeTools getLocalType] == 1) {
            self.readNumL.text =  [NSString stringWithFormat:@"More %@",qiaoModel.dialog_num];
        }else if ([NoticeTools getLocalType] ==2){
            self.readNumL.text =  [NSString stringWithFormat:@"会話内容 %@",qiaoModel.dialog_num];
        }
    }
    _sendImageView.hidden = (qiaoModel.lastChatModel.content_type.intValue ==3 || qiaoModel.lastChatModel.content_type.intValue ==2)?NO:YES;
    _playerView.voiceUrl = qiaoModel.lastChatModel.resource_url;
    _playerView.timeLen = qiaoModel.lastChatModel.resource_len;
    
    _playerView.hidden = qiaoModel.lastChatModel.content_type.intValue == 1?NO:YES;
    
    [self refreshLink:qiaoModel.lastChatModel];
    [self refreshImg:qiaoModel.lastChatModel];
    
    if (qiaoModel.lastChatModel.content_type.intValue == 1) {
        self.timeL.frame = CGRectMake(55, 86, 200, 17);
    }else if (qiaoModel.lastChatModel.content_type.intValue == 2){
        self.timeL.frame = CGRectMake(55, 86, 200, 17);
    }else if (qiaoModel.lastChatModel.content_type.intValue == 3){
        self.timeL.frame = CGRectMake(55, 142, 200, 17);
        
    }else if (qiaoModel.lastChatModel.content_type.intValue == 5){
        self.timeL.frame = CGRectMake(55, 107, 200, 17);
    }
    
    self.chatIntoImageView.frame = CGRectMake(DR_SCREEN_WIDTH-40, self.timeL.frame.origin.y, 20, 20);
    self.readNumL.frame = CGRectMake(DR_SCREEN_WIDTH-40-150,self.timeL.frame.origin.y, 150, 17);
    _timeL.text = qiaoModel.updated_at;
    
}

- (void)refreshImg:(NoticeChats *)chat{
    if (!_sendImageView.hidden) {

        if (chat.content_type.intValue == 2) {//信封
            self.sendImageView.frame = CGRectMake(55,43,32,32);
            self.sendImageView.image = UIImageNamed(@"Image_otherxinfengweidu");
        }else{
            self.sendImageView.frame = CGRectMake(55,43,88,88);
            if ([chat.resource_url containsString:@".gif"] || [chat.resource_url containsString:@".GIF"]){
                [_sendImageView setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.resource_url]] placeholder:GETUIImageNamed(@"img_empty") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                    
           
                }];
            }else{
                [_sendImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.resource_url]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
         
                }];
            }
        }
    }
}

- (void)refreshLink:(NoticeChats *)chat{
    if (chat.content_type.intValue == 5) {
        
        NSString *urlStr = chat.share_url;
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
    }else{
        _linkView.hidden = YES;
    }
}

//查看大图
- (void)bigTag{
    NoticeChats *_chat = self.qiaoModel.lastChatModel;
    NSArray *array = [_chat.resource_url componentsSeparatedByString:@"?"];
    if (!array.count) {
        return;
    }
    if (_chat.garbage_type.intValue) {
        return;
    }

    YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];
    if (_chat.content_type.intValue != 2) {
        item.thumbView = _sendImageView;
    }
    
    item.largeImageURL = [NSURL URLWithString:array[0]];
    NSArray *arr = @[item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    photoView.isNeedChangeSaveImage = YES;
    UIView *toView         = [UIApplication sharedApplication].keyWindow;
    [photoView presentFromImageView:_sendImageView toContainer:toView animated:YES completion:nil];
    

}
- (void)userInfoTap{

    if ([_qiaoModel.with_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _qiaoModel.with_user_id;
        ctl.isOther = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)longPressGestureRecognized:(id)sender{
    if (!self.qiaoModel.lastChatModel.isPlaying) {//只有在播放或者暂停的时候才可以拖拽
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
                [self.delegate dragingFloat:(self.qiaoModel.lastChatModel.resource_len.floatValue/self.playerView.frame.size.width)*p.x index:self.tag];
            }
            break;
        }
        default: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag:)]) {
                [self.delegate endDrag:self.tag];
            }
            break;
        }
    }
}


- (void)startPlay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop: section:)]) {
        [self.delegate startPlayAndStop:self.index section:0];
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
