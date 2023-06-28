//
//  NoticeSendStatusView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceStatusDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendStatusView : UIView
@property (nonatomic, strong) UIImageView *musicImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) NoticeVoiceStatusDetailModel *statusM;
@end

NS_ASSUME_NONNULL_END
