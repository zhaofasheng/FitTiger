//
//  NoticeTextZJMusicModel.m
//  NoticeXi
//
//  Created by li lei on 2021/1/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextZJMusicModel.h"

@implementation NoticeTextZJMusicModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"stateId":@"id"};
}

- (void)setBgm_info:(NSDictionary *)bgm_info{
    _bgm_info = bgm_info;
    self.bgmM = [NoticeBgmModel mj_objectWithKeyValues:bgm_info];
    self.hasListen = [NoticeComTools getHasbmgMp4:self.bgmM.bgmId];
}

- (void)setStateId:(NSString *)stateId{
    _stateId = stateId;
    
}
@end
