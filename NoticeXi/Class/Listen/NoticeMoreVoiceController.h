//
//  NoticeMoreVoiceController.h
//  NoticeXi
//
//  Created by li lei on 2020/1/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMoreVoiceController : BaseTableViewController
@property (nonatomic, strong) NSString *resourceId;
@property (nonatomic, strong) NSString *resourceType;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isCalclderVoice;
@property (nonatomic, strong) NSString *dataString;
@end

NS_ASSUME_NONNULL_END
