//
//  NoticeClockBdModel.m
//  NoticeXi
//
//  Created by li lei on 2019/11/11.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeClockBdModel.h"

@implementation NoticeClockBdModel

- (NSMutableArray *)tianshiArr{
    if (!_tianshiArr) {
        _tianshiArr = [NSMutableArray new];
    }
    return _tianshiArr;
}

- (NSMutableArray *)moguiArr{
    if (!_moguiArr) {
        _moguiArr = [NSMutableArray new];
    }
    return _moguiArr;
}

- (NSMutableArray *)shenArr{
    if (!_shenArr) {
        _shenArr = [NSMutableArray new];
    }
    return _shenArr;
}

- (void)setTop1:(NSArray *)top1{
    _top1 = top1;
    for (NSDictionary *dic in top1) {
        NoticeClockBdUser *bdUser = [NoticeClockBdUser mj_objectWithKeyValues:dic];
        [self.tianshiArr addObject:bdUser];
    }
}

- (void)setTop2:(NSArray *)top2{
    _top2 = top2;
    for (NSDictionary *dic in top2) {
        NoticeClockBdUser *bdUser = [NoticeClockBdUser mj_objectWithKeyValues:dic];
        [self.moguiArr addObject:bdUser];
    }
}

- (void)setTop3:(NSArray *)top3{
    _top3 = top3;
    for (NSDictionary *dic in top3) {
        NoticeClockBdUser *bdUser = [NoticeClockBdUser mj_objectWithKeyValues:dic];
        [self.shenArr addObject:bdUser];
    }
}

- (void)setUser_info:(NSDictionary *)user_info{
    _user_info = user_info;
    self.pyUserInfo = [NoticeUserInfoModel mj_objectWithKeyValues:user_info];
}
@end

