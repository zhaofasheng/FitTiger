//
//  NoticeSmallArrModel.h
//  NoticeXi
//
//  Created by li lei on 2018/10/27.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSmallArrModel : NSObject
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *imgsCount;
@property (nonatomic, strong) NSString *currentCount;
@property (nonatomic, strong) NoticeVoiceListModel *currentModel;
@end

NS_ASSUME_NONNULL_END
