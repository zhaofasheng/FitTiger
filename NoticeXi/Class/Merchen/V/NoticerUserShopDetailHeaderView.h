//
//  NoticerUserShopDetailHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2023/4/11.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticerUserShopDetailHeaderView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) FSCustomButton *noVoiceL;
@property (nonatomic, strong) UILabel *orderNumL;
@property (nonatomic, strong) UILabel *stausNumL;
@property (nonatomic, strong) UILabel *defaultL;
@property (nonatomic, strong) NSMutableArray *labelArr;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *timeL;
- (void)stopPlay;
@end

NS_ASSUME_NONNULL_END
