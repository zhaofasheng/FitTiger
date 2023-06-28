//
//  NoticeBookDetail.h
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeBookDetail : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *payView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *searchBtn;
- (void)requestList;
@end

NS_ASSUME_NONNULL_END
