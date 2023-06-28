//
//  NoticeIntuputTextController.h
//  NoticeXi
//
//  Created by li lei on 2020/7/17.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeSendTextDelegate <NSObject>

@optional
- (void)sendTextDelegate:(NSString * __nullable)str;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeIntuputTextController : UIViewController
@property (nonatomic, weak) id <NoticeSendTextDelegate>delegate;
@property (nonatomic, assign) BOOL isRegier;//是否是从注册页面进来
@property (nonatomic, assign) BOOL isChat;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) BOOL isRemember;//是否是记录
@property (strong, nonatomic) NoticeAreaModel *areaModel;
@property (nonatomic, strong) NoticeUserInfoModel *regModel;
@property (nonatomic, assign) BOOL isThird;
@end

NS_ASSUME_NONNULL_END
