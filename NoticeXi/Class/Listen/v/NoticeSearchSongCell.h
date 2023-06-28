//
//  NoticeSearchSongCell.h
//  NoticeXi
//
//  Created by li lei on 2019/4/19.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeSong.h"
#import "CBAutoScrollLabel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeMySongListClickPalyerButtonDelegate <NSObject>

@optional
- (void)clickMBSPlayButton:(NSInteger)index;
- (void)clickMBSMore:(NSInteger)index;
@end

@interface NoticeSearchSongCell : UITableViewCell
@property (nonatomic, weak) id<NoticeMySongListClickPalyerButtonDelegate>delegate;
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, strong) NoticeSong *mySong;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) CBAutoScrollLabel *nameL;
@property (nonatomic, strong) UILabel *scorL;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *moreL;
@end

NS_ASSUME_NONNULL_END
