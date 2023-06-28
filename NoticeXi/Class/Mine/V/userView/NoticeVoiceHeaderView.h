//
//  NoticeVoiceHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceHeaderView : UIImageView
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, assign) BOOL isOther;
- (void)refresh;

@end

NS_ASSUME_NONNULL_END
