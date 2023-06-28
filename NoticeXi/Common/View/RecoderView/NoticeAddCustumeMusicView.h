//
//  NoticeAddCustumeMusicView.h
//  NoticeXi
//
//  Created by li lei on 2021/8/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeHowAddMusicView.h"
#import "NoticeCustumMusiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAddCustumeMusicView : UIView<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NoticeHowAddMusicView *howView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UILabel *erroL;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL noRefresh;
@property (nonatomic,copy) void (^useMusicBlock)(NoticeCustumMusiceModel *model);
@property (nonatomic, strong) NoticeCustumMusiceModel *currentModel;
@property (nonatomic, strong) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isFromRecodering;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isFromeCenter;
@property (nonatomic, strong) NoticeNoDataView *queshenView;
@property (nonatomic, strong) UIView *mbsView;
@property (nonatomic, strong) NoticeCustumBackImageView *backGroundImageView;
@property (nonatomic,copy) void (^addMusicBlock)(BOOL add);
@property (nonatomic,copy) void (^requestMusicBlock)(BOOL add);
@property (nonatomic, strong) UIView *navView;
- (void)show;
- (void)clickWith:(NoticeCustumMusiceModel*)curM;
- (void)refresh;
@end

NS_ASSUME_NONNULL_END
