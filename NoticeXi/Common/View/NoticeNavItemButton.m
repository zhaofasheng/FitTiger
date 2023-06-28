//
//  NoticeNavItemButton.m
//  NoticeXi
//
//  Created by li lei on 2020/8/31.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeNavItemButton.h"

@implementation NoticeNavItemButton

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height/2;
}

@end
