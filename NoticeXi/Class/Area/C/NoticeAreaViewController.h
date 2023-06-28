//
//  NoticeAreaViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeAreaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAreaViewController : NoticeBaseListController
@property (nonatomic,copy) void (^adressBlock)(NoticeAreaModel *adressModel);

@end

NS_ASSUME_NONNULL_END
