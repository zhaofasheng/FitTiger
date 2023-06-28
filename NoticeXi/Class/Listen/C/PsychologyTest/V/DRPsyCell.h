//
//  DRPsyCell.h
//  NoticeXi
//
//  Created by li lei on 2019/1/22.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticePsyModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeQuestionDelegate <NSObject>

@optional
- (void)choiceModel:(NoticePsyModel *)model;

@end

@interface DRPsyCell : BaseCell

@property (nonatomic, weak)  id<NoticeQuestionDelegate>delegate;
@property (nonatomic, strong) NoticePsyModel *psyM;

@end

NS_ASSUME_NONNULL_END
