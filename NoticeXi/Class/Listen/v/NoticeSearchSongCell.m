//
//  NoticeSearchSongCell.m
//  NoticeXi
//
//  Created by li lei on 2019/4/19.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSearchSongCell.h"

@implementation NoticeSearchSongCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = GetColorWithName(@"BackColor");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,15,55,55)];
        _postImageView.layer.cornerRadius = 5;
        _postImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_postImageView];
        
        _nameL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+15,18,DR_SCREEN_WIDTH-15-15-55, 16)];
        _nameL.textColor = GetColorWithName(VMainTextColor);
        _nameL.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:_nameL];
        
        _scorL = [[UILabel alloc] initWithFrame:CGRectMake(_nameL.frame.origin.x,CGRectGetMaxY(_nameL.frame)+10,_nameL.frame.size.width, 13)];
        _scorL.font = ELEVENTEXTFONTSIZE;
        _scorL.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:_scorL];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 84, DR_SCREEN_WIDTH, 1)];
        _line.backgroundColor = GetColorWithName(VlineColor);
        [self.contentView addSubview:_line];
    }
    return self;
}

- (void)setSong:(NoticeSong *)song{
    _song = song;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:song.album_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _nameL.text = song.song_name;
    _scorL.text = [NSString stringWithFormat:@"%@/%@",song.album_singer,song.album_name];
}

- (void)setMySong:(NoticeSong *)mySong{
    _mySong = mySong;
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:mySong.album_cover]
                      placeholderImage:GETUIImageNamed(@"img_empty")
                               options:SDWebImageRefreshCached];
    _nameL.text = mySong.song_name;
    _scorL.text = [NSString stringWithFormat:@"%@/%@",mySong.album_singer,mySong.album_name];
    _postImageView.frame = CGRectMake(15, 15, 100, 100);
    _nameL.frame = CGRectMake(CGRectGetMaxX(_postImageView.frame)+15,15,DR_SCREEN_WIDTH-15-15-15-100, 16);
    _scorL.frame = CGRectMake(_nameL.frame.origin.x,CGRectGetMaxY(_nameL.frame)+15,_nameL.frame.size.width, 13);
    _line.frame = CGRectMake(0, 129, DR_SCREEN_WIDTH, 1);
    self.moreL.hidden = NO;
    self.moreL.text = [NSString stringWithFormat:@"%@%@",mySong.voice_num,[NoticeTools getLocalStrWith:@"movie.voicedata"]];
}

//点击播放按钮
- (void)clickPlay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMBSPlayButton:)]) {
         [self.delegate clickMBSPlayButton:self.index];
     }
}

- (void)clickMoreTap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMBSMore:)]) {
         [self.delegate clickMBSMore:self.index];
     }
}

- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_postImageView.frame)+15,130-15-44, 44, 44)];
        [_playButton setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_dyplay":@"Image_dyplayy") forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playButton];
    }
    return _playButton;
}

- (UILabel *)moreL{
    if (!_moreL) {
        _moreL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.postImageView.frame)+15, 130-42,160, 42)];
        _moreL.font = FOURTHTEENTEXTFONTSIZE;
        _moreL.textColor = GetColorWithName(VMainThumeColor);
        _moreL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMoreTap)];
        [_moreL addGestureRecognizer:tap];
        [self.contentView addSubview:_moreL];
    }
    return _moreL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
