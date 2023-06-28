//
//  NoticeVoiceListSubModel.m
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceListSubModel.h"
#import "NoticePsyModel.h"
@implementation NoticeVoiceListSubModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userId":@"id"};
}

- (void)setAvatar_url:(NSString *)avatar_url{
    NSArray *array = [avatar_url componentsSeparatedByString:@"?"];
    _avatar_url = array[0];
}

- (void)setLevel:(NSString *)level{
    _level = level;
    self.levelImgName = [NSString stringWithFormat:@"Image_leave%d",level.intValue>21?21:level.intValue];
    self.smallLevelImgName = [NSString stringWithFormat:@"Image_smalleave%d",level.intValue>21?21:level.intValue];
    if (level.intValue == 0) {
        self.levelImgIconName = @"Image_icon0";
    }else if (level.intValue > 0  & level.intValue < 4){
        self.levelImgIconName = @"Image_icon123";
    }else if (level.intValue > 3  & level.intValue < 7){
        self.levelImgIconName = @"Image_icon456";
    }else if (level.intValue > 6  & level.intValue < 10){
        self.levelImgIconName = @"Image_icon789";
    }else if (level.intValue > 9  & level.intValue < 13){
        self.levelImgIconName = @"Image_icon101112";
    }else if (level.intValue > 12  & level.intValue < 16){
        self.levelImgIconName = @"Image_icon131415";
    }else if (level.intValue > 15  & level.intValue < 19){
        self.levelImgIconName = @"Image_icon161718";
    }else{
        self.levelImgIconName = @"Image_icon192021";
    }

    self.levelName = [NSString stringWithFormat:@"Lv%@",level];
}

@end
