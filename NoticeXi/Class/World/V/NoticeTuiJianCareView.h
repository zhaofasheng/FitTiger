//
//  NoticeTuiJianCareView.h
//  NoticeXi
//
//  Created by li lei on 2021/5/17.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTuiJianCareView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *openImageView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic,copy) void (^changeFrameBlock)(BOOL change);
@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) UILabel *noDataL;
- (void)request;
@end

NS_ASSUME_NONNULL_END
