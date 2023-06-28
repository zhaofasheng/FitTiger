//
//  NoticeBgmLineView.h
//  NoticeXi
//
//  Created by li lei on 2021/8/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTextZJMusicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBgmLineView : UIView
@property (nonatomic, strong) UIImageView *peopleImageView;
@property (nonatomic, strong) UILabel *lineL;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) NoticeTextZJMusicModel *musicM;
@end

NS_ASSUME_NONNULL_END
