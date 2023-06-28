//
//  NoticeSetBanneerView.h
//  NoticeXi
//
//  Created by li lei on 2021/1/15.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBannerModel.h"
#import "FDAlertView.h"
#import "RBCustomDatePickerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSetBanneerView : UIView<sendTheValueDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) NoticeBannerModel *bannerM;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, assign) NSInteger choiceType;
@property (nonatomic,copy) void (^refreshBlock)(BOOL refresh);
@property (nonatomic, strong) NSString *managerCode;
@property (nonatomic, strong) UIImage *banneerImage;
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *bannerId;
@end

NS_ASSUME_NONNULL_END
