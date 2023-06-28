//
//  NoticeClickHeaderTeamView.h
//  NoticeXi
//
//  Created by li lei on 2023/6/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTeamChatModel.h"
#import "YYPersonItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeClickHeaderTeamView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *buttonArr;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) YYPersonItem *person;
@property (nonatomic, strong) NoticeTeamChatModel *chatModel;
@property (nonatomic,copy) void (^clickButtonTagBlock)(NSString *clickStr);
- (void)showIconView;
@end

NS_ASSUME_NONNULL_END
