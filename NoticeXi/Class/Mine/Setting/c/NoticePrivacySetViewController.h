//
//  NoticePrivacySetViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticePrivacySetViewController : BaseTableViewController
@property (nonatomic, strong) NSArray *titArr;
@property (nonatomic, strong) NSString *boolStr;
@property (nonatomic, strong) NSString *keyString;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic,copy) void (^openBlock)(BOOL open);
@property (nonatomic,copy) void (^prisetBlock)(NSString *pri);
@property (nonatomic, assign) BOOL isFromAddFriend;
@end

NS_ASSUME_NONNULL_END
