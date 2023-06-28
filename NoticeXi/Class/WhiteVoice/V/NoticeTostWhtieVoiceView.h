//
//  NoticeTostWhtieVoiceView.h
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeWhiteVoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTostWhtieVoiceView : UIView
- (instancetype)initWithShow:(NoticeWhiteVoiceListModel *)cardM;
- (void)showCardView;
@property (nonatomic, strong)  UIImageView *backImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) NSString *audioUrl;
@end

NS_ASSUME_NONNULL_END
