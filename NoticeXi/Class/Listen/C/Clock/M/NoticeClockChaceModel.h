//
//  NoticeClockChaceModel.h
//  NoticeXi
//
//  Created by li lei on 2019/11/12.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeClockChaceModel : NSObject
@property (nonatomic, strong) NSString *voiceAllUrl;//具体地址
@property (nonatomic, strong) NSString *voiceNameUrl;//名称
@property (nonatomic, strong) NSString *pyIdAndUserId;//配音和用户id组合
@property (nonatomic, strong) NSString *userId;//下载者用户id
@property (nonatomic, strong) NSString *fromUserId;//被下载者用户id
@property (nonatomic, strong) NSString *voicePlayerUrl;
@property (nonatomic, strong) NSString *isChoice;
@property (nonatomic, assign) BOOL isPlaying;
@end

NS_ASSUME_NONNULL_END
