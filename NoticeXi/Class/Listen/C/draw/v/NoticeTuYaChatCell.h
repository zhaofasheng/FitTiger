//
//  NoticeTuYaChatCell.h
//  NoticeXi
//
//  Created by li lei on 2020/6/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeChats.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticeTuYaChatDelegate <NSObject>

@optional
- (void)deleteWithIndex:(NSInteger)tag section:(NSInteger)section;
@end
@interface NoticeTuYaChatCell : BaseCell<LCActionSheetDelegate>
@property (nonatomic, assign) id <NoticeTuYaChatDelegate>delegate;
@property (nonatomic, strong) NoticeChats *chatModel;
@property (nonatomic, strong) UIImageView *sendImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL noSend;
@property (nonatomic, strong) NSString *drawId;
@property (nonatomic,copy) void (^refreshHeightBlock)(NSIndexPath *indxPath);
@property (nonatomic, strong) NSIndexPath *currentPath;
@end

NS_ASSUME_NONNULL_END
