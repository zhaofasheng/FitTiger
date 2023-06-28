//
//  NoticeSacnModel.m
//  NoticeXi
//
//  Created by li lei on 2020/6/30.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeSacnModel.h"

@implementation NoticeSacnModel
- (void)setResult:(NSDictionary *)result{
    _result = result;
    self.resultModel = [NoticeScanResult mj_objectWithKeyValues:result];
}
@end
