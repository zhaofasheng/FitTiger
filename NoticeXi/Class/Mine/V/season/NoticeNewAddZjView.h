//
//  NoticeNewAddZjView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/21.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewAddZjView : UIView<UITextFieldDelegate>
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *sendButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) UIImageView *choiceTapView;
@property (nonatomic, strong) UILabel *choiceL;
@property (nonatomic, strong) UIButton *onlySelfButton;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isDiaZJ;
@property (nonatomic,copy) void (^addBlock)(NSString *name,BOOL isOpen);
@end

NS_ASSUME_NONNULL_END
