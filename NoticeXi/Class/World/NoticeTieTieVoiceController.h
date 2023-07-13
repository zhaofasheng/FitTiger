//
//  NoticeTieTieVoiceController.h
//  NoticeXi
//
//  Created by li lei on 2022/11/9.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTieTieVoiceController : WMPageController
@property (nonatomic, strong) NSString *dateName;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *day;
- (void)refreshData;
@end

NS_ASSUME_NONNULL_END
