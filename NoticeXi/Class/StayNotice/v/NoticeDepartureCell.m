//
//  NoticeDepartureCell.m
//  NoticeXi
//
//  Created by li lei on 2023/3/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeDepartureCell.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMineViewController.h"
#import "NoticeDanMuController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeVoiceDetailController.h"
@implementation NoticeDepartureCell

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
        
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 12, DR_SCREEN_WIDTH-60, 21)];
        _nickNameL.font = XGFifthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];
        
        self.infoL = [[UILabel alloc] initWithFrame:CGRectMake(55, 33,DR_SCREEN_WIDTH-55-15, 17)];
        self.infoL.font = TWOTEXTFONTSIZE;
        self.infoL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:self.infoL];

        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(55, 58, DR_SCREEN_WIDTH-79, 20)];
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.contentL];
        self.contentL.numberOfLines = 0;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(55, CGRectGetMaxY(self.contentL.frame)+10, DR_SCREEN_WIDTH-74, 40)];
        self.backView.layer.cornerRadius = 4;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.backView];
        
        self.backView.userInteractionEnabled = YES;
        
        self.markImageView = [[UIImageView alloc] init];
        self.markImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.markImageView.clipsToBounds = YES;
        [self.backView addSubview:self.markImageView];
        self.markImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bokeTap)];
        [self.backView addGestureRecognizer:tap];
        
        _nameL = [[UILabel alloc] init];
        _nameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView addSubview:_nameL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, CGRectGetMaxY(self.backView.frame)+11, DR_SCREEN_WIDTH-55-48-15, 16)];
        self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.timeL.font = TWOTEXTFONTSIZE;
        [self.contentView addSubview:self.timeL];
        
        self.comImageView = [[UIImageView alloc] init];
        self.comImageView.image = UIImageNamed(@"departcom_img");
        [self.contentView addSubview:self.comImageView];
    }
    return self;
}

- (void)bokeTap{
    
    if (self.lyModel.message_type.intValue == 19000 || self.lyModel.message_type.intValue == 19001){
        if (self.clickHelpTitleBlock) {
            self.clickHelpTitleBlock(self.lyModel);
        }
        return;
    }
    
    if (self.lyModel.message_type.intValue == 19010 || self.lyModel.message_type.intValue == 19011) {
        if (self.lyModel.bokeModel) {
            NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];
            ctl.bokeModel = self.lyModel.bokeModel;
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
            return;
        }
        [[NoticeTools getTopViewController] showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@",self.lyModel.podcast_id] Accept:@"application/vnd.shengxi.v4.9.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [[NoticeTools getTopViewController] hideHUD];
            if (success) {
                NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dict[@"data"]];
                NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];
                ctl.bokeModel = model;
                self.lyModel.bokeModel = model;
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
    }
}

- (void)setVoiceComModel:(NoticeDataLikeModel *)voiceComModel{
    _voiceComModel = voiceComModel;
    self.backView.hidden = YES;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:voiceComModel.fromUser.avatar_url] placeholderImage:UIImageNamed(@"Image_jynohe")];
    self.iconMarkView.image = UIImageNamed(voiceComModel.fromUser.levelImgIconName);
    self.nickNameL.text = voiceComModel.fromUser.nick_name;
    self.infoL.frame = CGRectMake(55, 33,DR_SCREEN_WIDTH-55-48-15, 17);
    if (voiceComModel.message_type.intValue == 17100) {
        self.infoL.text = [NoticeTools chinese:@"给你的心情留言了" english:@"commented on your mood" japan:@"はお気持ちにコメントした"];
    }else if (voiceComModel.message_type.intValue == 17101){
        self.infoL.text = [NSString stringWithFormat:@"%@“%@”",[NoticeTools chinese:@"回复了你的留言" english:@"replied to your comment" japan:@"は返事した"],voiceComModel.voice_parent_comment_content];
    }
    
    self.helpImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-48, 15, 48, 48);
    [self.helpImageView sd_setImageWithURL:[NSURL URLWithString:voiceComModel.voice_cover_img.length > 10 ?voiceComModel.voice_cover_img:voiceComModel.fromUser.avatar_url]];
    
    self.contentL.frame = CGRectMake(55, 58, DR_SCREEN_WIDTH-55-78, voiceComModel.voiceComHeight);
    self.contentL.attributedText = voiceComModel.voiceComAtt;
    
    self.timeL.text = voiceComModel.created_at;
    self.timeL.frame = CGRectMake(55, CGRectGetMaxY(self.contentL.frame)+11, 200, 17);
    self.comImageView.frame = CGRectMake(DR_SCREEN_WIDTH-20-78, CGRectGetMaxY(self.contentL.frame)+10, 20, 20);
}

