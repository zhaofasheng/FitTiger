//
//  NoticeVoiceStatusDetailModel.h
//  NoticeXi
//
//  Created by li lei on 2021/5/17.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceStatusAudioModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceStatusDetailModel : NSObject
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSString *picture_url;
@property (nonatomic, strong) NSDictionary *audios;
@property (nonatomic, strong) NSString *picture_id;
@property (nonatomic, strong) NSString *audios_url;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NoticeVoiceStatusAudioModel *audioM;
@end

NS_ASSUME_NONNULL_END
