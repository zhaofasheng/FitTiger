//
//  NoticeTextTopicView.m
//  NoticeXi
//
//  Created by li lei on 2022/3/30.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextTopicView.h"

@implementation NoticeTextTopicView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.nameView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 0, 20)];
        self.nameView.backgroundColor = [[UIColor colorWithHexString:@"#456DA0"] colorWithAlphaComponent:0.2];
        self.nameView.layer.cornerRadius = 10;
        self.nameView.layer.masksToBounds = YES;
        
        [self addSubview:self.nameView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 12, 12)];
        label.text = @"#";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:8];
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.layer.cornerRadius = 6;
        label.layer.masksToBounds = YES;
        label.backgroundColor = [UIColor colorWithHexString:@"#456DA0"];
        [self.nameView addSubview:label];
                
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 0,20)];
        self.nameL.font = ELEVENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#456DA0"];
        [self.nameView addSubview:self.nameL];
 
        self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameView.frame)+12, 0, 20, 20)];
        [self.closeBtn setBackgroundImage:UIImageNamed(@"ly_xxx") forState:UIControlStateNormal];
        [self addSubview:self.closeBtn];
    }
    return self;
}

- (void)setTopicM:(NoticeTopicModel *)topicM{
    _topicM = topicM;
    self.nameL.text = topicM.topic_name;
    self.nameL.frame = CGRectMake(20, 0, GET_STRWIDTH(self.nameL.text, 11, 20), 20);
    self.nameView.frame = CGRectMake(15, 0, self.nameL.frame.size.width+10+20, 20);
    self.closeBtn.frame = CGRectMake(CGRectGetMaxX(self.nameView.frame)+12, 0, 20, 20);
}
@end
