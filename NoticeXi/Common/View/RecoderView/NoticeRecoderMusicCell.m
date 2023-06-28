//
//  NoticeRecoderMusicCell.m
//  NoticeXi
//
//  Created by li lei on 2021/3/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeRecoderMusicCell.h"

@implementation NoticeRecoderMusicCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:0];
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-36)/2, (frame.size.height-36)/2, 36, 36)];
        iconImageView.layer.cornerRadius = 35/2;
        iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:iconImageView];
        
        
        self.musiceImageView = iconImageView;
        
        self.choiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.choiceView.layer.cornerRadius = frame.size.width/2;
        self.choiceView.layer.masksToBounds = YES;
        self.choiceView.layer.borderWidth = 2;
        self.choiceView.layer.borderColor = GetColorWithName(VMainThumeColor).CGColor;
        [self.contentView addSubview:self.choiceView];
        self.choiceView.hidden = YES;
        
        self.newsImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-20)/2,iconImageView.frame.origin.y-9, 20, 9)];
        self.newsImageView.image = UIImageNamed(@"Image_newbgm");
        self.newsImageView.alpha = 0.6;
        self.newsImageView.hidden = YES;
        [self.contentView addSubview:self.newsImageView];
    }
    return self;
}

- (void)setModel:(NoticeTextZJMusicModel *)model{
    _model = model;
    if (model.imgName) {
        self.musiceImageView.image = UIImageNamed(model.imgName);
    }else{
        [self.musiceImageView sd_setImageWithURL:[NSURL URLWithString:model.bgmM.image_url]];
    }
    
    self.choiceView.hidden = !model.isSelect;
    if (model.bgmM.audio_url.length > 10) {
        self.musiceImageView.alpha = model.isSelect?1:0.6;
        self.newsImageView.hidden = model.hasListen?YES:NO;
    }else{
        self.musiceImageView.alpha = 1;
        self.newsImageView.hidden = YES;
    }
    
    if (model.isSelect && !model.noNeedRic) {
        [self startAnimation];
    }else{
        [self stopAnimtion];
    }
}
- (void)startAnimation{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 10;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100;

    [self.musiceImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimtion{
    [self.musiceImageView.layer removeAllAnimations];
}
@end
