//
//  NoticeMoivceInCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMovie.h"
#import "NoticeBook.h"
#import "NoticeSong.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMoivceInCell : UIView
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *songScro;
@property (nonatomic, strong) NSString *userScro;
@property (nonatomic, strong) NoticeMovie *movie;
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, strong) UIImageView *scoreImageView;
- (void)refreshUI;

@end

NS_ASSUME_NONNULL_END
