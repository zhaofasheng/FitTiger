//
//  NoticeEmtionCell.h
//  NoticeXi
//
//  Created by li lei on 2020/10/19.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeEmotionModel.h"
#import "YYKit.h"
#import "PGBubble.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeEmtionCell : UICollectionViewCell
@property (nonatomic, strong) NoticeEmotionModel *emotionModel;
@property (nonatomic, strong) YYAnimatedImageView *sendImageView;
@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, assign) BOOL isBeginChoice;
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) PGBubble *bubble;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, assign) BOOL isCu;//官方表情包
@property (nonatomic, copy) void (^refashBlock)(BOOL reafsh);
@property (nonatomic, copy) void (^collectBlock)(BOOL collect);
@end

NS_ASSUME_NONNULL_END
