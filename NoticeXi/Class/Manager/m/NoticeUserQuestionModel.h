//
//  NoticeUserQuestionModel.h
//  NoticeXi
//
//  Created by li lei on 2021/6/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserQuestionModel : NSObject
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSString *read_at;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *sysmsg_id;
@property (nonatomic, strong) NSDictionary *userInfo;//这个模型里的用户id是piPeiId
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, strong) NSDictionary *sysmsgInfo;
@property (nonatomic, strong) NoticeMessage *msgM;
@property (nonatomic, strong) NSString *questionId;
@end

NS_ASSUME_NONNULL_END
