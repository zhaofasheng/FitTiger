//
//  NoticeTcController.h
//  NoticeXi
//
//  Created by li lei on 2019/10/16.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTcController : BaseTableViewController
@property (nonatomic, strong) NSString *tcId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL needTag;
@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, assign) NSInteger topType;//类型
@property (nonatomic, assign) NSInteger tcTagType;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, assign) BOOL isUserLine;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isMain;
@property (nonatomic, assign) BOOL needBackGround;
@property (nonatomic, assign) BOOL isUserCenter;
@property (nonatomic, assign) BOOL isOrderByHot;//是否是最热排序
@property (nonatomic, assign) NSInteger relation_status;
@end

NS_ASSUME_NONNULL_END
