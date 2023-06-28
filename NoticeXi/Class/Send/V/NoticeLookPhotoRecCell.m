//
//  NoticeLookPhotoRecCell.m
//  NoticeXi
//
//  Created by li lei on 2022/3/28.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeLookPhotoRecCell.h"

@implementation NoticeLookPhotoRecCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        self.titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleImageView.clipsToBounds = YES;
        self.titleImageView.layer.cornerRadius = 2;
        self.titleImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.titleImageView];
        
        self.choiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        self.choiceView.layer.borderColor = [UIColor colorWithHexString:@"#F29997"].CGColor;
        self.choiceView.layer.borderWidth = 2;
        self.choiceView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.choiceView.layer.cornerRadius = 2;
        self.choiceView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.choiceView];
        self.choiceView.hidden = YES;
    }
    return self;
}

- (void)setCurrentChoiceM:(NoticeVoiceTypeModel *)currentChoiceM{
    _currentChoiceM = currentChoiceM;
    self.choiceView.hidden = currentChoiceM.isChoice?NO:YES;
    self.titleImageView.image = currentChoiceM.currentImg;
}

@end
