//
//  NoticeTestResultCell.h
//  NoticeXi
//
//  Created by li lei on 2021/5/26.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticePsyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTestResultCell : BaseCell
@property (nonatomic, strong) NoticePsyModel *testM;
@property (nonatomic, assign) BOOL noTap;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *sameImageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *choiceAL;
@property (nonatomic, strong) UILabel *choiceBL;
@property (nonatomic, strong) UILabel *choiceCL;
@property (nonatomic, strong) UILabel *choiceDL;
@property (nonatomic, strong) NSMutableArray *labelArr;
@property (nonatomic,copy) void (^choiceBlock)(NoticePsyModel *choiceM);
@end

NS_ASSUME_NONNULL_END
