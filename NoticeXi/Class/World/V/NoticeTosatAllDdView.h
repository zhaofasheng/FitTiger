//
//  NoticeTosatAllDdView.h
//  NoticeXi
//
//  Created by li lei on 2022/1/18.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTosatAllDdView : UIView
@property (nonatomic, strong) NoticeTopicModel *activityM;
@property (nonatomic, strong) UILabel *topicL;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *backView;

- (void)showView;

@end

NS_ASSUME_NONNULL_END
