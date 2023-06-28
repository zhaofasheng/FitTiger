//
//  NoticePhotoHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2018/10/25.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticePhotoHeaderView.h"

@implementation NoticePhotoHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = GetColorWithName(VlistColor);
        
        self.tiemL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
        self.tiemL.textColor = GetColorWithName(VMainTextColor);
        self.tiemL.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.tiemL];
    }
    return self;
}

@end
