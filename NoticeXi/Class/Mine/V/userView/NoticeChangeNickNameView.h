//
//  NoticeChangeNickNameView.h
//  NoticeXi
//
//  Created by li lei on 2022/8/4.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeNickNameView : UIView
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic,copy) void (^sendBlock)(NSString *name);
@end

NS_ASSUME_NONNULL_END
