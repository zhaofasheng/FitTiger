//
//  NoticeNewUserModel.h
//  NoticeXi
//
//  Created by li lei on 2021/8/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewUserModel : NSObject

@property (nonatomic, strong) NSString *mp4Id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *video_url;

@property (nonatomic, assign) BOOL hasLook;

@end

NS_ASSUME_NONNULL_END
