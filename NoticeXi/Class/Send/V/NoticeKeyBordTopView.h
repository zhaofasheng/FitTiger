//
//  NoticeKeyBordTopView.h
//  NoticeXi
//
//  Created by li lei on 2020/7/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCustomButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeKeyBordTopView : UIView
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIButton *topicBtn;
@property (nonatomic, strong) UIButton *statusBtn;
@property (nonatomic, strong) UILabel *imgL;
@property (nonatomic, strong) UILabel *topicL;
@property (nonatomic, strong) UILabel *bgmL;
@property (nonatomic, assign) BOOL isSendVoice;
@property (nonatomic, strong) FSCustomButton *shareButton;
@end

NS_ASSUME_NONNULL_END
