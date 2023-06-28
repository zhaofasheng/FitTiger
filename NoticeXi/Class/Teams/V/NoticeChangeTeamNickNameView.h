//
//  NoticeChangeTeamNickNameView.h
//  NoticeXi
//
//  Created by li lei on 2023/6/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeTeamNickNameView : UIView<UITextFieldDelegate>
@property (nonatomic,copy) void (^sureNameBlock)(NSString *name);
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NSString *currentName;
@property (nonatomic, strong) UIButton *closeBtn;
- (void)showNameView;
@end

NS_ASSUME_NONNULL_END
