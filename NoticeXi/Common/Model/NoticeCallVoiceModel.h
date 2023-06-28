//
//  NoticeCallVoiceModel.h
//  NoticeXi
//
//  Created by li lei on 2021/10/21.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCallVoiceModel : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *recordId;

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NoticeUserInfoModel *userM;

@end

NS_ASSUME_NONNULL_END
