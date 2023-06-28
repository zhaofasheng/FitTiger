//
//  NoticeTextTopicView.h
//  NoticeXi
//
//  Created by li lei on 2022/3/30.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTextTopicView : UIView
@property (nonatomic, strong,nullable) NoticeTopicModel *topicM;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIButton *closeBtn;
@end

NS_ASSUME_NONNULL_END
