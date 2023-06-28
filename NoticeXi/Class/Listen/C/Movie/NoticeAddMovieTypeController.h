//
//  NoticeAddMovieTypeController.h
//  NoticeXi
//
//  Created by li lei on 2019/7/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeAddMovieTypeController : UIViewController
@property (nonatomic, strong) NSString *movieType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic,copy) void (^movieTypeBlock)(NSString *name);
@end

NS_ASSUME_NONNULL_END
