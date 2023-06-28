//
//  NoticeTextMBSTieleView.m
//  NoticeXi
//
//  Created by li lei on 2020/7/13.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextMBSTieleView.h"

@implementation NoticeTextMBSTieleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,(self.frame.size.height-33)/2, 24, 33)];
        [self addSubview:self.titleImageView];
        self.titleImageView.layer.cornerRadius = 2.5;
        self.titleImageView.layer.masksToBounds = YES;
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(self.titleImageView.frame)+7,0,self.frame.size.width-33-7-20,self.frame.size.height)];
        self.nameL.textColor = GetColorWithName(VMainTextColor);
        [self addSubview:self.nameL];
        self.nameL.font = EIGHTEENTEXTFONTSIZE;
    }
    return self;
}

@end
