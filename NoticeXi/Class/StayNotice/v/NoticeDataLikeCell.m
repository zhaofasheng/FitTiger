//
//  NoticeDataLikeCell.m
//  NoticeXi
//
//  Created by li lei on 2023/3/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeDataLikeCell.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMineViewController.h"
@implementation NoticeDataLikeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
       // self.iconMarkView.image = UIImageNamed(pyModel.pyUserInfo.levelImgIconName);
        
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
        
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 12, DR_SCREEN_WIDTH-55-48-15, 21)];
        _nickNameL.font = XGFifthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, CGRectGetMaxY(_iconMarkView.frame)+11, DR_SCREEN_WIDTH-55-48-15, 16)];
        self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.timeL.font = TWOTEXTFONTSIZE;
        [self.contentView addSubview:self.timeL];
        
        self.infoL = [[UILabel alloc] initWithFrame:CGRectMake(55, 33,DR_SCREEN_WIDTH-55-48-15, 17)];
        self.infoL.font = TWOTEXTFONTSIZE;
        self.infoL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:self.infoL];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(55, 54, DR_SCREEN_WIDTH-55-48-15, 20)];
        self.contentL.font = XGFourthBoldFontSize;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.contentL];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeL.frame)+8, DR_SCREEN_WIDTH, 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (UIImageView *)helpImageView{
    if (!_helpImageView) {
        _helpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 54, 88, 88)];
        _helpImageView.layer.cornerRadius = 8;
        _helpImageView.layer.masksToBounds = YES;
        _helpImageView.contentMode = UIViewContentModeScaleAspectFill;
        _helpImageView.clipsToBounds = YES;
        [self.contentView addSubview:_helpImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigLook)];
        _helpImageView.userInteractionEnabled = YES;
        [_helpImageView addGestureRecognizer:tap];
    }
    return _helpImageView;
}

- (UILabel *)lineContentLabel{
    if (!_lineContentLabel) {
        _lineContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-10-50, 15, 50, 50)];
        _lineContentLabel.numberOfLines = 0;
        _lineContentLabel.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _lineContentLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_lineContentLabel];
    }
    return _lineContentLabel;
}

- (UIImageView *)voiceImageView{
    if (!_voiceImageView) {
        _voiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-48, 15, 48, 48)];
        _voiceImageView.layer.cornerRadius = 4;
        _voiceImageView.layer.masksToBounds = YES;
        _voiceImageView.contentMode = UIViewContentModeScaleAspectFill;
        _voiceImageView.clipsToBounds = YES;
        [self.contentView addSubview:_voiceImageView];
    }
    return _voiceImageView;
}

