//
//  NoticeContributionModel.m
//  NoticeXi
//
//  Created by li lei on 2020/11/13.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeContributionModel.h"

@implementation NoticeContributionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"tougaoId":@"id"};
}
- (void)setAnnexs:(NSArray *)annexs{
    _annexs = annexs;
    self.annexsArr = [NSMutableArray new];
    for (NSDictionary *dic in annexs) {
        NoticeAnnexsModel *annexsM = [NoticeAnnexsModel mj_objectWithKeyValues:dic];
        [self.annexsArr addObject:annexsM];
    }
}

- (void)setFrom_user_info:(NSDictionary *)from_user_info{
    _from_user_info = from_user_info;
    self.userInfo = [NoticeAbout mj_objectWithKeyValues:from_user_info];
}

@end
