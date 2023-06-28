//
//  NoticeSendTeamMsgTools.m
//  NoticeXi
//
//  Created by li lei on 2023/6/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendTeamMsgTools.h"
#import "AFNetworking.h"
@implementation NoticeSendTeamMsgTools

//网络监听,可在此处进行监听,后可发送通知给单利,在单利里面即可做操作
- (void)AFNetworkStatus:(NSString *)content{
    __weak typeof(self) weakSelf = self;
    AFNetworkReachabilityManager *managerAF = [AFNetworkReachabilityManager sharedManager];
    [managerAF startMonitoring];
    [managerAF setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                DRLog(@"未知的网络类型");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DRLog(@"通过WIFI上网");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DRLog(@"通过3G/4G上网");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                if (weakSelf.sendTextSuccessBlock) {
                    weakSelf.sendTextSuccessBlock(YES,content);
                }
                DRLog(@"无网络");
                break;
        }
    }];
}

- (void)sendImgWithPath:(NSString *)path success:(BOOL)success bucketid:(NSString *)bucketId imgData:(NSData *)imgData withUse:(NoticeTeamChatModel *  __nullable )chatM{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:self.teamModel.teamId forKey:@"massId"];
    [data setObject:@"2" forKey:@"type"];
    [data setObject:path forKey:@"resource_uri"];
    [data setObject:bucketId?bucketId:@"0" forKey:@"bucketId"];
    if(chatM){
        [data setObject:chatM.logId forKey:@"aboutId"];
    }
    [self.sendDic setObject:data forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self.sendDic];
}

- (void)sendemtionWithPath:(NSString *)path bucketid:(NSString *)bucketId pictureId:(NSString *)pictureId isHot:(BOOL)isHot withUse:(NoticeTeamChatModel * __nullable )chatM{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:self.teamModel.teamId forKey:@"massId"];
    [data setObject:@"2" forKey:@"type"];
    [data setObject:path forKey:@"resource_uri"];
    [data setObject:bucketId?bucketId:@"0" forKey:@"bucketId"];
    if(chatM){
        [data setObject:chatM.logId forKey:@"aboutId"];
    }
    [self.sendDic setObject:data forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self.sendDic];
}

- (void)sendVocieWith:(NSString *)localPath time:(NSString *)timeLength upSuccessPath:(NSString *)upSuccessPath success:(BOOL)success bucketid:(NSString *)bucketId withUse:(NoticeTeamChatModel *)chatM{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:self.teamModel.teamId forKey:@"massId"];
    [data setObject:@"3" forKey:@"type"];
    [data setObject:upSuccessPath forKey:@"resource_uri"];
    [data setObject:timeLength forKey:@"voiceLen"];
    [data setObject:bucketId?bucketId:@"0" forKey:@"bucketId"];
    if(chatM){
        [data setObject:chatM.logId forKey:@"aboutId"];
    }
    [self.sendDic setObject:data forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self.sendDic];
}

- (void)sendTextWith:(NSString *)text withUse:(NoticeTeamChatModel * __nullable )chatM atpersons:(NSString * _Nullable)persons{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:self.teamModel.teamId forKey:@"massId"];
    [data setObject:@"1" forKey:@"type"];
    [data setObject:text forKey:@"content"];
    if(chatM){
        [data setObject:chatM.logId forKey:@"aboutId"];
    }
    if(persons){
        [data setObject:persons forKey:@"callUserIds"];
    }
    [self.sendDic setObject:data forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self.sendDic];
    
    [self AFNetworkStatus:text];
}

- (BOOL)neeShowTime:(NSIndexPath *)indexPath chatModel:(NSMutableArray *)dataArr localArr:(NSMutableArray *)localArr withChat:(NoticeTeamChatModel *)chat{
    if(chat.isShowTime){//如果本身需要显示时间，就不需要继续往下
        return YES;
    }
    if (indexPath.section == 0) {//第一组
        if (indexPath.row == 0) {//第一个要显示时间
            chat.isShowTime = NO;
        }else{
            if (indexPath.row > 0) {//第二个开始做前一个比较
                if(dataArr.count-1 >= (indexPath.row-1)){
                    NoticeTeamChatModel *beChat = dataArr[indexPath.row-1];
                    chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                }
            }
        }
    }else{
        if (!dataArr.count) {//如果不存在第一组数据
            if (indexPath.row == 0) {//第一个要显示时间
                chat.isShowTime = NO;
            }else{
                if (indexPath.row > 0) {//第二个开始做前一个比较
                    if(localArr.count-1 >= (indexPath.row-1)){
                        NoticeTeamChatModel *beChat = localArr[indexPath.row-1];
                        chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                    }
                }
            }
        }else{//存在第一组数据
            if (indexPath.row == 0) {
                NoticeTeamChatModel *firdtChat = dataArr[0];
                chat.isShowTime = (chat.created_at.integerValue - firdtChat.created_at.integerValue)>60 ? YES : NO;
            }else{
                if (indexPath.row > 0) {//第二个开始做前一个比较
                    if(localArr.count-1 >= (indexPath.row-1)){
                        NoticeTeamChatModel *beChat = localArr[indexPath.row-1];
                        chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                    }
                }
            }
        }
    }
    return chat.isShowTime;
}

- (NSMutableDictionary *)sendDic{
    if(!_sendDic){
        _sendDic = [[NSMutableDictionary alloc] init];
        [_sendDic setObject:@"massChat" forKey:@"flag"];
    }
    return _sendDic;
}

@end
