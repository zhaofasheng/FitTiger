//
//  NoticeChangeSkinController.h
//  NoticeXi
//
//  Created by li lei on 2021/8/3.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeSkinModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeSkinController : UIViewController
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NoticeSkinModel *skinModel;
@end

NS_ASSUME_NONNULL_END
