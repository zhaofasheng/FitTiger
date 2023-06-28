//
//  NoticeRightNowCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeRightNowCell.h"

@implementation NoticeRightNowCell
{
    UIView *_line;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, 160, 13)];
        _nickNameL.font = TWOTEXTFONTSIZE;
        _nickNameL.textColor = GetColorWithName(VMainTextColor);
        _nickNameL.text = GETTEXTWITE(@"listen.noName");
        [self.contentView addSubview:_nickNameL];
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_nickNameL.frame)+6, 200, 12)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = GetColorWithName(VDarkTextColor);
        _timeL.text = GETTEXTWITE(@"listen.destroy");
        [self.contentView addSubview:_timeL];
        
        //右上角按钮
        _topiceButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-60, 14, 60, 30)];
        _topiceButton.titleLabel.font = ELEVENTEXTFONTSIZE;
        [_topiceButton setTitle:[NoticeTools getLocalStrWith:@"chat.jubao"] forState:UIControlStateNormal];
        [_topiceButton addTarget:self action:@selector(jubaoClick) forControlEvents:UIControlEventTouchUpInside];
        [_topiceButton setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        [self.contentView addSubview:_topiceButton];

        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_timeL.frame)+18, 150, 45)];
        [self.contentView addSubview:_playerView];

        self.imageViewS = [[NoticeVoiceImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_playerView.frame)+15, DR_SCREEN_WIDTH-30, (DR_SCREEN_WIDTH-30-6)/2)];
        [self.contentView addSubview:self.imageViewS];
        self.imageViewS.hidden = YES;
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _line.backgroundColor = GetColorWithName(VlistColor);
        [self.contentView addSubview:_line];
    }
    return self;
}

- (void)setRightNow:(NoticeVoiceListModel *)rightNow{
    _rightNow = rightNow;
    self.imageViewS.hidden = rightNow.img_list.count ? NO  : YES;
    self.imageViewS.imgArr = rightNow.img_list;
    _playerView.voiceUrl = rightNow.voice_url;
    _playerView.timeLen = rightNow.voice_len;
    _line.frame = CGRectMake(0, rightNow.img_list.count ? (119 + (DR_SCREEN_WIDTH-30 - 6)/2+15)-8+15 : 119-8+15, DR_SCREEN_WIDTH, 8);
    if ([rightNow.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {
        _topiceButton.hidden = YES;
    }else{
        _topiceButton.hidden = NO;
    }
}

- (void)jubaoClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(policeWith:)]) {
        [self.delegate policeWith:self.index];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
