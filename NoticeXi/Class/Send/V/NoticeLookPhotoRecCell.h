//
//  NoticeLookPhotoRecCell.h
//  NoticeXi
//
//  Created by li lei on 2022/3/28.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeLookPhotoRecCell : UICollectionViewCell
@property (nonatomic, strong) NoticeVoiceTypeModel *currentChoiceM;

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIView *choiceView;
@end

NS_ASSUME_NONNULL_END
