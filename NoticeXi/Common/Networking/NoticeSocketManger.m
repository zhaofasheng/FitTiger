//
//  NoticeSocketManger.m
//  NoticeXi
//
//  Created by li lei on 2018/12/28.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSocketManger.h"
#import "DRNetWorking.h"

#import "NoticeChats.h"
#import "NoticeShopChatController.h"
#import "HDAlertView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeGoToComShopController.h"
#define TYPECHAT @"singleChat"

@implementation NoticeSocketManger
{
    BOOL isConnect;
    NSInteger reconnectCount;
}

//完善的事情：推出登录要断开连接，使用单例

- (void)sendMessage:(NSMutableDictionary *)messageDic{//发送消息

    if (!messageDic) {
        return;
    }
    if (self.webSocket.readyState == SR_OPEN) {//判断是否链接和打开了服务器

        NSData *sendData = [NSJSONSerialization dataWithJSONObject:messageDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *message1 = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];
        NSData *data1 = [message1 dataUsingEncoding:NSUTF8StringEncoding];
        [self.webSocket send:data1];
        DRLog(@"发送信息:%@",messageDic);
        //连接状态发出去以后要清空消息避免重复发送
        self.sendMessageDic = nil;
    }else{//未连接则调用重连机制
        self.sendMessageDic = messageDic;
        [self reConnect];
    }
}

