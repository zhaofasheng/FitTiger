//
//  NoticeChoicePhotoCell.h
//  NoticeXi
//
//  Created by li lei on 2018/10/26.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

@protocol NoticeDeleteImageDelegate <NSObject>

- (void)deleteImageWith:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChoicePhotoCell : BaseCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<NoticeDeleteImageDelegate>delegate;
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic,copy) void (^hideKeybord)(BOOL hideKeyBord);
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, strong) NSString *videoPath;
@end

NS_ASSUME_NONNULL_END