- (void)setLyModel:(NoticeDataLikeModel *)lyModel{
    _lyModel = lyModel;
    if (lyModel.message_type.intValue == 19001) {
        self.iconImageView.hidden = YES;
        self.iconMarkView.image = UIImageNamed(@"Image_nimingpeiy");
        
    }else{
        self.iconImageView.hidden = NO;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:lyModel.fromUser.avatar_url] placeholderImage:UIImageNamed(@"Image_jynohe")];
        self.iconMarkView.image = UIImageNamed(lyModel.fromUser.levelImgIconName);
    }
    
    if (lyModel.message_type.intValue == 19001) {
        self.nickNameL.text = [NoticeTools chinese:@"作者" english:@"Author" japan:@"作者"];
    }else if (lyModel.message_type.intValue == 19000){
        self.nickNameL.text = [NoticeTools chinese:@"有热心民众" english:@"Someones" japan:@"熱心な民衆がいる"];
    }else if (lyModel.message_type.intValue == 8){
        self.nickNameL.text = [NoticeTools chinese:@"推送文章作者" english:@"The  artticle author" japan:@"文章の作者"];
    }else if (lyModel.message_type.intValue == 35){
        self.nickNameL.text = [NoticeTools chinese:@"每日一阅作者" english:@"The author" japan:@"作者"];
    }else{
        self.nickNameL.text = lyModel.fromUser.nick_name;
    }

    _helpImageView.hidden = YES;
    self.backView.hidden = NO;
    self.contentL.hidden = NO;
    
    if (lyModel.message_type.intValue == 48100 || lyModel.message_type.intValue == 48101){
        self.nameL.numberOfLines = 0;
        self.nameL.font = TWOTEXTFONTSIZE;
    }else{
        self.nameL.numberOfLines = 1;
        self.nameL.font = FOURTHTEENTEXTFONTSIZE;
    }
    
    self.backView.userInteractionEnabled = NO;
    if (lyModel.message_type.intValue == 48100 || lyModel.message_type.intValue == 48101) {
        
        self.contentL.attributedText = lyModel.dubbingAtt;
        self.contentL.frame = CGRectMake(55, 58, DR_SCREEN_WIDTH-79, lyModel.dubbingHeight);
        [self.markImageView sd_setImageWithURL:[NSURL URLWithString:lyModel.lineUser.avatar_url]];
        self.markImageView.frame = CGRectMake(0, 0, 40, 40);
        self.nameL.frame = CGRectMake(43, 0, self.backView.frame.size.width-45, 40);
        self.nameL.text = lyModel.line_content;
        if (lyModel.message_type.intValue == 48101){
            self.infoL.text = [NSString stringWithFormat:@"%@“%@”",[NoticeTools getLocalStrWith:@"each.replyPyCom"],lyModel.dubbing_parent_comment_content];
        }else{
            self.infoL.text = [NoticeTools getLocalStrWith:@"each.comPy"];
        }
        
    }else if (lyModel.message_type.intValue == 19000){
        self.infoL.text = self.infoL.text = [NoticeTools chinese:@"给你帖子留言了" english:@"commented your podcast" japan:@"があなたにコメントしました"];
        self.backView.userInteractionEnabled = YES;
        if (lyModel.comModel.content_type.intValue > 1) {
            self.helpImageView.hidden = NO;
            self.contentL.hidden = YES;
            [self.helpImageView sd_setImageWithURL:[NSURL URLWithString:lyModel.comModel.content]];
        }else{
            self.contentL.attributedText = lyModel.comAtt;
            self.contentL.frame = CGRectMake(55, 58, DR_SCREEN_WIDTH-79, lyModel.comHeight);
        }
        self.markImageView.image = UIImageNamed(@"depart_img");
        self.markImageView.frame = CGRectMake(10, 10, 20, 20);
        self.nameL.frame = CGRectMake(34, 0, self.backView.frame.size.width-45, 40);
        self.nameL.text = lyModel.invitation_title;
    }else if (lyModel.message_type.intValue == 19001){
        self.backView.userInteractionEnabled = YES;
        if (lyModel.comModel.content_type.intValue > 1) {
            self.infoL.text = [NSString stringWithFormat:@"%@“%@”",[NoticeTools getLocalStrWith:@"help.hotpeorep"],[NoticeTools getLocalStrWith:@"group.imgs"]];
        }else{
            self.infoL.text = [NSString stringWithFormat:@"%@“%@”",[NoticeTools getLocalStrWith:@"help.hotpeorep"],lyModel.comModel.content];
        }
        if (lyModel.subComModel.content_type.intValue > 1) {
            self.helpImageView.hidden = NO;
            self.contentL.hidden = YES;
            [self.helpImageView sd_setImageWithURL:[NSURL URLWithString:lyModel.subComModel.content]];
        }else{
            self.contentL.attributedText = lyModel.subComAtt;
            self.contentL.frame = CGRectMake(55, 58, DR_SCREEN_WIDTH-79, lyModel.subComHeight);
        }
        self.markImageView.image = UIImageNamed(@"depart_img");
        self.markImageView.frame = CGRectMake(10, 10, 20, 20);
        self.nameL.frame = CGRectMake(34, 0, self.backView.frame.size.width-45, 40);
        self.nameL.text = lyModel.invitation_title;
        
    }else if (lyModel.message_type.intValue == 19010 || lyModel.message_type.intValue == 19011){
        self.backView.userInteractionEnabled = YES;
        self.contentL.attributedText = lyModel.podcastAtt;
        self.contentL.frame = CGRectMake(55, 58, DR_SCREEN_WIDTH-79, lyModel.podcastHeight);
        
        [self.markImageView sd_setImageWithURL:[NSURL URLWithString:lyModel.podcast_cover_url]];
        self.markImageView.frame = CGRectMake(0, 0, 60, 40);
        self.nameL.frame = CGRectMake(68, 0, self.backView.frame.size.width-70, 40);
        self.nameL.text = lyModel.podcast_title;
        
        if (lyModel.message_type.intValue == 19011){
            self.infoL.text = [NSString stringWithFormat:@"%@“%@”",[NoticeTools chinese:@"回复了你的播客留言" english:@"replied to your comment" japan:@"があなたのコメントに返信しました"],lyModel.podcast_parent_comment_content];
        }else{
            self.infoL.text = [NoticeTools chinese:@"给你播客留言了" english:@"commented your podcast" japan:@"があなたにコメントしました"];
        }
    }else if (lyModel.message_type.intValue == 8){
        self.infoL.text = [NSString stringWithFormat:@"%@“%@”",[NoticeTools chinese:@"回复了你的留言" english:@"replied to your comment" japan:@"は返事した"],lyModel.html_parent_comment_content];
        
        self.contentL.attributedText = lyModel.htmlAtt;
        self.contentL.frame = CGRectMake(55, 58, DR_SCREEN_WIDTH-79, lyModel.htmlHeight);
        
        [self.markImageView sd_setImageWithURL:[NSURL URLWithString:lyModel.html_banner_url]];
        self.markImageView.frame = CGRectMake(0, 0, 60, 40);
        self.nameL.frame = CGRectMake(68, 0, self.backView.frame.size.width-70, 40);
        self.nameL.text = lyModel.html_title;
    }else if (lyModel.message_type.intValue == 35){
        self.infoL.text = [NSString stringWithFormat:@"%@“%@”",[NoticeTools chinese:@"回复了你的留言" english:@"replied to your comment" japan:@"は返事した"],lyModel.article_parent_comment_content];
        self.contentL.attributedText = lyModel.articleAtt;
        self.contentL.frame = CGRectMake(55, 58, DR_SCREEN_WIDTH-79, lyModel.articleHeight);
        self.markImageView.image = UIImageNamed(@"departread_img");
        self.markImageView.frame = CGRectMake(10, 10, 20, 20);
        self.nameL.frame = CGRectMake(34, 0, self.backView.frame.size.width-45, 40);
        self.nameL.text = lyModel.article_title;
    }else{
        self.backView.hidden = YES;
        self.backView.frame = CGRectMake(58,60, DR_SCREEN_WIDTH-58-20, 0);
        self.iconImageView.hidden = YES;
        self.infoL.text = @"";
        self.contentL.text = @"";
        self.nickNameL.text = @"请更新到最新版本查看";
    }
    
    if ((lyModel.message_type.intValue == 19000 && lyModel.comModel.content_type.intValue > 1) || (lyModel.message_type.intValue == 19001 && lyModel.subComModel.content_type.intValue > 1)){
        self.backView.frame = CGRectMake(58, CGRectGetMaxY(self.helpImageView.frame)+10, DR_SCREEN_WIDTH-58-20, 40);
    }else{
        self.backView.frame = CGRectMake(58, CGRectGetMaxY(self.contentL.frame)+10, DR_SCREEN_WIDTH-58-20, 40);
    }
    
    if (lyModel.message_type.intValue == 48100 || lyModel.message_type.intValue == 19000 || lyModel.message_type.intValue == 19010 || lyModel.message_type.intValue == 19011
        || lyModel.message_type.intValue == 8) {
        self.comImageView.hidden = NO;
    }else{
        self.comImageView.hidden = YES;
    }
    
    self.comImageView.frame = CGRectMake(DR_SCREEN_WIDTH-40, CGRectGetMaxY(self.backView.frame)+10, 20, 20);
    self.timeL.frame = CGRectMake(55, CGRectGetMaxY(self.backView.frame)+11, 200, 17);
    self.timeL.text = lyModel.created_at;
}

