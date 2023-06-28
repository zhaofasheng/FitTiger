//
//  NoticeDrawViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDrawViewController : UIViewController
@property (nonatomic, strong,nullable) NoticeTopicModel *topicM;
@property (nonatomic, strong) UIImage *tuyeImage;
@property (nonatomic, assign) BOOL isTuYa;
@property (nonatomic, assign) BOOL isFromSelf;
@property (nonatomic, assign) BOOL isFromDrawList;
@property (nonatomic, strong) NSString *drawId;
@property (nonatomic, strong) NSString *userId;
@end

NS_ASSUME_NONNULL_END
