//
//  NoticeManagerModel.h
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeManagerModel : NSObject
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *managerId;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *resource_len;
@property (nonatomic, strong) NSString *resource_type;
@property (nonatomic, strong) NSString *resource_url;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *voice_id;
@property (nonatomic, assign) CGFloat nowPro;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSString *nowTime;
@property (nonatomic, strong) NSString *resource_content;
@property (nonatomic, strong) NSString *recognition_content;
@property (nonatomic, strong) NSString *voice_user_id;
@property (nonatomic, strong) NSString *pointValue;
@property (nonatomic, assign) BOOL hasRead;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) NSString *chat_type;
@property (nonatomic, strong) NSString *sensitive_url;
@property (nonatomic, strong) NSString *resource_id;
@property (nonatomic, strong) NSString *dialog_status;
@property (nonatomic, strong) NSString *card_title;

@property (nonatomic, strong) NSArray *comment;
@property (nonatomic, strong) NSDictionary *voice;
@end

NS_ASSUME_NONNULL_END
