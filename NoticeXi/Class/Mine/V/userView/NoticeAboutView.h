//
//  NoticeAboutView.h
//  NoticeXi
//
//  Created by li lei on 2019/12/19.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeAbout.h"
#import "NoticeAchievementModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAboutView : UIView<TZImagePickerControllerDelegate,LCActionSheetDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isJustFriend;
@property (nonatomic, assign) BOOL isOtherNodata;
@property (nonatomic, strong) NoticeAbout *aboutM;
@property (nonatomic, strong) NoticeUserInfoModel *userInfo;
@property (nonatomic, strong) UIImageView *headerIimag;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *labelTopic1;
@property (nonatomic, strong) UILabel *labelTopic2;
@property (nonatomic, strong) UILabel *labelTopic3;
@property (nonatomic, strong) NSMutableArray *topicArr;
@property (nonatomic, strong) UIButton *achButton;
@property (nonatomic, strong) UILabel *titleL1;
@property (nonatomic, strong) UILabel *titleL2;
@property (nonatomic, strong) UIImageView *achImageView1;
@property (nonatomic, strong) UIImageView *achImageView2;
@property (nonatomic, strong) UILabel *achL1;
@property (nonatomic, strong) UILabel *achL2;
@property (nonatomic, strong) UIView *achBackView;
@property (nonatomic, strong) NoticeAchievementModel *achmentDate;
@property (nonatomic, strong) NoticeAchievementModel *achmentSgj;
- (void)showTostView;
- (void)showTostViewAnmtion;
- (void)dissMiss;
- (void)requestAch;
@end

NS_ASSUME_NONNULL_END
