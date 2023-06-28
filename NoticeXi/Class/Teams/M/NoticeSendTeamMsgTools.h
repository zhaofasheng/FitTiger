//
//  NoticeSendTeamMsgTools.h
//  NoticeXi
//
//  Created by li lei on 2023/6/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeGroupListModel.h"
#import "NoticeTeamChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendTeamMsgTools : NSObject
@property (nonatomic, strong) NSMutableDictionary *sendDic;
@property (nonatomic, strong) NoticeGroupListModel *teamModel;
@property (nonatomic, copy) void (^sendTextSuccessBlock)(BOOL fail ,NSString *content);
/// 发送图片消息
/// - Parameters:
///   - path: 图片路径
///   - success: 图片上传成功
///   - bucketId: bugketId
///   - imgData: 图片源文件
///   - chatM: 引用消息，如果存在，代表是引用谁的消息
- (void)sendImgWithPath:(NSString *)path success:(BOOL)success bucketid:(NSString *)bucketId imgData:(NSData *)imgData withUse:(NoticeTeamChatModel *  __nullable )chatM;

/// 发送表情包消息
/// - Parameters:
///   - path: 表情包路径
///   - bucketId: bucketid
///   - pictureId: 表情包id
///   - isHot: 是否是热门表情包
///   - chatM: 引用消息，如果存在，代表是引用谁的消息
- (void)sendemtionWithPath:(NSString *)path bucketid:(NSString *)bucketId pictureId:(NSString *)pictureId isHot:(BOOL)isHot withUse:(NoticeTeamChatModel * __nullable )chatM;


/// 发送语音消息
/// - Parameters:
///   - localPath: 语音本地源文件路径
///   - timeLength: 语音时长
///   - upSuccessPath: 语音上床成功后的url
///   - success: 语音是否上传成功
///   - bucketId: bucketid
///   - chatM: 引用消息，如果存在，代表是引用谁的消息
- (void)sendVocieWith:(NSString *)localPath time:(NSString *)timeLength upSuccessPath:(NSString *)upSuccessPath success:(BOOL)success bucketid:(NSString *)bucketId withUse:(NoticeTeamChatModel *__nullable)chatM;


/// 发送文本消息
/// - Parameters:
///   - text: 文本内容
///   - chatM: 引用消息，如果存在，代表是引用谁的消息
- (void)sendTextWith:(NSString *)text withUse:(NoticeTeamChatModel * __nullable )chatM atpersons:(NSString * __nullable )persons;

- (BOOL)neeShowTime:(NSIndexPath *)indexPath chatModel:(NSMutableArray *)dataArr localArr:(NSMutableArray *)localArr withChat:(NoticeTeamChatModel *)chat;


@end

NS_ASSUME_NONNULL_END
