//
//  NoticeMyFriendViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/11/2.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeAbout.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyFriendViewController : BaseTableViewController
@property (nonatomic, strong) NoticeAbout *aboutM;
@property (nonatomic, assign) BOOL isSend;//送画给朋友
@property (nonatomic, strong) UIImage *sendImage;
@property (nonatomic, strong) NSString *urlImage;
@property (nonatomic, strong) NSString *resourceId;
@property (nonatomic, assign) BOOL isCall;//打电话
@end

NS_ASSUME_NONNULL_END
