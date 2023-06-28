//
//  NoticeBookComViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeBook.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBookComViewController : BaseTableViewController
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) NSString *userId;
@end

NS_ASSUME_NONNULL_END
