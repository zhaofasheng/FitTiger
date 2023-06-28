//
//  NoticeTimeList.h
//  NoticeXi
//
//  Created by li lei on 2018/12/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceListModel.h"
#import "NoticeNoDataView.h"
#import "CustomPickerView.h"
#import "NoticeAbout.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticePlayChoiceTimeDelegate <NSObject>
@optional
- (void)choiceModelWithIndex:(NSInteger)index;
- (void)sendEmiton;
- (void)refreshMoreSuccess:(NSMutableArray *)dataArr;
- (void)removeAtIndex:(NSInteger)index;
@end

@interface NoticeTimeList : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<NoticePlayChoiceTimeDelegate>delegate;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *subTitleL;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NoticeVoiceListModel *currentModel;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isZj;
@property (nonatomic, assign) BOOL isLimit;
@property (nonatomic, strong) CustomPickerView *pickerView;
@property (nonatomic, strong) NoticeAbout *realisAbout;
- (void)show:(UIViewController *)ctl;

@end

NS_ASSUME_NONNULL_END
