//
//  NoticeAddMovieNameController.h
//  NoticeXi
//
//  Created by li lei on 2019/7/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeAddMovieNameController : UIViewController
@property (nonatomic, strong) NSString *movieName;
@property (nonatomic,copy) void (^movieNameBlock)(NSString *name);
@property (nonatomic, assign) NSInteger type;//1书籍名称，2歌曲名称，3歌曲作者，4歌曲专辑  5自己的专辑  6书籍作者
@end

NS_ASSUME_NONNULL_END
