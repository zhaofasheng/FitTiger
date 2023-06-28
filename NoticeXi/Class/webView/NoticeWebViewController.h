//
//  NoticeWebViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeWeb.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeWebViewController :NoticeBaseListController
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *html_id;
@property (nonatomic, strong) NSString *urlName;
@property (nonatomic, strong) NSURL *allUrl;
@property (nonatomic, strong) NoticeWeb *web;
@property (nonatomic, assign) BOOL isAboutSX;
@property (nonatomic, assign) BOOL isXieyi;
@property (nonatomic, assign) BOOL isFromShare;
@property (nonatomic, assign) BOOL isFromListen;
@property (nonatomic, assign) BOOL isBbs;
@property (nonatomic, assign) BOOL isMerechant;
@property (nonatomic, strong) NSString *specic;//特俗文章
@property (nonatomic,copy) void (^getTitleBlock)(NSString *title);
@end

NS_ASSUME_NONNULL_END

