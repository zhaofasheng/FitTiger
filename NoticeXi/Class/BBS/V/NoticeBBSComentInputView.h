//
//  NoticeBBSComentInputView.h
//  NoticeXi
//
//  Created by li lei on 2020/11/9.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeReplyToView.h"
#import "NoticeBBSComent.h"
#import "NoticeScroEmtionView.h"
#import "NoticeChocieImgListView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticeBBSComentInputDelegate <NSObject>

@optional
- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId;
- (void)sendWithComment:(NSString *)comment subCommentId:(NSString *)subcommentId;
- (void)sendWithComment:(NSString *)comment toUserId:(NSString *)userId subCommentId:(NSString *)subcommentId;
@end

@interface NoticeBBSComentInputView : UIView<UITextViewDelegate>
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, weak) id <NoticeBBSComentInputDelegate>delegate;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NoticeReplyToView *replyToView;
@property (nonatomic, strong) NSString *replyTo;
@property (nonatomic, strong) NSString *saveKey;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NoticeBBSComent *commentM;
@property (nonatomic, strong) NoticeSubComentModel *subCommentM;

@property (nonatomic, strong) NSString * __nullable commentId;//存在就是给留言留言，不存在就是给帖子留言
@property (nonatomic, strong) NSString *subcommentId;//存在艾特人的时候就是给二级留言留言，不存在就是给一级留言
@property (nonatomic, assign) BOOL needClear;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) BOOL isHelp;
@property (nonatomic, assign) BOOL ispy;
@property (nonatomic, assign) BOOL isHelpCom;
@property (nonatomic, assign) BOOL needReplyL;
@property (nonatomic, assign) BOOL ismanager;
@property (nonatomic, assign) BOOL isVoiceComment;
@property (nonatomic, assign) NSInteger limitNum;

@property (nonatomic, strong) UILabel *plaL;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, copy) void (^imgBlock)(NSMutableArray *  _Nonnull imagArr,NSString *commentId);
@property (nonatomic, copy) void (^emtionBlock)(NSString *url, NSString *buckId,NSString *pictureId,BOOL isHot,NSString *commentId);
@property (nonatomic, strong) NoticeChocieImgListView *imgListView;
@property (nonatomic, assign) BOOL emotionOpen;//表情框架打开
@property (nonatomic, assign) BOOL imgOpen;//图片框架打开
@property (nonatomic, strong) UIButton *emtionBtn;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) NoticeScroEmtionView *emotionView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) BOOL isresiger;
@property (nonatomic,copy) void (^orignYBlock)(CGFloat y);
@property (nonatomic, assign) BOOL isLead;//新手指南
- (void)showJustComment:(NSString * __nullable)commentId;

- (void)clearView;

@end

NS_ASSUME_NONNULL_END
