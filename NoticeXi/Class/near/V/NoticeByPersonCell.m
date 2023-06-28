//
//  NoticeByPersonCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeByPersonCell.h"
#import "DDHAttributedMode.h"
@implementation NoticeByPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 73, 73)];
        _iconImageView.layer.cornerRadius = 7;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 10,(DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15-12)/2+25, 15)];
        _nickNameL.font = THRETEENTEXTFONTSIZE;
        _nickNameL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:_nickNameL];
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-150,12,150, 12)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textAlignment = NSTextAlignmentRight;
        _timeL.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:_timeL];

        //昵称
        _infoL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12,CGRectGetMaxY(_nickNameL.frame)+7,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15-12, 14)];
        _infoL.font = TWOTEXTFONTSIZE;
        _infoL.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:_infoL];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, CGRectGetMaxY(_infoL.frame)+8,110, 25)];
        _playerView.delegate = self;
        _playerView.isThird = YES;
        [self.contentView addSubview:_playerView];
        
        _storyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_playerView.frame), _playerView.frame.origin.y, DR_SCREEN_WIDTH-CGRectGetMaxY(_playerView.frame)-15, _playerView.frame.size.height)];
        //near.memlong
        _storyL.textColor = GetColorWithName(VDarkTextColor);
        _storyL.textAlignment = NSTextAlignmentRight;
        _storyL.font = ELEVENTEXTFONTSIZE;
        [self.contentView addSubview:_storyL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 89.5, DR_SCREEN_WIDTH-12-CGRectGetMaxX(_iconImageView.frame),0.5)];
        line.backgroundColor = GetColorWithName(VlineColor);
        [self.contentView addSubview:line];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.12;
        [self.playerView addGestureRecognizer:longPress];
    }
    return self;
}
- (void)longPressGestureRecognized:(id)sender{
    if (!_person.isPlaying) {//只有在播放或者暂停的时候才可以拖拽
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
                [self.delegate dragingFloat:(_person.wave_len.floatValue/self.playerView.frame.size.width)*p.x index:self.tag];
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
//点击了播放按钮
- (void)startPlay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop:)]) {
        [self.delegate startPlayAndStop:self.index];
    }
}

- (void)setBlackPerson:(NoticeNearPerson *)blackPerson{
    
}

- (void)setPerson:(NoticeNearPerson *)person{
    _person = person;
    _nickNameL.text = person.nick_name;
    _infoL.text = person.self_intro.length ? person.self_intro : GETTEXTWITE(@"set.nojianjie");
    _timeL.text = [NSString stringWithFormat:@"%@ · %@",person.distance,person.login_at];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:person.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    _playerView.voiceUrl = person.wave_url;
    _playerView.timeLen = person.wave_len;
    self.playerView.timeLen = person.nowTime.integerValue?person.nowTime: person.wave_len;

    self.playerView.slieView.progress = person.nowPro >0 ?person.nowPro:0;
    NSString *str = [NSString stringWithFormat:@"%@%@",GETTEXTWITE(@"near.memlong"),person.voice_total_len];
    _storyL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor colorWithHexString:WHITEMAINCOLOR] setLengthString:person.voice_total_len beginSize:6];
 
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
