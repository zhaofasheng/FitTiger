//
//  NoticeMoreWantController.h
//  NoticeXi
//
//  Created by li lei on 2020/7/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMoreWantController : UIViewController
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, assign) BOOL isThird;
@property (strong, nonatomic) NoticeAreaModel *areaModel;
@property (nonatomic, strong) NoticeUserInfoModel *regModel;
@end

NS_ASSUME_NONNULL_END
