//
//  NoticeCarePeopleCell.h
//  NoticeXi
//
//  Created by li lei on 2021/4/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeFriendAcdModel.h"
#import "NoticeLelveImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeCarePeopleCell : BaseCell<LCActionSheetDelegate>
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NoticeLelveImageView *lelveImageView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) UILabel *hasNewInfoL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *funBtn;
@property (nonatomic, strong) NoticeFriendAcdModel *careModel;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isLikeEachOther;
@property (nonatomic, assign) BOOL isOfCared;
@property (nonatomic, assign) BOOL isSendWhite;
@property (nonatomic,copy) void (^cancelCareBlock)(NoticeFriendAcdModel *careM);
@property (nonatomic,copy) void (^sendBlock)(NoticeFriendAcdModel *person);
@property (nonatomic, strong) UIImage *sendImage;
@property (nonatomic, strong) NSString *resourceId;
@property (nonatomic, strong) UIButton *moreBtn;
@end

NS_ASSUME_NONNULL_END
