//
//  NoticePayReodModel.h
//  NoticeXi
//
//  Created by li lei on 2021/12/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticePayReodModel : NSObject

@property (nonatomic, strong) NSString *nick_name;

@property (nonatomic, strong) NSString *fee;
@property (nonatomic, strong) NSString *pay_time;
@property (nonatomic, strong) NSString *pay_type;
@property (nonatomic, strong) NSString *product_img;
@property (nonatomic, strong) NSString *product_name;
@property (nonatomic, strong) NSString *user_id;

@end

NS_ASSUME_NONNULL_END
