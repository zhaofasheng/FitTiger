//
//  DrawLikeModel.m
//  NoticeXi
//
//  Created by li lei on 2019/7/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "DrawLikeModel.h"

@implementation DrawLikeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"likeId":@"id"};
}
- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}
- (void)setNick_name:(NSString *)nick_name{
    
    if ([self.like_type isEqualToString:@"1"]) {
        _nick_name = @"匿名鉴赏家";
    }else{
        _nick_name = nick_name;
    }
}
@end
