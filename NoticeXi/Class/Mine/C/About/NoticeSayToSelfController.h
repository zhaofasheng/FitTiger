//
//  NoticeSayToSelfController.h
//  NoticeXi
//
//  Created by li lei on 2019/7/9.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeVoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSayToSelfController : NoticeBaseListController
@property (nonatomic, strong) NSString *voiceId;
@property (nonatomic, strong) NoticeVoiceListModel *choiceM;
@property (nonatomic,copy) void (^choiceBlock)(NoticeVoiceListModel *model);
@end

NS_ASSUME_NONNULL_END