//发送心跳
- (void)sendSocketPing{
    if (self.webSocket.readyState == SR_OPEN && [[NoticeSaveModel getUserInfo] user_id]) {//判断是否链接和打开了服务器
        NSMutableDictionary *addParemDic = [[NSMutableDictionary alloc] init];
        [addParemDic setObject:@"ping" forKey:@"flag"];
        NSData *messageData = [NSJSONSerialization dataWithJSONObject:addParemDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *message = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        if (!data) {
            return;
        }
        //DRLog(@"发送心跳");
        [self.webSocket send:data];
    }else{//未连接则调用重连机制
        if ([[NoticeSaveModel getUserInfo] user_id]) {
            [self reConnect];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{//收到消息
    if (!message) {
        return;
    }
    
    NSDictionary *dic = [NoticeTools dictionaryWithJsonString:message];
    
    DRLog(@"收到消息%@",dic);
  
    NoticeOneToOne *model = [NoticeOneToOne mj_objectWithKeyValues:dic];
    
    if ([model.flag isEqualToString:@"shopOrderRoom"] && model.orderType.intValue != 5) {//语音通话不等于5的时候代表需要结束订单
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEEDOVERVOICECHAT" object:nil];
        return;
    }
    
    if ([model.flag isEqualToString:@"shopOrder"]) {//店铺相关
        NoticeByOfOrderModel *orderM = [NoticeByOfOrderModel mj_objectWithKeyValues:model.data];
        [self isCall:orderM];
        return;
    }
    
    if ([model.flag isEqualToString:@"voiceDialogNum"]) {
        if (!model.data) {
            return;
        }
    }
    if ([model.flag isEqualToString:@"voiceRelevant"]) {//评论相关
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveComment:)]) {
            [self.delegate didReceiveComment:model.data];
        }
        return;
    }
    
    if ([model.msg containsString:@"限制沟通状态"] || [model.msg containsString:@"由于您近期多次"]) {
        NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithWarnTostViewContent:model.msg];
        [pinV showTostView];
        return;
    }
    if ([model.flag isEqualToString:@"systemMsg"]) {//系统消息
        NoticeUserInfoModel *userHd = [NoticeUserInfoModel mj_objectWithKeyValues:dic[@"data"]];
        if ([userHd.type isEqualToString:@"15"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveHduserInfo:)]) {
                [self.delegate didReceiveHduserInfo:dic[@"data"]];
            }
            return;
        }
        if (userHd.type.intValue == 28 && (userHd.change_type.intValue == 1 || userHd.change_type.intValue == 2 || userHd.change_type.intValue == 3 || userHd.change_type.intValue == 4 || userHd.change_type.intValue == 8)) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveOutGroup:)]) {
                [self.delegate didReceiveOutGroup:userHd.assoc_id];
            }
        }
    }
    
    if ([model.flag isEqualToString:@"assocParty"]) {//社团语音群聊
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveVoiceGroupChat:)]) {
            [self.delegate didReceiveVoiceGroupChat:model.data];
        }
        if (self.groupDelegate && [self.groupDelegate respondsToSelector:@selector(didReceiveVoiceGroupChat:)]) {
            [self.groupDelegate didReceiveVoiceGroupChat:model.data];
        }
        return;
    }
    
    if ([model.flag isEqualToString:@"massChat"]) {//社团消息
        if (!model.data) {
            return;
        }
        if (self.groupDelegate && [self.groupDelegate respondsToSelector:@selector(didReceiveGroupMainPageMessage:)]) {
            [self.groupDelegate didReceiveGroupMainPageMessage:model];
        }
        if (self.listDelegate && [self.listDelegate respondsToSelector:@selector(didReceiveListGroupChat:)]) {
            [self.listDelegate didReceiveListGroupChat:model];
        }
        if (self.memberDelegate && [self.memberDelegate respondsToSelector:@selector(didReceiveMemberOutOrJoinTeamChat:)]) {
            [self.memberDelegate didReceiveMemberOutOrJoinTeamChat:model];
        }
        return;
    }
    if ([model.action isEqualToString:@"interactive"]) {//收到互动消息
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveHdMessage:)]) {
            [self.delegate didReceiveHdMessage:dic];
        }
        return;
    }
    
    if (model.code && ![model.code isEqualToString:@"0"]) {
        if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
            if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
                [nav.topViewController showToastWithText:[NSString stringWithFormat:@"长链接信息接收失败%@-%@",model.msg,model.code]];
            }
        }
    }
    
    //匹配
    NoticeChats *chat1 = [NoticeChats mj_objectWithKeyValues:dic[@"data"]];
    if ([chat1.type isEqualToString:@"11"] || [chat1.type isEqualToString:@"13"]){//收到警告
        if ([chat1.type isEqualToString:@"13"]) {
            NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithWarnTostViewContent:chat1.title];
            [pinV showTostView];
            return;
        }
        XLAlertView *alertView = [[XLAlertView alloc] initWithTitle:@"系统通知" message:chat1.title cancleBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"]];
        [alertView showXLAlertView];
    }
    
    if ([chat1.type isEqualToString:@"12"]) {
        if (chat1.yunxin_id && chat1.yunxin_id.length > 7) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didLXAndMoFa:)]) {
                [self.delegate didLXAndMoFa:chat1];
            }
        }
        return;
    }
    
    //私聊悄悄话
    if ([model.flag isEqualToString:TYPECHAT] || [model.flag isEqualToString:@"receiveCard"]) {
        NoticeChats *chat = [NoticeChats mj_objectWithKeyValues:dic[@"data"]];
        
        if (![chat.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {//别人发的信息就震动
            if ([NoticeTools needShake]) {

                
                if (chat.chat_type.intValue == 3 || chat.chat_type.intValue == 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICIONHS" object:nil];//刷新悄悄话会话列表
                }
                if ([chat.chat_type isEqualToString:@"2"] || [chat.voice_id isEqualToString:@"0"]) {//私聊
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICION" object:nil];//刷新私聊会话列表
                }
            }
        }
        
        if (chat.yunxin_id && chat.yunxin_id.length > 7) {
            if (self.chatDelegate && [self.chatDelegate respondsToSelector:@selector(didLXAndMoFa:)]) {
                [self.chatDelegate didLXAndMoFa:dic];
            }
        }
        
        if (self.shopChatDelegate && [self.shopChatDelegate respondsToSelector:@selector(didReceiveMessage:)]) {
            [self.shopChatDelegate didReceiveMessage:dic];
        }
        
        if (self.chatDelegate && [self.chatDelegate respondsToSelector:@selector(didReceiveMessage:)]) {
            [self.chatDelegate didReceiveMessage:dic];
        }
        
    }else if ([model.flag isEqualToString:@"systemMsg"]){
        if (model.chatM.type.intValue == 28) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICENEWGROUPRED" object:nil];
        }
      
    }
}

