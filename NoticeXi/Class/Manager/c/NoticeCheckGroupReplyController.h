//
//  NoticeCheckGroupReplyController.h
//  NoticeXi
//
//  Created by li lei on 2020/9/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeManagerGroupReplyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeCheckGroupReplyController : UIViewController
@property (nonatomic, strong) NoticeManagerGroupReplyModel *replyModel;
@property (nonatomic, strong) NSString *managerCode;
@end

NS_ASSUME_NONNULL_END
