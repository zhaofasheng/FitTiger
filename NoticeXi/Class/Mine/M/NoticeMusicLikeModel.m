//
//  NoticeMusicLikeModel.m
//  NoticeXi
//
//  Created by li lei on 2023/2/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeMusicLikeModel.h"

@implementation NoticeMusicLikeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"likeId":@"id"};
}

- (void)setLevel:(NSString *)level{
    _level = level;

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

}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}
@end