// 连接关闭
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    // 判断是何种情况的关闭，如果是人为的就不需要重连，如果是其他情况，就重连
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
        [nav.topViewController showToastWithText:[NSString stringWithFormat:@"%@socket连接关闭",reason]];
    }
    //    if ([[NoticeSaveModel getUserInfo] user_id] && [NoticeTools needConnect]) {
    //        [self reConnect];
    //    }
    //
    DRLog(@"webSocket Closed!\n%@",reason);
}

// 接收服务器发送的pong消息
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    DRLog(@"Websocket received pong");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    //DRLog(@"链接失败");
    [self reConnect];
}

//链接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    DRLog(@"长链接成功");
    if (isConnect) {
        NSMutableDictionary *addParemDic = [[NSMutableDictionary alloc] init];
        [addParemDic setObject:@"init" forKey:@"flag"];
        NSData *messageData = [NSJSONSerialization dataWithJSONObject:addParemDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *message = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        if (!data) {
            return;
        }
        DRLog(@"发送信息:%@",message);
        [self.webSocket send:data];
        isConnect = NO;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
    }
    if (self.sendMessageDic) {//如果存在发送失败的则进行重连后接着发送
        [self sendMessage:self.sendMessageDic];
    }
    [self initHeart];
    
}

//保活机制  探测包
- (void)initHeart{
    [self.timer invalidate];
    self.timer = nil;
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf sendSocketPing];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)reConnect{//断开重连
    [self.timer invalidate];
    self.webSocket.delegate = nil;
    self.webSocket = nil;
    self.webSocket.delegate = self;
}

- (SRWebSocket *)webSocket{
    if (!_webSocket) {
        //2.request 建立请求，告诉服务器想要的资源，以及附加信息
        NSMutableURLRequest * requestss =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", socketHeader,socketIP, socketPort]]];
        NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
        if (userInfo.socket_id && userInfo.socket_token) {
            [requestss setValue:userInfo.socket_id forHTTPHeaderField:@"socket-id"];
            [requestss setValue:[DDHAttributedMode md5:[NSString stringWithFormat:@"%@%@",userInfo.socket_token,userInfo.socket_id]] forHTTPHeaderField:@"socket-signature"];
        }
        _webSocket = [[SRWebSocket alloc] initWithURLRequest:requestss];
        _webSocket.delegate = self;
        [_webSocket open];
        isConnect = YES;
        // 创建定时器
    }
    return _webSocket;
}

