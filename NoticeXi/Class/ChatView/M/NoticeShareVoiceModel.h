//
//  NoticeShareVoiceModel.h
//  NoticeXi
//
//  Created by li lei on 2022/5/27.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeFriendAcdModel.h"
#import "NoticeClockPyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShareVoiceModel : NSObject

@property (nonatomic, strong) NSString *show_status;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NoticeFriendAcdModel *userM;

@property (nonatomic, strong) NSDictionary *voice;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;

@property (nonatomic, strong) NSDictionary *dubbing;
@property (nonatomic, strong) NoticeClockPyModel *pyM;

@property (nonatomic, strong) NSDictionary *line;
@property (nonatomic, strong) NoticeClockPyModel *lineM;
@end

NS_ASSUME_NONNULL_END
