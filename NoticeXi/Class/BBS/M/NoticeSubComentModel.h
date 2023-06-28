//
//  NoticeSubComentModel.h
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeAbout.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSubComentModel : NSObject
@property (nonatomic, strong) NSString * __nullable caogaoText;//草稿
@property (nonatomic, strong) NSString *comment_content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSDictionary *from_user_info;
@property (nonatomic, assign) BOOL isGood;//是否点赞过
@property (nonatomic, strong) NoticeAbout *userInfo;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, assign) CGFloat comHeight;
@property (nonatomic, strong) NSMutableAttributedString *showComContent;

@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, strong) NSMutableAttributedString *allTextAttStr;
@property (nonatomic, strong) NSMutableAttributedString *hasToUseerIdAllTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;

@property (nonatomic, strong) NSString *comment_status;//留言状态

@property (nonatomic, strong) NSDictionary *to_user_info;//被艾特的用户信息
@property (nonatomic, strong) NoticeAbout *toUserInfo;

@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *to_user_id;//被@的用户ID

@property (nonatomic, strong) NSString *post_id;

@property (nonatomic, strong) NSString *base_comment_id;//一级留言ID

@property (nonatomic, strong) NSString *like_id;//点赞id
@property (nonatomic, strong) NSString *comment_type;//留言类型
@property (nonatomic, strong) NSString *reply_num;//回复数量
@property (nonatomic, strong) NSString *like_num;//点赞数量

- (void)sethHasToUserContent;
- (void)hasDelete;
- (void)reSetText;
@end

NS_ASSUME_NONNULL_END
