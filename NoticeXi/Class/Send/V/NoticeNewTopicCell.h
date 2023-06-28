//
//  NoticeNewTopicCell.h
//  NoticeXi
//
//  Created by li lei on 2021/4/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewTopicCell : BaseCell
@property (nonatomic, strong) UILabel *topicL;
@property (nonatomic, strong,nullable) NoticeTopicModel *topicM;
@end

NS_ASSUME_NONNULL_END
