//
//  NoticeTieTieCaleModel.m
//  NoticeXi
//
//  Created by li lei on 2022/10/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeTieTieCaleModel.h"

@implementation NoticeTieTieCaleModel

- (void)setMonths:(NSArray *)months{
    _months = months;
    if (months.count) {
        self.monthModels = [[NSMutableArray alloc] init];
        for (NSDictionary *monthDic in months) {
            NoticeTieTieCaleModel *monthM = [NoticeTieTieCaleModel mj_objectWithKeyValues:monthDic];
            monthM.year = self.year;
            [self.monthModels addObject:monthM];
        }
    }
}

- (void)setDays:(NSArray *)days{
    _days = days;
    if (days.count) {
        self.dayModels = [[NSMutableArray alloc] init];
        for (NSDictionary *dayDic in days) {
            NoticeTieTieCaleModel *dayModel = [NoticeTieTieCaleModel mj_objectWithKeyValues:dayDic];
      
            [self.dayModels addObject:dayModel];
        }
    }
}

@end
