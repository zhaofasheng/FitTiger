//
//  NoticeVoiceChatOfJuBaoController.h
//  NoticeXi
//
//  Created by li lei on 2023/4/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeJuBaoShopChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceChatOfJuBaoController : NoticeBaseListController
@property (nonatomic, strong) NSString *mangagerCode;
@property (nonatomic, strong) NoticeJuBaoShopChatModel *jubaoM;
@end

NS_ASSUME_NONNULL_END
