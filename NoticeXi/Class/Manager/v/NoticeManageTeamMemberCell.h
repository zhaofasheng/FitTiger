//
//  NoticeManageTeamMemberCell.h
//  NoticeXi
//
//  Created by li lei on 2023/6/27.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeTeamManageMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeManageTeamMemberCell : BaseCell
@property (nonatomic, strong) NoticeTeamManageMemberModel *model;
@property (nonatomic, strong) UILabel *fromL;
@property (nonatomic, strong) UILabel *toL;
@property (nonatomic, strong) UILabel *reasonL;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) UILabel *teamL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *checkL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) BOOL isOut;
@end

NS_ASSUME_NONNULL_END
