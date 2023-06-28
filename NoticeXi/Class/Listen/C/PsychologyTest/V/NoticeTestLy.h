//
//  NoticeTestLy.h
//  NoticeXi
//
//  Created by li lei on 2019/2/1.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeLYDELegate <NSObject>

@optional
- (void)liuyan;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTestLy : UIView<UITextViewDelegate>

@property (nonatomic, weak) id <NoticeLYDELegate>delegate;

@property (strong, nonatomic)  UITextView *textView;
@property (nonatomic, strong) UIView *textBackView;
@property (nonatomic, strong) UIView *dissView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) NSString *personlityId;
@property (nonatomic, strong) UIViewController *tostController;
@end

NS_ASSUME_NONNULL_END
