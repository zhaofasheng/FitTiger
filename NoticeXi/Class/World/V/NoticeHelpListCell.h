//
//  NoticeHelpListCell.h
//  NoticeXi
//
//  Created by li lei on 2022/8/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeHelpListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHelpListCell : BaseCell<LCActionSheetDelegate>
@property (nonatomic, strong) NoticeHelpListModel *helpModel;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIImageView *hotImageVuew;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, copy) void (^noLikeBlock)(NoticeHelpListModel *helpM);
@end

NS_ASSUME_NONNULL_END
