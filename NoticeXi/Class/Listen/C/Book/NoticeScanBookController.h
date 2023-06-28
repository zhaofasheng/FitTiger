//
//  NoticeScanBookController.h
//  NoticeXi
//
//  Created by li lei on 2020/6/30.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeSacnModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeScanBookController : UIViewController
@property (nonatomic,copy) void (^addBookBlock)(NoticeScanResult *scanModel);
@end

NS_ASSUME_NONNULL_END
