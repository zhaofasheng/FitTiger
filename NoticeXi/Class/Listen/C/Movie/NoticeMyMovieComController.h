//
//  NoticeMyMovieComController.h
//  NoticeXi
//
//  Created by li lei on 2019/4/3.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeMovie.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyMovieComController : BaseTableViewController
@property (nonatomic, strong) NoticeMovie *movie;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) NSInteger type; //1电影，2书籍，3音乐 0全部
@property (nonatomic, assign) BOOL fromUserCenter;//来自于个人主页
@end

NS_ASSUME_NONNULL_END
