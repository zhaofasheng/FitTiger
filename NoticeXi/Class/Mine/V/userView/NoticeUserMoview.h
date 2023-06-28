//
//  NoticeUserMoview.h
//  NoticeXi
//
//  Created by li lei on 2018/11/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMovie.h"
#import "NoticeBook.h"
#import "NoticeSong.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserMoview : UIView
@property (nonatomic, strong) NSString *userScroe;
@property (nonatomic, strong) NSString *songScroe;
@property (nonatomic, strong) NoticeMovie *movie;
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *scorL;
@property (nonatomic, strong) UILabel *scorTitleL;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) UIImageView *scroImagev;
@end

NS_ASSUME_NONNULL_END
