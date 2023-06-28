//
//  NoticeMovieTopCell.h
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

@protocol NoticeMyMBSListClickPalyerButtonDelegate <NSObject>

@optional
- (void)clickMBSPlayButton:(NSInteger)index;
- (void)clickMBSMoreButton:(NSInteger)index;
@end

@interface NoticeMovieTopCell : BaseCell
@property (nonatomic, weak) id<NoticeMyMBSListClickPalyerButtonDelegate>delegate;
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) NoticeBook *myBook;
@property (nonatomic, strong) NoticeMovie *movice;
@property (nonatomic, strong) NoticeMovie *firstMovice;
@property (nonatomic, strong) NoticeBook *firstbook;
@property (nonatomic, strong) NoticeMovie *myMovice;
@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) CBAutoScrollLabel *nameL;
@property (nonatomic, strong) UILabel *scorL;
@property (nonatomic, strong) UILabel *scorTitleL;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *moreL;
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
