//
//  NoticeBgmModel.h
//  NoticeXi
//
//  Created by li lei on 2021/8/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeBgmModel : NSObject
@property (nonatomic, strong) NSString *audio_url;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *bgmId;
@property (nonatomic, strong) NSString *tips;
@end

NS_ASSUME_NONNULL_END
