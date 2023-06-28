//
//  NoticePersonalityCell.h
//  NoticeXi
//
//  Created by li lei on 2019/1/30.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticePersonality.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol NoticePersonlityDelegate <NSObject>

@optional
- (void)lookAllPersonlityDescDelegate;

@end

@interface NoticePersonalityCell : BaseCell<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) NoticePersonality *personality;
@property (nonatomic, weak) id<NoticePersonlityDelegate>delegate;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (strong, nonatomic) WKWebView *webView;
@end

NS_ASSUME_NONNULL_END
