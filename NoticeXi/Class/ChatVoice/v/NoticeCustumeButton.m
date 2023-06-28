//
//  NoticeCustumeButton.m
//  NoticeXi
//
//  Created by li lei on 2020/8/26.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeCustumeButton.h"

@implementation NoticeCustumeButton

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height/2;
}

@end
