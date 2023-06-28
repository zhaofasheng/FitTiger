//
//  NoticeVoiceComModel.h
//  NoticeXi
//
//  Created by li lei on 2022/2/23.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceListSubModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceComModel : NSObject

@property (nonatomic, strong) NSString *voice_id;
@property (nonatomic, strong) NSString *subId;
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, strong) NSString *reply_num;
@property (nonatomic, strong) NSString *like_num;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *is_like;
@property (nonatomic, strong) NSString *is_allow_reply;

@property (nonatomic, strong) NSArray *replys;
@property (nonatomic, strong) NSMutableArray *replysArr;

@property (nonatomic, strong) NoticeVoiceListSubModel *fromUser;
@property (nonatomic, strong) NSDictionary *from_user;

@property (nonatomic, strong) NSString *comment_status;
@property (nonatomic, strong) NSAttributedString *mainTextAttStr;
@property (nonatomic, strong) NSAttributedString *subTextAttStr;
@property (nonatomic, assign) CGFloat mainTextHeight;
@property (nonatomic, assign) CGFloat subTextHeight;
@end

NS_ASSUME_NONNULL_END