- (UIImageView *)helpImageView{
    if (!_helpImageView) {
        _helpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 58, 88, 88)];
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

- (void)bigLook{
    if (self.voiceComModel) {
        [[NoticeTools getTopViewController] showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",self.voiceComModel.voice_id] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [[NoticeTools getTopViewController] hideHUD];
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                self.voiceComModel.voiceM = model;
                if (model.content_type.intValue == 2) {
                    NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
                    ctl.voiceM = model;
                    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
                }else{
                    NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
                    ctl.voiceM = model;
                    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
                }
            }
        } fail:^(NSError *error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
        return;
    }
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.helpImageView;
    item.largeImageURL     = [NSURL URLWithString:self.lyModel.message_type.intValue==19000? self.lyModel.comModel.content:self.lyModel.subComModel.content];

    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow;
    [photoView presentFromImageView:self.helpImageView toContainer:toView animated:YES completion:nil];
}

- (void)userInfoTap{
     
    if (self.lyModel.message_type.intValue == 19000 || self.lyModel.message_type.intValue == 19001) {
        return;
    }

    NSString *userId = self.voiceComModel?self.voiceComModel.fromUser.userId: self.lyModel.fromUser.userId;
    if (self.lyModel.message_type.intValue == 8 || self.lyModel.message_type.intValue == 35) {
        userId = @"1";
    }

    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.userId = userId;
    ctl.isOther = [userId isEqualToString:[NoticeTools getuserId]] ? NO : YES;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
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
