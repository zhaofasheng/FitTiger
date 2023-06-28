//
//  NoticeUserQuestionCell.h
//  NoticeXi
//
//  Created by li lei on 2021/6/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeUserQuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserQuestionCell : BaseCell
@property (nonatomic, strong) NoticeUserQuestionModel *questionM;
@property (nonatomic, assign) BOOL needMark;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) UILabel *numL;
@end

NS_ASSUME_NONNULL_END
