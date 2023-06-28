//
//  NoticeDrawCell.h
//  NoticeXi
//
//  Created by li lei on 2019/7/8.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeDrawList.h"
#import "NoticeManager.h"
#import "NoticeDrawTuM.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeDrawEditDelegate <NSObject>

@optional
- (void)deleteSucessWith:(NSInteger)index;

@end

@interface NoticeDrawCell : BaseCell<NoticeManagerUserDelegate,LCActionSheetDelegate>

@property (nonatomic, strong) NoticeDrawList *drawModel;
@property (nonatomic, assign) id <NoticeDrawEditDelegate>delegate;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *topicL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *drawImageView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) MCFireworksButton *firstImageView;
@property (nonatomic, strong) UILabel *firstL;

@property (nonatomic, strong) MCFireworksButton *firstImageView1;
@property (nonatomic, strong) UILabel *firstL1;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UILabel *thirdL;
@property (nonatomic, strong) UILabel *viewL;
@property (nonatomic, strong) UILabel *jsL;
@property (nonatomic, assign) BOOL isTopice;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isTuYaManager;
@property (nonatomic, assign) BOOL noNeedTuYa;
@property (nonatomic, assign) BOOL isMyDraw;
@property (nonatomic, assign) BOOL isPeopleTuYa;//是否是大家的涂鸦作品
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) LCActionSheet *isManagerSheet;
@property (nonatomic, strong) LCActionSheet *isjubaoSheet;
@property (nonatomic, strong) LCActionSheet *tuyaSheet;
@property (nonatomic, strong) LCActionSheet *tuyaSwitchSheet;
@property (nonatomic, strong) UIView *buttonEditView;
@property (nonatomic, strong) UIButton *priBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) NSString *passCode;
@property (nonatomic, strong) NoticeDrawTuM *tuModel;
@property (nonatomic, strong) UIButton *tyBtn;

@property (nonatomic, strong) UIButton *likeNumBtn;
@property (nonatomic, strong) UIButton *tyNumBtn;


@end

NS_ASSUME_NONNULL_END
