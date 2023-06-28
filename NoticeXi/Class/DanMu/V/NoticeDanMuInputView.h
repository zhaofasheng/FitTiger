//
//  NoticeDanMuInputView.h
//  NoticeXi
//
//  Created by li lei on 2021/2/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NoticeDanMuDelegate <NSObject>

@optional
- (void)sendContent:(NSString *__nullable)content color:(NSString *__nullable)color isTop:(BOOL)isTop;
- (void)choiceType:(BOOL)isChoiceType;
- (void)keyboderDidShow;
- (void)keyboderDidHide;
@end
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDanMuInputView : UIView<UITextViewDelegate>
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) UIImageView *sendImageView;
@property (nonatomic, weak) id <NoticeDanMuDelegate>delegate;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *emtionBtn;
@property (nonatomic, assign) BOOL choiceIng;
@property (nonatomic, assign) BOOL isUpKeyBorder;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) BOOL isNoneedReGetTime;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) UILabel *timeL;
@end

NS_ASSUME_NONNULL_END
