//
//  NoticeHotMovieCell.h
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

@interface NoticeHotMovieCell : BaseCell
@property (nonatomic, strong) NoticeMovie *movie;
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *scorL;
@end

NS_ASSUME_NONNULL_END
