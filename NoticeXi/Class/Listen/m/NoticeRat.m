//
//  NoticeRat.m
//  NoticeXi
//
//  Created by li lei on 2018/11/10.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeRat.h"

@implementation NoticeRat

- (void)setAvatar_url:(NSString *)avatar_url{
    NSArray *arr = [avatar_url componentsSeparatedByString:@"?"];
    _avatar_url = arr[0];
}

@end
