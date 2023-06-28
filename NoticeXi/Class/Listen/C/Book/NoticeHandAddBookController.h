//
//  NoticeHandAddBookController.h
//  NoticeXi
//
//  Created by li lei on 2019/7/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeBook.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHandAddBookController : BaseTableViewController
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) NSString *passCode;
@property (nonatomic, assign) BOOL isFromMangerM;
@end

NS_ASSUME_NONNULL_END
