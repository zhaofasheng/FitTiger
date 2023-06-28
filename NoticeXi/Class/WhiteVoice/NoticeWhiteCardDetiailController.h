//
//  NoticeWhiteCardDetiailController.h
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeWhiteVoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeWhiteCardDetiailController : BaseTableViewController

@property (nonatomic, strong) NoticeWhiteVoiceListModel *whiteModel;
@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic, assign) NSInteger currentItem;
@end

NS_ASSUME_NONNULL_END
