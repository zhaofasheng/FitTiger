//
//  NoticeNewStyleDrawCell.h
//  NoticeXi
//
//  Created by li lei on 2020/6/2.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeDrawList.h"
#import "NoticeManager.h"
#import "NoticeLelveImageView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticeNewDrawEditDelegate <NSObject>

@optional
- (void)deleteNewDrawSucessWith:(NSInteger)index;

@end
@interface NoticeNewStyleDrawCell : BaseCell<LCActionSheetDelegate,NoticeManagerUserDelegate>
@property (nonatomic, assign) id <NoticeNewDrawEditDelegate>delegate;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) NoticeLelveImageView *lelveImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *scL;
@property (nonatomic, strong) UILabel *topicL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *drawImageView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *sendOrCollBtn;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UILabel *firstL;
@property (nonatomic, strong) NoticeDrawList *drawM;
@property (nonatomic, strong) UIImageView *firstImageView1;
@property (nonatomic, strong) UILabel *firstL1;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) LCActionSheet *isManagerSheet;
@property (nonatomic, assign) BOOL goCenter;
@property (nonatomic, assign) BOOL noPushTopic;
@property (nonatomic, strong) UIImageView *scImageView;

@property (nonatomic, strong) UILabel *pickerL;
@property (nonatomic, assign) NSInteger type;//0 今日推荐，1热门，2实时，3我的作品，4，收藏,5,别人的作品,6作品单页,7有人喜欢了你的画
@end

NS_ASSUME_NONNULL_END
