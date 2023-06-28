//
//  NoticeTCCell.h
//  NoticeXi
//
//  Created by li lei on 2019/11/8.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeClockPyModel.h"
#import "NoticeManager.h"
#import "NoticeLelveImageView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeTcCellDelegate <NSObject>

@optional
- (void)delegateSuccess:(NoticeClockPyModel *)tcModel;
- (void)recoderSuccess:(NoticeClockPyModel *)tcModel;
- (void)editManagerWithDelete;
- (void)editManagerWithHide;
@end

@interface NoticeTCCell : BaseCell<NoticeRecordDelegate,NoticeManagerUserDelegate,LCActionSheetDelegate>
@property (nonatomic, assign) BOOL isGoToUserCenter;
@property (nonatomic, weak) id <NoticeTcCellDelegate>delegate;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) NoticeClockPyModel *tcModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *mbView;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UILabel *contentL;

@property (nonatomic, strong) NSString *managerCode;
@property (nonatomic, strong) UIButton *priBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIView *buttonEditView;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UIImageView *luyinMarkImage;
@property (nonatomic, strong) UILabel *numRecL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *pyImageView;
@property (nonatomic, strong) UILabel *hasL;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) LCActionSheet *managerSheet;
@property (nonatomic, assign) BOOL isHideTc;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) LCActionSheet *otherSheet;
@property (nonatomic, strong) UIImageView *scImageV;
@property (nonatomic, strong) UILabel *scL;
@property (nonatomic, assign) BOOL isUserCenter;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) NoticeLelveImageView *lelveImageView;
@end

NS_ASSUME_NONNULL_END
