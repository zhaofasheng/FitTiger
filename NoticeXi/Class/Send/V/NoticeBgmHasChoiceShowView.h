//
//  NoticeBgmHasChoiceShowView.h
//  NoticeXi
//
//  Created by li lei on 2022/4/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeBgmHasChoiceShowView : UIView
@property (nonatomic, assign) BOOL isReedit;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isaddSend;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIButton *closeBtn;
@end

NS_ASSUME_NONNULL_END
