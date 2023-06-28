//
//  NoticeLocalImageCell.m
//  NoticeXi
//
//  Created by li lei on 2021/3/23.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeLocalImageCell.h"

@implementation NoticeLocalImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.localLmageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (DR_SCREEN_WIDTH-6)/3, (DR_SCREEN_WIDTH-6)/3)];
        self.localLmageView.contentMode = UIViewContentModeScaleAspectFill;
        self.localLmageView.clipsToBounds = YES;
        [self.contentView addSubview:self.localLmageView];
    }
    return self;
}

@end
