//
//  NoticeShareTostView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeClockPyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShareTostView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) NSMutableArray *dataArr1;
@property (nonatomic, strong) UITableView *movieTableView1;

@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *chatL;
@property (nonatomic, strong) UILabel *likeL;
@property (nonatomic, assign) BOOL isPyOrTc;
- (void)showTost;
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeClockPyModel *pyModel;
@property (nonatomic, strong) NoticeClockPyModel *tcModel;
@end

NS_ASSUME_NONNULL_END
