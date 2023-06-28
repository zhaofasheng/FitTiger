//
//  NoticeShareToWorld.h
//  NoticeXi
//
//  Created by li lei on 2019/6/14.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceListModel.h"
#import "NoticeShareModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeShareToWorldSuccess <NSObject>

@optional
- (void)shareToWorldSucess;

@end

@interface NoticeShareToWorld : UIView<LCActionSheetDelegate>

- (void)shareToWorldWitn:(NoticeVoiceListModel *)model;

@property (nonatomic, weak) id<NoticeShareToWorldSuccess>delegate;
@property (nonatomic, strong) NoticeVoiceListModel *shareModel;
@property (nonatomic, strong) NoticeShareModel *shareM;
@end

NS_ASSUME_NONNULL_END
