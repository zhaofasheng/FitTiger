//
//  NoticeShopChatCommentCell.h
//  NoticeXi
//
//  Created by li lei on 2023/4/17.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeShopCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopChatCommentCell : BaseCell
@property (nonatomic, strong) NoticeShopCommentModel *commentModel;
@property (nonatomic, assign) BOOL isUserView;//是否是用户视角
@property (nonatomic, assign) BOOL needDelete;//删除按钮
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *marksL;
@property (nonatomic, strong) UILabel *labelL;
@property (nonatomic, strong) UIImageView *scroeimageView;
@property (nonatomic, strong) UILabel *scoreL;
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, assign) BOOL isComDetail;//评论详情
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, copy) void(^deleteSureBlock)(NoticeShopCommentModel *commentM);
@end

NS_ASSUME_NONNULL_END
