//
//  NoticeHotMovieList.h
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeHotMovieList : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *payView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *searchBtn;
- (void)requestList;
@end

NS_ASSUME_NONNULL_END
