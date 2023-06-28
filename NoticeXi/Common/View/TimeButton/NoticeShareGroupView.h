//
//  NoticeShareGroupView.h
//  NoticeXi
//
//  Created by li lei on 2020/10/21.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceListModel.h"
#import "NoticeDrawList.h"
#import "NoticeClockPyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShareGroupView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) UITableView *personTableView;
@property (nonatomic, strong) NSMutableArray *personArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, strong) UILabel *noGroupL;
@property (nonatomic, strong) UILabel *noFriendL;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeDrawList *drawM;
@property (nonatomic, strong) NoticeClockPyModel *pyModel;
@property (nonatomic, strong) UIImageView *collecImageView;
@property (nonatomic, strong) UIImage *sendImage;
@property (nonatomic, strong) UILabel *collL;
@property (nonatomic, copy) void (^clickCollectBlock)(BOOL collection);
@property (nonatomic, copy) void (^clickMoreFriendBlock)(BOOL more);
@property (nonatomic, copy) void (^clickvoiceBtnBlock)(NSInteger voiceType);
- (instancetype)initWithSendVoiceWith;
- (instancetype)initWithRecodeWith;
- (instancetype)initWithShareVoiceToGroup;
- (instancetype)initWithShareOtherDrawToGroup;
- (instancetype)initWithShareSelfDrawToGroup;
- (void)showShareView;
@end

NS_ASSUME_NONNULL_END
