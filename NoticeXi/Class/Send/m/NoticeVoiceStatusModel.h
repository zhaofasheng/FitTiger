//
//  NoticeVoiceStatusModel.h
//  NoticeXi
//
//  Created by li lei on 2021/4/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceStatusDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceStatusModel : NSObject

@property (nonatomic, strong) NSString *category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSArray *state;
@property (nonatomic, strong) NSMutableArray *stateArr;
@end

NS_ASSUME_NONNULL_END
