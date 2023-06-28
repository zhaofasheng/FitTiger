//
//  NoticeBBSComent.h
//  NoticeXi
//
//  Created by li lei on 2020/11/5.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeSubComentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBBSComent : NSObject
@property (nonatomic, strong) NSString * __nullable caogaoText;//草稿
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *comment_content;
@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat subCommentHeight;
@property (nonatomic, assign) BOOL isGood;//是否点赞过
@property (nonatomic, strong) NSDictionary *to_user_info;//被艾特的用户信息
@property (nonatomic, strong) NoticeAbout *toUserInfo;

@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *to_user_id;//被@的用户ID

@property (nonatomic, strong) NSString *comment_status;//留言状态

@property (nonatomic, strong) NSDictionary *from_user_info;//留言人用户信息
@property (nonatomic, strong) NoticeAbout *userInfo;

@property (nonatomic, strong) NSString *post_id;

@property (nonatomic, strong) NSString *base_comment_id;//一级留言ID

@property (nonatomic, strong) NSString *like_id;//点赞id
@property (nonatomic, strong) NSString *comment_type;//留言类型
@property (nonatomic, strong) NSString *reply_num;//回复数量
@property (nonatomic, strong) NSString *like_num;//点赞数量
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSMutableArray *subCommentArr;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSString *zan_id;
@property (nonatomic, strong) NSString *zaned_num;

@property (nonatomic, assign) CGFloat replyTextHeight;
@property (nonatomic, strong) NoticeBBSComent * __nullable replyM;
@property (nonatomic, strong) NSDictionary * __nullable reply;
@property (nonatomic, strong) NSString *dubbing_id;

@property (nonatomic, strong) NSAttributedString *twoAttTextStr;
@property (nonatomic, assign) CGFloat twoTextHeight;//两行文字高度
- (void)hasDelete;
@end

NS_ASSUME_NONNULL_END
