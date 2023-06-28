//
//  NoticeHelpCommentModel.h
//  NoticeXi
//
//  Created by li lei on 2022/8/6.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeHelpCommentModel : NSObject
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *be_reply_status;//是否被回复
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *content_type;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *invitation_id;
@property (nonatomic, strong) NSString *is_like;
@property (nonatomic, strong) NSString *like_num;
@property (nonatomic, strong) NSDictionary *from_user;
@property (nonatomic, strong) NoticeAbout *fromUserM;
@property (nonatomic, strong) NSString *tieUserId;//发帖人用户id
@property (nonatomic, strong) NSArray * __nullable replys;
@property (nonatomic, strong) NSMutableArray *replyArr;

@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSAttributedString *textAttStr;

@property (nonatomic, assign) CGFloat subTextHeight;
@property (nonatomic, strong) NSString *subContentType;

@property (nonatomic, strong) NSString *invitation_comment_parent_id;//来自于举报的时候的判断，大于零代表举报的是回复，否则是评论
@property (nonatomic, assign) BOOL isJubaoCom;
@end

NS_ASSUME_NONNULL_END
