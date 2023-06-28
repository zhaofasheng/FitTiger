//
//  NoticeVideoViewController.h
//  NoticeXi
//
//  Created by 赵小二 on 2018/10/20.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeVideoViewController : UIViewController
@property (nonatomic, strong) NSString *codeNum;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isE;
@property (nonatomic, assign) BOOL hasTest;
@property (nonatomic, strong) NSString *smsCode;
@property (nonatomic, assign) BOOL isRemember;//是否是记录
@property (nonatomic, assign) BOOL isThird;
@property (strong, nonatomic) NoticeAreaModel *areaModel;
@property (nonatomic, strong) NoticeUserInfoModel *regModel;
@end
