//
//  NoticeHeaderDataView.h
//  NoticeXi
//
//  Created by li lei on 2022/1/14.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHeaderDataView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) NSMutableArray *guidArr;
- (void)request;
@end

NS_ASSUME_NONNULL_END
