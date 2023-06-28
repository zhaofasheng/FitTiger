//
//  NoticeTitleAndImageCell.h
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

@protocol NoticeCacheManagerDelegate <NSObject>

@optional
- (void)sendVoiceWith:(NSInteger)index;
- (void)deleteVoiceWith:(NSInteger)indexl;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTitleAndImageCell : BaseCell
@property (nonatomic, strong) UILabel *mainL;
@property (nonatomic, strong) UILabel *subL;
@property (nonatomic, strong) UIImageView *subImageV;
@property (nonatomic, strong) UIImageView *leftImageV;
@property (nonatomic, strong) UILabel *subMainL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isSmallHeight;
@property (nonatomic, weak) id <NoticeCacheManagerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
