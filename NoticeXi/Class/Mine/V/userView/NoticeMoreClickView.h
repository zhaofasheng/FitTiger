//
//  NoticeMoreClickView.h
//  NoticeXi
//
//  Created by li lei on 2022/9/7.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMoreClickView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *bokeId;
- (void)showTost;
@end

NS_ASSUME_NONNULL_END
