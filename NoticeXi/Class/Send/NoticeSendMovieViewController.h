//
//  NoticeSendMovieViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeMovie.h"
#import "NoticeBook.h"
#import "NoticeSong.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendMovieViewController : BaseTableViewController
@property (nonatomic, strong) NoticeMovie *movice;
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL soonRecoder;//立刻录音
@property (nonatomic, strong,nullable) NSString *locaPath;
@property (nonatomic, strong,nullable) NSString *timeLen;
@property (nonatomic, assign) BOOL goRecoderAndLook;
@property (nonatomic, assign) BOOL isLongTime;//是否是录制长语音
@end

NS_ASSUME_NONNULL_END
