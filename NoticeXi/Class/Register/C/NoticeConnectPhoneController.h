//
//  NoticeConnectPhoneController.h
//  NoticeXi
//
//  Created by li lei on 2020/7/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeConnectPhoneController : UIViewController
@property (nonatomic, assign) BOOL isThird;
@property (nonatomic, assign) BOOL isRegister;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) BOOL isRemember;//是否是记录
@property (strong, nonatomic) NoticeAreaModel *areaModel;
@property (nonatomic, strong) NoticeUserInfoModel *regModel;
@property (nonatomic, strong) NSString *locapath;
@property (nonatomic, strong) NSString *timeLength;
@property (nonatomic, strong) NSString *text;
@end

NS_ASSUME_NONNULL_END
