//
//  NoticeTextZJContentView.h
//  NoticeXi
//
//  Created by li lei on 2021/1/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeZjModel.h"
#import "NoticeScrollView.h"
NS_ASSUME_NONNULL_BEGIN


@interface NoticeTextZJContentView : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) NoticeZjModel *zjModel;
@property (nonatomic, strong) NoticeScrollView *scroolView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *viewArr;
@property (nonatomic, strong) UIButton *musicBtn;
@property (nonatomic, strong) UIButton *contentBtn;
@property (nonatomic, strong) UIButton *listBtn;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NoticeVoiceListModel *currentModel;
@property (nonatomic,copy) void (^getCurrentBlock)(NoticeVoiceListModel *model);

@end

NS_ASSUME_NONNULL_END
