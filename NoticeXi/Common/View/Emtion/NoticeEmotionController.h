//
//  NoticeEmotionController.h
//  NoticeXi
//
//  Created by li lei on 2020/10/19.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeEmotionController : UIViewController
@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) void (^refashBlock)(BOOL reafsh);
@end

NS_ASSUME_NONNULL_END
