//
//  NoticeBBSDetailHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBBSModel.h"
#import "NoticeVoiceImgList.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBBSDetailHeaderView : UIView

@property (nonatomic, strong) NoticeBBSModel *bbsModel;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *contentTextL;
@property (nonatomic, strong) NoticeVoiceImgList *imageViewS;
@end

NS_ASSUME_NONNULL_END
