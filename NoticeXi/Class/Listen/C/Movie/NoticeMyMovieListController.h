//
//  NoticeMyMovieListController.h
//  NoticeXi
//
//  Created by li lei on 2019/4/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeAbout.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyMovieListController : BaseTableViewController
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, strong) NoticeAbout *realisAbout;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) NSInteger oldIndex;
@end

NS_ASSUME_NONNULL_END
