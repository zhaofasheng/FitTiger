//
//  NoticeAlbumView.h
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumPhotoCell.h"
#import "FSCustomButton.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeAlbumChoiceDelegate <NSObject>

@optional
- (void)choiceWith:(TZAlbumModel *)albumM;

@end

@interface NoticeAlbumView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id <NoticeAlbumChoiceDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *albumArr;
@property (nonatomic, assign) BOOL isDrop;

- (void)show:(FSCustomButton *)btn;
- (void)show:(FSCustomButton *)btn to:(UIView *)view;
- (void)dissMiss:(FSCustomButton *)btn;
@end

NS_ASSUME_NONNULL_END
