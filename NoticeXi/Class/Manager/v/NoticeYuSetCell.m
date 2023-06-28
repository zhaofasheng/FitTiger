//
//  NoticeYuSetCell.m
//  NoticeXi
//
//  Created by li lei on 2019/9/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeYuSetCell.h"

@implementation NoticeYuSetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-15-170, 65)];
        self.markL.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.markL];
        self.markL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel)];
        [self.markL addGestureRecognizer:tap];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-170, 15,110, 35)];
        _playerView.delegate = self;
        _playerView.isThird = YES;
        [self.contentView addSubview:_playerView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), 0, 60, 65)];
        [btn setTitle:[NoticeTools getLocalStrWith:@"em.rerecoder"] forState:UIControlStateNormal];
        [btn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [btn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        self.reButton = btn;
        
        self.messageImage = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-170+(110-35), 15, 35, 35)];
        [self.contentView addSubview:self.messageImage];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.12;
        [self.playerView addGestureRecognizer:longPress];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, 1)];
        line.backgroundColor = GetColorWithName(VlineColor);
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reRecord:)]) {
        [self.delegate reRecord:self.index];
    }
}

- (void)tapLabel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reInput:)]) {
        [self.delegate reInput:self.index];
    }
}

- (void)longPressGestureRecognized:(id)sender{
    if (!_model.isPlaying) {//只有在播放或者暂停的时候才可以拖拽
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
                [self.delegate dragingFloat:(_model.resource_len.floatValue/self.playerView.frame.size.width)*p.x index:self.tag];
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

- (void)setModel:(NoticeYuSetModel *)model{
    _model = model;
    _markL.text = model.reply_remark;

    _markL.textColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    _playerView.voiceUrl = model.resource_url;
    _playerView.timeLen = model.resource_len;
    self.playerView.timeLen = model.nowTime.integerValue?model.nowTime: model.resource_len;
    
    self.playerView.slieView.progress = model.nowPro >0 ?model.nowPro:0;
    
    self.playerView.hidden = model.resource_type.intValue == 1?NO:YES;
    self.messageImage.hidden = !self.playerView.hidden;
    [self.reButton setTitle:model.resource_type.intValue==1?[NoticeTools getLocalStrWith:@"em.rerecoder"]:@"重传" forState:UIControlStateNormal];
    if (!self.messageImage.hidden) {
        [self.messageImage sd_setImageWithURL:[NSURL URLWithString:model.resource_url] placeholderImage:UIImageNamed(@"Image_yuseimg")];
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
