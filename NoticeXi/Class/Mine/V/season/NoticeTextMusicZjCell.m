//
//  NoticeTextMusicZjCell.m
//  NoticeXi
//
//  Created by li lei on 2021/1/20.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextMusicZjCell.h"

@implementation NoticeTextMusicZjCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = GetColorWithName(VBackColor);
        self.imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        self.imagView.layer.cornerRadius = 55/2;
        self.imagView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imagView];
        
        if (![NoticeTools isWhiteTheme]) {
            UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
            mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            [self.imagView addSubview:mbView];
        }
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imagView.frame)+10, 55, 16)];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        self.titleL.font = THRETEENTEXTFONTSIZE;
        self.titleL.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:self.titleL];
        
        self.choiceImagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        self.choiceImagView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"wenzizhuanjiyc":@"wenzizhuanjibc");
        [self.contentView addSubview:self.choiceImagView];
    }
    return self;
}

- (void)setMusicM:(NoticeTextZJMusicModel *)musicM{
    _musicM = musicM;
    self.titleL.text = musicM.name;
    self.imagView.image = UIImageNamed(musicM.imgName);
    self.choiceImagView.hidden = !musicM.isSelect;
    if (musicM.isSelect) {
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

    [self.imagView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimtion{
    [self.imagView.layer removeAllAnimations];
}
@end
