//
//  NoticeClockButtonView.h
//  NoticeXi
//
//  Created by li lei on 2019/10/17.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeClockPyModel.h"
#import "NoticeBBSComentInputView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticeClockButtonDelegate <NSObject>

@optional
- (void)deleteSucessWith:(NoticeClockPyModel*)model;
- (void)setNIming:(NoticeClockPyModel*)model;
- (void)setHidePy:(NoticeClockPyModel*)model;
- (void)setPickerPy:(NoticeClockPyModel*)model;
@end
@interface NoticeClockButtonView : UIView<LCActionSheetDelegate,NoticeBBSComentInputDelegate>
@property (nonatomic, weak) id<NoticeClockButtonDelegate>delegate;
@property (nonatomic, strong) NoticeClockPyModel *pyModel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *tianshiImgView;
@property (nonatomic, strong) UILabel *tsL;
@property (nonatomic, strong) UIImageView *moguiImgView;
@property (nonatomic, strong) UILabel *mgL;
@property (nonatomic, strong) UIImageView *shenImgView;
@property (nonatomic, strong) UILabel *sL;
@property (nonatomic, strong) UILabel *shareL;
@property (nonatomic, strong) UIImageView *qizhiImgView;
@property (nonatomic, strong) UILabel *comL;
@property (nonatomic, assign) BOOL isTcPage;
@property (nonatomic, assign) BOOL noNeedPush;
@property (nonatomic, assign) BOOL needPost;
@property (nonatomic, assign) BOOL needBackGround;
@property (nonatomic, strong) NSMutableArray *imgArrary;
@property (nonatomic, strong) NSMutableArray *labelArrary;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) LCActionSheet *managerSheet;
@property (nonatomic, strong) LCActionSheet *managerPickerSheet;

@property (nonatomic,copy) void (^deletePyBlock)(NoticeClockPyModel *pyModel);
@end

NS_ASSUME_NONNULL_END
