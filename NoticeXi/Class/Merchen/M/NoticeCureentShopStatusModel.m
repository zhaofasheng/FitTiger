//
//  NoticeCureentShopStatusModel.m
//  NoticeXi
//
//  Created by li lei on 2022/7/7.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeCureentShopStatusModel.h"

@implementation NoticeCureentShopStatusModel

- (void)setApply_stage:(NSString *)apply_stage{
    _apply_stage = apply_stage;
    self.status = apply_stage.intValue;
}

@end
