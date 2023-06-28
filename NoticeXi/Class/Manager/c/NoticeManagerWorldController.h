//
//  NoticeManagerWorldController.h
//  NoticeXi
//
//  Created by li lei on 2019/8/29.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeManagerWorldCell.h"
#import "NoticeDrawList.h"
#import "NoticeDrawTuM.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeManagerWorldController : BaseTableViewController
@property (nonatomic, strong) NSString *mangagerCode;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeDrawList *drawM;
@property (nonatomic, strong) NoticeDrawTuM *tuYaModel;
@end

NS_ASSUME_NONNULL_END
