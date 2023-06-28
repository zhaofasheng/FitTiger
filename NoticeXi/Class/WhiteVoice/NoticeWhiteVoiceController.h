//
//  NoticeWhiteVoiceController.h
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeWhiteVoiceController : UIViewController
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *dialogId;
@property (nonatomic, assign) BOOL isSendChat;
@property (nonatomic, assign) BOOL isHasSend;
@property (nonatomic, assign) BOOL isHsGet;
@property (nonatomic, copy) void(^choiceArrBlock)(NSMutableArray<NoticeWhiteVoiceListModel *> *whiteArr);
@end

NS_ASSUME_NONNULL_END
