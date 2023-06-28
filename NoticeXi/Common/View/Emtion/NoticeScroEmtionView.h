//
//  NoticeScroEmtionView.h
//  NoticeXi
//
//  Created by li lei on 2020/12/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeEmotionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeScroEmtionView : UIView<UIScrollViewDelegate>
@property (nonatomic, copy) void (^sendBlock)(NSString *url, NSString *buckId,NSString *pictureId,BOOL isHot);
@property (nonatomic, strong) NoticeEmotionView *emotionView;
@property (nonatomic, strong) NoticeEmotionView *hotEmotionView;
@property (nonatomic, strong) NoticeEmotionView *cumEmotionView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *selfBtn;
@property (nonatomic, strong) UIButton *hotBtn;
@property (nonatomic, strong) UIButton *cuBtn;
@property (nonatomic, assign) BOOL isSelfEmotion;
@property (nonatomic, copy) void (^pushBlock)(BOOL push);
- (void)refreshEmotion;
@end

NS_ASSUME_NONNULL_END
