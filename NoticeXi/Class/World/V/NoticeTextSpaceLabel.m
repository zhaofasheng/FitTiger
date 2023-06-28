//
//  NoticeTextSpaceLabel.m
//  NoticeXi
//
//  Created by li lei on 2023/2/23.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextSpaceLabel.h"

@implementation NoticeTextSpaceLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect{
      CGRect rect1 = CGRectMake(rect.origin.x + 3, rect.origin.y + 3, rect.size.width - 6, rect.size.height -6);

      [super drawTextInRect:rect1];
}

@end
