//
//  NoticeBookDetailController.h
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeBook.h"
#import "NoticeMovieDetail.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBookDetailController : BaseTableViewController
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) NoticeMovieDetail *detialView;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *passCode;
@property (nonatomic, assign) BOOL isFromAdd;
@end

NS_ASSUME_NONNULL_END
