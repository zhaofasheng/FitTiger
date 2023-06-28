//
//  NoticeManagerGroupReplyModel.h
//  NoticeXi
//
//  Created by li lei on 2020/9/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeManagerGroupReplyModel : NSObject
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *replyId;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NoticeUserInfoModel *userM;

@property (nonatomic, strong) NSString *assocId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@end

NS_ASSUME_NONNULL_END
