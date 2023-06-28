//
//  NoticeJuBaoBoKeTosatView.h
//  NoticeXi
//
//  Created by li lei on 2022/9/26.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeRecoderEditView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeJuBaoBoKeTosatView : UIView<UITextViewDelegate>
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic,copy) void (^jubaoBlock)(NSString *content);
@property (nonatomic, strong) UILabel *plaL;
@property (nonatomic, strong) NoticeRecoderEditView *editView;
- (void)showView;

@end

NS_ASSUME_NONNULL_END
