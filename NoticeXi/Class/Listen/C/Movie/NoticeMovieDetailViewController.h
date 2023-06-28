//
//  NoticeMovieDetailViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeMovie.h"
#import "NoticeMovieDetail.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMovieDetailViewController : BaseTableViewController
@property (nonatomic, strong) NoticeMovie *movie;
@property (nonatomic, strong) NoticeMovieDetail *detialView;
@property (nonatomic, strong) NSString *movieId;
@property (nonatomic, assign) BOOL circleTransition;
@property (nonatomic, assign) BOOL isFromAdd;
@property (nonatomic, assign) BOOL pageTransition;
@property (nonatomic, strong) NSString *passCode;
@end

NS_ASSUME_NONNULL_END
