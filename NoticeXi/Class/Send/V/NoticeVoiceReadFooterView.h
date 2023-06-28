//
//  NoticeVoiceReadFooterView.h
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceReadMoreCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceReadFooterView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) void(^moreDetailBlock)(NoticeVoiceReadModel *detailReadModel);
@property (nonatomic, copy) void(^moreBlock)(BOOL more);
@end

NS_ASSUME_NONNULL_END
