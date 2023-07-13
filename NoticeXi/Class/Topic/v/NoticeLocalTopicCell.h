//
//  NoticeLocalTopicCell.h
//  NoticeXi
//
//  Created by li lei on 2018/10/31.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeTopicModel.h"

@protocol NoticeTopiceCancelDelegate <NSObject>

- (void)cancelHistoryTipicIn:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeLocalTopicCell : BaseCell
@property (nonatomic, strong) UILabel *mainL;
@property (nonatomic, strong) NoticeTopicModel *topicM;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger type;//1本地，2收藏，3热门
@property (nonatomic, weak) id<NoticeTopiceCancelDelegate>delegate;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UIImageView *markImageV;
@property (nonatomic, strong) UIButton *likeBtn;
@end

NS_ASSUME_NONNULL_END
