//
//  NoticeAtTeamsListView.h
//  NoticeXi
//
//  Created by li lei on 2023/6/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+SCIndexView.h"
#import "SCIndexViewConfiguration.h"
#import "NoticeTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAtTeamsListView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *syArr;
@property (nonatomic, strong) NSMutableArray *atArr;
@property (nonatomic, assign) BOOL canChoiceMore;
@property (nonatomic, assign) BOOL safeLock;
@property (nonatomic, strong) UILabel *choiceMoreL;
@property (nonatomic, strong) NoticeTextView *contentL;
@property (nonatomic,copy) void (^atBlock)(NSMutableArray *atArrary);
@property (nonatomic, strong) UIView *atAllView;
- (void)remvokUserId:(NSString *)userId;
- (void)showATView;
@end

NS_ASSUME_NONNULL_END
