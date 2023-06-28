//
//  NoticeTopicCell.h
//  NoticeXi
//
//  Created by li lei on 2018/10/31.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTopicCell : BaseCell
@property (nonatomic, strong) NoticeTopicModel *topicM;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) BOOL isDraw;
@end

NS_ASSUME_NONNULL_END
