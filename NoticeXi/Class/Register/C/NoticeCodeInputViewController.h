//
//  NoticeCodeInputViewController.h
//  NoticeXi
//
//  Created by 赵小二 on 2018/10/20.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeCodeInputViewController : UIViewController
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isThird;
@property (nonatomic, assign) BOOL isRemember;//是否是记录
@property (strong, nonatomic) NoticeAreaModel *areaModel;
@property (nonatomic, strong) NoticeUserInfoModel *regModel;
@property (nonatomic, strong) NSString *locapath;
@property (nonatomic, strong) NSString *timeLength;
@property (nonatomic, strong) NSString *text;
@end
