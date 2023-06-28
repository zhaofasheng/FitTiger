//
//  NoticeBBSTitleSection.h
//  NoticeXi
//
//  Created by li lei on 2020/11/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBBSModel.h"
#import "NoticeVoiceImgList.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBBSTitleSection : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NoticeBBSModel *bbsModel;
@property (nonatomic, strong) NoticeVoiceImgList *imageViewS;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UILabel *lyL;
@property (nonatomic, strong) UIView *backView;
@end

NS_ASSUME_NONNULL_END
