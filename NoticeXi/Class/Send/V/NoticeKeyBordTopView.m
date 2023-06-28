//
//  NoticeKeyBordTopView.m
//  NoticeXi
//
//  Created by li lei on 2020/7/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeKeyBordTopView.h"

@implementation NoticeKeyBordTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];

        
        self.photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (frame.size.height-40)/2,40, 40)];
        [self.photoBtn setBackgroundImage:UIImageNamed(@"Image_textchoiceimg") forState:UIControlStateNormal];
        [self addSubview:self.photoBtn];
        
        self.topicBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoBtn.frame)+20,(frame.size.height-40)/2,40, 40)];
        [self.topicBtn setBackgroundImage:UIImageNamed(@"tool_topic") forState:UIControlStateNormal];
        [self addSubview:self.topicBtn];
        
        self.statusBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.topicBtn.frame)+20,(frame.size.height-40)/2,40, 40)];
        [self.statusBtn setBackgroundImage:UIImageNamed(@"toool_status") forState:UIControlStateNormal];
        [self addSubview:self.statusBtn];
        
        self.shareButton = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-66, (frame.size.height-26)/2, 66, 26)];
        self.shareButton.layer.cornerRadius = 13;
        self.shareButton.layer.masksToBounds = YES;
        self.shareButton.backgroundColor = [UIColor colorWithHexString:@"#8FC2FF"];
        self.shareButton.buttonImagePosition = FSCustomButtonImagePositionRight;
        [self.shareButton setImage:UIImageNamed(@"Image_typevoic") forState:UIControlStateNormal];
        [self.shareButton setTitle:[NoticeTools getLocalStrWith:@"n.open"] forState:UIControlStateNormal];
        self.shareButton.titleLabel.font = TWOTEXTFONTSIZE;
        [self.shareButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self addSubview:self.shareButton];
    }
    return self;
}


@end
