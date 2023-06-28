//
//  NoticeAllHotCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMovie.h"
#import "NoticeBook.h"
#import "NoticeSong.h"
#import "CBAutoScrollLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAllHotCell : BaseCell
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, strong) NoticeMovie *movice;
@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *scorL;
@property (nonatomic, strong) UILabel *scorTitleL;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *backV;
@end

NS_ASSUME_NONNULL_END
