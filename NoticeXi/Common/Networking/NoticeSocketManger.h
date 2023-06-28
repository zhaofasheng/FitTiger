//
//  NoticeSocketManger.h
//  NoticeXi
//
//  Created by li lei on 2018/12/28.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SRWebSocket.h"
#import "DDHAttributedMode.h"
#import "NoticeShopGetOrderTostView.h"
#import "NoticeOneToOne.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeReceveMessageSendMessageDelegate <NSObject>
@optional
- (void)didLXAndMoFa:(id)message;
- (void)didReceiveMessage:(id)message;
- (void)didReceiveGroupMessage:(id)message;
- (void)didReceiveGroupMainPageMessage:(NoticeOneToOne *)message;
- (void)didReceiveHdMessage:(id)message;
- (void)didReceiveHduserInfo:(NSDictionary *)userInfoDic;
- (void)didReceiveComment:(NSDictionary *)commentVoiceDic;
- (void)didReceiveOutGroup:(NSString *)assocId;
- (void)didReceiveVoiceGroupChat:(id)message;
- (void)didReceiveListGroupChat:(NoticeOneToOne *)message;
- (void)didReceiveMemberOutOrJoinTeamChat:(NoticeOneToOne *)message;
@end

@interface NoticeSocketManger : NSObject<SRWebSocketDelegate>
@property (nonatomic, strong,nullable) SRWebSocket *webSocket;
//由于定时器由系统管理，所以不需要进行进行strong
@property (nonatomic, strong)NSTimer * __nullable timer;
- (void)sendMessage:(NSMutableDictionary *)messageDic;
- (void)reConnect;
@property (nonatomic, strong,nullable) NSMutableDictionary *sendMessageDic;
@property (nonatomic, weak) id <NoticeReceveMessageSendMessageDelegate>delegate;
@property (nonatomic, weak) id <NoticeReceveMessageSendMessageDelegate>chatDelegate;
@property (nonatomic, weak) id <NoticeReceveMessageSendMessageDelegate>shopChatDelegate;
@property (nonatomic, weak) id <NoticeReceveMessageSendMessageDelegate>groupDelegate;
@property (nonatomic, weak) id <NoticeReceveMessageSendMessageDelegate>listDelegate;
@property (nonatomic, weak) id <NoticeReceveMessageSendMessageDelegate>memberDelegate;
@property (nonatomic, strong) NoticeShopGetOrderTostView *callView;

@end

NS_ASSUME_NONNULL_END
