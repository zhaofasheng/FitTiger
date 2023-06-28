//
//  NoticeTextZJMusicModel.h
//  NoticeXi
//
//  Created by li lei on 2021/1/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeBgmModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTextZJMusicModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL hasListen;
@property (nonatomic, assign) BOOL choiceCustume;
@property (nonatomic, assign) BOOL noNeedRic;
@property (nonatomic, strong) NoticeBgmModel *bgmM;

@property (nonatomic, strong) NSString *stateId;
@property (nonatomic, strong) NSString *lines;
@property (nonatomic, strong) NSString *state_image_url;
@property (nonatomic, strong) NSDictionary *bgm_info;

@end

NS_ASSUME_NONNULL_END
