//
//  NoticeSongComController.h
//  NoticeXi
//
//  Created by li lei on 2019/4/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeSong.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSongComController :BaseTableViewController
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, strong) NSString *userId;
@end

NS_ASSUME_NONNULL_END
