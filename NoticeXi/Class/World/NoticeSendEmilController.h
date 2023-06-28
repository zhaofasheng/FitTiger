//
//  NoticeSendEmilController.h
//  NoticeXi
//
//  Created by li lei on 2022/12/30.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendEmilController : NoticeBaseListController
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, assign) BOOL canChoiceDate;
@end

NS_ASSUME_NONNULL_END
