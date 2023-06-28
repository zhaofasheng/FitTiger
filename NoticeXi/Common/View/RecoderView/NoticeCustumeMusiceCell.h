//
//  NoticeCustumeMusiceCell.h
//  NoticeXi
//
//  Created by li lei on 2021/8/30.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeCustumMusiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeCustumeMusiceCell : BaseCell
@property (nonatomic, strong) NoticeCustumMusiceModel *musicModel;
@property (nonatomic,copy) void (^playMusicBlock)(NoticeCustumMusiceModel *model);
@property (nonatomic,copy) void (^useMusicBlock)(NoticeCustumMusiceModel *model);
@property (nonatomic,copy) void (^deletesMusicBlock)(NoticeCustumMusiceModel *model);
@property (nonatomic,copy) void (^addMusicBlock)(BOOL add);
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *songNameL;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) UIButton *useButton;
@property (nonatomic, assign) BOOL isAddToMusicList;
@property (nonatomic, assign) BOOL isMyMusicList;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) BOOL isOther;//别人的歌单
@end

NS_ASSUME_NONNULL_END
