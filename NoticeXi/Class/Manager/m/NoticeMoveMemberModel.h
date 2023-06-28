//
//  NoticeMoveMemberModel.h
//  NoticeXi
//
//  Created by li lei on 2020/9/9.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeSubGroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMoveMemberModel : NSObject

@property (nonatomic, strong) NSString *moveId;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSDictionary *fromUserInfo;
@property (nonatomic, strong) NSDictionary *toUserInfo;
@property (nonatomic, strong) NSDictionary *assocInfo;
@property (nonatomic, strong) NoticeSubGroupModel *assocM;
@property (nonatomic, strong) NoticeUserInfoModel *fromUserM;
@property (nonatomic, strong) NoticeUserInfoModel *toUserM;

@end

NS_ASSUME_NONNULL_END
