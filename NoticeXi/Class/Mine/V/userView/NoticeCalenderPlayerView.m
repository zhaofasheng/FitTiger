//
//  NoticeCalenderPlayerView.m
//  NoticeXi
//
//  Created by li lei on 2019/12/31.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeCalenderPlayerView.h"

@implementation NoticeCalenderPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *backimgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backimgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_playerCenter":@"Image_playerCentery");
        [self addSubview:backimgView];
        self.userInteractionEnabled = YES;
        backimgView.userInteractionEnabled = YES;
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(17, 11, frame.size.width-34-90-25, 13)];
        self.timeL.font = THRETEENTEXTFONTSIZE;
        self.timeL.textColor = GetColorWithName(VMainThumeColor);
        [backimgView addSubview:self.timeL];
        
        UILabel *typeL = [[UILabel alloc] initWithFrame:CGRectMake(17,CGRectGetMaxY(self.timeL.frame)+9, frame.size.width-34-90-25, 11)];
        typeL.text = [NoticeTools getTextWithSim:@"随机播放中" fantText:@"隨機播放中"];
        typeL.font = ELEVENTEXTFONTSIZE;
        typeL.textColor = GetColorWithName(VMainThumeColor);
        [backimgView addSubview:typeL];
        
        NSArray *arr = @[@"停止",[NoticeTools getLocalStrWith:@"sendTextt.look"]];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(132+(45+25)*i, 14, 45, 25)];
            button.layer.cornerRadius = 25/2;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1;
            button.layer.borderColor = GetColorWithName(VMainThumeColor).CGColor;
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
            button.titleLabel.font = TWOTEXTFONTSIZE;
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [backimgView addSubview:button];
        }
    }
    return self;
}

- (void)buttonClick:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(StopOrLookClick:)]) {
        [self.delegate StopOrLookClick:!button.tag];
    }
}

@end