- (void)setLikeModel:(NoticeDataLikeModel *)likeModel{
    _likeModel = likeModel;
    
    if ((likeModel.message_type.intValue == 3 && likeModel.is_anonymous.boolValue) || likeModel.message_type.intValue == 23 || (likeModel.message_type.intValue == 16 && likeModel.is_anonymous.boolValue) || likeModel.message_type.intValue == 4 || likeModel.message_type.intValue == 26 || likeModel.message_type.intValue == 19002) {
        self.iconImageView.hidden = YES;
        if ((likeModel.message_type.intValue == 3 && likeModel.is_anonymous.boolValue) || (likeModel.message_type.intValue == 16 && likeModel.is_anonymous.boolValue) || likeModel.message_type.intValue == 19002) {
            self.iconMarkView.image = UIImageNamed(@"Image_nimingpeiy");
        }else{
            self.iconMarkView.image = UIImageNamed(@"Image_flower");
        }
        
    }else{
        self.iconImageView.hidden = NO;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:likeModel.fromUser.avatar_url] placeholderImage:UIImageNamed(@"Image_jynohe")];
        self.iconMarkView.image = UIImageNamed(likeModel.fromUser.levelImgIconName);
    }
    
    if (likeModel.message_type.intValue == 23 ||likeModel.message_type.intValue == 4 || likeModel.message_type.intValue == 26) {
        self.nickNameL.frame = CGRectMake(55, 20, self.nickNameL.frame.size.width, 21);
    }else{
        self.nickNameL.frame = CGRectMake(55,12, self.nickNameL.frame.size.width, 21);
    }
    
    self.infoL.hidden = NO;
    self.infoL.text = likeModel.message_typeName;
    
    _voiceImageView.hidden = YES;
    if (likeModel.message_type.intValue == 3 || likeModel.message_type.intValue == 17102 || likeModel.message_type.intValue == 17103) {//心情封面
        self.voiceImageView.hidden = NO;
        if (likeModel.voice_cover_img.length > 10) {
            [self.voiceImageView sd_setImageWithURL:[NSURL URLWithString:likeModel.voice_cover_img] placeholderImage:nil];
        }else{
            [self.voiceImageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]] placeholderImage:nil];
        }
        
    }else if (likeModel.message_type.intValue == 19012 || likeModel.message_type.intValue == 19013){//播客封面
        self.voiceImageView.hidden = NO;
    
        [self.voiceImageView sd_setImageWithURL:[NSURL URLWithString:likeModel.podcast_cover_url] placeholderImage:nil];
    }
    
    if (likeModel.message_type.intValue == 3 && likeModel.is_anonymous.boolValue) {
        self.nickNameL.text = @"有人";
    }else if (likeModel.message_type.intValue == 16 && likeModel.is_anonymous.boolValue){
        self.nickNameL.text = [NoticeTools getLocalStrWith:@"py.nm"];
    }else if (likeModel.message_type.intValue == 4){
        self.infoL.hidden = YES;
        self.nickNameL.text = [NoticeTools getLocalStrWith:@"each.thinkgoodOpen"];
    }else if (likeModel.message_type.intValue == 26){
        self.nickNameL.text = @"你的画被选为了今日推荐";
        self.infoL.hidden = YES;
    }else if (likeModel.message_type.intValue == 23){
        self.nickNameL.text = [NoticeTools getLocalStrWith:@"each.pyPick"];
        self.infoL.hidden = YES;
    }else if (likeModel.message_type.intValue == 19002){
        self.nickNameL.text = [NoticeTools chinese:@"有热心民众" english:@"User" japan:@"ある人"];
    }else{
        self.nickNameL.text = likeModel.fromUser.nick_name;
    }
    
    self.contentL.hidden = YES;
    _helpImageView.hidden = YES;
    
    if (likeModel.needLabel) {
        self.lineContentLabel.hidden = NO;
        if (likeModel.message_type.intValue == 19002){//求助帖留言点赞
            self.lineContentLabel.text = likeModel.invitation_title;
        }else{
            self.lineContentLabel.text = likeModel.line_content;
        }
    }else{
        self.lineContentLabel.hidden = YES;
    }
    
    if (likeModel.message_type.intValue == 19002){//求助帖留言点赞
        if (likeModel.comModel.content_type.intValue > 1) {
            self.timeL.frame = CGRectMake(55, 150, DR_SCREEN_WIDTH, 16);
            [self.helpImageView sd_setImageWithURL:[NSURL URLWithString:likeModel.comModel.content] placeholderImage:nil];
            self.helpImageView.hidden = NO;
        }else{
            self.contentL.text = likeModel.comModel.content;
            self.contentL.hidden = NO;
            self.timeL.frame = CGRectMake(55, 82, DR_SCREEN_WIDTH, 16);
        }
    }else if (likeModel.message_type.intValue == 17102 || likeModel.message_type.intValue == 17103){//心情留言/回复点赞
        self.contentL.hidden = NO;
        self.contentL.text = likeModel.voice_comment_content;
        self.timeL.frame = CGRectMake(55, 82, DR_SCREEN_WIDTH, 16);
    }else if (likeModel.message_type.intValue == 19012 || likeModel.message_type.intValue == 19013 || likeModel.message_type.intValue == 48102){//赞了配音/播客下的评论,
        self.contentL.hidden = NO;
        self.timeL.frame = CGRectMake(55, 82, DR_SCREEN_WIDTH, 16);
        if (likeModel.message_type.intValue == 19012 || likeModel.message_type.intValue == 19013) {
            self.contentL.text = likeModel.podcast_comment_content;
        }else if(likeModel.message_type.intValue == 48102){
            self.contentL.text = likeModel.dubbing_comment_content;
        }
    }else{
        self.timeL.frame = CGRectMake(55, 58, DR_SCREEN_WIDTH, 16);
    }
    
    self.timeL.text = likeModel.created_at;
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.timeL.frame)+7, DR_SCREEN_WIDTH, 1);
}

- (void)userInfoTap{
    if ((self.likeModel.message_type.intValue == 16 && self.likeModel.is_anonymous.boolValue) || (self.likeModel.message_type.intValue == 3 && self.likeModel.is_anonymous.boolValue) || self.likeModel.message_type.intValue == 4 || self.likeModel.message_type.intValue == 19002) {
        return;
    }

    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.userId = self.likeModel.fromUser.userId;
    ctl.isOther = [self.likeModel.fromUser.userId isEqualToString:[NoticeTools getuserId]] ? NO : YES;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)bigLook{
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.helpImageView;
    item.largeImageURL     = [NSURL URLWithString:self.likeModel.comModel.content];

    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow;
    [photoView presentFromImageView:self.helpImageView toContainer:toView animated:YES completion:nil];
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
