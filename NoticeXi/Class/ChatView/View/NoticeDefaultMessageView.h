//
//  NoticeDefaultMessageView.h
//  NoticeXi
//
//  Created by li lei on 2020/8/7.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeYuSetModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticeSendDefaultClickDelegate <NSObject>

@optional
- (void)sendMessageWithDefault:(NoticeYuSetModel *)model;

@end
@interface NoticeDefaultMessageView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) id <NoticeSendDefaultClickDelegate>delegate;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) NSMutableArray *imgArr;
- (void)show;
@end

NS_ASSUME_NONNULL_END
