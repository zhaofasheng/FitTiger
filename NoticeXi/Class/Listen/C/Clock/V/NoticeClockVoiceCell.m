//
//  NoticeClockVoiceCell.m
//  NoticeXi
//
//  Created by li lei on 2019/11/12.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeClockVoiceCell.h"
#import "AppDelegate.h"
@implementation NoticeClockVoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.choiceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(30,(65-11)/2, 11, 11)];
        self.choiceImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_choiceVoice":@"Image_choiceVoicey");
        [self.contentView addSubview:self.choiceImgView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.choiceImgView.frame)+15, 0, DR_SCREEN_WIDTH-11-15-30-15, 65)];
        self.nameL.font = FOURTHTEENTEXTFONTSIZE;
        self.nameL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:self.nameL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DR_SCREEN_WIDTH, 1)];
        line.backgroundColor = GetColorWithName(VlistColor);
        [self.contentView addSubview:line];
        
        self.stopLabel = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-70, 0,70, 65)];
        self.stopLabel.textAlignment = NSTextAlignmentRight;
        self.stopLabel.font = TWOTEXTFONTSIZE;
        self.stopLabel.textColor = GetColorWithName(VMainThumeColor);
        [self.contentView addSubview:self.stopLabel];
        self.stopLabel.text = @"停止播放";
        self.stopLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopPlayLocalMusice)];
        [self.stopLabel addGestureRecognizer:tap];
        self.stopLabel.hidden = YES;
    }
    return self;
}

- (void)stopPlayLocalMusice{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    self.stopLabel.hidden = YES;
}

- (void)setCacheModel:(NoticeClockChaceModel *)cacheModel{
    self.nameL.text = cacheModel.voiceNameUrl;
    self.choiceImgView.hidden = cacheModel.isChoice.integerValue?NO:YES;
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
