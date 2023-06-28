//
//  NoticeTextZJDetailView.h
//  NoticeXi
//
//  Created by li lei on 2021/1/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTextZJDetailView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NoticeZjModel *zjModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UIButton *musicBtn;
@property (nonatomic, strong) UIButton *contentBtn;
@property (nonatomic, strong) UIButton *listBtn;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic,copy) void (^getDataBlock)(NSMutableArray *arr);
@property (nonatomic,copy) void (^choiceDataBlock)(NoticeVoiceListModel *model);
@property (nonatomic,copy) void (^getFirstBlock)(NoticeVoiceListModel *model);
@property (nonatomic, strong) NoticeVoiceListModel *currentModel;
@property (nonatomic, assign) BOOL isFirstRequest;
@end

NS_ASSUME_NONNULL_END
