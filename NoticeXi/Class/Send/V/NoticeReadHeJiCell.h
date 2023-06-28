//
//  NoticeReadHeJiCell.h
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceReadModel.h"
#import "CBAutoScrollLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeReadHeJiCell : BaseCell
@property (nonatomic, strong) NoticeVoiceReadModel *readModel;
@property (nonatomic, copy) void(^readingBlock)(NoticeVoiceReadModel *moreM);
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *contentL;
@end

NS_ASSUME_NONNULL_END
