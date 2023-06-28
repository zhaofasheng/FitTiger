//
//  NoticePinBiView.h
//  NoticeXi
//
//  Created by li lei on 2019/6/3.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PinBiResult)(NSInteger type);
typedef void(^deleteClickBlock)(NSInteger type);
@interface NoticePinBiView : UIView
- (instancetype)initWithDeleteGroupMember;
- (instancetype)initWithLeaderJuBaoView1;
- (instancetype)initWithLeaderJuBaoViewDraw;
- (instancetype)initWithPinBiView;
- (instancetype)initWithLeaderView;
- (instancetype)initWithServer:(NSInteger)type;
- (instancetype)initWithTostViewType:(NSInteger)type;
- (instancetype)initWithJuBaoCardCallView;
- (instancetype)initWithLeaderJuBaoView;
- (instancetype)initWithLeaderWorld;
- (instancetype)initWithLeaderBook:(NSInteger)type;
- (instancetype)initWithWarnTostViewContent:(NSString *)content;
- (instancetype)initWithTostViewString:(NSString *)str;
- (instancetype)initWithWarnWord:(NSString *)warnWord;
- (instancetype)initWithNoticeView;
- (instancetype)initWithNoticeViewWarn;
- (instancetype)initWithLeaderView1;
- (instancetype)initWithTostWithImage:(NSString *)imageName titleName:(NSString *)titleName content1:(NSString *)content1 content2:(NSString *)content buttonName1:(NSString *)name1 buttonName2:(NSString *)name2 actionId:(NSString *)actionId type:(NSInteger)type;//1 共享到世界  2:0秒用户弹框
- (instancetype)initWithAddZJView;
- (instancetype)initWithLeaderViewZjLlimiy;
- (instancetype)initWithImageView;
- (instancetype)initWithJuBaoCallView;
- (instancetype)initWithGroupName1:(NSString *)name name2:(NSString *)name2;
@property (nonatomic,copy) PinBiResult ChoiceType;
@property (nonatomic,copy) deleteClickBlock deleteBlock;
@property (nonatomic, strong) NSString *actionId;
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UIView *tostView;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger imageTostType;//1 共享到世界  2:0秒用户弹框  3:新用户弹框选择服务器 6:强制更新  7:建议更新
@property (nonatomic, copy) void (^choiceBlock)(NSString *name);
@property (nonatomic, copy) void (^sureBlock)(NSInteger type);
@property (nonatomic, strong) NSString *choiceName1;
@property (nonatomic, strong) NSString *choiceName2;
- (void)showPinbView;
- (void)showTostView;
- (instancetype)initWithStopServer:(NSInteger)type dayNum:(NSInteger)dayNum;
@end

NS_ASSUME_NONNULL_END
