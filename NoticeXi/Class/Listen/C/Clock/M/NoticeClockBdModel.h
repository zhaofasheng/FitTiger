//
//  NoticeClockBdModel.h
//  NoticeXi
//
//  Created by li lei on 2019/11/11.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeClockBdUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeClockBdModel : NSObject
@property (nonatomic, strong) NSMutableArray *tianshiArr;
@property (nonatomic, strong) NSMutableArray *moguiArr;
@property (nonatomic, strong) NSMutableArray *shenArr;

@property (nonatomic, strong) NSArray *top1;
@property (nonatomic, strong) NSArray *top2;
@property (nonatomic, strong) NSArray *top3;

@property (nonatomic, strong) NoticeClockBdUser *tianshiUser;
@property (nonatomic, strong) NoticeClockBdUser *moguiUser;
@property (nonatomic, strong) NoticeClockBdUser *shenUser;

@property (nonatomic, strong) NSString *num1;
@property (nonatomic, strong) NSString *num2;
@property (nonatomic, strong) NSString *num3;

@property (nonatomic, strong) NSString *dubbing_num;//台词被配音数量
@property (nonatomic, strong) NSDictionary *user_info;//被配音者信息
@property (nonatomic, strong) NoticeUserInfoModel *pyUserInfo;
@end

NS_ASSUME_NONNULL_END
