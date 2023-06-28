//
//  NoticeSendBBSHistoryCell.h
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceImgList.h"
#import "NoticeBBSModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendBBSHistoryCell : BaseCell<LCActionSheetDelegate>
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *dateL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *contentTextL;
@property (nonatomic, strong) NoticeVoiceImgList *imageViewS;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NoticeBBSModel *bbsModel;
@property (nonatomic,copy) void (^deleteBlock)(NoticeBBSModel *bbsModel);

@property (nonatomic, strong) UIImageView *markImageView;
@end

NS_ASSUME_NONNULL_END
