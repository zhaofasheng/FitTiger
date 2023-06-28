//
//  NoticeDanMuController.h
//  NoticeXi
//
//  Created by li lei on 2021/2/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDanMuController : UIViewController
@property (nonatomic, strong) NoticeDanMuModel *bokeModel;
@property (nonatomic, assign) NSInteger currentItem;
@end

NS_ASSUME_NONNULL_END
