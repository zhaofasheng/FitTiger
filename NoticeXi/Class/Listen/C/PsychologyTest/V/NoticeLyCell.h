//
//  NoticeLyCell.h
//  NoticeXi
//
//  Created by li lei on 2019/1/30.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeTestLyModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeDeleteLiuYanDelegate <NSObject>

@optional
- (void)deleteLiuYanWith:(NSInteger)index;

@end

@interface NoticeLyCell : BaseCell
@property (nonatomic, strong) NoticeTestLyModel *lyModel;
@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id <NoticeDeleteLiuYanDelegate>delegate;
@property (nonatomic, assign) BOOL isOpen;
@end

NS_ASSUME_NONNULL_END
