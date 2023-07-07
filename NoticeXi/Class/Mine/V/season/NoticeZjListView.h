//
//  NoticeZjListView.h
//  NoticeXi
//
//  Created by li lei on 2019/8/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeNoDataView.h"
#import "NoticeVoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeMovieZjChatDelegate <NSObject>

@optional
- (void)moveToZjId:(NSString *)zjId diaiD:(NSString *)dialogId;
//创建的同时属于移动
- (void)moveAndCreateNewdiaiD:(NSString *)dialogId parm:(NSMutableDictionary *)parm;
@end

@interface NoticeZjListView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) id <NoticeMovieZjChatDelegate>delegate;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NoticeVoiceListModel *choiceM;
@property (nonatomic, strong) NSString *currentAlbumId;
@property (nonatomic, strong) NSString *choiceName;
@property (nonatomic, assign) BOOL isAdd;//YES  下拉
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, assign) BOOL isText;
@property (nonatomic, assign) BOOL isSendVoiceAdd;
@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, assign) BOOL isMove;
@property (nonatomic,copy) void (^addSuccessBlock)(NoticeZjModel *model);
@property (nonatomic, strong) NSString *dialogId;
@property (nonatomic, assign) BOOL isLimit;//是否是仅自己可见的对话专辑
- (instancetype)initWithFrame:(CGRect)frame isLimit:(BOOL)isLimit;
- (void)show;
@end

NS_ASSUME_NONNULL_END
