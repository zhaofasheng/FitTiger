//
//  NoticeHandAddMovieController.h
//  NoticeXi
//
//  Created by li lei on 2019/7/25.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeMovie.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHandAddMovieController : BaseTableViewController
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NoticeMovie *movie;
@property (nonatomic, strong) NSString *passCode;
@property (nonatomic, assign) BOOL isFromMangerM;
@end

NS_ASSUME_NONNULL_END