- (NoticeShopGetOrderTostView *)callView{
    if (!_callView) {
        _callView = [[NoticeShopGetOrderTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _callView;
}

- (void)isCall:(NoticeByOfOrderModel *)orderM{
    //文字聊天解忧模块
    if (orderM.type.intValue == 77666) {//新订单来了
        self.callView.orderModel = orderM.resultModel;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HASNEWORDERCHANTORDER" object:nil];   
        [self.callView showCallView];
    }else if (orderM.type.intValue == 77668){//买家取消订单
        if ([orderM.resultModel.shop_user_id isEqualToString:[NoticeTools getuserId]]) {
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"对方取消了订单" message:nil cancleBtn:@"好的，知道了"];
            [alerView showXLAlertView];
        }
        [_callView dissMiseeShow];
        [self noShowOrderId:orderM.resultModel.orderId];
    }else if (orderM.type.intValue == 77667){//店铺取消订单
    
        if ([orderM.resultModel.user_id isEqualToString:[NoticeTools getuserId]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"对方暂无法接单，请尝试其它店铺" message:nil cancleBtn:@"好的，知道了"];
            [alerView showXLAlertView];
        }
        [_callView dissMiseeShow];
        [self noShowOrderId:orderM.resultModel.orderId];
    }else if (orderM.type.intValue == 77669){//订单超时
     
        if ([orderM.resultModel.shop_user_id isEqualToString:[NoticeTools getuserId]]) {
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"有订单失效了" message:@"可在「解忧杂货铺-订单信息」中查看" cancleBtn:@"知道了"];
            [alerView showXLAlertView];
        }else{
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"订单已超时失效，请尝试其它店铺" message:nil cancleBtn:@"知道了"];
            [alerView showXLAlertView];
        }
        [self noShowOrderId:orderM.resultModel.orderId];
        [_callView dissMiseeShow];
    }else if (orderM.type.intValue == 77670){//订单接单
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        if (!appdel.isInShopChat) {
            appdel.isInShopChat = YES;
            NoticeShopChatController *ctl = [[NoticeShopChatController alloc] init];
            ctl.orderM = orderM.resultModel;
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];
        }
        [_callView dissMiseeShow];
    }else if (orderM.type.intValue == 77672){//订单完成
     
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPFINISHED" object:nil];
        [_callView dissMiseeShow];
        
        if ([orderM.resultModel.shop_user_id isEqualToString:[NoticeTools getuserId]]) {//如果自己是店主
            return;
        }
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"订单已结束" message:[NSString stringWithFormat:@"本次聊天需支付%@鲸币,将从你的钱包中扣除",orderM.resultModel.price] sureBtn:@"我知道了" cancleBtn:@"给个评价" right:YES];
       alerView.resultIndex = ^(NSInteger index) {
           if (index == 2) {
               NoticeGoToComShopController *ctl = [[NoticeGoToComShopController alloc] init];
               ctl.resultModel = orderM.resultModel;
               [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
           }
       };
       [alerView showXLAlertView];
        
        
    }else if (orderM.type.intValue == 77671){//订单被举报
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPHASJUBAOED" object:nil];

        [_callView dissMiseeShow];
    }else if (orderM.type.intValue == 77673){//后台告知超时结束
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPFINISHEDHOUTAI" object:nil];
        [_callView dissMiseeShow];
    }
    
    //语音聊天模块
    else if (orderM.type.intValue == 77678){//买家取消订单
        [_callView dissMiseeShow];
        [self noShowOrderId:orderM.resultModel.orderId];
    }else if (orderM.type.intValue == 77677){//店铺取消订单

        [_callView dissMiseeShow];
        [self noShowOrderId:orderM.resultModel.orderId];
    }else if (orderM.type.intValue == 77679){//订单超时

        [self noShowOrderId:orderM.resultModel.orderId];
        [_callView dissMiseeShow];
    }else if (orderM.type.intValue == 77682){//订单完成
        if ([orderM.resultModel.shop_user_id isEqualToString:[NoticeTools getuserId]]) {//如果自己是店主
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"订单已结束" message:[NSString stringWithFormat:@"本次通话收入%.2f鲸币，实收款为扣除20%%声昔服务费后的费用",orderM.resultModel.reality_jingbi.floatValue] cancleBtn:@"知道了"];
            [alerView showXLAlertView];
        }else{
            
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"订单已结束" message:[NSString stringWithFormat:@"本次通话%@鲸币/分钟，通话时长「%@」,需支付%@鲸币,将从你的钱包中扣除",orderM.resultModel.minute_jingbi,[self getMMSSFromSS:orderM.resultModel.second],orderM.resultModel.price] sureBtn:@"我知道了" cancleBtn:@"给个评价" right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    NoticeGoToComShopController *ctl = [[NoticeGoToComShopController alloc] init];
                    ctl.resultModel = orderM.resultModel;
                    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
                }
            };
            [alerView showXLAlertView];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPFINISHED" object:nil];
        [_callView dissMiseeShow];
    }else if (orderM.type.intValue == 77681){//订单被举报
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"有举报，订单结束" message:@"收到举报，管理员会尽快处理，鲸币明细具体以审核结果为准，将通过「声昔小助手」告知，请注意查收！" cancleBtn:@"我知道了"];
        [alerView showXLAlertView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPHASJUBAOED" object:nil];
        [_callView dissMiseeShow];
    }else if (orderM.type.intValue == 77683){//后台告知超时结束
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPFINISHEDHOUTAI" object:nil];
        [_callView dissMiseeShow];
    }
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
 
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    if(str_hour.intValue){
        return [NSString stringWithFormat:@"%@时%@分%@秒",str_hour.intValue?str_hour:@"0",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
    }else{
        if(str_minute.intValue){
            return [NSString stringWithFormat:@"%@分%@秒",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
        }else{
            return [NSString stringWithFormat:@"%@秒",str_second.intValue?str_second:@"0"];
        }
    }
}


- (void)noShowOrderId:(NSString *)orderId{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/cache/%@",orderId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict1, BOOL success1) {
        if (success1) {
            DRLog(@"不显示订单");
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

@end
