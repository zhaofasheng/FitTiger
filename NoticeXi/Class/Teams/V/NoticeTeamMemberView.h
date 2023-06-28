//
//  NoticeTeamMemberView.h
//  NoticeXi
//
//  Created by li lei on 2023/6/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTeamMemberView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *numView;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *showArr;
@end

NS_ASSUME_NONNULL_END
