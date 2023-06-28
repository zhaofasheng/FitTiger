//
//  NoticeLeaderModel.m
//  NoticeXi
//
//  Created by li lei on 2022/3/10.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeLeaderModel.h"

@implementation NoticeLeaderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"leadId":@"id"};
}

- (void)setResult:(NSArray *)result{
    _result = result;
    if (result.count) {
        self.firstArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in result) {
            [self.firstArr addObject:[NoticeRecesouceModel mj_objectWithKeyValues:dic]];
        }
    }
}

- (void)setResult_two:(NSArray *)result_two{
    _result_two = result_two;
    if (result_two.count) {
        self.secondArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in result_two) {
            [self.secondArr addObject:[NoticeRecesouceModel mj_objectWithKeyValues:dic]];
        }
    }
}

- (void)setResult_three:(NSArray *)result_three{
    _result_three = result_three;
    if (result_three.count) {
        self.thirdArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in result_three) {
            [self.thirdArr addObject:[NoticeRecesouceModel mj_objectWithKeyValues:dic]];
        }
    }
}
@end
