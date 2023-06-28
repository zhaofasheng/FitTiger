//
//  NoticeVoiceStatusModel.m
//  NoticeXi
//
//  Created by li lei on 2021/4/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceStatusModel.h"

@implementation NoticeVoiceStatusModel

- (void)setState:(NSArray *)state{
    _state = state;
    
    self.stateArr = [NSMutableArray new];
    for (NSDictionary *dic in state) {
        NoticeVoiceStatusDetailModel *detailM = [NoticeVoiceStatusDetailModel mj_objectWithKeyValues:dic];
        [self.stateArr addObject:detailM];
    }
}

@end
