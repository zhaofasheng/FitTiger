//
//  NoticeTieTieModel.m
//  NoticeXi
//
//  Created by li lei on 2022/4/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeTieTieModel.h"

@implementation NoticeTieTieModel

- (void)setSign_list:(NSArray *)sign_list{
    _sign_list = sign_list;
    if (_sign_list.count) {
        self.list = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in _sign_list) {
            NoticeTieTieModel *model = [NoticeTieTieModel mj_objectWithKeyValues:dic];
            [self.list addObject:model];
        }
    }
}

- (void)setPast_info:(NSDictionary *)past_info{
    _past_info = past_info;
    self.pastModel = [NoticeTieTieModel mj_objectWithKeyValues:past_info];
}

- (void)setFuture_info:(NSDictionary *)future_info{
    _future_info = future_info;
    self.futureModel = [NoticeTieTieModel mj_objectWithKeyValues:future_info];
}

- (void)setDate:(NSString *)date{
    _date = date;
    NSArray *arr = [date componentsSeparatedByString:@"-"];
    if (arr.count == 3) {
        self.year = [arr[0] intValue];
        self.month = [arr[1] intValue];
        self.day = [arr[2] intValue];
    }
}

- (void)setContinuity_text:(NSString *)continuity_text{
    _continuity_text = continuity_text;
    self.textHeight = [NoticeTools getHeightWithLineHight:8 font:15 width:DR_SCREEN_WIDTH-40-30 string:continuity_text];
    self.allTextAttStr = [NoticeTools getStringWithLineHight:8 string:continuity_text];
}



@end
