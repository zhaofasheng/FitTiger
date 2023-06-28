//
//  NoticeTextZJContentCell.h
//  NoticeXi
//
//  Created by li lei on 2021/1/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTextZJContentCell : UIView

@property (nonatomic, strong) NoticeScrollView *scrollView;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *lockImageV;
@end

NS_ASSUME_NONNULL_END
