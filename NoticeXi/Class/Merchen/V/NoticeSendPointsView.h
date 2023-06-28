//
//  NoticeSendPointsView.h
//  NoticeXi
//
//  Created by li lei on 2022/6/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendPointsView : UIView
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *oldView;
@property (strong, nonatomic) UITextField *phoneView;
@property (nonatomic, strong) NSString *prouctId;
@property (nonatomic, strong) UILabel *markL;

@property (nonatomic, strong) UIButton *nimingButton;
@property (nonatomic, assign) BOOL isNiming;

- (void)show;
@end

NS_ASSUME_NONNULL_END
