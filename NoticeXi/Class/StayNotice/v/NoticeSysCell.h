//
//  NoticeSysCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMessage.h"
#import "GZLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSysCell : BaseCell
@property (nonatomic, strong) NoticeMessage *message;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UILabel *buttonL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *editL;
@property (nonatomic,copy) void (^deleteBlock)(NoticeMessage *msgM);
@property (nonatomic,copy) void (^editBlock)(NoticeMessage *msgM);
@end

NS_ASSUME_NONNULL_END
