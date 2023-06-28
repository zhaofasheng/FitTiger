//
//  NoticeMovieDetail.h
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMovie.h"
#import "NoticeBook.h"
#import "NoticeSong.h"
#import "CBAutoScrollLabel.h"
@protocol NoticewTextDelegate <NSObject>

- (void)openmoreClickDelegate;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMovieDetail : UIView
@property (nonatomic, assign) BOOL isSong;
@property (nonatomic, assign) BOOL isBook;
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) NoticeBook *sendBook;
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, strong) NoticeSong *sendSong;
@property (nonatomic, strong) NoticeMovie *movice;
@property (nonatomic, strong) NoticeMovie *sendMovice;
@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *scorL;
@property (nonatomic, strong) UILabel *scorTitleL;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) id<NoticewTextDelegate>delegate;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *backView;
@end

NS_ASSUME_NONNULL_END
