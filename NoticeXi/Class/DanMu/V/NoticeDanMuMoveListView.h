//
//  NoticeDanMuMoveListView.h
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDanMuMoveListView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeDanMuModel *bokeM;

- (void)requestVoice;
@end

NS_ASSUME_NONNULL_END
