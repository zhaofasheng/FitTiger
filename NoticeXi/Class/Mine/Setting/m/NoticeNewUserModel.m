//
//  NoticeNewUserModel.m
//  NoticeXi
//
//  Created by li lei on 2021/8/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewUserModel.h"

@implementation NoticeNewUserModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"mp4Id":@"id"};
}

- (void)setMp4Id:(NSString *)mp4Id{
    _mp4Id = mp4Id;
    self.hasLook = [NoticeComTools getHasLookMp4:mp4Id];
}

@end
