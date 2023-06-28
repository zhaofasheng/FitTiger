//
//  NoticeLy.h
//  NoticeXi
//
//  Created by li lei on 2018/11/27.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeLy : NSObject

@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSString *liuyanId;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, strong) NSAttributedString *allreadTextAttStr;
@property (nonatomic, assign) CGFloat height1;
@property (nonatomic, strong) NSString *is_zan;
@property (nonatomic, strong) NSString *like_num;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *article_id;

@property (nonatomic, strong) NSString *replyted_at;
@property (nonatomic, strong) NSString *reply_content;
@property (nonatomic, strong) NSAttributedString *replyTextAttStr;
@property (nonatomic, assign) CGFloat height2;
@property (nonatomic, strong) NSString *reply_avatar_url;
@end

NS_ASSUME_NONNULL_END
