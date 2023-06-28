//
//  NoticeSongDetailController.h
//  NoticeXi
//
//  Created by li lei on 2019/4/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeSong.h"
#import "NoticeMovieDetail.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSongDetailController : BaseTableViewController
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, strong) NoticeMovieDetail *detialView;
@property (nonatomic, strong) NSString *songId;
@property (nonatomic, assign) BOOL isFromAdd;
@property (nonatomic, strong) NSString *passCode;
@end

NS_ASSUME_NONNULL_END
