//
//  NoticeUseTextView.m
//  NoticeXi
//
//  Created by li lei on 2020/12/16.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeUseTextView.h"

@implementation NoticeUseTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        _callChatNameL = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.frame.size.width-15-22, 30)];
        _callChatNameL.font = XGTHREEBoldFontSize;
        [self addSubview:_callChatNameL];
        
        _callChatContentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.frame.size.width-20,0)];
        _callChatContentL.font = TWOTEXTFONTSIZE;
        _callChatContentL.numberOfLines = 0;
        [self addSubview:_callChatContentL];
        
        self.callChatNameL.textColor = [UIColor colorWithHexString:@"#E1E2E6"];
        self.callChatContentL.textColor = [UIColor colorWithHexString:@"#E1E2E6"];
        
        self.upImageView = [[UIImageView alloc] init];
        self.upImageView.frame = CGRectMake(self.frame.size.width-3-22, 4, 22, 22);
        self.upImageView.userInteractionEnabled = YES;
        [self addSubview:self.upImageView];
        
        self.upImageView.image = UIImageNamed(@"Image_upms_b");
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(msgLocationTap)];
        [self.upImageView addGestureRecognizer:tap];
    }
    return self;
}

- (void)msgLocationTap{
    if (self.locationUseBlock) {
        self.locationUseBlock(YES);
    }
}

- (void)setChatModel:(NoticeTeamChatModel *)chatModel{
    _chatModel = chatModel;
    
    self.frame = CGRectMake(10, 10, _chatModel.textWidth, 30+_chatModel.callChatTextHeight+8);
    self.callChatNameL.frame = CGRectMake(8, 8, self.frame.size.width-8-30, 18);
    self.upImageView.frame = CGRectMake(self.frame.size.width-28, 7, 20, 20);
    self.callChatContentL.frame = CGRectMake(8, 30, chatModel.callChatTextWidth, chatModel.callChatTextHeight);
    
    self.callChatNameL.text = chatModel.userMsg.fromUserM.mass_nick_name;
    self.callChatContentL.attributedText = chatModel.callChatAttStr;
    
    self.upImageView.image = UIImageNamed(_chatModel.isSelf?@"Image_upms_b":@"Image_upm_b");
    self.backgroundColor = [UIColor colorWithHexString:_chatModel.isSelf?@"#0090D9":@"#EDEFF7"];
    self.callChatNameL.textColor = [UIColor colorWithHexString:_chatModel.isSelf?@"#E1E4F0":@"#5C5F66"];
    self.callChatContentL.textColor = [UIColor colorWithHexString:_chatModel.isSelf?@"#E1E4F0":@"#5C5F66"];
}

- (void)setIsSelf:(BOOL)isSelf{
    _isSelf = isSelf;
    if (isSelf) {
        self.backgroundColor = [UIColor colorWithHexString:@"#0090D9"];
    }
    else{
        self.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    }
    self.upImageView.frame = CGRectMake(self.frame.size.width-3-22, 4, 22, 22);
}

@end
