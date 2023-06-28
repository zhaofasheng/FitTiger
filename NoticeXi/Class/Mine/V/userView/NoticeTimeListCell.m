//
//  NoticeTimeListCell.m
//  NoticeXi
//
//  Created by li lei on 2018/12/20.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTimeListCell.h"

@implementation NoticeTimeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40-22, 49.5)];
        _timeL.font = SIXTEENTEXTFONTSIZE;
        _timeL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:_timeL];
        
        _noticeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(22, 14, 22, 22)];
        _noticeImageV.image = UIImageNamed(@"Image_voice_sgj");
        _noticeImageV.hidden = YES;
        [self.contentView addSubview:_noticeImageV];
        
        _lockImageV = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-22, 14, 22, 22)];
        _lockImageV.image = UIImageNamed(@"Imagelock");
        _lockImageV.hidden = YES;
        [self.contentView addSubview: _lockImageV];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = GetColorWithName(VlineColor);
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setVoice:(NoticeVoiceListModel *)voice{
    _voice = voice;
    _timeL.text = voice.timeSgj;
    _lockImageV.hidden = !voice.is_private.integerValue;
    if (voice.isPlaying) {
        _noticeImageV.hidden = NO;
        _timeL.textColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        _timeL.frame = CGRectMake(20+22+7, 0, DR_SCREEN_WIDTH-40-22, 49.5);
    }else{
        _noticeImageV.hidden = YES;
        _timeL.textColor = GetColorWithName(VMainTextColor);
        _timeL.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40-22, 49.5);
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
