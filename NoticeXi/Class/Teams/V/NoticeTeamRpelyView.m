//
//  NoticeTeamRpelyView.m
//  NoticeXi
//
//  Created by li lei on 2023/6/15.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamRpelyView.h"

@implementation NoticeTeamRpelyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, frame.size.width-20-52, frame.size.height)];
        self.replyLabel.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.replyLabel.font = THRETEENTEXTFONTSIZE;
        [self addSubview:self.replyLabel];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-40, (self.frame.size.height-20)/2, 20, 20)];
        [closeBtn setImage:UIImageNamed(@"Image_replycloce") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    return self;
}


- (void)closeClick{
    if (self.closeUseBlock) {
        self.closeUseBlock(YES);
    }
}

@end
