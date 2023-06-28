//
//  NoticeOtherUserInfoViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/31.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeOtherUserInfoViewController : UIViewController
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isFromChat;
@property (nonatomic, assign) BOOL isYourBlack;
@property (nonatomic, strong) NSString *cardTitle;
@end

NS_ASSUME_NONNULL_END
