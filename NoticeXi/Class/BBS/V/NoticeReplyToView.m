//
//  NoticeReplyToView.m
//  NoticeXi
//
//  Created by li lei on 2020/11/9.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeReplyToView.h"

@implementation NoticeReplyToView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:appdel.backImg?0.4:1];
        
        self.replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width-30, frame.size.height)];
        self.replyLabel.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.7];
        self.replyLabel.font = TWOTEXTFONTSIZE;
        [self addSubview:self.replyLabel];
    }
    return self;
}
@end
